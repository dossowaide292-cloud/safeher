import 'package:flutter/material.dart';
import '../../services/sos_service.dart';

class SosHistoryScreen extends StatefulWidget {
  const SosHistoryScreen({super.key});
  @override
  State<SosHistoryScreen> createState() => _SosHistoryScreenState();
}

class _SosHistoryScreenState extends State<SosHistoryScreen> {
  final _service = SosService(); List<Map<String, dynamic>> _alerts = []; bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { try { _alerts = await _service.list(); } catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible de charger l’historique.'))); } finally { if (mounted) setState(() => _loading = false); } }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Historique SOS')), body: _loading ? const Center(child: CircularProgressIndicator()) : _alerts.isEmpty ? const Center(child: Text('Aucune alerte enregistrée.')) : RefreshIndicator(onRefresh: _load, child: ListView.builder(itemCount: _alerts.length, itemBuilder: (context, index) { final alert = _alerts[index]; final date = DateTime.tryParse('${alert['triggeredAt']}'); return ListTile(leading: Icon(alert['status'] == 'CANCELLED' ? Icons.check_circle : Icons.warning, color: alert['status'] == 'CANCELLED' ? Colors.green : Colors.red), title: Text(alert['status'] == 'CANCELLED' ? 'Alerte annulée' : 'Alerte déclenchée'), subtitle: Text(date?.toLocal().toString() ?? 'Date inconnue'), trailing: alert['status'] == 'TRIGGERED' ? TextButton(onPressed: () async { await _service.cancel('${alert['id']}'); await _load(); }, child: const Text('Annuler')) : null); }));
}
