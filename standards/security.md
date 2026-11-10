# Standard : sécurité

## Secrets

- **Jamais dans Git**, ni dans un fichier du projet, ni dans un message de commit, ni dans les journaux de CI.
- Stockage : secrets GitHub (dépôt ou environnement), variables de l'hébergeur, trousseau du poste de travail.
- `.env.example` liste les variables attendues, **sans valeur**.
- Toute fuite suspectée : révoquer le secret **d'abord**, nettoyer l'historique ensuite.
- Contrôles automatiques : détection de secrets par gitleaks dans la CI de chaque dépôt ; sur les dépôts publics, la détection GitHub bloque aussi les pushs.

## Accès

- Principe du moindre privilège : chaque compte, jeton ou clé n'a que les droits nécessaires.
- Jetons à durée limitée et à portée restreinte quand le service le permet (ex. jeton Cloudflare limité au déploiement d'un Worker).
- Comptes nominatifs : pas de compte administrateur partagé entre plusieurs personnes.
- Authentification à deux facteurs obligatoire sur GitHub, Cloudflare, l'hébergeur et les comptes administrateurs WordPress.
- À la livraison, revoir la liste des accès et retirer ceux qui ne servent plus.

## GitHub

- `main` protégée : pull request obligatoire, ni force push ni suppression.
- Actions tierces épinglées par **SHA de commit**, outils téléchargés vérifiés par **empreinte SHA-256**.
- Workflows avec `permissions: contents: read` par défaut ; droits supplémentaires déclarés au cas par cas.
- Alertes Dependabot actives ; une alerte critique est traitée avant toute livraison.

## WordPress

- Cœur, thème et extensions à jour ; extensions inactives supprimées.
- Version de PHP supportée (8.3 ou plus récente).
- Novamira et toute passerelle IA (MCP) **interdits sur un site client en production** : ils donnent un contrôle complet du site.
- Pas d'éditeur de fichiers dans l'administration (`DISALLOW_FILE_EDIT`).
- Sauvegardes fichiers + base automatiques, avec une copie hors de l'hébergeur.
- Comptes administrateurs limités au strict nécessaire ; le client reçoit un rôle adapté à ses besoins.

## Astro et Cloudflare

- En-têtes de sécurité définis : `Content-Security-Policy`, `Strict-Transport-Security`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`.
- Interface `/admin` de Decap protégée par une authentification GitHub opérationnelle ; une page `/admin` publique sans authentification est interdite.
- Le client n'a accès qu'au CMS, pas au dépôt ni au compte Cloudflare, sauf demande explicite.

## Données personnelles

- Formulaires : collecte minimale, finalité indiquée, mention RGPD et lien vers la politique de confidentialité.
- Bandeau de consentement pour tout traceur non essentiel ; refus aussi simple que l'acceptation.
- Aucune donnée personnelle dans les URL, les journaux ou les dépôts.
