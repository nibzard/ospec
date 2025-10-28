---
layout: example
title: "Docs Portal (Marko + HTMX)"
description: "Lightning-fast content-heavy site with progressive enhancement via HTMX and minimal JavaScript"
outcome_type: "web-app"
stack:
  meta_framework: "Astro@5 (pages) + Marko@6 (partials)"
  ui_library: "Marko + vanilla"
  interactivity: "HTMX@1.9 + Hyperscript"
  styling: "TailwindCSS@4 + DaisyUI@4"
  search: "Pagefind (static) or Algolia DocSearch"
  cms: "Markdown/MDX in-repo + GitHub Actions ingestion"
  cache_cdn: "Cloudflare CDN"
  deployment: "Cloudflare Pages"
  package_manager: "pnpm@9"
complexity: "intermediate"
---

# Docs & Knowledge Portal (MPA: Marko + HTMX)

A lightning-fast documentation portal that demonstrates the power of progressive enhancement. Combines Astro's static generation with Marko's streaming SSR and HTMX's dynamic interactions for an incredibly performant content site with minimal JavaScript per route.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "docs-portal-marko-htmx"
name: "Docs & Knowledge Portal (MPA: Marko + HTMX)"
description: "Lightning-fast content-heavy site with progressive enhancement via HTMX; minimal JS per route, instant nav with View Transitions."
outcome_type: "web-app"

technology_stack:
  meta_framework: "Astro@5 (pages) + Marko@6 (partials)"
  ui_library: "Marko + vanilla"
  interactivity: "HTMX@1.9 + Hyperscript"
  styling: "TailwindCSS@4 + DaisyUI@4"
  search: "Pagefind (static) or Algolia DocSearch"
  cms: "Markdown/MDX in-repo + GitHub Actions ingestion"
  cache_cdn: "Cloudflare CDN + Stale-While-Revalidate"
  deployment: "Cloudflare Pages"
  package_manager: "pnpm@9"

agents:
  primary: "content-mpa-builder"
  secondary:
    deployment: "cf-pages-deployer"
    testing: "link-checker"

sub_agents:
  - name: "content-ingestor"
    description: "Pulls docs from multiple repos, normalizes frontmatter, builds ToC."
    focus: ["mdx", "frontmatter", "sitemaps", "rss"]
    model: "sonnet"
  - name: "pe-enhancer"
    description: "Adds HTMX swaps, progressive forms, and prefetch rules."
    focus: ["hx-get", "hx-swap", "speculation-rules", "view-transitions"]
    model: "haiku"

scripts:
  setup: |
    #!/usr/bin/env bash
    pnpm create astro@latest app --template docs
    cd app
    pnpm add @pagefind/default-ui htmx.org hyperscript.org marko tailwindcss daisyui
    pnpm add -D postcss autoprefixer @playwright/test @types/node
    pnpm dlx tailwindcss init -p
  dev: |
    #!/usr/bin/env bash
    pnpm dev
  build_index: |
    #!/usr/bin/env bash
    pnpm run build && npx pagefind --site dist
  deploy: |
    #!/usr/bin/env bash
    pnpm run build && wrangler pages deploy dist

acceptance:
  performance:
    ttfb_ms_p95: 150
    fcp_ms_p50: 80
    js_budget_per_route_kb_gzip: 10
  ux_flows:
    - name: "Docs browse"
      steps:
        - "Navigate section → article (HTMX swap + view transition)"
        - "Sticky ToC highlights current section"
    - name: "Search"
      steps:
        - "Type to filter (Pagefind/Algolia)"
        - "Keyboard nav to result; loads without full refresh"
    - name: "Feedback form"
      steps:
        - "Inline HTMX form posts → success toast"
