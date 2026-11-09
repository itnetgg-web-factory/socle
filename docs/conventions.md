# Conventions

Conventions communes à tous les dépôts de l'organisation `itnetgg-web-factory`.

## Nommage des dépôts

| Type | Nom | Visibilité |
|---|---|---|
| Socle commun | `socle` | Public |
| Modèles | `starter-astro`, `starter-wordpress` | Public, marqués « template » |
| Projet client | `client-<slug>` (ex. `client-institut-beaute`) | Privé |
| Documentation interne | `usine-documentation` | Privé |

- `<slug>` : minuscules, chiffres et tirets uniquement, sans accents.
- Chaque dépôt client porte un topic de filière : `filiere-astro` ou `filiere-wordpress`.

## Branches

- `main` : branche de production, toujours déployable. Protégée sur les dépôts publics : modification uniquement par pull request, ni force push ni suppression.
- `feature/<sujet-court>` : toute évolution (ex. `feature/bloc-tarifs`).
- `fix/<sujet-court>` : correction d'un défaut.
- Une branche = un sujet. Elle est supprimée automatiquement après fusion.

## Pull requests

- Fusion par **squash** uniquement : un commit par sujet sur `main`.
- Titre de PR = futur message de commit.
- Les contrôles automatiques doivent être au vert avant fusion (workflows ajoutés au bloc 2 de la Phase 0).

## Messages de commit

- En français, à l'impératif ou au constat, 72 caractères maximum pour la première ligne.
- Préfixe optionnel par domaine : `Astro :`, `WordPress :`, `CI :`, `Docs :`.
- Le corps explique le pourquoi, pas le comment.

## Versions

- Les modèles sont versionnés par tags `vMAJEUR.MINEUR.CORRECTIF` (ex. `v0.1.0`).
- Un projet client note dans son `README.md` la version du modèle dont il est issu.

## Fichiers présents dans chaque dépôt

| Fichier | Rôle |
|---|---|
| `README.md` | Rôle du dépôt, démarrage, structure |
| `CLAUDE.md` | Règles de travail pour Claude Code dans ce dépôt |
| `.editorconfig` | Encodage, fins de ligne, indentation |
| `.gitignore` | Exclusions (dépendances, builds, secrets) |
| `.env.example` | Variables attendues, **sans valeurs secrètes** (sauf `socle`, qui n'en a pas) |
