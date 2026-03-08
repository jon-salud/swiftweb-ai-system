#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# SwiftWeb AI System Installer
# Sets up agency guidelines across all AI tools on this machine
#
# Usage: bash install.sh
# ═══════════════════════════════════════════════════════════════

set -e

SWIFTWEB_DIR="$HOME/.swiftweb"
GREEN='\033[0;32m'
LIME='\033[1;33m'
RESET='\033[0m'
BOLD='\033[1m'

echo ""
echo -e "${LIME}${BOLD}  ███████╗██╗    ██╗██╗███████╗████████╗${RESET}"
echo -e "${LIME}${BOLD}  ██╔════╝██║    ██║██║██╔════╝╚══██╔══╝${RESET}"
echo -e "${LIME}${BOLD}  ███████╗██║ █╗ ██║██║█████╗     ██║   ${RESET}"
echo -e "${LIME}${BOLD}  ╚════██║██║███╗██║██║██╔══╝     ██║   ${RESET}"
echo -e "${LIME}${BOLD}  ███████║╚███╔███╔╝██║██║        ██║   ${RESET}"
echo -e "${LIME}${BOLD}  ╚══════╝ ╚══╝╚══╝ ╚═╝╚═╝        ╚═╝   ${RESET}"
echo ""
echo -e "  ${BOLD}AI System Installer${RESET} — Auckland Web Design Agency"
echo ""

# ── 1. Create ~/.swiftweb directory ──────────────────────────────
echo -e "${GREEN}[1/7]${RESET} Creating SwiftWeb config directory at $SWIFTWEB_DIR"
mkdir -p "$SWIFTWEB_DIR"
cp SWIFTWEB_GUIDELINES.md "$SWIFTWEB_DIR/"
cp prompts/templates.md "$SWIFTWEB_DIR/"
cp prompts/gemini-system.md "$SWIFTWEB_DIR/"
echo "      ✓ Guidelines installed to $SWIFTWEB_DIR"

# ── 2. Claude Code — global CLAUDE.md ────────────────────────────
echo -e "${GREEN}[2/7]${RESET} Installing Claude Code global instructions"
CLAUDE_GLOBAL="$HOME/.claude"
mkdir -p "$CLAUDE_GLOBAL"
cp .claude/CLAUDE.md "$CLAUDE_GLOBAL/CLAUDE.md"
# Also copy full guidelines so CLAUDE.md can reference them
cp SWIFTWEB_GUIDELINES.md "$CLAUDE_GLOBAL/SWIFTWEB_GUIDELINES.md"
echo "      ✓ Global CLAUDE.md installed at $CLAUDE_GLOBAL/CLAUDE.md"

# ── 3. Shell aliases ──────────────────────────────────────────────
echo -e "${GREEN}[3/7]${RESET} Adding shell aliases"

SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
  SHELL_RC="$HOME/.bash_profile"
fi

if [ -n "$SHELL_RC" ]; then
  # Remove old SwiftWeb block if exists
  sed -i.bak '/# SwiftWeb AI aliases/,/# End SwiftWeb/d' "$SHELL_RC" 2>/dev/null || true

  cat >> "$SHELL_RC" << 'ALIASES'

# SwiftWeb AI aliases
export SWIFTWEB_DIR="$HOME/.swiftweb"

# Gemini CLI with SwiftWeb system prompt auto-loaded
swgem() {
  gemini --system-prompt "$(cat $SWIFTWEB_DIR/gemini-system.md)" "$@"
}

# Cross-platform clipboard helper
_swiftweb_copy() {
  if command -v pbcopy &>/dev/null; then
    echo "$1" | pbcopy
  elif command -v xclip &>/dev/null; then
    echo "$1" | xclip -selection clipboard
  elif command -v xsel &>/dev/null; then
    echo "$1" | xsel --clipboard --input
  else
    return 1
  fi
}

