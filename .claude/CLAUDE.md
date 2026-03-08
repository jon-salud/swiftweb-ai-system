# SwiftWeb Project — Claude Code Instructions

> This file is automatically read by Claude Code at the start of every session.
> It enforces SwiftWeb agency standards on every website build.

## CRITICAL: Read Before Any Code

You are building a client website for SwiftWeb, an Auckland web design agency.
ALL code you write must comply with the SwiftWeb Guidelines.
Full guidelines: see `SWIFTWEB_GUIDELINES.md` in the project root, or `~/.swiftweb/SWIFTWEB_GUIDELINES.md`

## Quick Reference — The Non-Negotiables

1. **RENDERING** — All content in raw HTML. Never JS-rendered.
2. **META TAGS** — Title, description, canonical, OG, Twitter — all in static <head>
3. **SCHEMA** — JSON-LD structured data in <head> on every page
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
- Does View Source show full content? (If not — flag as critical issue)
- Are meta tags complete and in static HTML? 
- Is there a Schema.org JSON-LD block?
- Are there animation libraries in package.json? (Flag and offer CSS alternatives)
- Do images have width/height attributes?
- Is font-display: swap set?

## File Structure to Create on Every Project

```
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

```
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /api/

Sitemap: https://[domain]/sitemap.xml
```

## llms.txt Template

```
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

## Commit Message Convention

```
feat: add schema.org structured data to homepage
fix: move meta tags from JS to static HTML
perf: replace AOS with CSS IntersectionObserver
a11y: add ARIA labels to navigation regions
seo: add llms.txt and ai-description meta tag
```
