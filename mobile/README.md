# SafeHer mobile

## Lancer l'application

```bash
flutter pub get
flutter run --dart-define=SAFEHER_API_URL=http://10.0.2.2:3000
```

Cette étape prépare les notifications SOS : chaque alerte crée une file de notifications `PENDING` pour les contacts actifs. Aucun SMS ou push réel n'est envoyé tant qu'un fournisseur n'est pas configuré et validé.

Pour la production, il faudra choisir un fournisseur (SMS ou Firebase Cloud Messaging), obtenir le consentement des contacts et ajouter une politique de rétention des numéros.