# New client site — prompts for details then generates
swiftweb-new() {
  echo "SwiftWeb New Site Generator"
  read -p "Business Name: " biz_name
  read -p "Business Type: " biz_type
  read -p "City: " city
  read -p "Primary Services (comma separated): " services
  read -p "Framework (astro/nextjs/html): " framework

  PROMPT="Build a complete website for SwiftWeb client. Business: $biz_name. Type: $biz_type. Location: $city, New Zealand. Services: $services. Framework: $framework. Apply all SwiftWeb standards: SSR, full meta tags, Schema.org JSON-LD, ai-description meta, llms.txt, CSS-only animations, Lighthouse 95+."

  echo ""
  echo "Prompt ready. Copy and use with your preferred AI tool:"
  echo "────────────────────────────────────────────────────────"
  echo "$PROMPT"
  echo "────────────────────────────────────────────────────────"
  if _swiftweb_copy "$PROMPT"; then
    echo "(Copied to clipboard)"
  fi
}

# Audit a site
swiftweb-audit() {
  local url="${1:-}"
  if [ -z "$url" ]; then
    read -p "Site URL to audit: " url
  fi
  echo "Auditing $url against SwiftWeb standards..."
  cat "$SWIFTWEB_DIR/templates.md" | grep -A 50 "TEMPLATE 2: SEO" | head -55
}

# Open guidelines
swiftweb-guidelines() {
  cat "$SWIFTWEB_DIR/SWIFTWEB_GUIDELINES.md" | less
}

# Copy a prompt template
swiftweb-prompt() {
  local choice="${1:-}"
  if [ -z "$choice" ]; then
    echo "Available templates:"
    echo "  1) New Site"
    echo "  2) SEO/AIO Audit"
    echo "  3) Component"
    echo "  4) Schema.org"
    echo "  5) llms.txt"
    echo "  6) Performance Fix"
    echo "  7) Migration/Refactoring"
    read -p "Choose (1-7): " choice
  fi
  local template_file="$SWIFTWEB_DIR/templates.md"
  if [ ! -f "$template_file" ]; then
    echo "Error: templates file not found at $template_file"
    return 1
  fi
  # Validate input strictly — reject anything that isn't 1-7 (prevents octal/expr errors)
  if ! echo "$choice" | grep -qE '^[1-7]$'; then
    echo "Invalid choice. Please enter 1-7."
    return 1
  fi
  # Map number to template heading
  local headings=("" "TEMPLATE 1" "TEMPLATE 2" "TEMPLATE 3" "TEMPLATE 4" "TEMPLATE 5" "TEMPLATE 6" "TEMPLATE 7")
  local heading="${headings[$choice]}"
  # Extract template block: start printing on the matched heading, stop on the next one
  local content
  content=$(awk -v heading="$heading" '
    $0 ~ "^## " heading { printing=1 }
    printing && $0 ~ "^## TEMPLATE [0-9]" && $0 !~ "^## " heading { exit }
    printing { print }
  ' "$template_file")
  echo ""
  echo "$content"
  echo ""
  if _swiftweb_copy "$content"; then
    echo "↑ Template $choice copied to clipboard — paste into your AI tool"
  fi
}
# End SwiftWeb
ALIASES

  echo "      ✓ Aliases added to $SHELL_RC"
  echo "      → Run: source $SHELL_RC  (or open a new terminal)"
else
  echo "      ⚠ Could not detect shell RC file. Add aliases manually from:"
  echo "        $SWIFTWEB_DIR/aliases.sh"
fi

# ── 4. New client project scaffold script ────────────────────────
echo -e "${GREEN}[4/7]${RESET} Installing new-project scaffold script"

cat > "$SWIFTWEB_DIR/new-project.sh" << 'SCAFFOLD'
#!/bin/bash
# SwiftWeb New Client Project Scaffold
# Usage: bash ~/.swiftweb/new-project.sh [project-name]

PROJECT="${1:-client-site}"
# Overwrite protection — prompt before clobbering existing work
if [ -d "$PROJECT" ]; then
  echo "Warning: Directory '$PROJECT' already exists."
  read -p "Overwrite? This cannot be undone. (y/N): " confirm
  case "$confirm" in
    [yY][eE][sS]|[yY]) echo "Proceeding...";;
    *) echo "Aborting."; exit 1;;
  esac
