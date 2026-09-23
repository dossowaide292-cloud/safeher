import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SosService {
  SosService({Dio? client, FlutterSecureStorage? storage}) : _client = client ?? Dio(BaseOptions(baseUrl: _baseUrl)), _storage = storage ?? const FlutterSecureStorage();
  static const _baseUrl = String.fromEnvironment('SAFEHER_API_URL', defaultValue: 'http://10.0.2.2:3000');
  static const _key = 'safeher_access_token';
  final Dio _client; final FlutterSecureStorage _storage;

  Future<Map<String, dynamic>> trigger({double? latitude, double? longitude, String? message}) async {
    final response = await _client.post('/sos', data: {if (latitude != null) 'latitude': latitude, if (longitude != null) 'longitude': longitude, if (message != null) 'message': message}, options: await _options());
    return Map<String, dynamic>.from(response.data as Map);
  }
  Future<List<Map<String, dynamic>>> list() async {
    final response = await _client.get('/sos', options: await _options());
    return (response.data as List).map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }
  Future<void> cancel(String id) async { await _client.patch('/sos/$id/cancel', options: await _options()); }
  Future<Options> _options() async { final token = await _storage.read(key: _key); if (token == null) throw StateError('Session expirée'); return Options(headers: {'Authorization': 'Bearer $token'}); }
}
