import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AutoVault {
  static final Map<String, String> _memVault = {};
  static const _storage = FlutterSecureStorage();

  static String _safeKey(String userId) =>
      'vault_pass_${base64Url.encode(utf8.encode(userId)).replaceAll('=', '')}';

  static Future<void> savePassword(String userId, String password) async {
    _memVault[userId] = password;
    try {
      await _storage.write(key: _safeKey(userId), value: password);
    } catch (_) {}
  }

  static Future<String?> getPassword(String userId) async {
    if (_memVault.containsKey(userId)) {
      return _memVault[userId];
    }
    try {
      final stored = await _storage.read(key: _safeKey(userId));
      if (stored != null) {
        _memVault[userId] = stored;
        return stored;
      }
    } catch (_) {}
    return null;
  }

  static void clear(String userId) {
    _memVault.remove(userId);
    try {
      _storage.delete(key: _safeKey(userId));
    } catch (_) {}
  }
}
