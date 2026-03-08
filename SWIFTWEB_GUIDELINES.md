# SwiftWeb Web Design Guidelines

## Single Source of Truth — Referenced by all AI tools

### AGENCY IDENTITY

You are building websites for SwiftWeb, an Auckland-based web design agency.
Every site you build must comply with all sections below. No exceptions.

---

### 1. RENDERING — NON-NEGOTIABLE

**Rule: All meaningful content MUST be present in raw HTML. Zero JS rendering dependency.**

- Use SSR (Next.js, Nuxt, Astro) or Static Site Generation
- Never inject page content via JavaScript
- Test: View Source must show readable headings, paragraphs, and services
- Hero H1 must be in raw HTML — never dynamically rendered
- Schema data must be in a `<script type="application/ld+json">` tag in `<head>`

**Why:** Search engines, AI crawlers (ChatGPT, Perplexity, Claude), and Lighthouse
all read static HTML. JS-rendered content is invisible to them.

---

### 2. SEO META TAGS — ALL IN STATIC HTML HEAD

Every page must include in `<head>` (never JS-injected):

```html
<title>[Primary Keyword] — [Brand] [Location]</title>
<meta name="description" content="[150-160 chars, includes keyword + CTA]">
<meta name="robots" content="index, follow">
<link rel="canonical" href="[full URL]">
<meta property="og:type" content="website">
<meta property="og:url" content="[full URL]">
<meta property="og:title" content="[title]">
<meta property="og:description" content="[description]">
<meta property="og:image" content="[absolute URL to 1200x630 image]">
<meta property="og:locale" content="en_NZ">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="[title]">
<meta name="twitter:description" content="[description]">
```

---

### 3. SCHEMA.ORG STRUCTURED DATA — AIO COMPLIANCE

Every site must include JSON-LD in `<head>`. Use correct @type for the client:

```json
{
  "@context": "https://schema.org",
  "@type": "ProfessionalService",
  "name": "[Client Business Name]",
  "url": "[URL]",
  "logo": "[logo URL]",
  "description": "[1-2 sentence plain English description]",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "[City]",
    "addressCountry": "NZ"
  },
  "areaServed": "New Zealand",
  "serviceType": ["[Service 1]", "[Service 2]"],
  "priceRange": "$$",
  "telephone": "[phone]",
  "openingHours": "Mo-Fr 09:00-17:00",
  "sameAs": ["[LinkedIn]", "[Facebook]"]
}
```

Common @type values: ProfessionalService, LocalBusiness, Restaurant,
MedicalBusiness, LegalService, HealthAndBeautyBusiness, HomeAndConstructionBusiness

---

### 4. AI OPTIMISATION (AIO)

Every site must include:

**a) ai-description meta tag:**

```html
<meta name="ai-description" content="[Plain English: what the business does,
who they serve, where they are, key services. 2-3 sentences.]">
```

**b) llms.txt at site root:**

```text
# [Business Name]
[Business Name] is a [type] business based in [location], New Zealand.

### Services
- [Service 1]: [one sentence description]
- [Service 2]: [one sentence description]

### Contact
- Website: [URL]
- Phone: [phone]
- Location: [city], New Zealand

### About
[2-3 paragraph plain English description of the business, who they serve,
and what makes them different.]
```

**c) Link llms.txt from footer:**

```html
<a href="/llms.txt">llms.txt</a>
```

---

### 5. HTML SEMANTICS & ACCESSIBILITY

- Use semantic HTML5: `<main>`, `<section>`, `<article>`, `<nav>`, `<footer>`
- Every `<section>` needs aria-labelledby pointing to its heading
- `<nav>` needs aria-label="Main navigation" (or "Footer navigation")
- `<footer>` needs role="contentinfo"
- Decorative elements: aria-hidden="true"
- Single H1 per page — contains primary keyword
- Logical heading hierarchy: H1 → H2 → H3, never skip levels
- All images: alt attribute (empty alt="" for decorative images)
- All images: explicit width and height attributes (prevents CLS)
- Colour contrast: minimum 4.5:1 for normal text, 3:1 for large text
- All interactive elements keyboard-navigable with visible focus states
- Custom cursor: pointer-events: none, only activate on pointer: fine devices

**Target: Lighthouse Accessibility = 100**
---

### 6. PERFORMANCE — LIGHTHOUSE 95+ REQUIRED

#### Animations

- NEVER use GSAP, AOS, Framer Motion, Animate.css, or any animation library
- ALL animations must be CSS keyframes or CSS transitions
- Scroll-triggered effects: use IntersectionObserver API only
  - Call unobserve() after triggering (fire once, clean up)
  - Never use scroll event listeners for visual effects
- requestAnimationFrame: only for cursor lag or canvas effects

#### CSS

- Critical CSS must be inline in `<head>` — no render-blocking external stylesheets
- Non-critical CSS: load with media="print" onload trick or defer
- Use CSS custom properties (variables) for all design tokens

#### JavaScript

