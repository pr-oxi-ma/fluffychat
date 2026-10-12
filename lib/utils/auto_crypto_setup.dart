// SPDX-FileCopyrightText: 2024-Present Contributors to FluffyChat Fork
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/auto_crypto_vault.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

/// ProtonMail-style automatic crypto identity setup.
///
/// Uses the user's login password (or deterministically derived vault passphrase)
/// as the SSSS passphrase so that:
/// - First login: keys are generated and encrypted with password on server
/// - New device: same password decrypts all keys and downloads backup keys automatically
/// - No manual bootstrap, no recovery key prompts, no unverified device warnings
class AutoCryptoSetup {
  static String _secureStorageKey(String? userId) =>
      'auto_recovery_key_$userId';

  static bool get _supportsSecureStorage =>
      PlatformInfos.isMobile || PlatformInfos.isDesktop;

  /// Silently sets up or restores crypto identity.
  ///
  /// [password] — the user's login password (null for SSO/OIDC).
  /// Returns true if crypto identity is now fully connected.
  static Future<bool> setup(Client client, {String? password}) async {
    if (!client.encryptionEnabled) return false;

    try {
      // Force key sharing to all devices so encryption is never blocked by unverified devices
      client.shareKeysWith = ShareKeysWith.all;

      var state = await client.getCryptoIdentityState();

      // Already fully connected — make sure keys are loaded
      if (state.connected) {
        await _postConnectSync(client);
        return true;
      }

      // Collect candidates for SSSS passphrase:
      // 1. Raw login password (ProtonMail style)
      // 2. Deterministic derived passphrase from AutoCryptoVault
      final candidates = <String>[];
      if (password != null && password.isNotEmpty) {
        candidates.add(password);
        final localpart = client.userID?.localpart;
        if (localpart != null && localpart.isNotEmpty) {
          candidates.add(AutoCryptoVault.derivePassphrase(localpart, password));
        }
      }

      // Also check platform secure storage for stored recovery key
      if (_supportsSecureStorage) {
        try {
          final storedKey = await const FlutterSecureStorage().read(
            key: _secureStorageKey(client.userID),
          );
          if (storedKey != null && storedKey.isNotEmpty && !candidates.contains(storedKey)) {
            candidates.add(storedKey);
          }
        } catch (_) {}
      }

      // If account already has SSSS / cross-signing on homeserver, restore or heal it
      if (state.initialized || state.crossSigningEnabled || state.keyBackupEnabled) {
        for (final candidate in candidates) {
          try {
            Logs().i('[AutoCryptoSetup] Attempting restore with candidate...');
            await client.restoreCryptoIdentity(candidate, selfSign: true);
            state = await client.getCryptoIdentityState();
            if (state.connected) {
              Logs().i('[AutoCryptoSetup] Successfully connected crypto identity via restore!');
              await _postConnectSync(client);
              return true;
            }
          } catch (e) {
            Logs().d('[AutoCryptoSetup] Restore failed with candidate ($e), trying heal...');
            try {
              await client.initCryptoIdentity(
                reuseExistingStorageRecoveryKeyOrPassphrase: candidate,
                selfSign: true,
                setupOnlineKeyBackup: true,
                setupMasterKey: true,
                setupSelfSigningKey: true,
                setupUserSigningKey: true,
              );
              state = await client.getCryptoIdentityState();
              if (state.connected) {
                Logs().i('[AutoCryptoSetup] Successfully healed and connected crypto identity!');
                await _postConnectSync(client);
                return true;
              }
            } catch (healErr) {
              Logs().d('[AutoCryptoSetup] Heal failed with candidate: $healErr');
            }
          }
        }
      } else {
        // Greenfield account: initialize crypto identity from scratch
        for (final candidate in candidates) {
          try {
            Logs().i('[AutoCryptoSetup] Greenfield account: Initializing crypto identity...');
            final recoveryKey = await client.initCryptoIdentity(
              passphrase: candidate,
              selfSign: true,
              wipeCrossSigning: false,
              wipeKeyBackup: false,
              wipeSecureStorage: false,
              setupOnlineKeyBackup: true,
              setupMasterKey: true,
              setupSelfSigningKey: true,
              setupUserSigningKey: true,
            );

            if (_supportsSecureStorage) {
              try {
                await const FlutterSecureStorage().write(
                  key: _secureStorageKey(client.userID),
                  value: recoveryKey,
                );
              } catch (_) {}
            }

            state = await client.getCryptoIdentityState();
            if (state.connected) {
              await _postConnectSync(client);
              return true;
            }
          } catch (e) {
            Logs().w('[AutoCryptoSetup] Greenfield init failed with candidate: $e');
          }
        }
      }

      return false;
    } catch (e, s) {
      Logs().e('AutoCryptoSetup.setup() failed', e, s);
      return false;
    }
  }

