// SPDX-FileCopyrightText: 2024-Present Contributors to FluffyChat Fork
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

/// ProtonMail-style automatic crypto identity setup.
///
/// Uses the user's login password as the SSSS passphrase so that:
/// - First login: keys are generated and encrypted with password on server
/// - New device: same password decrypts all keys automatically
/// - No manual bootstrap, no recovery key prompts, no verification
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
      var state = await client.getCryptoIdentityState();

      // Already fully connected — nothing to do
      if (state.connected) {
        await _requestMissingKeys(client);
        return true;
      }

      if (!state.initialized) {
        // ── FIRST TIME (signup / fresh account) ──
        // Use password as SSSS passphrase (ProtonMail approach).
        // If no password (SSO), use null → auto-generated recovery key.
        final recoveryKey = await client.initCryptoIdentity(
          passphrase: password,
        );

        // Store recovery key in platform secure storage as backup
        if (_supportsSecureStorage) {
          try {
            await FlutterSecureStorage().write(
              key: _secureStorageKey(client.userID),
              value: recoveryKey,
            );
          } catch (e) {
            Logs().w('Could not store recovery key in secure storage', e);
          }
        }

        await _requestMissingKeys(client);
        return true;
      }

      // ── EXISTING ACCOUNT, NOT CONNECTED (new device / cookies cleared) ──
      if (state.initialized && !state.connected) {
        // Strategy 1: Use login password as SSSS passphrase
        if (password != null && password.isNotEmpty) {
          try {
            await client.restoreCryptoIdentity(password, selfSign: true);
            state = await client.getCryptoIdentityState();
            if (state.connected) {
              await _requestMissingKeys(client);
              return true;
            }
          } catch (e) {
            Logs().d('Password-based restore failed, trying fallbacks', e);
          }
        }

        // Strategy 2: Use recovery key from platform secure storage
        if (_supportsSecureStorage) {
          try {
            final storedKey = await FlutterSecureStorage().read(
              key: _secureStorageKey(client.userID),
            );
            if (storedKey != null && storedKey.isNotEmpty) {
              await client.restoreCryptoIdentity(storedKey, selfSign: true);
              state = await client.getCryptoIdentityState();
              if (state.connected) {
                await _requestMissingKeys(client);
                return true;
              }
            }
          } catch (e) {
            Logs().d('Secure storage restore failed', e);
          }
        }
      }

      // All auto strategies failed — caller decides what to do
      return false;
    } catch (e, s) {
      Logs().e('AutoCryptoSetup.setup() failed', e, s);
      return false;
    }
  }

  /// Auto-request decryption keys for all rooms with undecryptable messages.
  static Future<void> _requestMissingKeys(Client client) async {
    try {
      for (final room in client.rooms) {
        final lastEvent = room.lastEvent;
        if (lastEvent == null ||
            lastEvent.messageType != MessageTypes.BadEncrypted ||
            lastEvent.content['can_request_session'] != true) {
          continue;
        }
        final sessionId = lastEvent.content.tryGet<String>('session_id');
        final senderKey = lastEvent.content.tryGet<String>('sender_key');
        if (sessionId != null && senderKey != null) {
          client.encryption?.keyManager.maybeAutoRequest(
            room.id,
            sessionId,
            senderKey,
          );
        }
      }
    } catch (e) {
      Logs().d('Auto key request failed', e);
    }
  }
}