```

## Key Features

### Core Functionality
- ✅ **Static Site Generation** - Blazing fast initial loads with Astro
- ✅ **Progressive Enhancement** - Works without JavaScript, enhanced with HTMX
- ✅ **Instant Navigation** - View Transitions API for smooth page transitions
- ✅ **Full-Text Search** - Client-side search with Pagefind or Algolia integration
- ✅ **Content Management** - Markdown/MDX with GitHub Actions ingestion
- ✅ **Mobile-Optimized** - Touch-friendly interface with offline capabilities

### Performance Characteristics
- **Ultra-low JavaScript Budget** - 10KB gzip per route maximum
- **Streaming SSR** with Marko for instant perceived performance
- **Edge Caching** via Cloudflare CDN with stale-while-revalidate
- **Optimistic UI** updates with HTMX for instant feedback
- **Critical CSS Inlining** for fastest possible rendering

## Architecture Highlights

### Astro + Marko Integration
```astro
---
// src/layouts/DocsLayout.astro
import { SITE_TITLE } from '../config';
import '@htmx.org';
import '@pagefind/default-ui';

export interface Props {
  title: string;
  description: string;
  frontmatter: any;
}

const { title, description, frontmatter } = Astro.props;

// Content navigation
const { content } = Astro.props;
const allDocs = await Astro.glob('../content/**/*.md');
const currentSection = frontmatter.section;
const sectionDocs = allDocs.filter(doc =>
  doc.frontmatter.section === currentSection
).sort((a, b) => a.frontmatter.order - b.frontmatter.order);
---

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="description" content={description} />
    <title>{title} - {SITE_TITLE}</title>

    <!-- Critical CSS -->
    <style is:inline>
      /* Critical path CSS inlined */
    </style>

    <!-- View Transitions support -->
    <meta name="view-transition" content="same-origin" />

    <!-- Speculation rules for prefetching -->
    <script type="speculationrules">
    {
      "prerender": [
        {
          "source": "document",
          "where": { "selector": "a[href^='/docs/']" },
          "eagerness": "moderate"
        }
      ]
    }
    </script>
  </head>

  <body class="bg-background text-foreground">
    <div class="flex min-h-screen">
      <!-- Sidebar navigation -->
      <aside class="w-64 border-r bg-gray-50">
        <nav class="p-4">
          <ul class="space-y-2">
            {sectionDocs.map(doc => (
              <li>
                <a
                  href={doc.url}
                  class={`block px-3 py-2 rounded transition-colors ${
                    doc.url === Astro.url.pathname
                      ? 'bg-blue-100 text-blue-700'
                      : 'hover:bg-gray-100'
                  }`}
                  hx-get={doc.url}
                  hx-target="#main-content"
                  hx-swap="innerHTML transition:true"
                  hx-push-url="true"
                >
                  {doc.frontmatter.title}
                </a>
              </li>
            ))}
          </ul>
        </nav>
      </aside>

      <!-- Main content area -->
      <main id="main-content" class="flex-1">
        <article class="prose max-w-none p-6">
          <div class="mb-8">
            <h1>{frontmatter.title}</h1>
            <p class="text-lg text-gray-600">{frontmatter.description}</p>
          </div>

          <!-- Content rendering -->
          <slot />

          <!-- Table of Contents -->
          <div class="sticky top-4" id="toc-container">
            <div
              hx-get="/api/toc"
              hx-include="[data-content-id]"
              hx-trigger="load"
              hx-target="#toc-container"
              hx-swap="innerHTML"
            >
              Loading table of contents...
            </div>
          </div>
        </article>
      </main>
    </div>

    <!-- HTMX and Hyperscript -->
    <script src="https://unpkg.com/hyperscript.org@0.9.12"></script>

    <!-- Pagefind search -->
    <script src="/pagefind/pagefind.js"></script>

    <!-- Progressive enhancement script -->
    <script>
      // Initialize HTMX extensions
      document.addEventListener('htmx:afterSwap', function(evt) {
        // Reinitialize syntax highlighting
        if (typeof hljs !== 'undefined') {
          hljs.highlightAll();
        }

        // Update active navigation state
        document.querySelectorAll('nav a').forEach(link => {
          link.classList.remove('bg-blue-100', 'text-blue-700');
          if (link.getAttribute('href') === window.location.pathname) {
            link.classList.add('bg-blue-100', 'text-blue-700');
          }
        });
      });

      // View Transitions fallback
      if (!('viewTransition' in document)) {
        document.addEventListener('click', function(e) {
          const link = e.target.closest('a[href]');
          if (link && link.getAttribute('hx-get')) {
            e.preventDefault();
            // Fallback navigation
          }
        });
      }
    </script>
  </body>
