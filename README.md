# SwiftWeb AI System

Agency-wide AI compliance for web design projects — one install, every AI tool follows your standards automatically.

---

## Table of Contents

1. [What Is This?](#1-what-is-this)
2. [The Problem It Solves](#2-the-problem-it-solves)
3. [Prerequisites](#3-prerequisites)
4. [Installation](#4-installation)
5. [What Gets Installed](#5-what-gets-installed)
6. [Shell Commands Reference](#6-shell-commands-reference)
7. [VS Code Snippets Reference](#7-vs-code-snippets-reference)
8. [Tool-by-Tool Guide](#8-tool-by-tool-guide)
9. [Starting a New Client Project — Step by Step](#9-starting-a-new-client-project--step-by-step)
10. [Prompt Templates Guide](#10-prompt-templates-guide)
11. [Lighthouse CI — Automated Quality Checks](#11-lighthouse-ci--automated-quality-checks)
12. [Uninstalling](#12-uninstalling)
13. [Updating the Guidelines](#13-updating-the-guidelines)
14. [How It All Fits Together](#14-how-it-all-fits-together)
15. [Troubleshooting](#15-troubleshooting)
16. [FAQ](#16-faq)

---

## 1. What Is This?

The SwiftWeb AI System is a set of configuration files and shell commands that
teach AI coding tools — Claude Code, GitHub Copilot, and Gemini CLI — about
SwiftWeb's web design standards.

**If you have never used AI coding tools before:** these tools write HTML, CSS,
and JavaScript for you when you describe what you want in plain English. The
problem is they start each conversation with a blank slate and no knowledge of
how SwiftWeb builds websites. This system fixes that by loading your agency
standards into every AI tool automatically, before you type a single word.

**The result:** you open any AI tool, describe the client project, and the AI
already knows to include SEO meta tags, Schema.org structured data, CSS-only
animations, and all other SwiftWeb standards — without you having to ask.

---

## 2. The Problem It Solves

Every time you start a new session with an AI tool, it has no memory of your
previous conversations or your agency standards. You end up repeating yourself:

> "Make sure all content is in static HTML, not JavaScript. Add meta tags. Use
> Schema.org structured data. No GSAP animations. Lighthouse score must be 95+…"

This system puts those instructions into a file that each AI tool reads
automatically at the start of every session. You set it up once and never
repeat yourself again.

---

## 3. Prerequisites

Before installing, make sure you have the following. If you are unsure whether
something is installed, the check command is provided next to each item.

**Required:**

| Tool | What it is | Check if installed |
| --- | --- | --- |
| macOS or Linux | Operating system | — |
| Terminal app | Command-line interface (Terminal on Mac) | Already on your Mac |
| Git | Version control tool | `git --version` |
| Node.js (v18+) | JavaScript runtime | `node --version` |

**Optional (install when you want to use that tool):**

| Tool | What it is | Install |
| --- | --- | --- |
| Claude Code | Anthropic's AI coding agent | `npm install -g @anthropic-ai/claude-code` |
| Gemini CLI | Google's AI command-line tool | `npm install -g @google/gemini-cli` |
| VS Code | Code editor with Copilot support | Download from code.visualstudio.com |
| GitHub Copilot | AI assistant inside VS Code | Install the Copilot extension in VS Code |

> **What is a terminal?** It is the black or white window where you type
> commands. On a Mac, press `Command + Space`, type "Terminal", and press Enter.

---

## 4. Installation

### Step 1 — Download this repository

If you received this as a zip file, unzip it. If you have Git installed:

```bash
git clone https://github.com/jon-salud/swiftweb-ai-system.git
cd swiftweb-ai-system
```

### Step 2 — Run the installer

In your terminal, navigate to the folder and run:

```bash
bash install.sh
```

You will see the installer work through 7 steps, confirming each one. The
whole process takes about 10 seconds.

### Step 3 — Reload your shell

```bash
source ~/.zshrc
```

> If you use bash instead of zsh (run `echo $SHELL` to check), use:
> `source ~/.bashrc`

### Step 4 — Verify installation

Run this to confirm the new commands are available:

```bash
swiftweb-guidelines
```

If you see the SwiftWeb guidelines printed in the terminal, the install worked.
Press `q` to exit.

---

## 5. What Gets Installed

The installer creates files in the following locations. You do not need to
manage these directly — they work automatically in the background.

```text
~/.claude/
└── CLAUDE.md                        ← Claude Code reads this automatically
                                        on every session in every project

~/.swiftweb/
├── SWIFTWEB_GUIDELINES.md           ← Master agency standards (single source of truth)
├── templates.md                     ← 6 reusable prompt templates
├── gemini-system.md                 ← Gemini CLI system prompt
├── new-project.sh                   ← New client project scaffold script
└── lighthouserc.json                ← Lighthouse CI pass/fail thresholds

~/Library/Application Support/Code/User/snippets/
└── swiftweb.code-snippets           ← VS Code typing shortcuts

~/.zshrc (or ~/.bashrc)
└── [shell commands appended]        ← swgem, swiftweb-new, swiftweb-audit, etc.
```

**Per-project files** (created by `new-project.sh` for each client):

```text
my-client/
├── CLAUDE.md                        ← Claude Code project-level instructions
├── SWIFTWEB_GUIDELINES.md           ← Guidelines copy for reference
├── public/
│   ├── robots.txt                   ← Search engine crawl rules
│   └── llms.txt                     ← AI crawler description file
├── src/styles/
│   └── tokens.css                   ← Brand colours, fonts, spacing variables
├── .vscode/settings.json            ← VS Code + Copilot settings
└── .github/copilot-instructions.md  ← GitHub Copilot instructions
```

---

## 6. Shell Commands Reference

After installation and running `source ~/.zshrc`, the following commands are
available in your terminal from any directory.

---

### `swgem` — Gemini CLI with SwiftWeb guidelines pre-loaded

Sends a prompt to Google's Gemini CLI with the SwiftWeb system prompt
automatically attached. Gemini will follow all agency standards in its response.

**Syntax:**

```bash
swgem "your prompt here"
```

**Examples:**

```bash
# Build a hero section
swgem "Build a hero section for a physiotherapy clinic in Hamilton"

# Generate structured data
swgem "Generate Schema.org JSON-LD for a restaurant called Harbour Kitchen in Wellington"

# Audit existing code
swgem "Audit this HTML for SEO and performance issues: $(cat index.html)"

# Generate an llms.txt file
swgem "Write an llms.txt file for Auckland law firm Mitchell & Associates, specialising in property and commercial law"

# Fix Lighthouse issues
swgem "This site scores 72 on Lighthouse performance. Here is the HTML: $(cat index.html). List every fix needed."
```

> **Requires:** Gemini CLI installed (`npm install -g @google/gemini-cli`) and
> a valid Google API key configured.

---

### `swiftweb-new` — New client site prompt generator

An interactive command that asks you questions about the client, then builds a
complete AI prompt and copies it to your clipboard, ready to paste into any AI
tool (Claude, Copilot Chat, ChatGPT, etc.).

**Usage:**

```bash
swiftweb-new
```

You will be asked:

```text
Business Name:
Business Type:
City:
Primary Services (comma separated):
Framework (astro/nextjs/html):
```

After answering, the command prints a fully formatted, standards-compliant
prompt and copies it to your clipboard. Paste it into any AI tool to generate
a complete website.

---

### `swiftweb-audit` — Audit a site against SwiftWeb standards

Displays the full SEO and AIO audit checklist from your templates. Use this
as a guide when reviewing a site manually, or pass it to an AI tool along with
the site's HTML source.

**Usage:**

```bash
# Opens the audit checklist
swiftweb-audit

# Optionally pass a URL as an argument
swiftweb-audit https://example.co.nz
```

**How to use with an AI tool:**

1. Run `swiftweb-audit` to get the checklist
2. In your browser, visit the site you want to audit
3. Press `Command + U` (Mac) to view the page source
4. Select all (`Command + A`), copy (`Command + C`)
5. Open your AI tool, paste the HTML, then paste the audit checklist
6. Ask the AI to check every item and provide fixes

---

### `swiftweb-guidelines` — View the full agency guidelines

Prints the complete SwiftWeb guidelines document to your terminal. Useful for
a quick reference when working without an AI tool.

**Usage:**

```bash
swiftweb-guidelines
```

Use arrow keys to scroll. Press `q` to exit.

---

### `swiftweb-prompt` — Browse and copy prompt templates

Shows a numbered menu of the 7 available prompt templates and copies the
selected template to your clipboard automatically.

**Usage:**

```bash
swiftweb-prompt        # Interactive menu
swiftweb-prompt 3      # Jump directly to Template 3
```

You will see:

```text
Available templates:
  1) New Site
  2) SEO/AIO Audit
  3) Component
  4) Schema.org
  5) llms.txt
  6) Performance Fix
  7) Migration/Refactoring
Choose (1-7):
```

Choose a number and the full template text is printed and copied to your
clipboard. Paste it directly into your AI tool.

---

### `bash ~/.swiftweb/new-project.sh` — Scaffold a new client project folder

Creates a complete, ready-to-use project folder for a new client with all
required files pre-filled. Run this once at the start of every new project.

**Usage:**

```bash
bash ~/.swiftweb/new-project.sh client-name
```

Replace `client-name` with a short, lowercase, hyphenated name for the project
(e.g. `acme-plumbing`, `harbour-dental`, `city-law-firm`).

**Example:**

```bash
bash ~/.swiftweb/new-project.sh harbour-dental
cd harbour-dental
```

After running, open the folder in VS Code:

```bash
code harbour-dental
```

---

## 7. VS Code Snippets Reference

After installation, four typing shortcuts are available in VS Code whenever you
are editing `.html`, `.astro`, `.jsx`, `.tsx`, or `.vue` files.

**How to use a snippet:**

1. Open a file in VS Code
2. Type the snippet trigger (e.g. `sw-head`)
3. Press `Tab` — the full code block appears
4. Press `Tab` again to jump between the placeholder fields and fill them in

---

### `sw-head` — Complete HTML `<head>` block

Inserts a complete, SEO-ready `<head>` section with:

- Title tag
- Meta description
- Canonical URL
- Open Graph tags (for social media sharing previews)
- Twitter card tags
- `ai-description` meta tag (for AI crawler visibility)
- Schema.org JSON-LD structured data block
- Google Fonts preconnect links

**When to use:** At the start of every new HTML page or layout file.

---

### `sw-reveal` — Scroll reveal animation

Inserts the CSS classes and JavaScript needed for elements to fade in as the
user scrolls down the page. Uses `IntersectionObserver` — no animation
libraries required.

**When to use:** Whenever you want sections or cards to animate into view on
scroll.

**How to use the generated code:**

Add `class="reveal"` to any HTML element you want to animate:

```html
<section class="reveal">
  <h2>Our Services</h2>
</section>
```

For staggered animations on multiple items, add delay classes:

```html
<div class="reveal reveal-delay-1">Card 1</div>
<div class="reveal reveal-delay-2">Card 2</div>
<div class="reveal reveal-delay-3">Card 3</div>
```

---

### `sw-schema` — Schema.org JSON-LD block

Inserts a complete `<script type="application/ld+json">` block with structured
data fields ready to fill in. Structured data helps Google and AI tools like
ChatGPT understand and correctly describe a business.

**When to use:** On every page, inside `<head>`.

---

### `sw-llms` — llms.txt file template

Inserts the standard `llms.txt` template for a client. This file is placed at
the root of the website (e.g. `yoursite.co.nz/llms.txt`) and helps AI tools
like ChatGPT, Perplexity, and Google AI Overviews understand and accurately
recommend the business.

**When to use:** Once per project, when creating `public/llms.txt`.

---

## 8. Tool-by-Tool Guide

### Claude Code

**What it is:** An AI coding agent by Anthropic that you run in your terminal.
You describe what you want to build and it writes the code, edits files, and
runs commands for you.

**How it picks up SwiftWeb standards:** Claude Code automatically reads a file
called `CLAUDE.md` when it starts. The installer places this file at
`~/.claude/CLAUDE.md`. This means every Claude Code session, in every project
on your machine, starts with full knowledge of SwiftWeb standards.

**No extra setup needed per project.** Just run Claude Code:

```bash
claude
```

**Example prompts to use in Claude Code:**

```text
Build a homepage for a Wellington accounting firm called KiwiBooks.
Services: tax returns, bookkeeping, business advisory.
Framework: Astro. Apply all SwiftWeb standards.
```

```text
Audit this project for SwiftWeb compliance. Check every file for missing
meta tags, schema, llms.txt, and any animation libraries.
```

---

### VS Code + GitHub Copilot

**What it is:** GitHub Copilot is an AI assistant built into VS Code. It
suggests code as you type and answers questions in the Copilot Chat panel.

**How it picks up SwiftWeb standards:** Copilot reads a file called
`.github/copilot-instructions.md` in the project root. The `new-project.sh`
scaffold places this file in every new project automatically.

**Setup per project:**

```bash
bash ~/.swiftweb/new-project.sh my-client
code my-client
```

Once the project is open in VS Code, all Copilot chat responses and inline
suggestions will follow SwiftWeb standards.

**How to open Copilot Chat in VS Code:**

Press `Command + Shift + I` (Mac) or click the Copilot icon in the left sidebar.

**Example Copilot Chat prompts:**

```text
Build a services section for this client. Use the brand tokens from tokens.css.
Add scroll reveal animations using the sw-reveal pattern.
```

```text
Review index.html and tell me what SEO meta tags are missing.
```

---

### Gemini CLI

**What it is:** Google's AI tool that runs in your terminal. Good for quick
code generation and audits without opening a code editor.

**How it picks up SwiftWeb standards:** The `swgem` alias automatically
prepends the full SwiftWeb system prompt to every Gemini request. You never
have to attach guidelines manually.

**Install:**

```bash
npm install -g @google/gemini-cli
```

Then authenticate with your Google account when prompted.

**Usage:**

```bash
swgem "build a contact form component for a law firm"
```

This is equivalent to running:

```bash
gemini --system-prompt "$(cat ~/.swiftweb/gemini-system.md)" "build a contact form component for a law firm"
```

**Use `swgem` — not raw `gemini` — for all SwiftWeb work.**

---

### ChatGPT, Perplexity, or Any Other AI Tool

These tools do not have a way to auto-load guidelines, so you paste a prompt
template manually.

**How to use:**

1. Run `swiftweb-prompt` in your terminal and choose a template number (1–7)
2. The template is printed and copied to your clipboard automatically
3. Paste it into your AI tool of choice
4. Fill in the placeholders in `[SQUARE BRACKETS]` with client details

---

## 9. Starting a New Client Project — Step by Step

Follow these steps for every new client engagement.

### Step 1 — Create the project folder

```bash
bash ~/.swiftweb/new-project.sh client-name
```

Replace `client-name` with a short identifier for the project. For example:

```bash
bash ~/.swiftweb/new-project.sh auckland-physio
```

This creates:

```text
auckland-physio/
├── CLAUDE.md                        ← AI instructions (pre-filled)
├── SWIFTWEB_GUIDELINES.md           ← Full standards reference
├── public/
│   ├── robots.txt                   ← Ready to go
│   └── llms.txt                     ← Needs client info added
├── src/styles/
│   └── tokens.css                   ← Needs brand colours & fonts added
├── .vscode/settings.json
└── .github/copilot-instructions.md
```

### Step 2 — Fill in client details

Open the project folder:

```bash
cd auckland-physio
code .
```

Edit these two files with the client's actual information:

**`public/llms.txt`** — Write 2–3 plain English paragraphs describing the
business: what they do, who they serve, where they are, and what makes them
different. This file is read by AI tools like ChatGPT to recommend the
business accurately.

**`src/styles/tokens.css`** — Replace the placeholder colours and font names
with the client's actual brand. Every component in the project will reference
these variables.

### Step 3 — Generate the site with your AI tool

**With Claude Code:**

```bash
cd auckland-physio
claude
```

Then prompt Claude:

```text
Build a complete homepage for Auckland Physio. Services: sports injury
rehabilitation, post-surgery recovery, chronic pain management.
Target audience: active adults aged 25-55. Brand personality: clinical
but warm. Primary keyword: physio Auckland. Framework: Astro.
```

**With Copilot Chat (in VS Code):**

Press `Command + Shift + I` and type:

```text
Build a complete homepage using the client brief in CLAUDE.md.
Use the brand tokens from tokens.css. Apply all SwiftWeb standards.
```

**With Gemini CLI:**

```bash
swgem "Build a complete homepage for Auckland Physio. Services: sports injury rehab, post-surgery recovery, chronic pain. Location: Auckland CBD. Framework: plain HTML. Apply all SwiftWeb standards."
```

### Step 4 — Review compliance

After the AI generates code, run a quick check:

1. **View Source test** — Open the site in a browser and press `Command + U`.
   You should be able to read all headings and content without JavaScript.
   If the page looks blank, content is being JS-rendered — flag this as a
   critical issue.

2. **Run the audit checklist:**

   ```bash
   swiftweb-audit
   ```

   Work through each item in the checklist manually or paste the audit
   template with the page source into your AI tool for an automated review.

3. **Run Lighthouse** (see Section 11 for setup):

   ```bash
   npx @lhci/cli autorun
   ```

---

## 10. Prompt Templates Guide

Seven prompt templates live at `~/.swiftweb/templates.md`. Each is a structured
prompt designed to get the best results from any AI tool. Access them with:

```bash
swiftweb-prompt          # Interactive menu — copies selection to clipboard
swiftweb-prompt 2        # Jump directly to Template 2
```

Or open the file directly:

```bash
cat ~/.swiftweb/templates.md
```

---

### Template 1 — New Client Site

**Use when:** Starting a brand new website from scratch.

Fill in the `[PLACEHOLDERS]` with the client brief and paste into any AI tool.
The template asks the AI to deliver: a complete HTML page with all meta tags
populated, a CSS design system, all page sections, `robots.txt`, `llms.txt`,
and a sitemap structure.

---

### Template 2 — SEO & AIO Audit

**Use when:** Reviewing an existing site for compliance issues.

Paste this template along with the site's raw HTML source (from View Source)
into any AI tool. The AI will check every item and return a `PASS / FAIL /
MISSING` report with exact code fixes for each failure.

**Items checked:** static rendering, all meta tags (including `og:locale` and
`meta name="robots"`), Schema.org JSON-LD, `ai-description` meta, `llms.txt`,
`robots.txt`, sitemap (Google + Bing), animation libraries, `font-display: swap`,
image dimensions, deferred scripts, semantic HTML, ARIA labels, Lighthouse
score assertions (LCP, TBT, CLS).

---

### Template 3 — Component Generation

**Use when:** Building a single section (hero, services, testimonials, etc.)
rather than a full page.

Provide the brand colours, fonts, and content description. The AI will deliver
self-contained HTML and CSS using the project's design token variables, with
accessible markup and CSS scroll reveal animations.

---

### Template 4 — Schema.org Generator

**Use when:** You need to generate the structured data block for a client.

Provide the business details and the AI will output the correct `@type` for
the business category (e.g. `MedicalBusiness`, `LegalService`, `Restaurant`),
fully populated and ready to paste into the site's `<head>`.

---

### Template 5 — llms.txt Generator

**Use when:** Writing the `llms.txt` AI optimisation file for a client.

This file, placed at `yoursite.co.nz/llms.txt`, helps ChatGPT, Perplexity,
Claude, and Google AI Overviews accurately describe and recommend the business
when users ask questions like "best physio in Auckland."

Provide the client details and the AI will return a professionally written,
plain-English `llms.txt` file ready to publish.

---

### Template 6 — Performance Fix

**Use when:** A site has a low Lighthouse score and you need to diagnose and
fix the issues.

Paste the template with the site's code. The AI will identify every performance
issue, explain which Lighthouse metric it affects (LCP, TBT, CLS, FCP), and
provide the exact code fix for each one.

---

### Template 7 — Migration & Refactoring

**Use when:** Taking over an existing site that uses animation libraries (GSAP,
AOS, Framer Motion) and needs to be migrated to CSS-only animations, or when
content is JS-rendered and needs to be moved to static HTML.

Paste the template with the problematic code. The AI will identify every
non-compliant pattern, provide the CSS replacement for each animation, and
confirm which Lighthouse metric improves as a result.

---

## 11. Lighthouse CI — Automated Quality Checks

Lighthouse is Google's tool for measuring website quality. It checks
performance, accessibility, SEO, and best practices and gives each a score
out of 100.

SwiftWeb's required minimum scores are:

| Category | Minimum Score |
| --- | --- |
| Performance | 95 |
| Accessibility | 100 |
| Best Practices | 100 |
| SEO | 100 |

Lighthouse CI (`@lhci/cli`) automates these checks and can be set to block
deployments that fail to meet these thresholds.

### Set up Lighthouse CI on a project

```bash
# Copy the pre-configured settings file into your project
cp ~/.swiftweb/lighthouserc.json ./lighthouserc.json

# Install the Lighthouse CI tool
npm install -D @lhci/cli

# Run the checks
npx @lhci/cli autorun
```

The config file at `~/.swiftweb/lighthouserc.json` is pre-set with SwiftWeb's
thresholds. If any score falls below the minimum, the command exits with an
error — useful for blocking deploys in CI/CD pipelines.

> **Framework note:** The default config targets Next.js (port 3000).
> Update `startServerCommand` and `url` in `lighthouserc.json` for your
> framework. The file includes commented examples for Next.js, Astro (port 4321),
> Nuxt, and plain HTML (`npx serve .`).

### Add to GitHub Actions (optional)

Create `.github/workflows/lighthouse.yml` in your project and add this:

```yaml
name: Lighthouse CI
on: [push]
jobs:
  lhci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run build
      - run: npx @lhci/cli autorun
```

This will run Lighthouse on every push and fail the build if scores drop below
SwiftWeb minimums.

---

## 12. Uninstalling

To remove everything installed by this tool:

```bash
cd /path/to/swiftweb-ai-system
bash uninstall.sh
```

This removes:

- `~/.swiftweb/` — all SwiftWeb config files
- `~/.claude/CLAUDE.md` — global Claude instructions (only if SwiftWeb-authored)
- `~/.claude/SWIFTWEB_GUIDELINES.md`
- VS Code `swiftweb.code-snippets` file
- The SwiftWeb alias block from your shell RC file (`.zshrc` / `.bashrc` / `.bash_profile`)

Your existing projects are not touched.

---

## 13. Updating the Guidelines

The master guidelines file is:

```text
~/.swiftweb/SWIFTWEB_GUIDELINES.md
```

Edit this file to update standards across all AI tools simultaneously. The
change takes effect on the next session of each tool.

**Update the master file:**

```bash
code ~/.swiftweb/SWIFTWEB_GUIDELINES.md
```

**Also update the Claude Code global file** (these are separate copies):

```bash
code ~/.claude/CLAUDE.md
```

**To re-install from the latest version of this repo:**

```bash
cd /path/to/swiftweb-ai-system
bash install.sh
source ~/.zshrc
```

The installer safely removes and re-adds the shell aliases without creating
duplicates.

---

## 14. How It All Fits Together

```text
SWIFTWEB_GUIDELINES.md              ← Single source of truth
         │
         ├── ~/.claude/CLAUDE.md             → Claude Code (auto-loaded every session)
         │
         ├── .github/copilot-instructions.md → GitHub Copilot (per-project)
         │
         ├── .vscode/settings.json           → VS Code inline instructions
         │
         ├── swgem alias                      → Gemini CLI (system prompt prepended)
         │     └── uses ~/.swiftweb/gemini-system.md
         │
         └── ~/.swiftweb/templates.md        → Manual use in ChatGPT, Perplexity, etc.
```

The key principle: **guidelines live once, flow everywhere.**
You maintain one file. Every AI tool reads from it automatically.

---

## 15. Troubleshooting

### `swgem: command not found`

The shell aliases were not loaded. Run:

```bash
source ~/.zshrc
```

If that does not work, check that the aliases were added:

```bash
grep "SwiftWeb AI aliases" ~/.zshrc
```

If nothing appears, re-run the installer:

```bash
bash install.sh
source ~/.zshrc
```

### `swiftweb-new: command not found`

Same cause as above. Run `source ~/.zshrc`.

### Claude Code does not seem to know SwiftWeb standards

Check that the global `CLAUDE.md` was installed:

```bash
cat ~/.claude/CLAUDE.md
```

If the file is missing or empty, re-run the installer.

If working in a project, also check that `CLAUDE.md` exists in the project
root. Claude Code reads the project-level file first.

### Copilot Chat is not following the standards

Check that `.github/copilot-instructions.md` exists in the project root:

```bash
ls .github/copilot-instructions.md
```

If missing, copy it from the installed SwiftWeb cache:

```bash
mkdir -p .github
cp ~/.swiftweb/copilot-instructions.md .github/
```

Or run the scaffold script again for the project:

```bash
bash ~/.swiftweb/new-project.sh my-client
```

### VS Code snippets are not appearing

Snippets should appear in `.html`, `.astro`, `.jsx`, `.tsx`, and `.vue` files.
Try typing `sw-` and waiting for the autocomplete list to appear. If nothing
shows, check that the snippets file was installed:

```bash
ls ~/Library/Application\ Support/Code/User/snippets/swiftweb.code-snippets
```

If missing, re-run the installer and reload VS Code (`Command + Shift + P` →
"Reload Window").

### Lighthouse CI fails even though scores look fine manually

The CI config runs 3 passes and averages the results. Single-run manual scores
can be inflated. The thresholds (95 performance, 100 accessibility) are strict
by design. Common causes of failure:

- Animation libraries still present in `package.json`
- Images missing `width` or `height` attributes
- `font-display: swap` not set
- Scripts not deferred

Run `swiftweb-audit` to check each item systematically.

---

## 16. FAQ

**Do I need to run `source ~/.zshrc` every time I open a new terminal?**

No — only once after installation. New terminal windows automatically load
your shell configuration. You only need `source ~/.zshrc` in a terminal that
was already open when you installed.

**Does this affect AI tools on other machines?**

No. The install only affects the current machine. Run the installer on each
machine where you do SwiftWeb work.

**Can I use this with a Windows PC?**

The shell aliases are written for zsh/bash (macOS and Linux). On Windows,
use WSL (Windows Subsystem for Linux) and follow the Linux instructions.
The VS Code snippets and project scaffold work on all platforms.

**What if a client wants to use React or Vue instead of Astro/Next.js?**

The guidelines support Astro, Next.js, Nuxt, and plain HTML. React alone
(without Next.js) is not recommended because it renders on the client side,
making content invisible to search engines and AI crawlers. If the client
requires React, use Next.js with server-side rendering.

**What is `llms.txt` and why do clients need it?**

`llms.txt` is a plain text file placed at the root of a website that AI tools
like ChatGPT, Perplexity, and Google AI Overviews read to understand a
business. When someone asks an AI "find me a good dentist in Auckland", the AI
reads `llms.txt` files from dental websites to form its answer. Without it,
the AI may describe the business inaccurately or not mention it at all.

**Can I customise the guidelines for a specific client project?**

Yes. Edit the `CLAUDE.md` in the project root to add or override
project-specific rules. Claude Code reads the project-level file first and
falls back to the global `~/.claude/CLAUDE.md`. The `.github/copilot-instructions.md`
in the project root can also be edited per project.

**How do I add a new prompt template?**

Edit `~/.swiftweb/templates.md` directly and add a new `## TEMPLATE N:` section
following the existing format. The change is immediately available via
`swiftweb-prompt`.

**Should I commit `.env` files to Git?**

Never. Always add `.env`, `.env.local`, and `.env.*.local` to your `.gitignore`
before running `git add`. Store API keys and secrets as environment variables,
not in source code. Reference them in code as `process.env.VARIABLE_NAME`
(Next.js/Node) or `import.meta.env.VARIABLE_NAME` (Astro/Vite). If you
accidentally commit a secret, rotate the key immediately.

**What version of Node.js do I need?**

Node.js 18 or higher. Check with `node --version`. Install or update at
nodejs.org.
