import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';

  final FlutterSecureStorage _storage;
  AuthStorage() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> save({required String userId, required String name}) async {
    await _storage.write(key: _keyUserId, value: userId);
    await _storage.write(key: _keyUserName, value: name);
  }

  Future<({String userId, String name})?> load() async {
    final userId = await _storage.read(key: _keyUserId);
    final name = await _storage.read(key: _keyUserName);
    if (userId == null || userId.isEmpty) return null;
    return (userId: userId, name: name ?? '');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
