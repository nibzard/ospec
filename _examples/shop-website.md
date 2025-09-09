---
layout: example
title: "E-Commerce Shop Website"
description: "Full-featured online store with products, cart, checkout, and payments"
outcome_type: "web-app"
stack:
  frontend: "Next.js@14"
  styling: "TailwindCSS@3"
  backend: "Supabase"
  payments: "Stripe"
  auth: "Clerk"
  deploy: "Vercel"
github: "https://github.com/nibzard/ospec-examples/tree/main/shop-website"
---

# E-Commerce Shop Website

A complete e-commerce solution built with modern web technologies and OSpec automation.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "shop-website-basic"
name: "Shop Website — Starter"
description: "Small e-commerce storefront with product pages, cart, checkout (Stripe), auth, and deploy to Vercel."
outcome_type: "web-app"

acceptance:
  http_endpoints:
    - path: "/"
      status: 200
    - path: "/products"
      status: 200
    - path: "/cart"
      status: 200
    - path: "/checkout"
      status: 200
  ux_flows:
    - name: "purchase_flow"
      steps:
        - view_product_catalog
        - select_product
        - add_to_cart
        - proceed_to_checkout
        - enter_payment_details
        - confirm_order
        - view_confirmation
  tests:
    - file: "tests/test_products.py"
      type: "unit"
    - file: "tests/test_cart.py"
      type: "integration"
    - file: "tests/test_checkout.py"
      type: "e2e"
  performance:
    response_time_ms: 200
    throughput_rps: 100

stack:
  frontend: "Next.js@14"
  styling: "TailwindCSS@3"
  backend: "Supabase (Postgres)"
  payments: "Stripe"
  auth: "Clerk"
  cdn: "Cloudflare"
  deploy: "Vercel"

guardrails:
  tests_required: true
  min_test_coverage: 0.75
  lint: true
  type_check: true
  dependency_check: true
  security_scan: true
  license_whitelist: ["MIT", "Apache-2.0", "BSD-3-Clause"]
  human_approval_required: ["payment_integration", "production_deploy"]

prompts:
  specifier: "prompts/ecommerce-specifier.md"
  planner: "prompts/ecommerce-planner.md"
  implementer: "prompts/ecommerce-implementer.md"
  reviewer: "prompts/ecommerce-reviewer.md"

scripts:
  setup: "scripts/setup.sh"
  test: "scripts/test.sh"
  build: "scripts/build.sh"
  deploy: "scripts/deploy.sh"
  seed_data: "scripts/seed-products.sh"

metadata:
  maintainers:
    - name: "Alice Developer"
      email: "alice@example.com"
      github: "alice-dev"
  estimated_effort: "MVP: 3-5 days"
  tags: ["ecommerce", "payments", "authentication", "serverless"]
  version: "1.0.0"

secrets:
  provider: "vercel://env"
  required:
    - "STRIPE_SECRET_KEY"
    - "STRIPE_WEBHOOK_SECRET"
    - "DATABASE_URL"
    - "CLERK_SECRET_KEY"
    - "VERCEL_TOKEN"
  optional:
    - "SENTRY_DSN"
    - "ANALYTICS_ID"
```

## Features

### Core Functionality
- ✅ Product catalog with search and filters
- ✅ Shopping cart with session persistence
- ✅ Secure checkout with Stripe
- ✅ User authentication with Clerk
- ✅ Order history and tracking
- ✅ Admin dashboard for inventory

### Technical Highlights
- **Server-side rendering** with Next.js App Router
- **Type-safe database** queries with Prisma
- **Real-time updates** via Supabase subscriptions
- **Optimized images** with Next.js Image component
- **Mobile-responsive** design with TailwindCSS
- **PCI-compliant** payment processing

## Task Decomposition

The OSpec agent breaks this down into:

1. **Setup & Configuration** (2h)
   - Initialize Next.js project
   - Configure Supabase database
   - Set up authentication with Clerk
   - Configure Stripe SDK

2. **Product Management** (3h)
   - Create product schema
   - Build product listing page
   - Implement product detail views
   - Add search and filtering

3. **Shopping Cart** (2h)
   - Session-based cart storage
   - Add/remove items
   - Quantity updates
   - Cart persistence

4. **Checkout Flow** (4h)
   - Shipping information form
   - Stripe payment integration
   - Order confirmation
   - Email notifications

5. **User Features** (2h)
   - User registration/login
   - Profile management
   - Order history
   - Saved addresses

6. **Admin Dashboard** (3h)
   - Product CRUD operations
   - Order management
   - Inventory tracking
   - Basic analytics

7. **Testing & QA** (2h)
   - Unit tests for utilities
   - Integration tests for API
   - E2E tests for critical paths
   - Performance optimization

8. **Deployment** (1h)
   - Vercel configuration
   - Environment variables
   - Domain setup
   - Production checks

## Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn
- Stripe account
- Clerk account
- Supabase project
- Vercel account

### Quick Start

```bash
# Clone the example
git clone https://github.com/nibzard/ospec-examples
cd shop-website

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env.local
# Edit .env.local with your keys

# Run database migrations
npm run db:migrate

# Seed sample data
npm run db:seed

# Start development server
npm run dev
```

### Environment Variables

```env
# Database
DATABASE_URL=postgresql://...

# Authentication
CLERK_SECRET_KEY=sk_...
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_...

# Payments
STRIPE_SECRET_KEY=sk_...
STRIPE_WEBHOOK_SECRET=whsec_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_...

# Deployment
VERCEL_URL=https://...
```

## Architecture

```
shop-website/
├── app/                    # Next.js app router
│   ├── (shop)/            # Public shop pages
│   │   ├── page.tsx       # Homepage
│   │   ├── products/      # Product pages
│   │   ├── cart/          # Cart page
│   │   └── checkout/      # Checkout flow
│   ├── (admin)/           # Admin dashboard
│   └── api/               # API routes
├── components/            # React components
├── lib/                   # Utilities
│   ├── db.ts             # Database client
│   ├── stripe.ts         # Stripe client
│   └── auth.ts           # Auth helpers
├── prisma/               # Database schema
└── tests/                # Test suites
```

## Performance Optimizations

- Static generation for product pages
- Dynamic imports for heavy components
- Image optimization with responsive sizes
- Database query optimization with indexes
- CDN caching for static assets
- Edge functions for API routes

## Security Considerations

- HTTPS enforced on all routes
- CSRF protection enabled
- Rate limiting on API endpoints
- Input validation and sanitization
- SQL injection prevention via Prisma
- XSS protection headers
- Content Security Policy configured

## Monitoring & Analytics

- Error tracking with Sentry
- Performance monitoring with Vercel Analytics
- Custom events for conversion tracking
- Real User Monitoring (RUM)
- Server-side logging

## Live Demo

[View Live Demo →](https://shop-ospec-example.vercel.app)

## Source Code

[View on GitHub →](https://github.com/nibzard/ospec-examples/tree/main/shop-website)

## Related Examples

- [API Service →]({{ 'examples/api-service/' | relative_url }})
- [Mobile App →]({{ 'examples/mobile-app/' | relative_url }})
- [Admin Dashboard →]({{ 'examples/admin-dashboard/' | relative_url }})