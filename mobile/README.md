# SafeHer mobile

## Lancer l'application

```bash
flutter pub get
flutter run --dart-define=SAFEHER_API_URL=http://10.0.2.2:3000
```

Le coffre-fort expose :
- `GET /evidence`
- `POST /evidence/upload` (multipart, limite 25 Mo)
- `DELETE /evidence/:id`

Cette première version stocke les fichiers côté serveur et calcule leur empreinte SHA-256. **Le chiffrement côté client doit être ajouté avant toute utilisation en production** : ne téléversez pas de données sensibles réelles dans cet environnement de démonstration.
