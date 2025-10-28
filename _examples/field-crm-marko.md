---
layout: example
title: "Field CRM (Marko)"
description: "Mobile-first CRM for agents in the field with HTML-streaming and tiny per-route JavaScript"
outcome_type: "web-app"
stack:
  meta_framework: "Marko@6"
  ui_library: "Marko"
  styling: "TailwindCSS@4 + DaisyUI@4"
  database: "Neon Postgres + Drizzle ORM"
  auth: "Lucia"
  cache: "Cloudflare KV + Redis"
  deployment: "Fly.io"
  package_manager: "pnpm@9"
complexity: "advanced"
---

# Field CRM (MPA, Ultra-lean)

A mobile-first CRM solution designed for field agents who need fast, reliable access to customer data while working offline. Built with Marko's streaming SSR for optimal performance and minimal JavaScript per route.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "field-crm-marko"
name: "Field CRM (MPA, Ultra-lean)"
description: "Mobile-first CRM for agents in the field; HTML-streaming, tiny per-route JS."
outcome_type: "web-app"

technology_stack:
  meta_framework: "Marko@6"           # Streaming SSR + selective hydration
  ui_library: "Marko"
  styling: "TailwindCSS@4 + DaisyUI@4"
  database: "Neon Postgres + Drizzle ORM"
  auth: "Lucia"
  cache: "Cloudflare KV (sessions) + Redis (rate limits)"
  deployment: "Fly.io"                # Long-lived Node, regional proximity
  package_manager: "pnpm@9"

agents:
  primary: "builder-pro"
  secondary:
    deployment: "fly-ops"
    testing: "qa-buddy"

sub_agents:
  - name: "crm-domain-expert"
    description: "Leads, contacts, pipelines, activities."
    focus: ["kanban-pipeline", "lead-import", "csv-export"]
    model: "sonnet"
  - name: "perf-auditor"
    description: "Chases bundle and TTFB; audits hydration boundaries."
    focus: ["route-level-js", "streaming", "image-optim"]
    model: "opus"

scripts:
  setup: |
    #!/usr/bin/env bash
    set -e
    echo "🚀 Scaffolding Field CRM (Marko 6)…"
    pnpm create @marko/app@latest app --template basic
    cd app
    pnpm add -D tailwindcss postcss autoprefixer daisyui @tailwindcss/typography
    pnpm add drizzle-orm pg neon-http wrangler zod lucia @lucia-auth/adapter-postgresql
    pnpm dlx tailwindcss init -p
  dev: |
    #!/usr/bin/env bash
    pnpm dev
  deploy: |
    #!/usr/bin/env bash
    echo "✈️  Deploying to Fly.io (region: fra)…"
    fly launch --no-deploy --name field-crm-marko --region fra
    fly deploy

acceptance:
  performance:
    ttfb_ms_p95: 200
    fcp_ms_p50: 80
    js_budget_per_route_kb_gzip: 30
  ux_flows:
    - name: "Create and advance a deal"
      steps:
        - "Add lead with minimal form"
        - "Drag card across stages; persists"
        - "Offline note queues, syncs on reconnect"
    - name: "Mobile quick actions"
      steps:
        - "Call/SMS tap from lead profile"
        - "Log activity with 2 taps"
    - name: "Import CSV"
      steps:
        - "Upload CSV → map columns → preview diffs → commit"
```

## Key Features

### Core Functionality
- ✅ **Lead & Contact Management** - Mobile-optimized forms with offline support
- ✅ **Visual Pipeline** - Drag-and-drop kanban board with optimistic updates
- ✅ **Activity Tracking** - Call logs, notes, and follow-ups with automatic sync
- ✅ **Offline-First Design** - Service worker caching with background sync
- ✅ **CSV Import/Export** - Bulk data operations with conflict resolution
- ✅ **Real-time Collaboration** - Multi-agent presence and conflict resolution

### Performance Optimizations
- **Streaming SSR** with Marko 6 for instant perceived performance
- **Route-level JavaScript** budgeting (30KB gzip max per route)
- **Progressive Enhancement** - Core functionality works without JavaScript
- **Selective Hydration** - Only interactive components get client-side JS
- **Edge Caching** with Cloudflare KV for session data
- **Regional Deployment** on Fly.io for low-latency database access

## Architecture Highlights

### Mobile-First UX Patterns
- **Touch-Optimized Interface** - Large tap targets and gesture support
- **Progressive Web App** - Installable with offline capabilities
- **Adaptive Design** - Responsive layout that works on any screen size
- **Quick Actions** - One-tap calling, messaging, and activity logging

### Offline-First Strategy
```javascript
// Service worker for offline functionality
self.addEventListener('sync', (event) => {
  if (event.tag === 'background-sync') {
    event.waitUntil(syncOfflineData());
  }
});

