# Working in this repo

How to change this repo. This applies to people and to coding agents.

## Layout

- `.claude-plugin/marketplace.json`: the marketplace catalog.
- `plugins/ash-enterprise/`: the only plugin. Its version is in `.claude-plugin/plugin.json`.
- `plugins/ash-enterprise/skills/<name>/SKILL.md`: one folder per skill.
- `scripts/check.sh`: every repo check. CI runs the same script.
- `scripts/test-check.sh`: tests for `check.sh`.
- `package.json`: pins the Claude Code CLI that CI uses. Dependabot updates it.
- `scripts/requirements.txt`: pins `skills-ref` to a commit. The **Upstream pins** workflow fails each month that `skills-ref` has newer commits.

## Add or change a skill

1. Create `plugins/ash-enterprise/skills/<name>/SKILL.md`. No other file needs to change, because the plugin loads every skill in that folder.
2. The `name` in the frontmatter must equal the folder name.
3. Never rename an existing skill folder. The folder name is the ID people type (`/ash-enterprise-plugin:<name>`), so a rename breaks it for everyone.
4. Frontmatter must only use `name`, `description`, `license`, `allowed-tools`, `metadata` and `compatibility`. Put anything else, such as `author`, under `metadata`.
5. `description` must be 1024 characters or fewer. It should say what the skill does and when to use it, since agents decide whether to load a skill from its description.
6. Long reference material should go in a `references/` folder next to `SKILL.md`.
7. A PR that changes a skill, including a wording-only change, must use `feat` or `fix` in its title. A `docs` title merges but never releases, so installed users never get the change.

## Versions and releases

release-please owns the version and `CHANGELOG.md`. Never edit them by hand.

- A `feat`, `fix`, `perf` or `revert` PR releases a new plugin version. Other types, such as `docs`, `chore`, `ci`, `refactor` and `test`, don't.
- After a releasing PR merges, release-please opens a release PR. Merging that PR bumps the version in `plugin.json` and tags the release. The version bump is what makes Claude Code offer the update to users.
- Removing a skill, renaming a skill folder or renaming the plugin breaks users. Avoid these changes. If one can't be avoided, mark the PR title with `!`, for example `feat!: remove the ticket-writer skill`.

## PR titles

PRs are squash merged, and the PR title becomes the commit that release-please reads. The PR title must follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<optional scope>): <summary>
feat(prd-creator): add a risks section
```

- When a change is to one skill, use the skill's folder name as the scope.
- Ticket IDs go in the PR description, not the title. In this repo, this replaces the `TICKET-ID description` format from the software-engineer skill, because release-please can't read that format.
- Branch names can be anything.

## Before opening a PR

You must run `scripts/check.sh` and get exit code 0.

- 0: all checks passed.
- 1: a check failed.
- 2: a check could not run, so the result is unknown. Exit 2 is not a pass.

The script needs:

- the Claude Code CLI (`claude`)
- `jq`
- `skills-ref`, installed in a virtualenv with `pip install -r scripts/requirements.txt`

CI runs the same script and also checks the PR title.

If you change `scripts/check.sh`, you must also run `scripts/test-check.sh` and get exit code 0. It needs `rsync` as well, and uses a stand-in for `skills-ref`.

When the **Upstream pins** workflow fails, change the commit in `scripts/requirements.txt` to the one it names, in a PR titled `ci: ...`.

## Keep out of the repo

Planning docs, design notes, scratch files and test logs. Keep them local.
