# Standard : livraison

Une livraison = une mise en production vérifiable, réversible et documentée.

## Chaîne commune

1. Branche `feature/*` ou `fix/*`.
2. Pull request : contrôles automatiques au vert (détection de secrets, format, puis build et tests propres à la filière).
3. Déploiement en **préproduction** (`staging`) et vérification du rendu.
4. **Validation humaine** par Gérard.
5. Fusion dans `main` et déploiement en **production**.
6. Vérification après mise en ligne.

Aucune mise en production sans préproduction vérifiée, sauf correctif urgent documenté a posteriori.

## Environnements GitHub

| Environnement | Déclenchement | Protection |
|---|---|---|
| `staging` | Pull request ou branche | Aucune |
| `production` | `main` uniquement | Validation de Gérard par la fusion de la pull request |

Dépôts clients privés en **GitHub Team** (décision du 26/11/2026). Sur un dépôt privé, Team permet la protection de branche, les secrets d'environnement et la restriction des déploiements à `main`. En revanche, la validation manuelle d'environnement (« required reviewers ») reste réservée aux dépôts publics et à Enterprise : la validation humaine se fait donc à la fusion de la pull request. L'offre Free n'est pas utilisée pour un dépôt client privé, car elle n'y offre ni protection de `main` ni secrets d'environnement.

## Filière A : WordPress

- Déployer uniquement le thème, les extensions et les mu-plugins maison, par GitHub Actions. Transport : SSH/SFTP si l'hébergeur l'ouvre aux runners GitHub ; sinon FTPS (certificat vérifié) avec un compte FTP limité au dossier `wp-content`, comme chez o2switch où SSH est filtré par adresse IP. Envoi par fichier provisoire puis renommage, pour qu'aucun fichier ne manque pendant le déploiement. Détails : `starter-wordpress/docs/deploiement.md`.
- Ne jamais toucher à `uploads/`, à la base ni aux extensions installées par le client.
- Sauvegarde fichiers + base **avant** chaque mise en production.
- Retour arrière : redéployer le tag précédent ; restaurer la base seulement si une migration l'exige.

## Filière B : Astro

- Build dans la CI, déploiement Cloudflare Workers avec Wrangler.
- Préproduction sur `workers.dev` ou sur une version de prévisualisation.
- Retour arrière : redéployer la version précédente (Cloudflare conserve l'historique des versions) ou revenir au commit précédent.

## Versions

- Chaque mise en production est marquée par un tag `vMAJEUR.MINEUR.CORRECTIF`.
- Le `CHANGELOG.md` du projet résume ce qui a changé pour le client.

## Remise au client

- Accès : comptes nominatifs créés, droits vérifiés, accès temporaires retirés.
- Guide d'édition court : modifier un texte, une image, un tarif, ajouter une prestation.
- Récapitulatif : domaine, hébergement, Cloudflare, sauvegardes, contacts, coûts récurrents.
- Test d'autonomie réalisé : le client a modifié un contenu sans aide, et un déploiement ultérieur ne l'a pas écrasé.
- Vérifications [accessibilité](accessibility.md), [SEO](seo.md) et [sécurité](security.md) passées.
