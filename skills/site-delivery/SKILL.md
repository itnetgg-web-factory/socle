---
name: site-delivery
description: Préparer et vérifier la mise en production ou la remise au client d'un site de l'usine itnetgg-web-factory, en filière WordPress ou Astro. À utiliser pour une mise en ligne, une nouvelle version en production, un retour arrière ou la livraison finale d'un site à un client.
---

# Livraison d'un site

Référence : `socle/standards/delivery.md`. Une livraison est **vérifiable, réversible et documentée**. Claude Code prépare et vérifie ; **Gérard valide** chaque mise en production.

## 1. Préparer

- Identifier le projet, la filière, la version à livrer (tag `vX.Y.Z`) et la version actuellement en production.
- Lister les changements depuis la dernière livraison et compléter le `CHANGELOG.md` en termes compréhensibles par le client.
- Vérifier que la préproduction correspond exactement à ce qui sera livré.

## 2. Vérifier en préproduction

| Domaine | Contrôle |
|---|---|
| CI | Contrôles au vert sur le commit à livrer |
| Accessibilité | Check-list de `standards/accessibility.md` |
| SEO et performance | Check-list de `standards/seo.md` (Lighthouse mobile) |
| Sécurité | Check-list de `standards/security.md`, aucune alerte critique |
| Contenu | Textes, images, liens, formulaires testés |
| Autonomie client | Une modification faite dans le CMS survit à un nouveau déploiement |

Présenter le résultat à Gérard sous forme de tableau : contrôle, résultat, preuve (lien, capture, sortie de commande).

## 3. Sauvegarder

- WordPress : sauvegarde fichiers + base de la production, copie hors de l'hébergeur.
- Astro : noter l'identifiant de la version Cloudflare en production.

## 4. Mettre en production

- Uniquement après l'accord explicite de Gérard pour **cette** livraison.
- Déploiement par le workflow GitHub Actions de production, jamais à la main.
- Créer le tag de version.

## 5. Vérifier après mise en ligne

- Pages principales accessibles en HTTPS, redirections en place.
- Indexation autorisée en production (et toujours interdite en préproduction).
- Formulaires et intégrations fonctionnels.
- En cas d'anomalie bloquante : **retour arrière immédiat** (version précédente), puis analyse.

## 6. Remettre au client (livraison finale)

- Comptes nominatifs du client créés, accès temporaires retirés, liste des accès revue.
- Guide d'édition court remis.
- Récapitulatif remis : domaine, hébergement, Cloudflare, sauvegardes, coûts récurrents, contacts.
- Décision notée sur le dépôt : maintien dans l'organisation ou transfert au client.

## Retour arrière

- WordPress : redéployer le tag précédent ; restaurer la base seulement si une migration l'exige, après accord de Gérard.
- Astro : redéployer la version Cloudflare précédente ou le commit précédent.
- Toujours consigner l'incident et la cause dans le suivi du projet.
