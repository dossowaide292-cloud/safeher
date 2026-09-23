import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/trusted_contact_service.dart';

class TrustedContactsScreen extends StatefulWidget {
  const TrustedContactsScreen({super.key});
  @override
  State<TrustedContactsScreen> createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  final _service = TrustedContactService();
  List<Map<String, dynamic>> _contacts = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try { _contacts = await _service.list(); }
    catch (_) { if (mounted) _message('Impossible de charger les contacts.'); }
    finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _add() async {
    final name = TextEditingController(); final phone = TextEditingController(); final relation = TextEditingController();
    final result = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Ajouter un contact'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'Nom')), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Téléphone')), TextField(controller: relation, decoration: const InputDecoration(labelText: 'Relation (optionnel)'))]), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')), FilledButton(onPressed: () async { if (name.text.trim().isEmpty || phone.text.trim().isEmpty) return; try { await _service.create(name: name.text, phone: phone.text, relationship: relation.text); if (context.mounted) Navigator.pop(context, true); } on DioException { if (context.mounted) _message('Vérifiez le numéro de téléphone.'); } }, child: const Text('Ajouter'))]));
    name.dispose(); phone.dispose(); relation.dispose();
    if (result == true) { setState(() => _loading = true); await _load(); }
  }

  Future<void> _remove(String id) async { await _service.remove(id); await _load(); }
  void _message(String text) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text))); }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Contacts de confiance'), actions: [IconButton(onPressed: _add, icon: const Icon(Icons.add), tooltip: 'Ajouter')]), body: _loading ? const Center(child: CircularProgressIndicator()) : _contacts.isEmpty ? const Center(child: Text('Aucun contact enregistré.')) : ListView.builder(itemCount: _contacts.length, itemBuilder: (context, index) { final contact = _contacts[index]; return ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text('${contact['name']}'), subtitle: Text('${contact['phone']}\n${contact['relationship'] ?? ''}'), isThreeLine: true, trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _remove('${contact['id']}'))); }));
}
