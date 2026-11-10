# CLAUDE.md : socle

Ce dépôt contient les conventions, standards, workflows réutilisables et Skills communs à l'usine `itnetgg-web-factory`. Il est **public** : n'y écrire aucune information propre à un client, à un hébergement ou à un compte.

## Règles

- Suivre [`docs/conventions.md`](docs/conventions.md) : branche `feature/*`, pull request, fusion par squash.
- Ne jamais committer de secret, de jeton, de mot de passe ni d'identifiant de compte.
- Un changement de convention ou de standard impacte les deux modèles : le signaler et proposer la mise à jour de `starter-astro` et `starter-wordpress`.
- Le workflow `controles.yml` est appelé par les autres dépôts via un tag (`@v0.1.0`) : toute modification donne lieu à un nouveau tag, puis à la mise à jour des appels.
- Actions tierces épinglées par SHA de commit, outils téléchargés vérifiés par SHA-256 (voir `standards/security.md`).
- Les décisions d'architecture sont prises par Gérard ; Claude Code propose, puis exécute après accord.
