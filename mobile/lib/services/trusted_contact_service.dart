import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TrustedContactService {
  TrustedContactService({Dio? client, FlutterSecureStorage? storage}) : _client = client ?? Dio(BaseOptions(baseUrl: _baseUrl)), _storage = storage ?? const FlutterSecureStorage();
  static const _baseUrl = String.fromEnvironment('SAFEHER_API_URL', defaultValue: 'http://10.0.2.2:3000');
  static const _key = 'safeher_access_token';
  final Dio _client;
  final FlutterSecureStorage _storage;

  Future<Options> _options() async {
    final token = await _storage.read(key: _key);
    if (token == null || token.isEmpty) throw StateError('Session expirée');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }
  Future<List<Map<String, dynamic>>> list() async {
    final response = await _client.get('/trusted-contacts', options: await _options());
    return (response.data as List).map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }
  Future<Map<String, dynamic>> create({required String name, required String phone, String? relationship}) async {
    final response = await _client.post('/trusted-contacts', data: {'name': name.trim(), 'phone': phone.trim(), if (relationship != null && relationship.trim().isNotEmpty) 'relationship': relationship.trim()}, options: await _options());
    return Map<String, dynamic>.from(response.data as Map);
  }
  Future<void> remove(String id) async => _client.delete('/trusted-contacts/$id', options: await _options());
}
