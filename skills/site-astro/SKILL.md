---
name: site-astro
description: Créer ou faire évoluer un site de la filière B de l'usine itnetgg-web-factory (Astro + Decap CMS + Cloudflare Workers) à partir de starter-astro. À utiliser pour une landing page ou un site vitrine Astro, ses composants, ses contenus éditables, son CMS ou son déploiement Cloudflare.
---

# Site Astro (filière B)

## Avant de commencer

1. Lire le `CLAUDE.md` et le `README.md` du dépôt, puis les standards de `socle/standards/` utiles à la tâche.
2. Vérifier la cible : dépôt `itnetgg-web-factory/<nom>`, branche `feature/*` ou `fix/*`. Jamais de commit direct sur `main`.
3. Si le projet n'existe pas encore : le créer depuis le modèle (voir `socle/docs/nouveau-projet-client.md`), après accord de Gérard.

## Structure attendue

```
src/components/   composants .astro réutilisables, paramétrés par props
src/layouts/      BaseLayout (en-tête, pied de page, métadonnées SEO)
src/content/      contenus éditables (pages, services, témoignages), schémas validés
src/pages/        routes
public/admin/     Decap CMS
```

## Règles de réalisation

- **Contenu hors des composants** : tout texte, image ou tarif modifiable par le client vient de `src/content/` et figure dans la configuration Decap. Aucun contenu client codé en dur.
- **Statique par défaut** ; JavaScript client uniquement pour un composant interactif, avec la directive `client:*` la plus sobre (`client:visible` plutôt que `client:load`).
- **Schémas stricts** dans la configuration des collections : un champ manquant ou mal formé doit faire échouer le build.
- **Images** : composant `Image` d'Astro, formats modernes, dimensions et `alt` obligatoires.
- **Accessibilité et SEO** : appliquer `socle/standards/accessibility.md` et `seo.md` dès la création du composant, pas en fin de projet.

## Vérifier avant de proposer la fusion

1. `npm ci` puis `npm run build` sans erreur ni avertissement de schéma.
2. Rendu vérifié dans le navigateur (`npm run preview`) : mobile et bureau.
3. Pour une modification de contenu ou de CMS : simuler l'édition dans `/admin` et vérifier le commit produit.
4. Pull request avec résumé, captures si le rendu change, contrôles CI au vert.

## Déploiement

- Cloudflare Workers avec Wrangler, via GitHub Actions uniquement ; identifiants dans les secrets GitHub.
- Sur `workers.dev` tant que le site n'est pas validé ; domaine définitif seulement avec l'accord de Gérard.
- Ne créer **aucune** ressource Cloudflare (Worker, domaine, D1, R2, KV) sans autorisation explicite.
- Production : suivre `site-delivery`.

## Interdits

- Aucun secret dans le dépôt, les journaux ou la configuration Decap.
- Pas d'interface `/admin` publiée sans authentification GitHub opérationnelle.
- Pas de dépendance ajoutée sans justification dans la pull request.