// Queue actions when offline
function queueAction(type, data) {
  const queue = JSON.parse(localStorage.getItem('actionQueue') || '[]');
  queue.push({ type, data, timestamp: Date.now() });
  localStorage.setItem('actionQueue', JSON.stringify(queue));
}
```

### Streaming SSR Implementation
```marko
<!-- Marko template with streaming -->
<class-layout>
  <@header>
    <await(pipelineData)>
      <@then>
        <pipeline-view data=pipelineData/>
      </@then>
      @loading {
        <pipeline-skeleton/>
      }
    </await>
  </@header>

  <@content>
    <await(leadsData)>
      <leads-list data=leadsData mobile=true/>
    </await>
  </@content>
</class-layout>
```

## Development Workflow

### 1. Project Setup
```bash
# Clone and set up the project
git clone <repository-url>
cd field-crm-marko
pnpm install

# Set up environment variables
cp .env.example .env.local
# Configure database and auth providers

# Run database migrations
pnpm run db:migrate

# Start development server
pnpm dev
```

### 2. Database Schema
```sql
-- Core CRM tables
CREATE TABLE leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  company TEXT,
  status TEXT DEFAULT 'prospect',
  value DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE pipeline_stages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  position INTEGER NOT NULL,
  board_id UUID REFERENCES boards(id)
);

CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id UUID REFERENCES leads(id),
  type TEXT NOT NULL, -- call, email, meeting, note
  content TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  synced_at TIMESTAMP
);
```

### 3. Performance Monitoring
- **Core Web Vitals** tracking with custom thresholds
- **Bundle analysis** per route to ensure JS budget compliance
- **Database query optimization** with connection pooling
- **CDN performance** monitoring for static assets

## Deployment Strategy

### Fly.io Configuration
```toml
# fly.toml
app = "field-crm-marko"
primary_region = "fra"

[build]
  builder = "paketobuildpacks/builder:base"

[env]
  PORT = "8080"
  NODE_ENV = "production"

[[services]]
  protocol = "tcp"
  internal_port = 8080

  [[services.ports]]
    port = 80
    handlers = ["http"]

  [[services.ports]]
    port = 443
    handlers = ["tls", "http"]
```

### Performance Budget Enforcement
```javascript
// webpack.config.js - Bundle analysis
module.exports = {
  performance: {
    maxAssetSize: 30000, // 30KB per route
    maxEntrypointSize: 50000
  },
  optimization: {
    splitChunks: {
      chunks: 'all',
      maxInitialRequests: 2,
      maxAsyncRequests: 4
    }
  }
};
```

## Security Considerations

- **Authentication** via Lucia with secure session management
- **Rate Limiting** with Redis to prevent abuse
- **Input Validation** using Zod schemas
- **CSRF Protection** on all state-changing operations
- **Content Security Policy** for defense in depth
- **Data Encryption** at rest and in transit

## Monitoring & Analytics

- **Error Tracking** with integrated error reporting
- **Performance Metrics** - TTFB, FCP, route-level JS sizes
- **User Analytics** - Feature usage and conversion tracking
- **Database Performance** - Query optimization and indexing
- **Uptime Monitoring** with automated alerting

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm package manager
- Neon PostgreSQL database
- Fly.io account for deployment

### Quick Start
```bash
# Install dependencies
pnpm install

# Set up environment
cp .env.example .env.local
# Edit with your database and auth credentials

# Initialize database
pnpm run db:setup

# Start development
pnpm dev
```

### Environment Variables
```env
# Database
DATABASE_URL=postgresql://...

# Authentication
LUCIA_AUTH_SECRET=your-secret-key
LUCIA_AUTH_ADAPTER postgresql

# Cache
REDIS_URL=redis://...
CLOUDFLARE_KV_API_TOKEN=...

# Deployment
FLY_API_TOKEN=...
```

## Related Examples

- [Shop Website →]({{ 'examples/shop-website/' | relative_url }}) - E-commerce with similar mobile patterns
- [SaaS Starter →]({{ 'examples/saas-starter-sveltekit/' | relative_url }}) - Authentication and database patterns
- [Enterprise Admin →]({{ 'examples/enterprise-admin-nuxt/' | relative_url }}) - Admin interface patterns