</html>
```

### HTMX-Powered Search
```html
<!-- src/components/Search.astro -->
<div class="search-container" _="on install set searchInput to #search-input">
  <!-- Search input -->
  <div class="relative">
    <input
      id="search-input"
      type="text"
      placeholder="Search documentation..."
      class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
      hx-get="/api/search"
      hx-target="#search-results"
      hx-trigger="keyup changed delay:300ms"
      hx-include="[data-search-params]"
    />

    <!-- Loading indicator -->
    <div
      id="search-loading"
      class="absolute right-3 top-3 hidden"
      hx-get="/api/search"
      hx-trigger="from:body htmx:beforeRequest"
      hx-target="#search-loading"
      hx-swap="innerHTML"
    >
      <div class="animate-spin h-4 w-4 border-2 border-blue-500 border-t-transparent rounded-full"></div>
    </div>
  </div>

  <!-- Search parameters (hidden) -->
  <div data-search-params>
    <input type="hidden" name="limit" value="10" />
    <input type="hidden" name="section" value="docs" />
  </div>

  <!-- Search results -->
  <div id="search-results" class="absolute z-50 w-full mt-1 bg-white border rounded-lg shadow-lg max-h-80 overflow-y-auto">
    <!-- Results loaded here via HTMX -->
  </div>
</div>

<script _="on load
  // Initialize Pagefind search
  async function initSearch() {
    const search = await import('/pagefind/pagefind.js');

    window.performSearch = async function(query) {
      if (!query) {
        document.getElementById('search-results').innerHTML = '';
        return;
      }

      try {
        const results = await search.search(query);
        displayResults(results);
      } catch (error) {
        console.error('Search error:', error);
      }
    };

    function displayResults(results) {
      const container = document.getElementById('search-results');

      if (results.results.length === 0) {
        container.innerHTML = '<div class="p-4 text-gray-500">No results found</div>';
        return;
      }

      const html = results.results.map(result => `
        <div class="p-4 border-b hover:bg-gray-50 cursor-pointer" onclick="window.location.href='${result.url}'">
          <div class="font-medium text-blue-700">${result.data.meta.title}</div>
          <div class="text-sm text-gray-600 line-clamp-2">${result.excerpt}</div>
          <div class="text-xs text-gray-500 mt-1">${result.data.meta.section}</div>
        </div>
      `).join('');

      container.innerHTML = html;
    }
  }

  initSearch()

  // Handle search input
  on input in searchInput debounced at 300ms
    call performSearch(searchInput.value)

  // Handle keyboard navigation
  on keydown in searchInput
    if event.key is 'Escape'
      blur searchInput
      hide #search-results
    else if event.key is 'ArrowDown'
      focus first link in #search-results
    else if event.key is 'ArrowUp'
      focus last link in #search-results
"></script>
```

### Progressive Feedback Form
```html
<!-- src/components/FeedbackForm.astro -->
<form
  class="feedback-form"
  hx-post="/api/feedback"
  hx-target="#feedback-result"
  hx-swap="innerHTML"
  hx-on--after-request="this.reset()"
  _="on submit
    add .opacity-50 to #submit-button
    set #submit-button.innerHTML to 'Submitting...'"
