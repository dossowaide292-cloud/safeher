import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  AuthService({Dio? client, FlutterSecureStorage? storage})
      : _client = client ?? Dio(BaseOptions(baseUrl: _baseUrl)),
        _storage = storage ?? const FlutterSecureStorage();

  static const _baseUrl = String.fromEnvironment('SAFEHER_API_URL', defaultValue: 'http://10.0.2.2:3000');
  static const accessTokenKey = 'safeher_access_token';
  static const _refreshTokenKey = 'safeher_refresh_token';
  final Dio _client;
  final FlutterSecureStorage _storage;

  Future<void> login({required String identifier, required String password}) async {
    final response = await _client.post('/auth/login', data: {'identifier': identifier.trim(), 'password': password});
    await _saveTokens(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> register({String? email, String? phone, required String password}) async {
    final response = await _client.post('/auth/register', data: {
      if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      'password': password,
    });
    await _saveTokens(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> logout() async {
    final token = await _storage.read(key: accessTokenKey);
    try {
      if (token != null && token.isNotEmpty) {
        await _client.post('/auth/logout', options: _options(token));
      }
    } finally {
      await clearTokens();
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<Options> authOptions() async {
    final token = await _storage.read(key: accessTokenKey);
    if (token == null || token.isEmpty) throw StateError('Session expirée');
    return _options(token);
  }

  Options _options(String token) => Options(headers: {'Authorization': 'Bearer $token'});

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final access = data['accessToken'] as String?;
    final refresh = data['refreshToken'] as String?;
    if (access == null || refresh == null) throw const FormatException('Réponse d’authentification invalide');
    await _storage.write(key: accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
  }
}