fi
mkdir -p "$PROJECT"/{public,src/{styles,components,pages}}

# CLAUDE.md in project root
cp ~/.swiftweb/SWIFTWEB_GUIDELINES.md "$PROJECT/SWIFTWEB_GUIDELINES.md"
cp ~/.claude/CLAUDE.md "$PROJECT/CLAUDE.md"

# robots.txt
cat > "$PROJECT/public/robots.txt" << 'ROBOTS'
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/

Sitemap: https://DOMAIN/sitemap.xml
ROBOTS

# llms.txt placeholder
cat > "$PROJECT/public/llms.txt" << 'LLMS'
# Business Name
[Replace with client business name]

## Services
- [Service 1]: [Description]
- [Service 2]: [Description]

## About
[Replace with 2-3 paragraph description of the business]

## Contact
- Website: https://DOMAIN
- Phone: [PHONE]
- Location: [CITY], New Zealand
LLMS

# CSS tokens
cat > "$PROJECT/src/styles/tokens.css" << 'TOKENS'
:root {
  /* Brand Colours — customise per client */
  --color-primary:  #0a0a0f;
  --color-accent:   #000000;
  --color-text:     #0a0a0f;
  --color-bg:       #ffffff;
  --color-surface:  #f5f3ee;
  --color-mist:     #888888;

  /* Typography — choose distinctive fonts per client */
  --font-display: 'Font Name', sans-serif;
  --font-body:    'Font Name', sans-serif;
  --font-mono:    'Font Name', monospace;

  /* Easing */
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-spring:   cubic-bezier(0.34, 1.56, 0.64, 1);

  /* Spacing scale */
  --space-xs:  0.5rem;
  --space-sm:  1rem;
  --space-md:  2rem;
  --space-lg:  4rem;
  --space-xl:  8rem;
  --space-2xl: 12rem;
}

/* Scroll reveal utility */
.reveal {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.8s var(--ease-out-expo),
              transform 0.8s var(--ease-out-expo);
}
.reveal.visible { opacity: 1; transform: translateY(0); }
.reveal-delay-1 { transition-delay: 0.1s; }
.reveal-delay-2 { transition-delay: 0.2s; }
.reveal-delay-3 { transition-delay: 0.3s; }
TOKENS

# .vscode/settings.json — embedded to avoid broken relative paths
mkdir -p "$PROJECT/.vscode"
cat > "$PROJECT/.vscode/settings.json" << 'VSCODE_SETTINGS'
{
  "github.copilot.chat.codeGeneration.instructions": [
    { "file": ".github/copilot-instructions.md" }
  ],
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "files.associations": {
    "*.css": "css",
    "*.html": "html"
  }
}
VSCODE_SETTINGS

# .github/copilot-instructions.md — copy from ~/.swiftweb if present
mkdir -p "$PROJECT/.github"
if [ -f "$HOME/.swiftweb/copilot-instructions.md" ]; then
  cp "$HOME/.swiftweb/copilot-instructions.md" "$PROJECT/.github/copilot-instructions.md"
else
  cat > "$PROJECT/.github/copilot-instructions.md" << 'COPILOT_STUB'
# GitHub Copilot Custom Instructions — SwiftWeb Agency
# Full instructions not found. Re-run: bash install.sh
# Refer to SWIFTWEB_GUIDELINES.md in this project root.
COPILOT_STUB
fi

