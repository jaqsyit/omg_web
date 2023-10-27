import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    return storage.read(key: 'access_token');
  }

  Future<void> setToken(String accessToken) async {
    await storage.write(key: 'access_token', value: accessToken);
  }

  Future<void> deleteTokens() async {
    await storage.delete(key: 'access_token');
  }
}