>
  <div class="space-y-4">
    <div>
      <label class="block text-sm font-medium mb-1">Was this helpful?</label>
      <div class="flex space-x-4">
        <label class="flex items-center">
          <input type="radio" name="helpful" value="yes" class="mr-2" required />
          Yes
        </label>
        <label class="flex items-center">
          <input type="radio" name="helpful" value="no" class="mr-2" />
          No
        </label>
      </div>
    </div>

    <div>
      <label class="block text-sm font-medium mb-1">Additional feedback (optional)</label>
      <textarea
        name="feedback"
        rows="3"
        class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        placeholder="How can we improve this documentation?"
      ></textarea>
    </div>

    <div>
      <label class="block text-sm font-medium mb-1">Email (optional)</label>
      <input
        type="email"
        name="email"
        class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        placeholder="your@email.com"
      />
    </div>

    <button
      id="submit-button"
      type="submit"
      class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
    >
      Submit Feedback
    </button>
  </div>
</form>

<div id="feedback-result">
  <!-- Feedback result displayed here -->
</div>
```

### API Endpoints for HTMX
```typescript
// src/pages/api/search.ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ url }) => {
  const searchParams = url.searchParams;
  const query = searchParams.get('q');
  const limit = parseInt(searchParams.get('limit') || '10');

  if (!query) {
    return new Response('<div class="p-4 text-gray-500">Enter a search term</div>', {
      headers: { 'Content-Type': 'text/html' }
    });
  }

  try {
    // Use Pagefind for search
    const pagefind = await import('../pagefind/pagefind.js');
    const results = await pagefind.default.search(query, {
      filter: { section: 'docs' },
      excerptLength: 150
    });

    // Format results as HTML
    const html = results.results.slice(0, limit).map(result => `
      <a href="${result.url}" class="block p-4 border-b hover:bg-gray-50 transition-colors">
        <div class="font-medium text-blue-700 mb-1">${result.data.meta.title}</div>
        <div class="text-sm text-gray-600 line-clamp-2">${result.excerpt}</div>
        <div class="text-xs text-gray-500 mt-1">${result.data.meta.section} • ${result.data.meta.category}</div>
      </a>
    `).join('');

    return new Response(html || '<div class="p-4 text-gray-500">No results found</div>', {
      headers: { 'Content-Type': 'text/html' }
    });

  } catch (error) {
    console.error('Search error:', error);
    return new Response('<div class="p-4 text-red-500">Search temporarily unavailable</div>', {
      headers: { 'Content-Type': 'text/html' }
    });
  }
};

// src/pages/api/feedback.ts
export const POST: APIRoute = async ({ request }) => {
  try {
    const formData = await request.formData();
    const helpful = formData.get('helpful') as string;
    const feedback = formData.get('feedback') as string;
    const email = formData.get('email') as string;
    const page = request.headers.get('referer') || 'unknown';

    // Store feedback (could be to database, email, etc.)
    console.log('Feedback received:', { helpful, feedback, email, page });

    // Return success message
    const message = helpful === 'yes'
      ? 'Thanks for the feedback! We\'re glad this was helpful.'
      : 'Thanks for your feedback. We\'ll use it to improve our documentation.';

    return new Response(`
      <div class="p-4 bg-green-50 border border-green-200 rounded-lg">
        <div class="flex items-center">
          <svg class="w-5 h-5 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
          </svg>
          <span class="text-green-700">${message}</span>
        </div>
      </div>
    `, {
      headers: { 'Content-Type': 'text/html' }
    });

  } catch (error) {
    console.error('Feedback error:', error);
    return new Response(`
      <div class="p-4 bg-red-50 border border-red-200 rounded-lg">
        <div class="text-red-700">Failed to submit feedback. Please try again.</div>
      </div>
    `, {
      headers: { 'Content-Type': 'text/html' }
    });
  }
};
```

## Development Workflow

### 1. Project Setup
```bash
# Create Astro project
pnpm create astro@latest docs-portal --template docs
cd docs-portal

# Install additional dependencies
pnpm add @pagefind/default-ui htmx.org hyperscript.org marko tailwindcss daisyui
pnpm add -D postcss autoprefixer @playwright/test @types/node

