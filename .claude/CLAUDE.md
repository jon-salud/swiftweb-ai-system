# SwiftWeb Project — Claude Code Instructions

> This file is automatically read by Claude Code at the start of every session.
> It enforces SwiftWeb agency standards on every website build.

## CRITICAL: Read Before Any Code

You are building a client website for SwiftWeb, an Auckland web design agency.
ALL code you write must comply with the SwiftWeb Guidelines.
Full guidelines: see `SWIFTWEB_GUIDELINES.md` in the project root, or `~/.swiftweb/SWIFTWEB_GUIDELINES.md`

## Quick Reference — The Non-Negotiables

1. **RENDERING** — All content in raw HTML. Never JS-rendered.
2. **META TAGS** — Title, description, canonical, OG, Twitter — all in static `<head>`
3. **SCHEMA** — JSON-LD structured data in `<head>` on every page
4. **AIO** — ai-description meta tag + llms.txt at root + link in footer
5. **ANIMATIONS** — CSS only. Never GSAP/AOS/Framer Motion. IntersectionObserver for scroll.
6. **PERFORMANCE** — Lighthouse 95+ required. No render-blocking CSS/JS.
7. **ACCESSIBILITY** — Semantic HTML5, ARIA labels, WCAG AA contrast, Lighthouse a11y = 100.

## Starting a New Client Site

When asked to start a new site, ALWAYS:

1. Ask for: business name, location, services, target audience, brand personality
2. Choose a framework from approved list (Next.js, Astro, Nuxt, plain HTML)
3. Generate the full HTML shell first — with ALL meta tags and schema populated
4. Confirm View Source test will pass before adding JS
5. Choose distinctive typography (NEVER Inter/Roboto/Arial as display font)
6. Implement CSS custom properties before writing any component styles
7. Generate llms.txt content based on client information

## Reviewing Existing Code

When reviewing or editing a site, check:

### Rendering

- Does View Source show full content? (If not — flag as critical issue)
- Is there a blank `<div id="root">` as the only body content? (Flag: JS-rendered)
- Is H1 visible in raw HTML source?

### SEO & Meta

- Are meta tags complete and in static HTML?
- Is `og:locale` set to `en_NZ`?
- Is `meta name="robots"` present?
- Is there a `<link rel="canonical">`?
- Does `robots.txt` allow crawlers and reference the sitemap?
- Is `sitemap.xml` submitted to Google Search Console and Bing Webmaster Tools?

### Schema & AIO

- Is there a Schema.org JSON-LD block in `<head>`?
- Is `ai-description` meta tag present?
- Is `llms.txt` reachable at `/llms.txt` and linked from footer?

### Performance & Animations

- Are there animation libraries in `package.json`? (Flag and offer CSS equivalents)
- Are scroll effects using IntersectionObserver (not scroll event listeners)?
- Is `font-display: swap` set on all fonts?
- Do all images have `width` and `height` attributes?
- Are scripts deferred or type="module"?

### Accessibility

- Do sections have `aria-labelledby`?
- Does `<nav>` have `aria-label`?
- Does `<footer>` have `role="contentinfo"`?
- Do all images have `alt` attributes?

## File Structure to Create on Every Project

```text
/
├── CLAUDE.md              ← this file (copy to project root)
├── SWIFTWEB_GUIDELINES.md ← full guidelines reference
├── public/
│   ├── robots.txt
│   ├── sitemap.xml        ← or generated at build time
│   └── llms.txt           ← AI optimisation file
├── src/
│   ├── styles/
│   │   └── tokens.css     ← CSS custom properties / design tokens
│   └── ...
```

## robots.txt Template

```text
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/

Sitemap: https://[domain]/sitemap.xml
```

## llms.txt Template

```text
# [Business Name]
[Business Name] is a [type] business located in [city], New Zealand.

## Services
- [Service]: [description]

## Contact
- Website: [URL]
- Phone: [phone]
- Address: [city], New Zealand

## About
[2-3 paragraphs describing the business in plain English]
```

## Security & Secrets

NEVER commit secrets or credentials to the repository:

- Always add `.env` and `.env.local` to `.gitignore` before any `git add`
- Never hardcode API keys, tokens, or passwords in source files
- Use environment variables for all sensitive values
- If you see a hardcoded secret, flag it immediately and offer to move it to `.env`
- Reference secrets in code as `process.env.VARIABLE_NAME` (Next.js/Node) or
  `import.meta.env.VARIABLE_NAME` (Astro/Vite)

```text
# .gitignore — always include these
.env
.env.local
.env.*.local
```

## Commit Message Convention

```text
feat: add schema.org structured data to homepage
fix: move meta tags from JS to static HTML
perf: replace AOS with CSS IntersectionObserver
a11y: add ARIA labels to navigation regions
seo: add llms.txt and ai-description meta tag
```
