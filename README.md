# SafeHer

SafeHer est une application open source destinée à protéger, accompagner et sécuriser les preuves des femmes et jeunes filles victimes de violences ou de cyberharcèlement.

> **Important :** cette première version est un socle technique. Elle ne remplace pas les services d'urgence, un avocat, un médecin ou un accompagnement associatif.

## Structure

- `backend/` — API NestJS + Prisma
- `mobile/` — application Flutter (à initialiser)
- `infrastructure/` — Docker Compose et configuration locale

## Démarrage rapide

### Prérequis

- Docker et Docker Compose
- Node.js 20+ pour le développement local du backend
- Flutter 3.22+ pour l'application mobile

### Lancer PostgreSQL et l'API

```bash
cp .env.example .env
docker compose -f infrastructure/docker-compose.yml up --build
```

L'API est disponible sur `http://localhost:3000` et Swagger sur `http://localhost:3000/docs`.

### Vérifier l'installation

```bash
curl http://localhost:3000/health
```

## Sécurité

- Ne jamais committer `.env`.
- Les données sensibles ne doivent pas être stockées en clair.
- Le chiffrement côté client sera implémenté avant la mise en production du coffre-fort.
- Toute fonctionnalité SOS doit être testée avec des partenaires locaux avant déploiement.

## Licence

MIT
