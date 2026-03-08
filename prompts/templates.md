# SwiftWeb Reusable Prompt Templates

Use these in any AI tool: Claude, Copilot Chat, Gemini, ChatGPT

---

## TEMPLATE 1: NEW CLIENT SITE

Use when: Starting a brand new website from scratch

---

You are building a new website for a SwiftWeb client. Apply all SwiftWeb
agency standards (SSR rendering, full SEO meta tags, Schema.org JSON-LD,
llms.txt, CSS-only animations, Lighthouse 95+, Lighthouse a11y 100).

CLIENT BRIEF:

- Business Name: [NAME]
- Business Type: [TYPE — e.g. physiotherapy clinic, law firm, restaurant]
- Location: [CITY], New Zealand
- Services: [LIST SERVICES]
- Target Audience: [WHO THEY SERVE]
- Brand Personality: [e.g. professional/clinical, warm/approachable, bold/creative]
- Primary Keyword: [MAIN SEARCH TERM]
- Pages Needed: [Home / About / Services / Contact / etc.]

DELIVER:

1. Complete HTML page with ALL meta tags and Schema.org JSON-LD populated
2. CSS design system using custom properties (colours, fonts, spacing)
3. Sections: Hero, Services, About/Process, Testimonials, CTA, Footer
4. CSS-only animations with IntersectionObserver scroll reveals
5. robots.txt content
6. llms.txt content
7. Sitemap.xml structure

Framework to use: [Astro / Next.js / Plain HTML]

---

## TEMPLATE 2: SEO & AIO AUDIT

Use when: Auditing an existing site for compliance

---

Audit this website for SwiftWeb agency compliance. Check every item and
report PASS / FAIL / MISSING with specific fixes for each failure.

SITE URL: [URL]
(If providing code, paste the raw HTML source from View Source)

AUDIT CHECKLIST:

RENDERING

- [ ] All content visible in raw HTML (not JS-rendered)
- [ ] H1 present in static source

SEO META TAGS

- [ ] Title tag (50-60 chars, includes keyword)
- [ ] Meta description (150-160 chars)
- [ ] Canonical URL
- [ ] Open Graph tags (type, url, title, description, image)
- [ ] og:locale set to en_NZ
- [ ] Twitter card tags
- [ ] meta name="robots" content="index, follow"
- [ ] html lang attribute set

STRUCTURED DATA

- [ ] Schema.org JSON-LD present in `<head>`
- [ ] Correct @type for business
- [ ] Address, phone, services populated
- [ ] sameAs links to social profiles

AI OPTIMISATION

- [ ] ai-description meta tag
- [ ] llms.txt reachable at /llms.txt
- [ ] llms.txt linked from footer

PERFORMANCE

- [ ] No animation libraries (GSAP/AOS/Framer Motion)
- [ ] IntersectionObserver used for scroll effects (not scroll events)
- [ ] font-display: swap set
- [ ] Images have width + height attributes
- [ ] Critical CSS inline (no render-blocking stylesheets)
- [ ] Scripts deferred

ACCESSIBILITY

- [ ] Semantic HTML5 elements
- [ ] ARIA labels on nav/sections/footer
- [ ] Images have alt attributes

SEO CRAWLABILITY

- [ ] robots.txt allows crawlers and references sitemap
- [ ] sitemap.xml submitted to Google Search Console
- [ ] sitemap.xml submitted to Bing Webmaster Tools

LIGHTHOUSE ASSERTIONS

- [ ] Performance ≥ 95
- [ ] Accessibility = 100
- [ ] Best Practices = 100
- [ ] SEO = 100
- [ ] LCP ≤ 2.5s
- [ ] TBT ≤ 200ms
- [ ] CLS ≤ 0.1

For each FAIL, provide the exact code fix.

---

## TEMPLATE 3: COMPONENT GENERATION

Use when: Building a single section or component

---

Build a [COMPONENT NAME] component for a SwiftWeb client website.

CONTEXT:

- Business: [NAME] — [TYPE]
- Brand colours: Primary [HEX], Accent [HEX], Background [HEX], Text [HEX]
- Display font: [FONT NAME]
- Body font: [FONT NAME]
- Content: [DESCRIBE WHAT GOES IN THIS SECTION]

REQUIREMENTS (non-negotiable):

- Semantic HTML with aria-labelledby on the section
- CSS using the project's custom property tokens (--color-primary etc.)
- Any reveal animation: CSS only, triggered by IntersectionObserver
- Never animate layout properties — use transform/opacity only
- Accessible: correct heading level, alt text, keyboard navigation if interactive
- Mobile-first responsive

