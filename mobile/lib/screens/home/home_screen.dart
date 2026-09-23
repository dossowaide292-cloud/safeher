import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../contacts/trusted_contacts_screen.dart';
import '../sos/sos_screen.dart';
import '../vault/vault_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('SafeHer'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () async { await AuthService().logout(); if (context.mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false); })]),
    body: ListView(padding: const EdgeInsets.all(24), children: [
      Text('Vous êtes dans votre espace sécurisé.', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 24),
      Card(child: ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Mon coffre-fort'), subtitle: const Text('Ajouter et gérer vos preuves.'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen())))),
      Card(child: ListTile(leading: const Icon(Icons.people_outline), title: const Text('Contacts de confiance'), subtitle: const Text('Gérer les personnes à prévenir.'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrustedContactsScreen())))),
      Card(child: ListTile(leading: const Icon(Icons.warning_amber_rounded), title: const Text('SOS'), subtitle: const Text('Déclencher une alerte.'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SosScreen())))),
    ],),
  );
}
