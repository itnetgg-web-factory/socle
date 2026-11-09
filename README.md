# socle

Socle commun de l'usine à sites web **itnetgg-web-factory** : conventions, standards, workflows CI/CD partagés et Skills Claude Code.

L'usine produit des sites selon deux filières, avec une seule méthode de travail :

| Filière | Pile technique | Modèle |
|---|---|---|
| A | WordPress + Gutenberg + Novamira, hébergement o2switch | [`starter-wordpress`](https://github.com/itnetgg-web-factory/starter-wordpress) |
| B | Astro + Decap CMS + Cloudflare Workers | [`starter-astro`](https://github.com/itnetgg-web-factory/starter-astro) |

Règle de choix : **WordPress pour la liberté éditoriale, Astro pour la simplicité opérationnelle et la performance.**

## Contenu

| Chemin | Rôle | État |
|---|---|---|
| [`docs/conventions.md`](docs/conventions.md) | Nommage, branches, commits, versions | Fait |
| [`docs/nouveau-projet-client.md`](docs/nouveau-projet-client.md) | Procédure de création d'un projet client | Première version |
| `standards/` | Architecture, sécurité, accessibilité, SEO, livraison | Phase 0, bloc 2 |
| `.github/workflows/` | Workflows réutilisables (contrôles, détection de secrets) | Phase 0, bloc 2 |
| `skills/` | Skills Claude Code `site-wordpress`, `site-astro`, `site-delivery` | Phase 0, bloc 2 |

## Principes

- Gérard est architecte et décideur ; Claude Code exécute des étapes complètes avec un résultat vérifiable.
- Aucun secret dans Git : les secrets vivent dans les paramètres GitHub (dépôt ou environnement) ou chez l'hébergeur.
- Toute modification de `main` passe par une pull request.
- Chaque client garde son domaine et ses comptes d'hébergement ; Gérard y accède comme collaborateur.