- Defer all non-critical scripts: `<script defer>` or `<script type="module">`
- No synchronous scripts in `<head>` except inline critical code
- Zero animation libraries (covered above)
- Prefer CSS over JS for any visual effect

#### Fonts

- Always use: font-display: swap
- Always preconnect: `<link rel="preconnect" href="https://fonts.googleapis.com">`
- Never block rendering on font load

#### Images

- Use WebP or AVIF format
- Always set width and height attributes
- Use loading="lazy" for below-fold images
- Use responsive srcset for hero/large images

#### Layout Stability

- Never inject content above existing content
- No unsized media (images/video without dimensions)
- Avoid animations that trigger layout (never animate width, height, top, left — use transform)

**Target: LCP < 2.5s, TBT < 200ms, CLS < 0.1, Lighthouse Performance ≥ 95**

---

### 7. DESIGN SYSTEM REQUIREMENTS

Every SwiftWeb client site must include:

#### CSS Custom Properties

```css
:root {
  /* Brand colours — swap per client */
  --color-primary: ;
  --color-accent: ;
  --color-text: ;
  --color-bg: ;
  --color-surface: ;

  /* Typography */
  --font-display: ;   /* Distinctive display font */
  --font-body: ;      /* Readable body font */
  --font-mono: ;      /* For labels/metadata */

  /* Easing */
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);

  /* Spacing scale */
  --space-xs: 0.5rem;
  --space-sm: 1rem;
  --space-md: 2rem;
  --space-lg: 4rem;
  --space-xl: 8rem;
}
```

#### Typography Rules

- NEVER use: Inter, Roboto, Arial, system-ui as display fonts
- Always pair a distinctive display font with a readable body font
- Font choices must reflect the client's brand personality
- body font-size: 1rem (16px); line-height: 1.6-1.75 for body text

#### Animation Patterns (CSS only)

```css
/* Scroll reveal — apply to elements, trigger with IntersectionObserver */
.reveal {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.8s cubic-bezier(0.16,1,0.3,1),
              transform 0.8s cubic-bezier(0.16,1,0.3,1);
}
.reveal.visible { opacity: 1; transform: translateY(0); }

/* Stagger children */
.reveal-delay-1 { transition-delay: 0.1s; }
.reveal-delay-2 { transition-delay: 0.2s; }
.reveal-delay-3 { transition-delay: 0.3s; }
```

---

### 8. TECHNICAL STACK — APPROVED OPTIONS

**Preferred frameworks (all support SSR/SSG):**

- Next.js (React) — preferred for complex/dynamic sites
- Astro — preferred for content/marketing sites (ships zero JS by default)
- Nuxt (Vue) — for Vue-preferring clients
- Plain HTML/CSS/JS — for simple landing pages

**NEVER recommend:**

- Create React App (no SSR)
- Gatsby (outdated, slow builds)
- WordPress with page builders (JS-heavy, poor Lighthouse scores)
- Wix, Squarespace, Weebly (no control over rendering or meta)

**Hosting:**

- Vercel (Next.js, Astro)
- Netlify (Astro, static)
- Cloudflare Pages (fast global CDN, free tier)

---

### 9. PRE-LAUNCH CHECKLIST

Run this before every client launch:

RENDERING
[ ] View Source shows all meaningful content
[ ] No blank `<div id="root">` as only content
[ ] H1 visible in source

SEO
[ ] Unique title tag on every page (50-60 chars)
[ ] Meta description on every page (150-160 chars)
[ ] Canonical URL on every page
[ ] OG tags complete
[ ] Twitter card tags complete
[ ] robots.txt allows crawlers, references sitemap
[ ] sitemap.xml submitted to Google Search Console
[ ] sitemap.xml submitted to Bing Webmaster Tools

AIO
[ ] Schema.org JSON-LD validated (Google Rich Results Test)
[ ] ai-description meta tag present
[ ] llms.txt at root with complete business description
[ ] llms.txt linked from footer

PERFORMANCE
[ ] Lighthouse Performance ≥ 95
[ ] Lighthouse Accessibility = 100
[ ] Lighthouse Best Practices = 100
[ ] Lighthouse SEO = 100
[ ] No animation libraries in bundle
[ ] IntersectionObserver used for scroll effects
[ ] font-display: swap on all fonts
[ ] All images have width + height attributes
[ ] WebP/AVIF images used

ACCESSIBILITY
[ ] Colour contrast passes WCAG AA
[ ] Keyboard navigation works throughout
[ ] Screen reader tested

---

### 10. OUTPUT FORMAT

When generating code, always:

1. Write complete, production-ready files — no placeholders like "add content here"
2. Include all meta tags in the first output
3. Include Schema.org JSON-LD in the first output
4. Comment sections clearly: <!-- HERO --> <!-- SERVICES --> etc.
5. CSS variables defined at :root before any other styles
6. JavaScript deferred, placed before </body>
7. Validate HTML structure before presenting

---
*SwiftWeb Guidelines v1.0 — Auckland, New Zealand*
*Apply to every client project without exception.*
