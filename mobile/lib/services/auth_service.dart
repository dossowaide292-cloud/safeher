import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  AuthService({Dio? client, FlutterSecureStorage? storage})
      : _client = client ?? Dio(BaseOptions(baseUrl: _baseUrl)),
        _storage = storage ?? const FlutterSecureStorage();

  static const _baseUrl = String.fromEnvironment(
    'SAFEHER_API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const _accessTokenKey = 'safeher_access_token';
  static const _refreshTokenKey = 'safeher_refresh_token';

  final Dio _client;
  final FlutterSecureStorage _storage;

  Future<void> login({required String identifier, required String password}) async {
    final response = await _client.post('/auth/login', data: {
      'identifier': identifier.trim(),
      'password': password,
    });
    await _saveTokens(response.data as Map<String, dynamic>);
  }

  Future<void> register({String? email, String? phone, required String password}) async {
    final response = await _client.post('/auth/register', data: {
      if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      'password': password,
    });
    await _saveTokens(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    final token = await _storage.read(key: _accessTokenKey);
    if (token != null) {
      try {
        await _client.post('/auth/logout', options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
      } finally {
        await clearTokens();
      }
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    if (accessToken == null || refreshToken == null) {
      throw const FormatException('Réponse d’authentification invalide');
    }
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }
}
