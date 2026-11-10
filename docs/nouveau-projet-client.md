# Créer un nouveau projet client

Procédure commune aux deux filières. Le déploiement propre à chaque filière sera détaillé lors de la réalisation des modèles (blocs Astro 4/4 et WordPress 3/3).

## 1. Choisir la filière

Appliquer la grille de [`standards/architecture.md`](../standards/architecture.md). La décision revient à Gérard et est notée dans le `README.md` du projet.

## 2. Créer le dépôt depuis le modèle

```bash
gh repo create itnetgg-web-factory/client-<slug> --private \
  --template itnetgg-web-factory/starter-<astro|wordpress> --clone
gh repo edit itnetgg-web-factory/client-<slug> --add-topic filiere-<astro|wordpress> \
  --enable-squash-merge --enable-merge-commit=false --enable-rebase-merge=false --delete-branch-on-merge
```

Puis dans la copie locale, accès Git par GitHub CLI :

```bash
git config credential.https://github.com.helper '!gh auth git-credential'
```

Noter dans le `README.md` du projet : client, filière, version du modèle utilisée (tag).

## 3. Contrôles automatiques

Le modèle contient déjà `.github/workflows/ci.yml`, qui appelle les contrôles communs de `socle` (format et détection de secrets). Vérifier que la première exécution passe au vert.

## 4. Environnements et secrets

| Offre GitHub | Dépôt client privé |
|---|---|
| Free | Pas de protection de `main`, pas d'environnements protégés : secrets **de dépôt**, validation faite dans la pull request |
| Team | Protection de `main`, environnements `staging` et `production` avec validation manuelle |

Le choix de l'offre est à trancher avant le premier client. Dans tous les cas : aucun secret dans Git, voir [`standards/security.md`](../standards/security.md).

## 5. Comptes du client

- **Domaine** : reste au nom du client.
- **Cloudflare** (filière B, et DNS éventuellement pour la filière A) : compte ouvert au nom du client, Gérard invité comme collaborateur.
- **Hébergement WordPress** (filière A) : compte au nom du client ; préproduction sur o2switch.
- Authentification à deux facteurs activée partout.

## 6. Réaliser

- Filière B : Skill `site-astro`.
- Filière A : Skill `site-wordpress`.

## 7. Livrer

Skill `site-delivery` et [`standards/delivery.md`](../standards/delivery.md).
