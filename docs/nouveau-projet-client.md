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

## 4. Protection, environnements et secrets

Les dépôts clients sont **privés**, et l'organisation est sur l'offre **GitHub Team** (décision du 26/11/2026). L'organisation passe en Team avant la création du premier dépôt client : c'est Gérard qui s'en occupe, en facturation mensuelle.

| Réglage | Dépôt client privé, offre Team |
|---|---|
| `main` | Protégée : pull request obligatoire, contrôles au vert, règles appliquées aux administrateurs, ni force push ni suppression. Filière Astro : branche à jour **non** exigée, pour que les brouillons Decap se publient l'un après l'autre (décision du 26/11/2026). Filière WordPress : branche à jour exigée |
| Environnements | `staging` et `production`, déploiement limité à `main`, secrets **d'environnement** |
| Validation avant production | Par la fusion de la pull request dans `main` (Gérard). La validation manuelle d'environnement (« required reviewers ») n'existe pas sur un dépôt privé en Team. |
| Accès du client, filière Astro (Decap) | Collaborateur externe, en écriture sur ce seul dépôt : **un siège Team par personne**, refacturé au client |
| Accès du client, filière WordPress | Aucun accès GitHub : le client modifie son site dans WordPress |

Protection de `main`, une fois la première CI passée (les noms des contrôles doivent exister) :

```bash
# Filière Astro : strict=false. Filière WordPress : strict=true et seulement les deux contrôles communs.
gh api -X PUT repos/itnetgg-web-factory/client-<slug>/branches/main/protection --input - <<'JSON'
{
  "required_status_checks": {"strict": false, "contexts": [
    "controles / Format (editorconfig)", "controles / Secrets (gitleaks)", "Build (astro check + build)"]},
  "enforce_admins": true,
  "required_pull_request_reviews": {"required_approving_review_count": 0, "dismiss_stale_reviews": true},
  "required_conversation_resolution": true,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
```

Aucun secret dans Git : voir [`standards/security.md`](../standards/security.md).

## 5. Comptes du client

- **Domaine** : reste au nom du client.
- **Cloudflare** (filière B, et DNS éventuellement pour la filière A) : compte ouvert au nom du client, Gérard invité comme collaborateur.
- **Hébergement WordPress** (filière A) : compte au nom du client. La préproduction est **chez cet hébergeur**, sur un sous-domaine avec sa propre base, construite par la procédure maison en WP-CLI. Jamais sur le compte principal de l'usine, et jamais avec la préproduction de WP Tiger (son bouton « Mettre en ligne » remplace tout le site de production). Décision du 26/11/2026.
- Authentification à deux facteurs activée partout.

## 6. Réaliser

- Filière B : Skill `site-astro`.
- Filière A : Skill `site-wordpress`.

## 7. Livrer

Skill `site-delivery` et [`standards/delivery.md`](../standards/delivery.md).
