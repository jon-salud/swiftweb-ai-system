#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# SwiftWeb AI System — Test Suite
# Tests install.sh logic without actually installing
#
# Usage: bash tests/test_install.sh
# ═══════════════════════════════════════════════════════════════

PASS=0
FAIL=0
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'
BOLD='\033[1m'

pass() { echo -e "  ${GREEN}✓${RESET} $1"; ((PASS++)); }
fail() { echo -e "  ${RED}✗${RESET} $1"; ((FAIL++)); }
section() { echo ""; echo -e "${BOLD}$1${RESET}"; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ── TEST 1: install.sh exists and is executable ──────────────────
section "TEST GROUP 1: install.sh basics"

if [ -f "$REPO_DIR/install.sh" ]; then
  pass "install.sh exists"
else
  fail "install.sh not found"
fi

if bash -n "$REPO_DIR/install.sh" 2>/dev/null; then
  pass "install.sh has valid bash syntax"
else
  fail "install.sh has syntax errors"
fi

# ── TEST 2: No broken scaffold path ─────────────────────────────
section "TEST GROUP 2: install.sh — no broken scaffold path"

if grep -q '~/.swiftweb/../swiftweb-ai-system/' "$REPO_DIR/install.sh"; then
  fail "install.sh contains broken path: ~/.swiftweb/../swiftweb-ai-system/"
else
  pass "install.sh does not contain broken scaffold path"
fi

# ── TEST 3: swiftweb-prompt actually uses \$choice ────────────────
section "TEST GROUP 3: swiftweb-prompt uses \$choice"

if grep -A 20 'swiftweb-prompt()' "$REPO_DIR/install.sh" | grep -q '\$choice'; then
  pass "swiftweb-prompt uses \$choice variable"
else
  fail "swiftweb-prompt does not use \$choice — templates are never displayed"
fi

# ── TEST 4: clipboard fallback (pbcopy with Linux fallback) ──────
section "TEST GROUP 4: Clipboard cross-platform support"

if grep -q 'xclip\|xsel\|_clipboard_copy' "$REPO_DIR/install.sh"; then
  pass "install.sh has Linux clipboard fallback (xclip/xsel)"
else
  fail "install.sh only uses pbcopy — will fail silently on Linux"
fi

# ── TEST 5: .bash_profile detection ──────────────────────────────
section "TEST GROUP 5: .bash_profile shell detection"

if grep -q '\.bash_profile' "$REPO_DIR/install.sh"; then
  pass "install.sh checks for .bash_profile"
else
  fail "install.sh does not detect .bash_profile — macOS bash users get no aliases"
fi

# ── TEST 6: lighthouserc.json has framework comments ─────────────
section "TEST GROUP 6: lighthouserc.json framework guidance"

if grep -q 'Astro\|astro\|framework\|FRAMEWORK' "$REPO_DIR/install.sh"; then
  pass "lighthouserc.json template includes framework-specific guidance"
else
  fail "lighthouserc.json template has no framework guidance (hardcodes Next.js port 3000)"
fi

# ── TEST 7: swiftweb-prompt listed in final summary ──────────────
section "TEST GROUP 7: swiftweb-prompt in install summary"

if grep -A 30 '\[7/7\]' "$REPO_DIR/install.sh" | grep -q 'swiftweb-prompt'; then
  pass "swiftweb-prompt is listed in [7/7] installation summary"
else
  fail "swiftweb-prompt is missing from [7/7] installation summary"
fi

# ── TEST 8: new-project.sh has overwrite protection ──────────────
section "TEST GROUP 8: new-project.sh overwrite protection"

if grep -q 'already exists\|-d "\$PROJECT"' "$REPO_DIR/install.sh"; then
  pass "new-project.sh checks if project directory already exists"
else
  fail "new-project.sh silently overwrites existing projects"
fi

# ── TEST 9: uninstall.sh exists ───────────────────────────────────
section "TEST GROUP 9: uninstall.sh"

if [ -f "$REPO_DIR/uninstall.sh" ]; then
  pass "uninstall.sh exists"
  if bash -n "$REPO_DIR/uninstall.sh" 2>/dev/null; then
    pass "uninstall.sh has valid bash syntax"
  else
    fail "uninstall.sh has syntax errors"
  fi
else
  fail "uninstall.sh does not exist — no way to cleanly remove installation"
fi

# ── TEST 10: SWIFTWEB_GUIDELINES.md — valid CSS syntax ───────────
section "TEST GROUP 10: SWIFTWEB_GUIDELINES.md — valid CSS values"

if grep -q '^  --color-primary: ;' "$REPO_DIR/SWIFTWEB_GUIDELINES.md"; then
  fail "SWIFTWEB_GUIDELINES.md has invalid empty CSS value: --color-primary: ;"
else
  pass "SWIFTWEB_GUIDELINES.md CSS custom properties have valid placeholder values"
fi

# ── TEST 11: llms.txt template uses ## H2 headings ───────────────
section "TEST GROUP 11: llms.txt template heading consistency"

# Check specifically within the llms.txt template block in SWIFTWEB_GUIDELINES.md
LLM_SECTION=$(awk '/llms\.txt at site root/,/Link llms\.txt from footer/' "$REPO_DIR/SWIFTWEB_GUIDELINES.md")
if echo "$LLM_SECTION" | grep -qE '^### '; then
  fail "llms.txt template in SWIFTWEB_GUIDELINES.md uses ### H3 — should be ## H2"
else
  pass "llms.txt template uses ## H2 headings (consistent with all other files)"
fi

# ── TEST 12: templates.md — no Python string wrappers ────────────
section "TEST GROUP 12: templates.md — no Python string wrappers"

if grep -qE '^[A-Z_]+ = """' "$REPO_DIR/prompts/templates.md"; then
  fail "prompts/templates.md contains Python string wrappers (VARIABLE = \"\"\")"
else
  pass "prompts/templates.md contains plain prompt text (no Python wrappers)"
fi

# ── TEST 13: templates.md — Template 2 has og:locale ─────────────
section "TEST GROUP 13: Template 2 audit checklist completeness"

TEMPLATE2_SECTION=$(awk '/TEMPLATE 2/,/TEMPLATE 3/' "$REPO_DIR/prompts/templates.md")
if echo "$TEMPLATE2_SECTION" | grep -q 'og:locale'; then
  pass "Template 2 includes og:locale check"
else
  fail "Template 2 is missing og:locale check (present in Section 9 canon checklist)"
fi

if echo "$TEMPLATE2_SECTION" | grep -qi 'robots'; then
  pass "Template 2 includes robots.txt check"
else
  fail "Template 2 is missing robots.txt check (present in Section 9 canon checklist)"
fi

if echo "$TEMPLATE2_SECTION" | grep -qi 'sitemap'; then
  pass "Template 2 includes sitemap check"
else
  fail "Template 2 is missing sitemap check (present in Section 9 canon checklist)"
fi

if echo "$TEMPLATE2_SECTION" | grep -qi 'bing\|LCP\|CLS\|TBT'; then
  pass "Template 2 includes Lighthouse metric / Bing Webmaster check"
else
  fail "Template 2 missing Bing Webmaster Tools or Lighthouse metric assertions"
fi

# ── TEST 14: templates.md — Template 7 exists ────────────────────
section "TEST GROUP 14: Template 7 — Migration/Refactoring"

if grep -q 'TEMPLATE 7' "$REPO_DIR/prompts/templates.md"; then
  pass "Template 7 (migration/refactoring) exists"
else
  fail "Template 7 (migration/refactoring) is missing"
fi

# ── TEST 15: .claude/CLAUDE.md — has .env / secrets guidance ─────
section "TEST GROUP 15: .claude/CLAUDE.md — secrets safety"

if grep -qi '\.env\|secret\|api.key\|gitignore' "$REPO_DIR/.claude/CLAUDE.md"; then
  pass ".claude/CLAUDE.md includes .env / secrets safety guidance"
else
  fail ".claude/CLAUDE.md missing .env / secrets guidance — risk of committed credentials"
fi

# ── TEST 16: copilot-instructions.md — system-ui banned ──────────
section "TEST GROUP 16: copilot-instructions.md — banned fonts complete"

if grep -q 'system-ui' "$REPO_DIR/.github/copilot-instructions.md"; then
  pass "copilot-instructions.md bans system-ui as display font"
else
  fail "copilot-instructions.md missing system-ui in NEVER use fonts list"
fi

# ── TEST 17: copilot-instructions.md — TypeScript guidance ───────
section "TEST GROUP 17: copilot-instructions.md — TypeScript guidance"

if grep -qi 'typescript\|\.ts\b' "$REPO_DIR/.github/copilot-instructions.md"; then
  pass "copilot-instructions.md includes TypeScript guidance"
else
  fail "copilot-instructions.md has no TypeScript guidance (Copilot defaults to TS)"
fi

# ── TEST 18: gemini-system.md — og:locale present ────────────────
section "TEST GROUP 18: gemini-system.md — og:locale"

if grep -q 'og:locale' "$REPO_DIR/prompts/gemini-system.md"; then
  pass "gemini-system.md lists og:locale in SEO meta tags"
else
  fail "gemini-system.md missing og:locale from SEO meta tags list"
fi

# ── TEST 19: copilot-instructions.md — meta robots present ───────
section "TEST GROUP 19: copilot-instructions.md — meta robots"

if grep -q 'robots' "$REPO_DIR/.github/copilot-instructions.md"; then
  pass "copilot-instructions.md includes meta name=\"robots\" in ALWAYS list"
else
  fail "copilot-instructions.md missing meta name=\"robots\" from ALWAYS include list"
fi

# ── TEST 20: README.md — correct GitHub clone URL ────────────────
section "TEST GROUP 20: README.md — correct GitHub clone URL"

if grep -q 'swiftweb/swiftweb-ai-system' "$REPO_DIR/README.md"; then
  fail "README.md uses wrong clone URL (swiftweb/...) — should be jon-salud/swiftweb-ai-system"
else
  pass "README.md clone URL uses correct owner (jon-salud)"
fi

# ── TEST 21: No set -e contradiction with || true on critical ops ─
section "TEST GROUP 21: install.sh — no critical suppression"

# Count || true on non-sed/non-optional lines
SUPPRESSED=$(grep '|| true' "$REPO_DIR/install.sh" | grep -v 'sed\|mkdir\|2>/dev/null' | wc -l | tr -d ' ')
if [ "$SUPPRESSED" -gt "0" ]; then
  fail "install.sh suppresses errors with '|| true' on $SUPPRESSED critical operation(s)"
else
  pass "install.sh does not suppress errors on critical operations"
fi

# ── SUMMARY ──────────────────────────────────────────────────────
TOTAL=$((PASS + FAIL))
echo ""
echo "═══════════════════════════════════════════════════════════"
echo -e "${BOLD}  Test Results: $PASS/$TOTAL passed${RESET}"
if [ "$FAIL" -gt 0 ]; then
  echo -e "  ${RED}$FAIL test(s) failed${RESET}"
  echo ""
  echo "  Run 'bash install.sh' after fixes, then re-run tests."
  echo "═══════════════════════════════════════════════════════════"
  exit 1
else
  echo -e "  ${GREEN}All tests passed!${RESET}"
  echo "═══════════════════════════════════════════════════════════"
  exit 0
fi