# Configure Tailwind
pnpm dlx tailwindcss init -p
```

### 2. Content Structure
```
src/
├── content/
│   ├── getting-started/
│   │   ├── introduction.md
│   │   ├── installation.md
│   │   └── quick-start.md
│   ├── guides/
│   │   ├── authentication.md
│   │   ├── deployment.md
│   │   └── best-practices.md
│   ├── api/
│   │   ├── overview.md
│   │   ├── endpoints.md
│   │   └── examples.md
│   └── reference/
│       ├── configuration.md
│       ├── troubleshooting.md
│       └── changelog.md
├── components/
│   ├── Search.astro
│   ├── FeedbackForm.astro
│   ├── TableOfContents.astro
│   └── CodeBlock.astro
├── layouts/
│   ├── DocsLayout.astro
│   └── PlainLayout.astro
└── pages/
    ├── docs/[...slug].astro
    └── api/
        ├── search.ts
        ├── feedback.ts
        └── toc.ts
```

### 3. Content Ingestion Workflow
```yaml
# .github/workflows/content-sync.yml
name: Sync Documentation Content

on:
  push:
    paths:
      - 'content/**'
  schedule:
    - cron: '0 */6 * * *' # Every 6 hours

jobs:
  sync-content:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install dependencies
        run: pnpm install

      - name: Process content
        run: |
          node scripts/process-content.js

      - name: Build site
        run: pnpm run build

      - name: Build search index
        run: pnpm run build:index

      - name: Deploy to Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: docs-portal
          directory: dist
```

## Performance Optimization

### Critical Path Optimization
```typescript
// astro.config.mjs
import { defineConfig } from 'astro/config';

export default defineConfig({
  output: 'static',
  build: {
    format: 'directory'
  },

  // Optimize assets
  vite: {
    build: {
      rollupOptions: {
        output: {
          manualChunks: {
            vendor: ['htmx.org', 'hyperscript.org'],
            search: ['@pagefind/default-ui']
          }
        }
      }
    }
  },

  // Image optimization
  image: {
    domains: ['localhost'],
    format: ['webp', 'avif'],
    quality: 85
  },

  // Performance integrations
  integrations: [
    // Add performance monitoring
    // Add sitemap generation
    // Add RSS feeds
  ]
});
```

### Service Worker for Offline Support
```typescript
// public/sw.js
const CACHE_NAME = 'docs-portal-v1';
const STATIC_ASSETS = [
  '/',
  '/docs/getting-started/introduction',
  '/css/global.css',
  '/js/main.js'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(STATIC_ASSETS))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Return cached version or fetch from network
        return response || fetch(event.request)
          .then(response => {
            // Cache successful responses
            if (response.ok) {
              const responseClone = response.clone();
              caches.open(CACHE_NAME)
                .then(cache => cache.put(event.request, responseClone));
            }
            return response;
          });
      })
  );
});
```

## Security Considerations

- **Content Security Policy** for XSS prevention
- **Input Sanitization** for user-generated content
- **Rate Limiting** on search and feedback endpoints
- **HTTPS Enforcement** across all routes
- **Subresource Integrity** for external scripts
- **Safe HTML Rendering** for markdown content

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm package manager
- Cloudflare account for deployment

### Quick Start
```bash
# Clone and set up
git clone <repository-url>
cd docs-portal-marko-htmx
pnpm install

# Start development
pnpm dev

# Build for production
pnpm run build

# Build search index
pnpm run build:index
```

### Environment Variables
```env
# Analytics (optional)
PUBLIC_ANALYTICS_ID=your-analytics-id

# Search configuration
SEARCH_PROVIDER=pagefind # or algolia
ALGOLIA_APP_ID=your-app-id
ALGOLIA_API_KEY=your-api-key
ALGOLIA_INDEX_NAME=your-index
```

## Related Examples

- [SaaS Starter →]({{ 'examples/saas-starter-sveltekit/' | relative_url }}) - Content management patterns
- [Enterprise Admin →]({{ 'examples/enterprise-admin-nuxt/' | relative_url }}) - Search implementation patterns
- [Router App →]({{ 'examples/router-app-tanstack-solid/' | relative_url }}) - Progressive enhancement patterns