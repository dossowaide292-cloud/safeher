import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/evidence_service.dart';

class VaultScreen extends StatefulWidget { const VaultScreen({super.key}); @override State<VaultScreen> createState() => _VaultScreenState(); }
class _VaultScreenState extends State<VaultScreen> {
  final _service = EvidenceService(); List<Map<String, dynamic>> _items = []; bool _loading = true;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { try { _items = await _service.list(); } catch (_) { _message('Impossible de charger le coffre-fort.'); } finally { if (mounted) setState(() => _loading = false); } }
  Future<void> _pick() async { final result = await FilePicker.platform.pickFiles(withData: false); final file = result?.files.single; if (file?.path == null) return; setState(() => _loading = true); try { await _service.uploadEncrypted(await File(file!.path!).readAsBytes(), file.name); _message('Fichier chiffré ajouté.'); } catch (_) { _message('Upload impossible.'); } finally { await _load(); } }
  Future<void> _download(Map<String, dynamic> item) async { try { final bytes = await _service.downloadDecrypted('${item['id']}'); final result = await FilePicker.platform.saveFile(fileName: '${item['originalName']}', bytes: bytes); if (result != null) _message('Fichier restauré localement.'); } catch (_) { _message('Téléchargement ou déchiffrement impossible.'); } }
  Future<void> _remove(String id) async { try { await _service.remove(id); await _load(); } catch (_) { _message('Suppression impossible.'); } }
  void _message(String value) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value))); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Mon coffre-fort'), actions: [IconButton(onPressed: _pick, icon: const Icon(Icons.upload_file))]), body: _loading ? const Center(child: CircularProgressIndicator()) : _items.isEmpty ? const Center(child: Text('Aucune preuve enregistrée.')) : ListView.builder(itemCount: _items.length, itemBuilder: (_, i) { final item = _items[i]; return ListTile(leading: Icon(item['encrypted'] == true ? Icons.lock : Icons.insert_drive_file_outlined), title: Text('${item['originalName']}'), subtitle: Text('${item['size']} octets\nSHA-256 : ${item['sha256']}'), isThreeLine: true, trailing: Wrap(children: [IconButton(icon: const Icon(Icons.download_outlined), onPressed: () => _download(item)), IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _remove('${item['id']}'))])); }));
}
