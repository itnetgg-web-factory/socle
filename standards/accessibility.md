# Standard : accessibilité

Objectif : niveau **WCAG 2.2 AA** sur toutes les pages livrées. Référence française : RGAA.

## Structure

- Langue déclarée (`<html lang="fr">`).
- Un seul `h1` par page, puis une hiérarchie de titres sans saut de niveau.
- Zones identifiées : `header`, `nav`, `main`, `footer`.
- Lien d'évitement « Aller au contenu » en tout début de page.
- Titre de page (`<title>`) unique et descriptif.

## Contenus

- Toute image porteuse d'information a une alternative textuelle ; les images décoratives ont `alt=""`.
- Liens et boutons explicites hors contexte (pas de « cliquez ici » seul).
- Vidéos sous-titrées ; pas de lecture automatique avec le son.
- Texte lisible : taille de base d'au moins 16 px, interligne confortable, pas de texte justifié.

## Couleurs

- Contraste d'au moins **4,5:1** pour le texte courant, **3:1** pour le grand texte et les composants d'interface.
- L'information n'est jamais transmise par la couleur seule.

## Clavier et interactions

- Tout est utilisable au clavier, dans un ordre logique.
- Focus toujours visible.
- Cibles tactiles d'au moins 24 × 24 px.
- Les animations respectent `prefers-reduced-motion`.

## Formulaires

- Chaque champ a une étiquette visible associée (`label`).
- Champs obligatoires et format attendu indiqués avant la saisie.
- Messages d'erreur explicites, liés au champ concerné.

## Vérification avant livraison

- Contrôle automatique (Lighthouse ou axe) sans erreur bloquante.
- Parcours complet au clavier des pages principales.
- Test de zoom à 200 % sans perte de contenu ni défilement horizontal.
- Vérification des contrastes de la palette retenue.
- Côté WordPress : les blocs personnalisés respectent ces règles, quel que soit le contenu saisi par le client.