echo ""
echo "✓ SwiftWeb project scaffolded: $PROJECT/"
echo ""
echo "  Structure:"
echo "  $PROJECT/"
echo "  ├── CLAUDE.md                    ← Claude Code instructions"
echo "  ├── SWIFTWEB_GUIDELINES.md       ← Full agency guidelines"
echo "  ├── public/"
echo "  │   ├── robots.txt"
echo "  │   └── llms.txt                 ← Update with client info"
echo "  ├── src/styles/"
echo "  │   └── tokens.css               ← Update with client brand"
echo "  ├── .vscode/settings.json        ← Copilot instructions"
echo "  └── .github/copilot-instructions.md"
echo ""
echo "  Next steps:"
echo "  1. Update public/llms.txt with client business description"
echo "  2. Update src/styles/tokens.css with client brand colours & fonts"
echo "  3. Open in VS Code or run: claude (in project directory)"
SCAFFOLD

chmod +x "$SWIFTWEB_DIR/new-project.sh"
echo "      ✓ Scaffold script installed at $SWIFTWEB_DIR/new-project.sh"

# ── 5. VS Code snippets ───────────────────────────────────────────
echo -e "${GREEN}[5/7]${RESET} Installing VS Code HTML snippets"

VSCODE_SNIPPETS_DIR="$HOME/Library/Application Support/Code/User/snippets"
[ ! -d "$VSCODE_SNIPPETS_DIR" ] && VSCODE_SNIPPETS_DIR="$HOME/.config/Code/User/snippets"
mkdir -p "$VSCODE_SNIPPETS_DIR" 2>/dev/null || true

