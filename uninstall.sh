#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# SwiftWeb AI System Uninstaller
# Removes all files and shell aliases installed by install.sh
#
# Usage: bash uninstall.sh
# ═══════════════════════════════════════════════════════════════

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'
BOLD='\033[1m'

echo ""
echo -e "${YELLOW}${BOLD}  SwiftWeb AI System — Uninstaller${RESET}"
echo ""
echo "  This will remove:"
echo "  ├── ~/.swiftweb/           (all SwiftWeb config files)"
echo "  ├── ~/.claude/CLAUDE.md    (SwiftWeb Claude instructions)"
echo "  ├── ~/.claude/SWIFTWEB_GUIDELINES.md"
echo "  ├── VS Code swiftweb snippets"
echo "  └── Shell aliases from your RC file"
echo ""
read -p "  Continue? (y/N): " confirm
case "$confirm" in
  [yY][eE][sS]|[yY]) echo "";;
  *) echo "  Aborted."; exit 0;;
esac

# ── 1. Remove ~/.swiftweb directory ─────────────────────────────
echo -e "${GREEN}[1/4]${RESET} Removing ~/.swiftweb directory"
if [ -d "$HOME/.swiftweb" ]; then
  rm -rf "$HOME/.swiftweb"
  echo "      ✓ Removed ~/.swiftweb"
else
  echo "      → ~/.swiftweb not found, skipping"
fi

# ── 2. Remove Claude global files ───────────────────────────────
echo -e "${GREEN}[2/4]${RESET} Removing Claude Code SwiftWeb files"
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  # Only remove if it's a SwiftWeb file
  if grep -q 'SwiftWeb' "$HOME/.claude/CLAUDE.md" 2>/dev/null; then
    cp "$HOME/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md.swiftweb-backup"
    rm -f "$HOME/.claude/CLAUDE.md"
    echo "      ✓ Removed ~/.claude/CLAUDE.md"
    echo "      → Backup saved: ~/.claude/CLAUDE.md.swiftweb-backup"
    echo "        (restore with: cp ~/.claude/CLAUDE.md.swiftweb-backup ~/.claude/CLAUDE.md)"
  else
    echo "      → ~/.claude/CLAUDE.md exists but is not a SwiftWeb file — skipping"
  fi
fi
if [ -f "$HOME/.claude/SWIFTWEB_GUIDELINES.md" ]; then
  rm -f "$HOME/.claude/SWIFTWEB_GUIDELINES.md"
  echo "      ✓ Removed ~/.claude/SWIFTWEB_GUIDELINES.md"
fi

# ── 3. Remove VS Code snippets ───────────────────────────────────
echo -e "${GREEN}[3/4]${RESET} Removing VS Code SwiftWeb snippets"
SNIPPET_FILE="$HOME/Library/Application Support/Code/User/snippets/swiftweb.code-snippets"
[ ! -f "$SNIPPET_FILE" ] && SNIPPET_FILE="$HOME/.config/Code/User/snippets/swiftweb.code-snippets"
if [ -f "$SNIPPET_FILE" ]; then
  rm -f "$SNIPPET_FILE"
  echo "      ✓ Removed swiftweb.code-snippets"
else
  echo "      → VS Code snippet file not found, skipping"
fi

# ── 4. Remove shell aliases ──────────────────────────────────────
echo -e "${GREEN}[4/4]${RESET} Removing shell aliases"

SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
  SHELL_RC="$HOME/.bash_profile"
fi

if [ -n "$SHELL_RC" ]; then
  if grep -q '# SwiftWeb AI aliases' "$SHELL_RC"; then
    sed -i.bak '/# SwiftWeb AI aliases/,/# End SwiftWeb/d' "$SHELL_RC"
    echo "      ✓ Removed SwiftWeb alias block from $SHELL_RC"
    echo "      → Backup saved: ${SHELL_RC}.bak"
  else
    echo "      → No SwiftWeb aliases found in $SHELL_RC"
  fi
else
  echo "      → No shell RC file detected"
fi

# ── Done ─────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}${BOLD}  Uninstall complete.${RESET}"
echo ""
echo "  To apply alias removal: source $SHELL_RC"
echo "  Or open a new terminal window."
echo ""
