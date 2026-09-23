import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EvidenceService {
  EvidenceService({Dio? client, FlutterSecureStorage? storage}) : _client = client ?? Dio(BaseOptions(baseUrl: _baseUrl)), _storage = storage ?? const FlutterSecureStorage();
  static const _baseUrl = String.fromEnvironment('SAFEHER_API_URL', defaultValue: 'http://10.0.2.2:3000');
  static const _key = 'safeher_access_token';
  final Dio _client; final FlutterSecureStorage _storage;

  Future<List<Map<String, dynamic>>> list() async {
    final response = await _client.get('/evidence', options: await _options());
    return (response.data as List).map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<Map<String, dynamic>> upload(String path, String name) async {
    final form = FormData.fromMap({'file': await MultipartFile.fromFile(path, filename: name)});
    final response = await _client.post('/evidence/upload', data: form, options: await _options());
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> remove(String id) async { await _client.delete('/evidence/$id', options: await _options()); }
  Future<Options> _options() async { final token = await _storage.read(key: _key); if (token == null) throw StateError('Session expirée'); return Options(headers: {'Authorization': 'Bearer $token'}); }
}
