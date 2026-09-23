# SafeHer mobile

## Lancer l'application

```bash
flutter pub get
flutter run --dart-define=SAFEHER_API_URL=http://10.0.2.2:3000
```

- Android Emulator : `http://10.0.2.2:3000`
- iOS Simulator : `http://127.0.0.1:3000`
- Téléphone physique : remplacer l'URL par l'adresse IP locale de l'ordinateur.

Les tokens sont conservés dans `flutter_secure_storage`. Le coffre-fort, le SOS et l'annuaire seront branchés dans les prochaines étapes.
