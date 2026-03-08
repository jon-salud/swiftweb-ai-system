# SwiftWeb AI System
**Agency-wide AI compliance for web design projects**

One install. Every AI tool follows your standards automatically.

---

## The Problem This Solves

When you switch between Claude Code, VS Code Copilot, Gemini CLI, and other
AI tools mid-project, each one starts fresh with no knowledge of your agency
standards. You end up manually reminding every tool about SSR rendering,
meta tags, schema markup, and CSS-only animations — every single session.

This system solves that by placing your guidelines *once* in the right location
for each tool to auto-load them.

---

## Quick Install

```bash
bash install.sh
source ~/.zshrc   # or ~/.bashrc
```

That's it. All tools are now configured.

---

## What Gets Installed & Where

```
~/.claude/
└── CLAUDE.md                   ← Claude Code reads this automatically
                                   on every session in every project

~/.swiftweb/
├── SWIFTWEB_GUIDELINES.md      ← Master guidelines (single source of truth)
├── templates.md                ← 6 reusable prompt templates
├── gemini-system.md            ← Gemini CLI system prompt
├── new-project.sh              ← Scaffolds a new client project
└── lighthouserc.json           ← Lighthouse CI pass/fail thresholds

Per-project (added by new-project.sh or manually):
├── CLAUDE.md                   ← Claude Code project-level override
├── .vscode/settings.json       ← VS Code + Copilot inline instructions
└── .github/copilot-instructions.md  ← GitHub Copilot instructions
```

---

## Tool-by-Tool Guide

### Claude Code
**How it works:** Claude Code automatically reads `CLAUDE.md` from the current
directory, then falls back to `~/.claude/CLAUDE.md`.

**Setup:** Already done by `install.sh`. Just run `claude` in any project.

**Result:** Every Claude Code session starts knowing all SwiftWeb standards.
You never need to re-explain SSR, meta tags, schema, or animation rules.

---

### VS Code + GitHub Copilot
**How it works:** Copilot reads `.github/copilot-instructions.md` in the
project root and applies them to all chat and inline suggestions.

**Setup:** `install.sh` installs global snippets. For each project, run:
```bash
bash ~/.swiftweb/new-project.sh [project-name]
```
This creates the `.github/copilot-instructions.md` and `.vscode/settings.json`.

**VS Code Snippets available after install:**
| Trigger | What it inserts |
|---------|----------------|
| `sw-head` | Complete SEO+AIO HTML `<head>` |
| `sw-reveal` | CSS scroll reveal + IntersectionObserver JS |
| `sw-schema` | Schema.org JSON-LD block |
| `sw-llms` | llms.txt template |

---

### Gemini CLI
**How it works:** The `swgem` alias automatically prepends the SwiftWeb
system prompt to every Gemini CLI call.

**Usage:**
```bash
swgem "Build a hero section for a physiotherapy clinic in Hamilton"
swgem "Audit this site for SEO issues: [paste HTML]"
swgem "Generate Schema.org JSON-LD for a restaurant in Christchurch"
```

**Direct usage without alias:**
```bash
gemini --system-prompt "$(cat ~/.swiftweb/gemini-system.md)" "your prompt"
```

---

### Any Other AI Tool (ChatGPT, Perplexity, etc.)
Use the prompt templates in `~/.swiftweb/templates.md`.

Six templates cover all common scenarios:
1. **New Client Site** — full site from a brief
2. **SEO & AIO Audit** — compliance checklist against existing code
3. **Component Generation** — individual section with brand context
4. **Schema.org Generator** — structured data from client info
5. **llms.txt Generator** — AI optimisation file
6. **Performance Fix** — Lighthouse score improvement

---

## Starting a New Client Project

```bash
bash ~/.swiftweb/new-project.sh acme-plumbing
cd acme-plumbing
```

This scaffolds:
```
acme-plumbing/
├── CLAUDE.md                    ← Project AI instructions
├── SWIFTWEB_GUIDELINES.md
├── public/
│   ├── robots.txt
│   └── llms.txt                 ← Update with client info
├── src/styles/
│   └── tokens.css               ← Update with client brand
├── .vscode/settings.json
└── .github/copilot-instructions.md
```

Then fill in `public/llms.txt` and `src/styles/tokens.css` with client-specific
info, and open the project in your preferred tool.

---

## Lighthouse CI

Every project should include automated Lighthouse testing. Copy the config:

```bash
cp ~/.swiftweb/lighthouserc.json ./lighthouserc.json
npm install -D @lhci/cli
npx @lhci/cli autorun
```

The config enforces hard failures if scores drop below:
- Performance: 95
- Accessibility: 100
- Best Practices: 100
- SEO: 100

Add to your CI/CD pipeline (GitHub Actions, Vercel, Netlify) to block
deploys that fail SwiftWeb standards.

---

## Updating the Guidelines

The master file is `~/.swiftweb/SWIFTWEB_GUIDELINES.md`.
Edit it once and all tools pick up the changes on their next session.

For Claude Code specifically, changes to `~/.claude/CLAUDE.md` take effect
immediately on the next `claude` session.

---

## The Architecture Explained

```
SWIFTWEB_GUIDELINES.md          ← Single source of truth
        │
        ├── ~/.claude/CLAUDE.md          → Claude Code (auto-loaded)
        ├── .github/copilot-instructions → GitHub Copilot (per-project)
        ├── .vscode/settings.json        → VS Code inline instructions
        ├── swgem alias                  → Gemini CLI (system prompt)
        └── templates.md                → Manual use in any AI tool
```

The key principle: **guidelines live once, flow everywhere.**
You maintain one file. All AI tools read from it.
