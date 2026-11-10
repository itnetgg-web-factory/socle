# Standard : référencement (SEO)

## Par page

- `<title>` unique, 50 à 60 caractères, mot-clé principal en tête.
- Meta description unique, 140 à 160 caractères.
- URL courte, en minuscules, avec tirets, sans paramètres inutiles.
- Un `h1` qui reprend l'intention de la page.
- Balise canonique.
- Balises Open Graph (`og:title`, `og:description`, `og:image`) pour le partage.

## Site

- `sitemap.xml` généré automatiquement et déclaré dans `robots.txt`.
- `robots.txt` adapté : **préproduction et sites de test non indexables** (`noindex` + réglage WordPress « Demander aux moteurs de ne pas indexer »).
- HTTPS partout, redirection 301 de `http` et de la variante sans ou avec `www`.
- Page 404 utile (lien vers l'accueil et les pages principales).
- Données structurées JSON-LD adaptées à l'activité (`LocalBusiness`, `Organization`, `Service`, `FAQPage` selon le cas).
- Fiche Google Business Profile cohérente avec les coordonnées du site pour les activités locales.

## Performance

Objectifs mesurés sur mobile (Core Web Vitals) :

| Indicateur | Objectif |
|---|---|
| LCP (affichage du contenu principal) | < 2,5 s |
| INP (réactivité) | < 200 ms |
| CLS (stabilité visuelle) | < 0,1 |

- Images en WebP ou AVIF, dimensionnées, avec `width` et `height`, chargement différé hors écran.
- Polices limitées (2 familles maximum), `font-display: swap`.
- Pas de JavaScript inutile ; aucune bibliothèque chargée « au cas où ».

## Migration d'un site existant

- Inventaire des URL existantes avant refonte.
- Redirections 301 de chaque ancienne URL vers son équivalent.
- Vérification dans Google Search Console après mise en ligne.

## Vérification avant livraison

- Lighthouse SEO ≥ 95 et Performance ≥ 90 sur mobile pour les pages principales.
- Sitemap accessible, `robots.txt` de production (indexation autorisée).
- Titres, descriptions et alternatives d'images renseignés sur toutes les pages.
