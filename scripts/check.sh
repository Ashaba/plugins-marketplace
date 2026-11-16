#!/usr/bin/env bash
# Runs every repo check. CI runs this same script.
# Exit codes: 0 all checks passed, 1 a check failed, 2 a check could not run.
set -uo pipefail
cd "$(dirname "$0")/.."

readonly MARKETPLACE=.claude-plugin/marketplace.json
readonly RELEASE_MANIFEST=.release-please-manifest.json

failed=0
unchecked=0
plugins=""  # One line per relative-path plugin: name, path, description (tab-separated).

fail() { echo "FAIL: $*"; failed=1; }
cannot_check() { echo "cannot check: $*"; unchecked=1; }
installed() { command -v "$1" >/dev/null 2>&1; }

load_plugins() {
  if ! installed jq; then cannot_check "jq is not installed"; return; fi
  plugins=$(jq -r '.plugins[] | select(.source | type == "string" and startswith("./"))
    | [.name, (.source | ltrimstr("./")), .description] | @tsv' "$MARKETPLACE") \
    || { fail "$MARKETPLACE: could not read the plugin list"; plugins=""; return; }
  [[ -n $plugins ]] || cannot_check "no relative-path plugins in $MARKETPLACE"
}

check_with_claude() {
  if ! installed claude; then cannot_check "claude is not installed"; return; fi
  claude plugin validate . --strict || fail "claude plugin validate . --strict"
  [[ -n $plugins ]] || return
  local name path description
  while IFS=$'\t' read -r name path description; do
    claude plugin validate "$path" --strict || fail "claude plugin validate $path --strict"
  done <<< "$plugins"
}

check_skills() {
  if ! installed skills-ref; then cannot_check "skills-ref is not installed"; return; fi
  local skill_dirs=() name path description
  shopt -s nullglob
  while IFS=$'\t' read -r name path description; do
    skill_dirs+=("$path"/skills/*/)
  done <<< "$plugins"
  shopt -u nullglob
  if (( ${#skill_dirs[@]} == 0 )); then
    cannot_check "no skills found in the plugins listed in $MARKETPLACE"
    return
  fi
  local dir output
  for dir in "${skill_dirs[@]}"; do
    output=$(skills-ref validate "$dir" 2>&1) || fail "$dir: $output"
  done
}

# Each plugin's version must match what release-please last released, and its
# description must match the marketplace entry users see before installing.
check_plugin_metadata() {
  if ! jq empty "$RELEASE_MANIFEST" 2>/dev/null; then
    fail "$RELEASE_MANIFEST: could not read"
    return
  fi
  local name path description plugin_json released
  while IFS=$'\t' read -r name path description; do
    plugin_json="$path/.claude-plugin/plugin.json"
    released=$(jq -r --arg path "$path" '.[$path] // empty' "$RELEASE_MANIFEST")
    if [[ -z $released ]]; then
      fail "$RELEASE_MANIFEST: no entry for $path, so plugin $name is never released"
      continue
    fi
    [[ $(jq -r '.version' "$plugin_json") == "$released" ]] \
      || fail "$plugin_json: version does not match $RELEASE_MANIFEST ($released)"
    [[ $(jq -r '.description' "$plugin_json") == "$description" ]] \
      || fail "$plugin_json: description does not match the $name entry in $MARKETPLACE"
  done <<< "$plugins"
}

load_plugins
check_with_claude
if [[ -n $plugins ]]; then
  check_skills
  check_plugin_metadata
fi

if (( failed )); then exit 1; fi
if (( unchecked )); then echo "Incomplete: some checks could not run."; exit 2; fi
echo "All checks passed."
