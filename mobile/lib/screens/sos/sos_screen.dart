import 'package:flutter/material.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Alerte SOS')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
      const SizedBox(height: 24),
      Text('Cette fonction sera connectée aux contacts de confiance dans la prochaine étape.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 16),
      const Text('En cas de danger immédiat, contactez les services d’urgence locaux. Ne comptez pas uniquement sur l’application.', textAlign: TextAlign.center),
      const Spacer(),
      FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.all(18)), onPressed: () => Navigator.of(context).pop(), child: const Text('Retour')),
    ])),
  );
}
