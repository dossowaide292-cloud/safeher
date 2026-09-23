import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/sos_service.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});
  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final _service = SosService();
  bool _loading = false;
  String? _status;

  Future<Position?> _location() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return null;
    return Geolocator.getCurrentPosition();
  }

  Future<void> _trigger() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déclencher l’alerte SOS ?'),
        content: const Text('Votre alerte sera enregistrée avec votre position si elle est disponible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Déclencher')),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() { _loading = true; _status = null; });
    try {
      final position = await _location();
      await _service.trigger(latitude: position?.latitude, longitude: position?.longitude, message: 'Alerte SOS déclenchée depuis SafeHer');
      if (mounted) setState(() => _status = 'Alerte enregistrée. Contactez aussi les services d’urgence si le danger est immédiat.');
    } on DioException catch (error) {
      if (mounted) setState(() => _status = '${error.response?.data?['message'] ?? 'Impossible d’envoyer l’alerte.'}');
    } on Object catch (_) {
      if (mounted) setState(() => _status = 'Impossible d’envoyer l’alerte. Vérifiez votre connexion.');
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Alerte SOS')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
      const SizedBox(height: 24),
      const Text('Utilisez cette fonction uniquement si vous avez besoin d’aide. La localisation est demandée avec votre consentement.', textAlign: TextAlign.center),
      if (_status != null) ...[const SizedBox(height: 20), Text(_status!, textAlign: TextAlign.center)],
      const Spacer(),
      FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.all(18)), onPressed: _loading ? null : _trigger, icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) : const Icon(Icons.sos), label: Text(_loading ? 'Envoi en cours…' : 'DÉCLENCHER SOS')),
      const SizedBox(height: 12),
      OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Retour')),
    ])),
  );
}