cat > "$VSCODE_SNIPPETS_DIR/swiftweb.code-snippets" << 'SNIPPETS'
{
  "SwiftWeb HTML Head": {
    "prefix": "sw-head",
    "description": "SwiftWeb compliant HTML head with all SEO + AIO tags",
    "body": [
      "<head>",
      "  <meta charset=\"UTF-8\">",
      "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
      "  <meta name=\"theme-color\" content=\"${1:#000000}\">",
      "",
      "  <title>${2:Keyword} — ${3:Brand} ${4:Auckland}</title>",
      "  <meta name=\"description\" content=\"${5:150-160 char description with keyword and CTA}\">",
      "  <meta name=\"robots\" content=\"index, follow\">",
      "  <link rel=\"canonical\" href=\"${6:https://domain.co.nz/}\">",
      "",
      "  <meta property=\"og:type\" content=\"website\">",
      "  <meta property=\"og:url\" content=\"${6}\">",
      "  <meta property=\"og:title\" content=\"${2} — ${3} ${4}\">",
      "  <meta property=\"og:description\" content=\"${5}\">",
      "  <meta property=\"og:image\" content=\"${6}og-image.jpg\">",
      "  <meta property=\"og:locale\" content=\"en_NZ\">",
      "  <meta name=\"twitter:card\" content=\"summary_large_image\">",
      "  <meta name=\"twitter:title\" content=\"${2} — ${3} ${4}\">",
      "  <meta name=\"twitter:description\" content=\"${5}\">",
      "",
      "  <meta name=\"ai-description\" content=\"${7:Plain English: what the business does, who they serve, where they are.}\">",
      "",
      "  <script type=\"application/ld+json\">",
      "  {",
      "    \"@context\": \"https://schema.org\",",
      "    \"@type\": \"${8:ProfessionalService}\",",
      "    \"name\": \"${3}\",",
      "    \"url\": \"${6}\",",
      "    \"description\": \"${7}\",",
      "    \"address\": {",
      "      \"@type\": \"PostalAddress\",",
      "      \"addressLocality\": \"${4}\",",
      "      \"addressCountry\": \"NZ\"",
      "    },",
      "    \"areaServed\": \"New Zealand\"",
      "  }",
      "  </script>",
      "",
      "  <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">",
      "  <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>",
      "</head>"
    ]
  },
  "SwiftWeb Scroll Reveal": {
    "prefix": "sw-reveal",
    "description": "SwiftWeb CSS scroll reveal + IntersectionObserver",
    "body": [
      "/* Scroll reveal CSS */",
      ".reveal {",
      "  opacity: 0;",
      "  transform: translateY(30px);",
      "  transition: opacity 0.8s cubic-bezier(0.16,1,0.3,1),",
      "              transform 0.8s cubic-bezier(0.16,1,0.3,1);",
      "}",
      ".reveal.visible { opacity: 1; transform: translateY(0); }",
      ".reveal-delay-1 { transition-delay: 0.1s; }",
      ".reveal-delay-2 { transition-delay: 0.2s; }",
      ".reveal-delay-3 { transition-delay: 0.3s; }",
      "",
      "/* IntersectionObserver JS */",
      "const revealObserver = new IntersectionObserver((entries) => {",
      "  entries.forEach(entry => {",
      "    if (entry.isIntersecting) {",
      "      entry.target.classList.add('visible');",
      "      revealObserver.unobserve(entry.target);",
      "    }",
      "  });",
      "}, { threshold: 0.12 });",
      "document.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));"
    ]
  },
  "SwiftWeb Schema ProfessionalService": {
    "prefix": "sw-schema",
    "description": "SwiftWeb Schema.org JSON-LD for professional service",
    "body": [
      "<script type=\"application/ld+json\">",
      "{",
      "  \"@context\": \"https://schema.org\",",
      "  \"@type\": \"${1:ProfessionalService}\",",
      "  \"name\": \"${2:Business Name}\",",
      "  \"url\": \"${3:https://domain.co.nz}\",",
      "  \"logo\": \"${3}/logo.png\",",
      "  \"description\": \"${4:Description}\",",
      "  \"address\": {",
      "    \"@type\": \"PostalAddress\",",
      "    \"addressLocality\": \"${5:Auckland}\",",
      "    \"addressCountry\": \"NZ\"",
      "  },",
      "  \"areaServed\": \"New Zealand\",",
      "  \"serviceType\": [\"${6:Service 1}\", \"${7:Service 2}\"],",
      "  \"telephone\": \"${8:+64-9-000-0000}\",",
      "  \"openingHours\": \"Mo-Fr 09:00-17:00\",",
      "  \"sameAs\": [\"${9:LinkedIn URL}\"]",
      "}",
      "</script>"
    ]
  },
  "SwiftWeb llms.txt": {
    "prefix": "sw-llms",
    "description": "SwiftWeb llms.txt template",
    "body": [
      "# ${1:Business Name}",
      "${1} is a ${2:type} business based in ${3:Auckland}, New Zealand.",
      "",
      "## Services",
      "- ${4:Service 1}: ${5:Description}",
      "- ${6:Service 2}: ${7:Description}",
      "",
      "## About",
      "${8:Two to three paragraphs describing the business in plain English.}",
      "",
      "## Contact",
      "- Website: ${9:https://domain.co.nz}",
      "- Phone: ${10:+64 9 000 0000}",
      "- Location: ${3}, New Zealand"
    ]
  }
}
SNIPPETS

echo "      ✓ VS Code snippets installed (sw-head, sw-reveal, sw-schema, sw-llms)"

# ── 5b. Copy copilot-instructions.md to ~/.swiftweb for scaffold use ──
cp .github/copilot-instructions.md "$SWIFTWEB_DIR/copilot-instructions.md"
echo "      ✓ copilot-instructions.md cached in $SWIFTWEB_DIR"

# ── 6. Lighthouse CI config ───────────────────────────────────────
echo -e "${GREEN}[6/7]${RESET} Creating Lighthouse CI config template"

