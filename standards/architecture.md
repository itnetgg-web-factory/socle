# Standard : architecture

S'applique à tous les projets de l'usine, quelle que soit la filière.

## Choisir la filière

| Critère | Filière A : WordPress | Filière B : Astro |
|---|---|---|
| Le client modifie les mises en page | Oui | Non |
| Blog à plusieurs rédacteurs, comptes utilisateurs | Oui | Possible |
| Boutique en ligne | Oui (WooCommerce) | Non |
| Structure stable, contenus simples | Possible | Oui |
| Hébergement et maintenance minimaux | Non | Oui |

La décision est prise par Gérard et notée dans le `README.md` du projet.

## Principes communs

- **Partir d'un modèle** : tout projet client est créé depuis `starter-astro` ou `starter-wordpress`, jamais de zéro.
- **Séparer code et contenu** : le code vit dans Git ; les contenus éditables par le client vivent dans le CMS (base WordPress ou fichiers de contenu Astro). Un déploiement de code ne doit jamais écraser un contenu.
- **Composants réutilisables** : chaque section (présentation, prestations, tarifs, témoignages, galerie, contact) est un composant ou un bloc paramétrable, pas du contenu codé en dur.
- **Natif d'abord** : utiliser les mécanismes de la plateforme (blocs Gutenberg, collections de contenu Astro) avant d'ajouter une dépendance.
- **Dépendances minimales** : chaque extension, bibliothèque ou service tiers doit être justifié (besoin, coût, maintenance, alternative native).
- **Environnements séparés** : développement local, préproduction (`staging`), production. Aucune expérimentation en production.

## Filière A : WordPress

| Élément | Règle |
|---|---|
| Versionné | Thème, extensions et mu-plugins développés pour le site |
| Hors Git | Cœur WordPress, `wp-config.php`, base, médias, extensions installées par le client |
| Éditeur | Gutenberg + blocs personnalisés |
| IA | Novamira en développement et préproduction uniquement |
| Données | Types de contenu, taxonomies et champs natifs, ou extension de modélisation si elle est déjà présente |

## Filière B : Astro

| Élément | Règle |
|---|---|
| Rendu | Statique par défaut ; rendu serveur seulement si un besoin le justifie |
| Contenus | `src/content/` avec schémas validés au build |
| JavaScript | Uniquement pour les composants interactifs (Islands) |
| CMS | Decap CMS, chaque modification devient un commit |
| Hébergement | Cloudflare Workers, compte au nom du client |

## Comptes et propriété

- Domaine, hébergement et compte Cloudflare appartiennent au client ; Gérard y est collaborateur.
- Le dépôt client vit dans l'organisation `itnetgg-web-factory` pendant la réalisation ; son transfert au client est prévu dans la procédure de livraison.
