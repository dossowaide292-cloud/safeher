# SafeHer mobile

## Lancer l'application

```bash
flutter pub get
flutter run --dart-define=SAFEHER_API_URL=http://10.0.2.2:3000
```

- Android Emulator : `http://10.0.2.2:3000`
- iOS Simulator : `http://127.0.0.1:3000`
- Téléphone physique : remplacer l'URL par l'adresse IP locale de l'ordinateur.

Le backend expose désormais :
- `GET/POST/PATCH/DELETE /trusted-contacts`
- `GET /sos`
- `PATCH /sos/:id/cancel`

Après `flutter create .`, ajoutez les permissions de localisation à Android et iOS avant de tester la géolocalisation.
