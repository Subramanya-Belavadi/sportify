import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';

  final FlutterSecureStorage _storage;
  AuthStorage() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> save({required String userId, required String name, required String email}) async {
    await _storage.write(key: _keyUserId, value: userId);
    await _storage.write(key: _keyUserName, value: name);
    await _storage.write(key: _keyUserEmail, value: email);
  }

  Future<({String userId, String name, String email})?> load() async {
    final userId = await _storage.read(key: _keyUserId);
    final name = await _storage.read(key: _keyUserName);
    final email = await _storage.read(key: _keyUserEmail);
    if (userId == null || userId.isEmpty) return null;
    return (userId: userId, name: name ?? '', email: email ?? '');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
