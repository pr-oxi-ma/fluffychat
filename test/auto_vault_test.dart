// SPDX-FileCopyrightText: 2026 FluffyChat Fork Authors
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/auto_vault.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AutoVault Tests', () {
    test('Stores and retrieves password from memory cache', () async {
      const userId = '@alice:matrix.local';
      const password = 'SuperSecretPassword123!';

      await AutoVault.savePassword(userId, password);
      final retrieved = await AutoVault.getPassword(userId);

      expect(retrieved, equals(password));
    });

    test('Clears password from memory and storage', () async {
      const userId = '@bob:matrix.local';
      const password = 'AnotherPassword456!';

      await AutoVault.savePassword(userId, password);
      expect(await AutoVault.getPassword(userId), equals(password));

      AutoVault.clear(userId);
      expect(await AutoVault.getPassword(userId), isNull);
    });

    test('Handles non-existent user safely', () async {
      final retrieved = await AutoVault.getPassword('@nonexistent:matrix.local');
      expect(retrieved, isNull);
    });
  });
}
