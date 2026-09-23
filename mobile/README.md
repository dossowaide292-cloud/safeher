# SafeHer mobile

## Lancer l'application

```bash
flutter pub get
flutter run --dart-define=SAFEHER_API_URL=http://10.0.2.2:3000
```

Le coffre-fort chiffre maintenant chaque fichier sur le téléphone avec AES-256-GCM avant l'upload. La clé est conservée dans `flutter_secure_storage`, avec une clé distincte par installation de l'application.

Le serveur ne reçoit que le payload chiffré et conserve son empreinte SHA-256. Cette version ne permet pas encore de restaurer/télécharger les fichiers : la gestion de récupération de clé et le téléchargement authentifié doivent être ajoutés avant la production.

**Ne perdez pas le téléphone ou la clé locale sans procédure de récupération : le serveur ne peut pas déchiffrer les fichiers.**
