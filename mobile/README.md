# SafeHer mobile

## Lancer l'application

```bash
flutter pub get
flutter run --dart-define=SAFEHER_API_URL=http://10.0.2.2:3000
```

- Android Emulator : `http://10.0.2.2:3000`
- iOS Simulator : `http://127.0.0.1:3000`
- Téléphone physique : remplacer l'URL par l'adresse IP locale de l'ordinateur.

Pour utiliser la localisation, ajoutez les permissions `ACCESS_FINE_LOCATION` et `ACCESS_COARSE_LOCATION` Android, ainsi que `NSLocationWhenInUseUsageDescription` iOS, après avoir généré les plateformes Flutter.

Les tokens sont conservés dans `flutter_secure_storage`. Le SOS enregistre une alerte authentifiée dans l'API et transmet la position uniquement si l'utilisatrice l'autorise et si elle est disponible.
