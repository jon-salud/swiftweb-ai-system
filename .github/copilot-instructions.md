# GitHub Copilot Custom Instructions — SwiftWeb Agency

## Context

You are assisting with client website development for SwiftWeb, an Auckland
web design agency. Apply these standards to every suggestion.

## HTML Generation Rules

When generating any HTML page or component:

ALWAYS include in `<head>`:

- `<title>` with keyword — Brand format
- `<meta name="description">` (150-160 chars)
- `<link rel="canonical">`
- Open Graph meta tags (og:type, og:url, og:title, og:description, og:image)
- Twitter card meta tags
- `<script type="application/ld+json">` with Schema.org structured data
- `<meta name="ai-description">` for AI crawler visibility
- `<link rel="preconnect">` for any external font sources
- font-display: swap on @font-face declarations

NEVER:

- Inject meta tags or page content via JavaScript
- Use GSAP, AOS, Framer Motion, or any animation library
- Use scroll event listeners for animations (use IntersectionObserver)
- Recommend Create React App, Gatsby, Wix, Squarespace
- Use Inter, Roboto, or Arial as a display/heading font
- Write images without width and height attributes
- Animate layout properties (width, height, top, left) — use transform only

## CSS Suggestions

Always suggest:

- CSS custom properties (:root variables) for colours, fonts, spacing
- CSS keyframe animations instead of JS animation libraries
- transform/opacity for animations (GPU-composited, no layout reflow)
- font-display: swap for all @font-face rules
- Explicit width and height on all img elements

Pattern for scroll reveals (prefer this over any library):

```css
.reveal {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.8s cubic-bezier(0.16,1,0.3,1),
              transform 0.8s cubic-bezier(0.16,1,0.3,1);
}
.reveal.visible { opacity: 1; transform: translateY(0); }
```

```javascript
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      e.target.classList.add('visible');
      observer.unobserve(e.target);
    }
  });
}, { threshold: 0.12 });
document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
```

## JavaScript Suggestions

- Prefer `<script defer>` or `<script type="module">` — never blocking scripts in `<head>`
- Use IntersectionObserver for scroll-based effects
- Use requestAnimationFrame only for canvas or cursor lag animations
- Keep JS bundles minimal — if it can be CSS, make it CSS

## Framework Recommendations

Suggest in this order:

1. Astro — for content/marketing/portfolio sites (ships zero JS by default)
2. Next.js — for dynamic sites needing server-side data
3. Plain HTML/CSS/JS — for simple landing pages
4. Nuxt — for Vue projects

## Accessibility

Every component should include:

- Semantic HTML elements (section, article, nav, main, footer)
- ARIA labels on nav, section, footer elements
- aria-hidden="true" on decorative elements
- alt text on all images (empty alt="" for decorative)
- Keyboard-accessible interactive elements

## Lighthouse Targets

Performance: 95+  |  Accessibility: 100  |  Best Practices: 100  |  SEO: 100
