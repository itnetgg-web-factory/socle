# Procédure de livraison : filière WordPress

Procédure pas à pas pour livrer une nouvelle version du code (thème, extensions, mu-plugins) d'un site WordPress hébergé chez o2switch, ou pour le remettre au client. Elle applique [`standards/delivery.md`](../standards/delivery.md) ; les contrôles de fond sont dans les standards d'accessibilité, de SEO et de sécurité.

Qui fait quoi : Claude Code prépare, vérifie et présente les preuves ; **Gérard valide chaque mise en production** et fusionne.

Statut des étapes : **testé** (réalisé avec succès), **à tester**.

## 1. Préparer

1. Branche `feature/*` ou `fix/*`, pull request vers `main`.
2. Numéro de version du thème dans `style.css` (`Version:`) : il pilote le rafraîchissement du cache des compositions et la vérification après déploiement.
3. `CHANGELOG.md` complété en termes compréhensibles par le client.
4. Contrôles automatiques de la PR au vert (format, détection de secrets).

## 2. Vérifier en préproduction

| Contrôle | Comment |
|---|---|
| Rendu | Pages principales en mobile et bureau, éditeur de blocs sans bloc invalide |
| Accessibilité, SEO | Lighthouse mobile (accessibilité 100 attendue), puis check-lists des standards |
| Formulaire | Un envoi réel reçu, et les cas d'erreur (champ vide, robot, envoi trop rapide) |
| Autonomie client | Empreinte `md5` du contenu d'une page éditée, relevée avant puis après déploiement : identique, avec le même nombre de révisions |
| Indexation | Interdite en préproduction (Réglages › Lecture) |

Présenter à Gérard un tableau : contrôle, résultat, preuve.

## 3. Sauvegarder avant la mise en production

1. Sauvegarde maison par le script du socle (voir [`sauvegardes-o2switch.md`](sauvegardes-o2switch.md)) *(testé)*.
2. Contrôler le résultat : fichiers et base présents, empreintes valides.
3. Noter la date et le dossier dans le suivi du projet.

## 4. Mettre en production

1. Accord explicite de Gérard pour **cette** livraison.
2. Fusion de la PR dans `main` (squash). Le workflow déploie le code maison en FTPS, sans coupure : chaque fichier est envoyé sous un nom provisoire puis renommé.
3. Suivre le déploiement : `gh run watch <identifiant> --exit-status`.
4. Créer le tag `vMAJEUR.MINEUR.CORRECTIF` sur le commit déployé.

Si le déploiement échoue avant l'envoi (message `Name or service not known`, connexion impossible) : le site n'a pas été touché. Relancer avec `gh run rerun <identifiant> --failed` *(testé le 24/11 : incident de résolution DNS sur le runner, réussi au second essai)*.

## 5. Vérifier après mise en ligne

```bash
U=https://<domaine-du-site>
curl -s -A "Mozilla/5.0" $U/ | grep -o 'webfactory-blocks/style.css?ver=[0-9.]*'   # version attendue
ssh <alias-ssh> 'cat <dossier-du-site>/wp-content/webfactory-deploiement.txt'        # commit déployé
ssh <alias-ssh> 'cd <dossier-du-site> && wp db query "select md5(post_content) from wp5b_posts where ID=<page>" --skip-column-names'
ssh <alias-ssh> 'find <dossier-du-site>/wp-content -name ".depot-*"'                  # aucun fichier provisoire
```

Puis : pages principales en HTTPS, formulaire testé, indexation conforme (autorisée en production, interdite ailleurs), `uploads/` et contenus du client intacts.

## 6. Revenir en arrière

### Code : pull request d'annulation *(testé le 24/11)*

1. Repérer le commit fusionné fautif : `git log --oneline main`.
2. Branche `fix/annuler-<sujet>`, puis `git revert --no-edit <commit>` (un commit squashé s'annule en une fois).
3. Pull request, contrôles au vert, accord de Gérard, fusion : le déploiement remet l'ancienne version.
4. Vérifier comme à l'étape 5 : version précédente servie, contenus identiques.

Mesuré : de la fusion à la version précédente servie, quelques minutes (deux essais de déploiement, le premier ayant échoué sur un incident réseau). Les contenus du client (page éditée, révisions, médias) n'ont pas été touchés : le déploiement ne concerne ni `uploads/` ni la base.

### Fichiers : copie maison *(à tester)*

Si le dépôt est inutilisable, remettre les fichiers de `wp-content` depuis la dernière copie maison (voir [`sauvegardes-o2switch.md`](sauvegardes-o2switch.md)).

### Base de données

Restaurer la base **seulement** si une migration l'exige, après accord de Gérard et après une sauvegarde de l'état actuel. Ne pas restaurer pour annuler un déploiement de code.

Consigner l'incident et sa cause dans le suivi du projet.

## 7. Remettre au client

- Comptes nominatifs créés (rôle Éditeur pour le client), compte technique de déploiement limité à `wp-content`, accès temporaires retirés.
- Guide utilisateur et guide administrateur remis (`starter-wordpress/docs/`).
- Récapitulatif : domaine, hébergement, sauvegardes (date de la dernière copie maison), coûts récurrents, contacts.
- Test d'autonomie rejoué sur le site livré.
- Décision notée sur le dépôt : maintien dans l'organisation ou transfert au client.
