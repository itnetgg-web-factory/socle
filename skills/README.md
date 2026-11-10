# Skills Claude Code

| Skill | Usage |
|---|---|
| [`site-astro`](site-astro/SKILL.md) | Créer ou faire évoluer un site de la filière B (Astro + Decap + Cloudflare) |
| [`site-wordpress`](site-wordpress/SKILL.md) | Créer ou faire évoluer un site de la filière A (WordPress + Gutenberg) |
| [`site-delivery`](site-delivery/SKILL.md) | Mettre en production, livrer au client, revenir en arrière |

## Installation sur un poste

Les Skills sont lus par Claude Code dans `~/.claude/skills/`. Installer par lien symbolique depuis une copie locale de `socle`, pour qu'une mise à jour du dépôt soit prise en compte :

```bash
for s in site-astro site-wordpress site-delivery; do
  ln -sfn "$PWD/skills/$s" "$HOME/.claude/skills/$s"
done
```

Commande à lancer depuis la racine de `socle`.
