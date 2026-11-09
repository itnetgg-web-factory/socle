# Créer un nouveau projet client

Première version (Phase 0, bloc 1). Les étapes CI/CD, environnements et livraison seront complétées au bloc 2 et lors de l'industrialisation.

## 1. Choisir la filière

| Besoin | Filière |
|---|---|
| Landing page, site vitrine à structure stable | B : Astro |
| Client qui modifie lui-même les mises en page | A : WordPress |
| Blog avec plusieurs rédacteurs | A : WordPress |
| Boutique en ligne (WooCommerce) | A : WordPress |
| Coût d'hébergement et maintenance minimaux | B : Astro |

En cas de doute, la décision revient à Gérard.

## 2. Créer le dépôt depuis le modèle

```bash
gh repo create itnetgg-web-factory/client-<slug> --private --template itnetgg-web-factory/starter-<astro|wordpress> --clone
gh repo edit itnetgg-web-factory/client-<slug> --add-topic filiere-<astro|wordpress>
```

Noter dans le `README.md` du projet la version du modèle utilisée (tag).

## 3. Comptes du client

- **Domaine** : reste au nom du client.
- **Cloudflare** (filière B, et DNS éventuellement pour la filière A) : compte ouvert au nom du client, Gérard invité comme collaborateur.
- **Hébergement WordPress** (filière A) : compte au nom du client.

## 4. Secrets

- Jamais dans Git ni dans les fichiers du projet.
- Dépôt client privé en offre GitHub Free : secrets de dépôt uniquement (pas de secrets d'environnement ni de validation manuelle avant déploiement). L'offre Team lèverait cette limite : décision à prendre avant le premier client.

## 5. Suite

À compléter au bloc 2 de la Phase 0 : workflows à activer, environnements `staging` et `production`, check-list de livraison.
