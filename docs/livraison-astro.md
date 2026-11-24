# Procédure de livraison : filière Astro

Procédure pas à pas pour livrer une nouvelle version d'un site Astro publié sur Cloudflare Workers, ou pour le remettre au client. Elle applique [`standards/delivery.md`](../standards/delivery.md) ; détails techniques dans `starter-astro/docs/deploiement.md`.

Qui fait quoi : Claude Code prépare, vérifie et présente les preuves ; **Gérard valide chaque mise en production**, fusionne et agit dans le compte Cloudflare.

Statut des étapes : **testé**, **à tester**.

## 1. Préparer

1. Branche `feature/*` ou `fix/*`, pull request vers `main`. Les modifications de contenu du client arrivent aussi par pull request (Decap CMS, flux éditorial) : les relire avant de fusionner.
2. `CHANGELOG.md` complété en termes compréhensibles par le client.
3. Un champ de contenu modifié l'est à la fois dans le schéma, la configuration Decap, la documentation et les tests.

## 2. Vérifier avant fusion

| Contrôle | Comment |
|---|---|
| Build | `npm ci`, puis `npm run verify` (types, tests des schémas, build) sans erreur |
| Rendu | `npm run preview` : mobile et bureau |
| Édition | `npm run dev` + `npm run cms:local` : une modification dans `/admin` produit le bon fichier |
| Accessibilité, SEO | Lighthouse mobile, puis check-lists des standards |
| Sécurité | En-têtes (`public/_headers`), `/admin` en `noindex`, aucun secret dans le dépôt |

Présenter à Gérard un tableau : contrôle, résultat, preuve.

## 3. Noter le point de retour

Avant la mise en production, relever la version actuellement publiée : `npx wrangler deployments list` (le message de chaque version porte le commit publié). C'est la version vers laquelle revenir en urgence.

## 4. Mettre en production

1. Accord explicite de Gérard pour **cette** livraison.
2. Fusion dans `main` : GitHub Actions construit et publie (`wrangler deploy --message "Commit <sha>"`).
3. Suivre : `gh run watch <identifiant> --exit-status`.
4. Créer le tag `vMAJEUR.MINEUR.CORRECTIF`.

Aucune ressource Cloudflare (Worker, domaine, stockage) n'est créée sans autorisation. Le domaine définitif n'est branché qu'avec l'accord de Gérard, les changements DNS étant préparés par Claude Code et appliqués par Gérard.

## 5. Vérifier après mise en ligne

```bash
U=https://<adresse-du-site>
curl -sI $U/ | grep -iE "^HTTP|x-frame|strict-transport"   # 200 + en-têtes de sécurité
curl -s $U/robots.txt                                       # Disallow: / tant que le site n'est pas indexable
curl -sI $U/admin/ | grep -i x-robots                       # noindex sur /admin
```

Puis : pages principales, formulaires et intégrations, connexion à `/admin` et publication d'un contenu d'essai, indexation conforme (autorisée en production, interdite ailleurs).

## 6. Revenir en arrière

| Situation | Action | Statut |
|---|---|---|
| Contenu ou code fautif, sans urgence | Pull request d'annulation (`git revert`), puis fusion : le site est republié | **testé** |
| Urgence | `npx wrangler deployments list`, puis `npx wrangler rollback <version-id> --message "Motif"`, ou tableau de bord Cloudflare : Workers › le site › Deployments › Rollback. Effet constaté en moins de 10 secondes | **testé** (ligne de commande) |

Après un retour arrière par Cloudflare, `main` n'a pas changé : corriger `main` par une pull request d'annulation, sinon la prochaine publication du client republie la version fautive. Consigner l'incident et sa cause dans le suivi du projet.

Essai complet réalisé sur le starter : version fautive publiée, retour arrière par `wrangler rollback`, puis pull request d'annulation fusionnée et publiée ; site final identique à l'état de départ. En mode non interactif, `--yes` évite la question de confirmation.

## 7. Remettre au client

- Comptes nominatifs : accès au dépôt pour le flux éditorial, GitHub App propre au site, accès temporaires retirés.
- Guide utilisateur et guide administrateur remis (`starter-astro/docs/`).
- Récapitulatif : domaine, Cloudflare, dépôt, coûts récurrents, contacts.
- Test d'autonomie rejoué : le client publie un contenu sans aide, la publication apparaît sur le site.
- Décision notée sur le dépôt : maintien dans l'organisation ou transfert au client.
