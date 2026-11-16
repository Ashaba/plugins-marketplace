# Ash's plugin marketplace

A Claude Code plugin marketplace with one plugin, `ash-enterprise-plugin`. It adds skills for writing PRDs, technical design docs and tickets, building front-end interfaces, and applying engineering standards to code, commits and pull requests. The skills follow the [Agent Skills specification](https://agentskills.io/specification), so they also work in other agents.

This is a personal collection. No company supports it.

## Install in Claude Code

In a terminal, run:

```
claude plugin install ash-enterprise-plugin --marketplace Ashaba/plugins-marketplace
```

Or, inside a Claude Code session, type:

```
/plugin marketplace add Ashaba/plugins-marketplace
/plugin install ash-enterprise-plugin@ashabahebwa-plugins
```

Claude uses a skill on its own when your request matches it. To run one directly, type `/ash-enterprise-plugin:<skill>` in a Claude Code session, for example `/ash-enterprise-plugin:prd-creator`. The skills are in [plugins/ash-enterprise/skills](plugins/ash-enterprise/skills).

## Get updates

Every merged feature or fix releases a new plugin version. Claude Code only installs a new copy when the version changes.

Auto-update is off by default for this marketplace. To turn it on, type `/plugin` in a Claude Code session, open the **Marketplaces** tab, select `ashabahebwa-plugins`, and select **Enable auto-update**.

To update by hand, run in a terminal:

```
claude plugin marketplace update ashabahebwa-plugins
claude plugin update ash-enterprise-plugin@ashabahebwa-plugins
```

## Use the skills in other agents

[`npx skills`](https://github.com/vercel-labs/skills) installs the skills into other agents. It needs Node.js 22.20 or later. Run these in a terminal:

```
npx skills add Ashaba/plugins-marketplace --list
npx skills add Ashaba/plugins-marketplace --skill prd-creator -a cursor
```

- Devin for Terminal: use `-a devin`. The skill goes in `.devin/skills/`.
- Devin sessions on a repo, and agents that read `.agents/skills/` (for example Codex, Cursor, Gemini CLI and GitHub Copilot): use `-a universal --copy` in that repo and commit the `.agents/skills/` folder.
- Glean: open **Settings**, then **Skills**, select **Add Skill**, and paste the GitHub link to a skill's `SKILL.md`.

Don't use `npx skills` for Claude Code. Install the plugin instead, so you get updates. Copies made with `npx skills` don't change when a new version is released; run `npx skills update` to refresh them.

## Contributing

See [AGENTS.md](AGENTS.md).