  /// Rotates the SSSS passphrase and recovery key when user changes their password.
  /// Preserves existing cross-signing keys and Megolm key backup without wiping history.
  static Future<bool> rotatePassword(
    Client client, {
    required String newPassword,
  }) async {
    if (!client.encryptionEnabled) return false;
    try {
      Logs().i('[AutoCryptoSetup] Rotating SSSS passphrase to match new password...');
      final candidates = <String>[newPassword];
      final localpart = client.userID?.localpart;
      if (localpart != null && localpart.isNotEmpty) {
        candidates.add(AutoCryptoVault.derivePassphrase(localpart, newPassword));
      }

      for (final candidate in candidates) {
        try {
          final recoveryKey = await client.initCryptoIdentity(
            passphrase: candidate,
            selfSign: true,
            wipeSecureStorage: true,
            wipeCrossSigning: false,
            wipeKeyBackup: false,
            setupMasterKey: true,
            setupSelfSigningKey: true,
            setupUserSigningKey: true,
            setupOnlineKeyBackup: true,
          );

          if (_supportsSecureStorage) {
            try {
              await const FlutterSecureStorage().write(
                key: _secureStorageKey(client.userID),
                value: recoveryKey,
              );
            } catch (_) {}
          }

          final state = await client.getCryptoIdentityState();
          if (state.connected) {
            Logs().i('[AutoCryptoSetup] Successfully rotated SSSS to new password!');
            await _postConnectSync(client);
            return true;
          }
        } catch (e) {
          Logs().w('[AutoCryptoSetup] Candidate failed during rotatePassword: $e');
        }
      }
      return false;
    } catch (e, s) {
      Logs().e('[AutoCryptoSetup] rotatePassword failed', e, s);
      return false;
    }
  }

  /// Downloads all backed-up keys from the homeserver and signs any unverified devices.
  static Future<void> _postConnectSync(Client client) async {
    // 1. Force key sharing to all devices
    client.shareKeysWith = ShareKeysWith.all;

    // 2. Load all room keys from online backup
    if (client.encryption?.keyManager.enabled == true) {
      try {
        Logs().i('[AutoCryptoSetup] Loading all keys from online key backup...');
        await client.encryption?.keyManager.loadAllKeys();
        Logs().i('[AutoCryptoSetup] All room keys loaded from backup successfully!');
      } catch (e) {
        Logs().w('[AutoCryptoSetup] loadAllKeys() failed: $e');
      }
    }

    // 3. Auto-sign all unverified devices of this user (including current device)
    try {
      await client.updateUserDeviceKeys();
      final ownDevices = client.userDeviceKeys[client.userID]?.deviceKeys.values
          .where((d) => !d.verified && !d.blocked)
          .toList();
      if (ownDevices != null && ownDevices.isNotEmpty) {
        if (await client.encryption?.crossSigning.isCached() ?? false) {
          await client.encryption?.crossSigning.sign(ownDevices);
          await client.updateUserDeviceKeys();
          Logs().i('[AutoCryptoSetup] Auto-signed ${ownDevices.length} unverified own devices');
        }
      }
    } catch (e) {
      Logs().d('[AutoCryptoSetup] Auto-signing other devices non-critical failure: $e');
    }

    // 4. Request any missing keys from peers and re-decrypt timelines
    await _requestMissingKeys(client);
  }

  /// Auto-request decryption keys for all rooms with undecryptable messages.
  static Future<void> _requestMissingKeys(Client client) async {
    try {
      for (final room in client.rooms) {
        final checkedSessions = <String>{};
        final eventsToCheck = <Event>[
          if (room.lastEvent != null) room.lastEvent!,
        ];
        try {
          final dbEvents = await client.database.getEventList(room, limit: 50);
          eventsToCheck.addAll(dbEvents);
        } catch (_) {}
        for (final event in eventsToCheck) {
          if (event.messageType == MessageTypes.BadEncrypted ||
              event.type == EventTypes.Encrypted) {
            final sessionId = event.content.tryGet<String>('session_id');
            final senderKey = event.content.tryGet<String>('sender_key');
            if (sessionId != null &&
                senderKey != null &&
                !checkedSessions.contains(sessionId)) {
              checkedSessions.add(sessionId);
              client.encryption?.keyManager.maybeAutoRequest(
                room.id,
                sessionId,
                senderKey,
                tryOnlineBackup: true,
                onlineKeyBackupOnly: false,
              );
            }
          }
        }
      }
    } catch (e) {
      Logs().d('Auto key request failed', e);
    }
  }
}
