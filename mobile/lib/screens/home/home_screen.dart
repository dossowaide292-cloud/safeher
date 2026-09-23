import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../contacts/trusted_contacts_screen.dart';
import '../sos/sos_history_screen.dart';
import '../sos/sos_screen.dart';
import '../vault/vault_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('SafeHer'), actions: [IconButton(icon: const Icon(Icons.logout), tooltip: 'Se déconnecter', onPressed: () async { await AuthService().logout(); if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst); })]), body: ListView(padding: const EdgeInsets.all(24), children: [Text('Vous êtes dans votre espace sécurisé.', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 24), Card(child: ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Mon coffre-fort'), subtitle: const Text('Ajouter et gérer vos preuves.'), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VaultScreen())))), Card(child: ListTile(leading: const Icon(Icons.support_agent), title: const Text('Parler à l’assistant'), subtitle: const Text('Obtenir une orientation.'), onTap: () {})), Card(child: ListTile(leading: const Icon(Icons.people_outline), title: const Text('Contacts de confiance'), subtitle: const Text('Gérer les personnes à prévenir.'), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TrustedContactsScreen())))), Card(child: ListTile(leading: const Icon(Icons.history), title: const Text('Historique SOS'), subtitle: const Text('Consulter vos alertes.'), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SosHistoryScreen())))), const SizedBox(height: 32), FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.all(18)), icon: const Icon(Icons.warning_amber_rounded), label: const Text('SOS — demander de l’aide'), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SosScreen()))) ]);
}
