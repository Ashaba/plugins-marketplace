#!/usr/bin/env bash
# Tests for scripts/check.sh. Each case copies the repo, changes one thing,
# runs check.sh with a stub skills-ref, and asserts on exit code and output.
# Usage: scripts/test-check.sh (needs claude, jq and rsync; skills-ref is stubbed)
set -uo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d "${TMPDIR:-/tmp}/check-tests.XXXXXX")
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin"
cat > "$work/bin/skills-ref" <<'EOF'
#!/bin/sh
echo "$2" >> "$STUB_LOG"
echo "Valid skill"
EOF
chmod +x "$work/bin/skills-ref"
passed=0 failed=0

copy_repo() {
  local dest=$1
  rsync -a --exclude .git --exclude node_modules --exclude .superpowers "$repo/" "$dest/"
}

run_case() {
  local name=$1 want_exit=$2 want_text=$3 setup=$4
  local dir="$work/$name"
  copy_repo "$dir"
  (cd "$dir" && eval "$setup")
  local out code
  out=$(cd "$dir" && STUB_LOG="$dir/stub.log" PATH="$work/bin:$PATH" scripts/check.sh 2>&1)
  code=$?
  if [[ $code == "$want_exit" ]] && grep -q -F -- "$want_text" <<< "$out$(cat "$dir/stub.log" 2>/dev/null)"; then
    echo "PASS $name"; passed=$((passed + 1))
  else
    echo "FAIL $name: exit $code (want $want_exit), missing: $want_text"
    grep -E 'FAIL|cannot' <<< "$out" | sed 's/^/    /'
    failed=$((failed + 1))
  fi
}

run_case clean_tree_passes 0 "All checks passed." ":"

run_case broken_skill_frontmatter_fails_claude_validation 1 \
  "FAIL: claude plugin validate plugins/ash-enterprise --strict" \
  "perl -i -pe 's/^name: ticket-writer\$/name: [broken/' plugins/ash-enterprise/skills/ticket-writer/SKILL.md"

run_case skills_found_from_marketplace_sources 0 \
  "extra/other/skills/ticket-writer/" \
  "mkdir -p extra && cp -R plugins/ash-enterprise extra/other \
   && jq '.name = \"other-plugin\"' extra/other/.claude-plugin/plugin.json > p.tmp && mv p.tmp extra/other/.claude-plugin/plugin.json \
   && jq --arg d \"\$(jq -r .description extra/other/.claude-plugin/plugin.json)\" '.plugins += [{name: \"other-plugin\", source: \"./extra/other\", description: \$d}]' .claude-plugin/marketplace.json > m.tmp && mv m.tmp .claude-plugin/marketplace.json \
   && jq '. + {\"extra/other\": \"1.3.0\"}' .release-please-manifest.json > r.tmp && mv r.tmp .release-please-manifest.json"

run_case unreadable_release_manifest_says_so 1 \
  "FAIL: .release-please-manifest.json: could not read" \
  "echo '{' > .release-please-manifest.json"

run_case no_skills_is_not_a_pass 2 \
  "cannot check: no skills found" \
  "rm -rf plugins/ash-enterprise/skills"

echo "passed=$passed failed=$failed"
(( failed == 0 ))
