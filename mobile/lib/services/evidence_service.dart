import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EvidenceService {
  EvidenceService({Dio? client, FlutterSecureStorage? storage}) : _client = client ?? Dio(BaseOptions(baseUrl: _baseUrl)), _storage = storage ?? const FlutterSecureStorage();
  static const _baseUrl = String.fromEnvironment('SAFEHER_API_URL', defaultValue: 'http://10.0.2.2:3000');
  static const _tokenKey = 'safeher_access_token';
  static const _vaultKey = 'safeher_vault_key_v1';
  final Dio _client; final FlutterSecureStorage _storage; final AesGcm _cipher = const AesGcm.with256bits();

  Future<Options> _options() async { final token = await _storage.read(key: _tokenKey); if (token == null || token.isEmpty) throw StateError('Session expirée'); return Options(headers: {'Authorization': 'Bearer $token'}); }
  Future<List<Map<String, dynamic>>> list() async { final response = await _client.get('/evidence', options: await _options()); return (response.data as List).map((item) => Map<String, dynamic>.from(item as Map)).toList(); }
  Future<Map<String, dynamic>> uploadEncrypted(Uint8List bytes, String name) async {
    final key = await _key();
    final nonce = _cipher.newNonce();
    final box = await _cipher.encrypt(bytes, secretKey: key, nonce: nonce);
    final payload = Uint8List(nonce.length + box.cipherText.length + box.mac.bytes.length)
      ..setRange(0, nonce.length, nonce)
      ..setRange(nonce.length, nonce.length + box.cipherText.length, box.cipherText)
      ..setRange(nonce.length + box.cipherText.length, nonce.length + box.cipherText.length + box.mac.bytes.length, box.mac.bytes);
    final form = FormData.fromMap({'file': MultipartFile.fromBytes(payload, filename: '$name.safeher'), 'encrypted': 'true'});
    final response = await _client.post('/evidence/upload', data: form, options: await _options());
    return Map<String, dynamic>.from(response.data as Map);
  }
  Future<void> remove(String id) async { await _client.delete('/evidence/$id', options: await _options()); }
  Future<SecretKey> _key() async { final encoded = await _storage.read(key: _vaultKey); if (encoded != null) return SecretKey(base64Url.decode(encoded)); final key = await _cipher.newSecretKey(); final bytes = await key.extractBytes(); await _storage.write(key: _vaultKey, value: base64UrlEncode(bytes)); return SecretKey(bytes); }
}
