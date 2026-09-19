// SPDX-FileCopyrightText: 2026 Proxima
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

class AutoCryptoVault {
  /// Deterministically derives a secure, compliant SSSS passphrase from username + password.
  /// Meets all entropy and character complexity requirements.
  static String derivePassphrase(String username, String password) {
    final cleanUser = username.trim().toLowerCase();
    // Salt with Proxima custom vault secret
    final hmacSha256 = Hmac(
      sha256,
      utf8.encode('PROXIMA_MATRIX_SILENT_VAULT_2026_SALT'),
    );
    final digest = hmacSha256.convert(utf8.encode('$cleanUser:$password'));
    // Ensures uppercase, lowercase, numbers, special characters, and >= 12 chars length
    return 'Px!$digest!9aA#';
  }

  /// Silently initializes or restores the crypto identity and key backup
  /// without prompting the user for recovery keys or emojis.
  static Future<bool> setupOrRestore(
    Client client,
    String username,
    String password,
  ) async {
    try {
      Logs().i('[AutoCryptoVault] Starting silent crypto sync for $username');
      final passphrase = derivePassphrase(username, password);

      // Force room key sharing to all user devices (bypasses unverified restriction)
      client.shareKeysWith = ShareKeysWith.all;

      final state = await client.getCryptoIdentityState();
      Logs().i(
        '[AutoCryptoVault] Crypto state: initialized=${state.initialized}, connected=${state.connected}',
      );

      if (!state.initialized) {
        Logs().i('[AutoCryptoVault] Greenfield account: Initializing crypto identity & backup...');
        await client.initCryptoIdentity(
          passphrase: passphrase,
          selfSign: true,
          wipeCrossSigning: false,
          wipeKeyBackup: false,
          wipeSecureStorage: false,
          setupOnlineKeyBackup: true,
          setupMasterKey: true,
          setupSelfSigningKey: true,
          setupUserSigningKey: true,
        );
        Logs().i('[AutoCryptoVault] Successfully initialized SSSS & Key Backup!');
      } else if (!state.connected) {
        Logs().i('[AutoCryptoVault] Existing account: Restoring SSSS & auto-signing device...');
        await client.restoreCryptoIdentity(
          passphrase,
          selfSign: true,
        );
        Logs().i('[AutoCryptoVault] Successfully restored crypto identity & verified device!');
      } else {
        Logs().i('[AutoCryptoVault] Crypto identity is already fully connected and verified.');
      }
      return true;
    } catch (e, s) {
      Logs().e('[AutoCryptoVault] Error during silent crypto operation', e, s);
      return false;
    }
  }
}
