import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/evidence_service.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});
  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _service = EvidenceService();
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { try { _items = await _service.list(); } catch (_) { if (mounted) _message('Impossible de charger le coffre-fort.'); } finally { if (mounted) setState(() => _loading = false); } }
  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    final file = result?.files.single;
    if (file?.path == null) return;
    setState(() => _loading = true);
    try { await _service.upload(file!.path!, file.name); _message('Fichier ajouté au coffre-fort.'); }
    on DioException catch (error) { _message('${error.response?.data?['message'] ?? 'Upload impossible.'}'); }
    finally { await _load(); }
  }
  Future<void> _remove(String id) async { try { await _service.remove(id); await _load(); } catch (_) { _message('Suppression impossible.'); } }
  void _message(String text) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text))); }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Mon coffre-fort'), actions: [IconButton(onPressed: _pick, icon: const Icon(Icons.upload_file), tooltip: 'Ajouter une preuve')]), body: _loading ? const Center(child: CircularProgressIndicator()) : _items.isEmpty ? const Center(child: Text('Aucune preuve enregistrée.')) : RefreshIndicator(onRefresh: _load, child: ListView.builder(itemCount: _items.length, itemBuilder: (context, index) { final item = _items[index]; return ListTile(leading: const Icon(Icons.insert_drive_file_outlined), title: Text('${item['originalName']}'), subtitle: Text('${item['mimeType']} • ${item['size']} octets\nSHA-256 : ${item['sha256']}'), isThreeLine: true, trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _remove('${item['id']}'))); }));
}
