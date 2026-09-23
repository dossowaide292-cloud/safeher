import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SosService {
  SosService({Dio? client, FlutterSecureStorage? storage})
      : _client = client ?? Dio(BaseOptions(baseUrl: _baseUrl)),
        _storage = storage ?? const FlutterSecureStorage();

  static const _baseUrl = String.fromEnvironment('SAFEHER_API_URL', defaultValue: 'http://10.0.2.2:3000');
  static const _accessTokenKey = 'safeher_access_token';
  final Dio _client;
  final FlutterSecureStorage _storage;

  Future<Map<String, dynamic>> trigger({double? latitude, double? longitude, String? message}) async {
    final token = await _storage.read(key: _accessTokenKey);
    if (token == null) throw StateError('Session expirée');
    final response = await _client.post('/sos', data: {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (message != null && message.trim().isNotEmpty) 'message': message.trim(),
    }, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return Map<String, dynamic>.from(response.data as Map);
  }
}