cat > "$SWIFTWEB_DIR/lighthouserc.json" << 'LHCI'
{
  "_comment_framework": "IMPORTANT: Update startServerCommand and url for your framework. See examples below.",
  "_examples": {
    "nextjs":  { "startServerCommand": "npm run build && npm run start", "url": ["http://localhost:3000/"] },
    "astro":   { "startServerCommand": "npm run build && npm run preview", "url": ["http://localhost:4321/"] },
    "nuxt":    { "startServerCommand": "npm run build && npm run preview", "url": ["http://localhost:3000/"] },
    "html":    { "startServerCommand": "npx serve .", "url": ["http://localhost:3000/"] }
  },
  "ci": {
    "collect": {
      "numberOfRuns": 3,
      "startServerCommand": "npm run build && npm run start",
      "url": ["http://localhost:3000/"]
    },
    "assert": {
      "preset": "lighthouse:no-pwa",
      "assertions": {
        "categories:performance": ["error", {"minScore": 0.95}],
        "categories:accessibility": ["error", {"minScore": 1.0}],
        "categories:best-practices": ["error", {"minScore": 1.0}],
        "categories:seo": ["error", {"minScore": 1.0}],
        "largest-contentful-paint": ["error", {"maxNumericValue": 2500}],
        "total-blocking-time": ["error", {"maxNumericValue": 200}],
        "cumulative-layout-shift": ["error", {"maxNumericValue": 0.1}],
        "first-contentful-paint": ["error", {"maxNumericValue": 1800}],
        "uses-optimized-images": "warn",
        "uses-webp-images": "warn",
        "render-blocking-resources": "error",
        "uses-text-compression": "warn",
        "meta-description": "error",
        "document-title": "error",
        "html-has-lang": "error",
        "image-alt": "error",
        "link-name": "error"
      }
    },
    "upload": {
      "target": "temporary-public-storage"
    }
  }
}
LHCI

echo "      ✓ Lighthouse CI config saved at $SWIFTWEB_DIR/lighthouserc.json"
echo "      → Copy to project root and run: npx @lhci/cli autorun"

# ── 7. Summary ────────────────────────────────────────────────────
echo -e "${GREEN}[7/7]${RESET} Installation complete!"
echo ""
echo -e "${LIME}${BOLD}  SwiftWeb AI System Installed${RESET}"
echo ""
echo "  What was installed:"
echo "  ├── ~/.swiftweb/SWIFTWEB_GUIDELINES.md   ← Master guidelines"
echo "  ├── ~/.swiftweb/templates.md              ← Reusable prompts"
echo "  ├── ~/.swiftweb/gemini-system.md          ← Gemini CLI system prompt"
echo "  ├── ~/.swiftweb/new-project.sh            ← Project scaffold script"
echo "  ├── ~/.swiftweb/lighthouserc.json         ← Lighthouse CI config"
echo "  ├── ~/.claude/CLAUDE.md                   ← Claude Code global instructions"
echo "  └── VS Code snippets (sw-head, sw-reveal, sw-schema, sw-llms)"
echo ""
echo "  Shell commands now available (after: source ~/.zshrc):"
echo "  swgem 'prompt'              → Gemini with SwiftWeb guidelines"
echo "  swiftweb-new                → New client site prompt generator"
echo "  swiftweb-audit [url]        → Audit site against standards"
echo "  swiftweb-guidelines         → View full guidelines in pager"
echo "  swiftweb-prompt [1-7]       → Copy a prompt template to clipboard"
echo ""
echo "  New project scaffold:"
echo "  bash ~/.swiftweb/new-project.sh my-client"
echo ""
echo "  Tool coverage:"
echo "  ✓ Claude Code    → ~/.claude/CLAUDE.md (auto-loaded)"
echo "  ✓ VS Code        → .vscode/settings.json + .github/copilot-instructions.md"
echo "  ✓ GitHub Copilot → .github/copilot-instructions.md"
echo "  ✓ Gemini CLI     → swgem alias with system prompt"
echo "  ✓ Any AI tool    → ~/.swiftweb/templates.md prompt library"
echo ""
