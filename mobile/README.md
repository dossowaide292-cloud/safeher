# SafeHer mobile

## Installation

```bash
flutter pub get
flutter analyze
```

## Lancement

Android Emulator :

```bash
flutter run --dart-define=SAFEHER_API_URL=http://10.0.2.2:3000
```

iOS Simulator :

```bash
flutter run --dart-define=SAFEHER_API_URL=http://127.0.0.1:3000
```

Téléphone physique : remplace l’URL par l’adresse IP locale de la machine qui exécute l’API.

## Fonctionnalités branchées

- Authentification : `/auth/register`, `/auth/login`, `/auth/logout`
- Contacts : `/trusted-contacts`
- SOS : `/sos`
- Coffre-fort : `/evidence`, `/evidence/upload`

Les tokens sont conservés avec `flutter_secure_storage`. Les fichiers sont chiffrés localement avec AES-256-GCM avant l’upload. Cette version ne permet pas encore la récupération/décryption des fichiers : ne l’utilisez pas avec des preuves réelles sans procédure de récupération de clé validée.
