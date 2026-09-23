# Coffre-fort SafeHer

Le coffre-fort propose maintenant un cycle complet :

1. chiffrement AES-256-GCM sur le mobile ;
2. upload du payload chiffré ;
3. téléchargement authentifié ;
4. déchiffrement local ;
5. sauvegarde choisie par l’utilisatrice.

La clé reste dans `flutter_secure_storage` et n’est jamais envoyée au serveur. Une nouvelle installation ne peut donc pas déchiffrer les anciennes preuves sans mécanisme de récupération de clé.

## Validation

```bash
cd backend
npm run build
```

```bash
cd mobile
flutter pub get
flutter analyze
```

Test fonctionnel : téléverser un fichier, le télécharger, puis vérifier que le fichier restauré est identique à l’original.
