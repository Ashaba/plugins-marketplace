#!/usr/bin/env bash
# Runs every repo check. CI runs this same script.
# Exit codes: 0 all checks passed, 1 a check failed, 2 a check could not run.
set -uo pipefail
cd "$(dirname "$0")/.."

readonly MARKETPLACE=.claude-plugin/marketplace.json
readonly RELEASE_MANIFEST=.release-please-manifest.json

failed=0
unchecked=0

fail() { echo "FAIL: $*"; failed=1; }
cannot_check() { echo "cannot check: $*"; unchecked=1; }
installed() { command -v "$1" >/dev/null 2>&1; }

check_marketplace() {
  if ! installed claude; then cannot_check "claude is not installed"; return; fi
  claude plugin validate . --strict || fail "claude plugin validate . --strict"
}

check_skills() {
  if ! installed skills-ref; then cannot_check "skills-ref is not installed"; return; fi
  shopt -s nullglob
  local skill_dirs=(plugins/*/skills/*/)
  shopt -u nullglob
  if (( ${#skill_dirs[@]} == 0 )); then
    cannot_check "no skills found under plugins/*/skills/"
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
  if ! installed jq; then cannot_check "jq is not installed"; return; fi
  local plugins
  plugins=$(jq -r '.plugins[] | select(.source | type == "string" and startswith("./"))
    | [.name, .source, .description] | @tsv' "$MARKETPLACE") \
    || { fail "$MARKETPLACE: could not read the plugin list"; return; }
  if [[ -z $plugins ]]; then
    cannot_check "no relative-path plugins in $MARKETPLACE"
    return
  fi

  local name source description path plugin_json released
  while IFS=$'\t' read -r name source description; do
    path=${source#./}
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

check_marketplace
check_skills
check_plugin_metadata

if (( failed )); then exit 1; fi
if (( unchecked )); then echo "Incomplete: some checks could not run."; exit 2; fi
echo "All checks passed."