OUTPUT: Complete HTML + CSS for the component only. No external dependencies.

---

## TEMPLATE 4: SCHEMA.ORG GENERATOR

Use when: Generating structured data for a client

---

Generate Schema.org JSON-LD structured data for this SwiftWeb client.

CLIENT INFO:

- Business Name: [NAME]
- Business Type: [TYPE]
- URL: [URL]
- Description: [1-2 sentences]
- Address: [STREET, CITY, POSTCODE]
- Phone: [PHONE]
- Hours: [e.g. Mon-Fri 9am-5pm]
- Services: [LIST]
- Price Range: [$ / $$ / $$$]
- Social Profiles: [LinkedIn, Facebook, Instagram URLs]
- Logo URL: [URL]

Output a complete `<script type="application/ld+json">` block using the most
specific Schema.org @type appropriate for this business type.
Also output a LocalBusiness @type as a secondary block if the primary type
is more specific (e.g. MedicalBusiness).
Validate that all fields follow Schema.org specifications.

---

## TEMPLATE 5: LLMS.TXT GENERATOR

Use when: Creating the AI optimisation file for a client

---

Write the llms.txt file for this SwiftWeb client website.

This file is placed at [URL]/llms.txt to help AI systems (ChatGPT, Claude,
Perplexity, Google AI Overviews) understand and accurately recommend the business.

Write it in clear, plain English — not marketing speak. AI models should be
able to read this and accurately answer: "Who is [business name]?",
"What does [business name] do?", "Where is [business name] located?",
"Is [business name] a good option for [service] in [city]?"

CLIENT INFO:

- Business Name: [NAME]
- Business Type: [TYPE]
- Location: [CITY], New Zealand
- Services: [LIST]
- Target Customers: [WHO THEY SERVE]
- What Makes Them Different: [USP]
- Contact: [PHONE / EMAIL / URL]
- Social: [LINKS]

Format:

```markdown
# [Business Name]
[One sentence summary]

## Services
[Bullet list with brief descriptions]

## Who We Serve
[Description of ideal clients]

## About
[2-3 paragraphs — conversational, factual, no hyperbole]

## Contact
[Contact details]
```

---

## TEMPLATE 6: PERFORMANCE FIX

Use when: Improving Lighthouse scores on an existing site

---

Analyse this website code and fix all Lighthouse performance issues.
Target: Performance 95+, Accessibility 100, Best Practices 100, SEO 100.

[PASTE CODE OR URL]

For each issue found, provide:

1. The problem (what it is, why it hurts the score)
2. The Lighthouse metric it affects (LCP/TBT/CLS/FCP)
3. The exact code fix

Priority fixes to check:

- Animation libraries (replace with CSS equivalents)
- Scroll event listeners (replace with IntersectionObserver)
- Render-blocking scripts (add defer/async)
- Missing font-display: swap
- Images without width/height
- JS-injected meta tags (move to static HTML)
- Missing or incomplete Schema.org data
- Missing ai-description meta and llms.txt

---

## TEMPLATE 7: MIGRATION & REFACTORING

Use when: Migrating an existing site off animation libraries or JS-rendered content

---

Refactor this existing website to comply with SwiftWeb agency standards.

[PASTE CODE OR REPOSITORY URL]

MIGRATION TASKS:

1. ANIMATION LIBRARY REMOVAL
   - Identify every use of GSAP, AOS, Framer Motion, Animate.css, or similar
   - Replace each with equivalent CSS keyframe or transition
   - Replace scroll event listeners with IntersectionObserver
   - Preserve identical visual behaviour — timing, easing, triggered element

2. SSR / RENDERING FIX
   - Identify any content injected via JavaScript after page load
   - Move that content to static HTML (or SSR template)
   - Meta tags must be in static `<head>`, not set by client-side JS

3. PERFORMANCE
   - Audit for render-blocking scripts — add defer or type="module"
   - Add font-display: swap to all @font-face rules
   - Add width and height to all images
   - Replace missing WebP images where possible

4. SEO & AIO
   - Confirm all SEO meta tags are in static HTML (not JS-injected)
   - Add og:locale="en_NZ" if missing
   - Add meta name="robots" content="index, follow" if missing
   - Add ai-description meta tag if missing
   - Verify llms.txt exists at site root

FOR EACH CHANGE:

1. State the original code
2. State the replacement code
3. Confirm no visual regression
4. Confirm Lighthouse metric improvement (which metric, expected gain)
