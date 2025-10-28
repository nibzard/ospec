---
layout: example
title: "SaaS Starter (SvelteKit)"
description: "Complete SaaS foundation with authentication, billing, teams, and email management"
outcome_type: "web-app"
stack:
  meta_framework: "SvelteKit@2"
  ui_library: "Svelte@5"
  styling: "TailwindCSS@4 + Skeleton UI"
  database: "Supabase Postgres"
  auth: "Supabase Auth"
  payments: "Stripe@13"
  emails: "Resend + React Email"
  deployment: "Vercel"
  package_manager: "pnpm@9"
complexity: "advanced"
---

# SaaS Starter (SvelteKit DX)

An opinionated SaaS foundation that handles the complex parts of building a subscription-based business. Includes authentication, billing, team management, and email communications with Svelte's excellent developer experience and compiled performance.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "saas-starter-sveltekit"
name: "SaaS Starter (SvelteKit DX)"
description: "Opinionated SaaS base: auth, billing, teams, emails; compiled reactivity."
outcome_type: "web-app"

technology_stack:
  meta_framework: "SvelteKit@2"
  ui_library: "Svelte@5"
  styling: "TailwindCSS@4 + Skeleton UI"
  database: "Supabase Postgres"
  auth: "Supabase Auth"
  payments: "Stripe@13"
  emails: "Resend + React Email"
  deployment: "Vercel (Edge where possible)"
  package_manager: "pnpm@9"

agents:
  primary: "saas-chief"
  secondary:
    deployment: "vercelizer"
    testing: "vitest-playwright"

sub_agents:
  - name: "billing-expert"
    description: "Stripe subs, webhooks, proration."
    focus: ["checkout", "billing-portal", "metered-usage"]
    model: "sonnet"
  - name: "dx-curator"
    description: "CLI, codegen, docs."
    focus: ["svelte-add", "eslint/prettier", "hygen-templates"]
    model: "haiku"

scripts:
  setup: |
    #!/usr/bin/env bash
    pnpm create svelte@latest app --template skeleton
    cd app
    pnpm add @supabase/supabase-js drizzle-orm stripe zod resend @react-email/components
    pnpm add -D tailwindcss postcss autoprefixer daisyui vitest @playwright/test
    pnpm dlx tailwindcss init -p
  dev: |
    #!/usr/bin/env bash
    pnpm dev --open
  deploy: |
    #!/usr/bin/env bash
    vercel --prod

acceptance:
  performance:
    web_vitals_targets:
      lcp_ms_p75: 1200
      fid_ms_p75: 50
      cls_p75: 0.05
  ux_flows:
    - name: "Sign up + org creation"
      steps:
        - "Magic link sign-in"
        - "Create org, invite member"
    - name: "Subscription purchase"
      steps:
        - "Select plan → Stripe checkout"
        - "Seat-based billing; tax handled"
    - name: "Email lifecycle"
      steps:
        - "Welcome, invite, invoice emails render correctly (dark/light)"
```

## Key Features

### Core SaaS Functionality
- ✅ **Multi-tenant Architecture** - Organization-based isolation and permissions
- ✅ **User Authentication** - Magic link and OAuth providers via Supabase
- ✅ **Subscription Management** - Stripe integration with proration and metering
- ✅ **Team Collaboration** - Role-based access and invitation system
- ✅ **Email System** - Transactional emails with React Email templates
- ✅ **Billing Portal** - Self-service plan changes and payment methods

### Developer Experience
- **Type Safety** throughout with TypeScript and strict mode
- **Svelte 5** with runes for simplified state management
- **Skeleton UI** component library with dark mode support
- **Hot Reload** in development with instant updates
- **Form Validation** using SvelteKit's built-in form actions
- **Database Migrations** with Drizzle ORM

## Architecture Highlights

### Svelte 5 Runes for State Management
```svelte
<!-- src/lib/components/subscription/SubscriptionCard.svelte -->
<script lang="ts">
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { goto } from '$app/navigation';

  // Reactive state with runes
  let subscription = $state<Subscription | null>(null);
  let loading = $state(true);
  let cancelling = $state(false);

  // Effects for data fetching
  $effect(() => {
    loadSubscription();
  });

  async function loadSubscription() {
    loading = true;
    try {
      subscription = await getSubscription();
    } finally {
      loading = false;
    }
  }

  async function handleCancel() {
    cancelling = true;
    try {
      await cancelSubscription();
      await goto('/billing/cancelled');
    } finally {
      cancelling = false;
    }
  }
</script>

{#if loading}
  <div class="animate-pulse">
    <div class="h-20 bg-gray-200 rounded"></div>
  </div>
{:else if subscription}
  <div class="bg-white rounded-lg shadow p-6">
    <h3 class="text-lg font-semibold">{subscription.plan.name}</h3>
    <p class="text-gray-600">${subscription.amount}/month</p>
    <button
      onclick={handleCancel}
      disabled={cancelling}
      class="mt-4 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 disabled:opacity-50"
    >
      {cancelling ? 'Cancelling...' : 'Cancel Subscription'}
    </button>
  </div>
{/if}
```

### Stripe Integration with Webhooks
```typescript
// src/routes/api/webhooks/stripe/+server.ts
import { stripe } from '$lib/server/stripe';
import { db } from '$lib/server/db';
import { subscriptions, users } from '$lib/server/db/schema';
import { eq } from 'drizzle-orm';
import { json, type RequestHandler } from '@sveltejs/kit';

export const POST: RequestHandler = async ({ request }) => {
  const body = await request.text();
  const signature = request.headers.get('stripe-signature')!;

  let event: Stripe.Event;

  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    );
  } catch (err) {
    return json({ error: 'Invalid signature' }, { status: 400 });
  }

  switch (event.type) {
    case 'customer.subscription.created':
    case 'customer.subscription.updated':
      const subscription = event.data.object as Stripe.Subscription;
      await db.insert(subscriptions)
        .values({
          id: subscription.id,
          userId: subscription.metadata.userId!,
          planId: subscription.items.data[0].price.id,
          status: subscription.status,
          currentPeriodStart: new Date(subscription.current_period_start * 1000),
          currentPeriodEnd: new Date(subscription.current_period_end * 1000),
        })
        .onConflictDoUpdate({
          target: subscriptions.id,
          set: {
            status: subscription.status,
            currentPeriodStart: new Date(subscription.current_period_start * 1000),
            currentPeriodEnd: new Date(subscription.current_period_end * 1000),
          }
        });
      break;

    case 'invoice.payment_succeeded':
      // Update user access, send receipt email
      await handleSuccessfulPayment(event.data.object as Stripe.Invoice);
      break;

    case 'invoice.payment_failed':
      // Notify user of payment failure
      await handleFailedPayment(event.data.object as Stripe.Invoice);
      break;
  }

  return json({ received: true });
};
```

### Supabase Auth Integration
```typescript
// src/lib/server/auth.ts
import { createClient } from '@supabase/supabase-js';
import { dev } from '$app/environment';

const supabaseUrl = process.env.SUPABASE_URL!;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

export async function getCurrentUser(request: Request) {
  const token = request.headers.get('Authorization')?.replace('Bearer ', '');

  if (!token) return null;

  const { data: { user }, error } = await supabase.auth.getUser(token);

  if (error || !user) return null;

  return user;
}
```

### Email Templates with React Email
```typescript
// src/lib/emails/templates/WelcomeEmail.tsx
import { Html, Head, Body, Container, Text, Button } from '@react-email/components';

interface WelcomeEmailProps {
  userName: string;
  organizationName: string;
  confirmUrl: string;
}

export const WelcomeEmail = ({ userName, organizationName, confirmUrl }: WelcomeEmailProps) => (
  <Html>
    <Head />
    <Body style={main}>
      <Container style={container}>
        <Text style={heading}>Welcome to {organizationName}!</Text>
        <Text style={paragraph}>
          Hi {userName},
        </Text>
        <Text style={paragraph}>
          Welcome aboard! We're excited to have you join our team. Your account has been created
          and you're ready to start using our platform.
        </Text>
        <Button href={confirmUrl} style={button}>
          Get Started
        </Button>
        <Text style={paragraph}>
          If you have any questions, don't hesitate to reach out to our support team.
        </Text>
        <Text style={footer}>
          Best regards,
          <br />
          The Team
        </Text>
      </Container>
    </Body>
  </Html>
);

const main = {
  backgroundColor: '#f6f9fc',
  fontFamily: 'system-ui, -apple-system, sans-serif',
};

const container = {
  backgroundColor: '#ffffff',
  margin: '0 auto',
  padding: '20px 0',
  maxWidth: '600px',
  borderRadius: '8px',
  boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
};

const heading = {
  fontSize: '24px',
  fontWeight: '600',
  color: '#1f2937',
  marginBottom: '20px',
};

const paragraph = {
  fontSize: '16px',
  lineHeight: '24px',
  color: '#4b5563',
  marginBottom: '20px',
};

const button = {
  backgroundColor: '#3b82f6',
  color: '#ffffff',
  padding: '12px 24px',
  borderRadius: '6px',
  textDecoration: 'none',
  display: 'inline-block',
  fontWeight: '500',
};

const footer = {
  fontSize: '14px',
  color: '#6b7280',
  marginTop: '40px',
};
```

## Development Workflow

### 1. Project Setup
```bash
# Create SvelteKit project
pnpm create svelte@latest saas-app --template skeleton
cd saas-app

# Install dependencies
pnpm add @supabase/supabase-js drizzle-orm stripe zod resend @react-email/components
pnpm add -D tailwindcss postcss autoprefixer daisyui vitest @playwright/test

# Initialize Tailwind and Skeleton
pnpm dlx tailwindcss init -p
pnpm dlx skeleton-ui init
```

### 2. Database Schema with Drizzle
```typescript
// src/lib/server/db/schema.ts
import { pgTable, text, timestamp, boolean, jsonb, uuid } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  avatarUrl: text('avatar_url'),
  emailVerified: boolean('email_verified').default(false),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const organizations = pgTable('organizations', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: text('name').notNull(),
  slug: text('slug').notNull().unique(),
  ownerId: uuid('owner_id').references(() => users.id),
  stripeCustomerId: text('stripe_customer_id'),
  createdAt: timestamp('created_at').defaultNow(),
});

export const organizationMembers = pgTable('organization_members', {
  id: uuid('id').defaultRandom().primaryKey(),
  organizationId: uuid('organization_id').references(() => organizations.id),
  userId: uuid('user_id').references(() => users.id),
  role: text('role').notNull(), // owner, admin, member
  invitedAt: timestamp('invited_at'),
  joinedAt: timestamp('joined_at'),
});

export const subscriptions = pgTable('subscriptions', {
  id: uuid('id').defaultRandom().primaryKey(),
  organizationId: uuid('organization_id').references(() => organizations.id),
  stripeSubscriptionId: text('stripe_subscription_id').notNull(),
  status: text('status').notNull(), // active, canceled, past_due, etc.
  priceId: text('price_id').notNull(),
  currentPeriodStart: timestamp('current_period_start').notNull(),
  currentPeriodEnd: timestamp('current_period_end').notNull(),
  cancelAtPeriodEnd: boolean('cancel_at_period_end').default(false),
  metadata: jsonb('metadata'),
});
```

### 3. Authentication Flow
```typescript
// src/routes/api/auth/magic-link/+server.ts
import { supabase } from '$lib/server/auth';
import { redirect, type RequestHandler } from '@sveltejs/kit';

export const POST: RequestHandler = async ({ request }) => {
  const { email } = await request.json();

  const { data, error } = await supabase.auth.signInWithOtp({
    email,
    options: {
      emailRedirectTo: `${new URL(request.url).origin}/auth/callback`,
    },
  });

  if (error) {
    return json({ error: error.message }, { status: 400 });
  }

  return json({ message: 'Magic link sent to your email' });
};
```

## Performance Optimization

### Edge Runtime Configuration
```typescript
// vite.config.ts
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [sveltekit()],
  define: {
    // Enable edge runtime where possible
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
  },
});
```

### Form Actions for Better UX
```typescript
// src/routes/billing/upgrade/+page.server.ts
import { fail, redirect } from '@sveltejs/kit';
import { stripe } from '$lib/server/stripe';
import { getCurrentUser } from '$lib/server/auth';
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ request }) => {
  const user = await getCurrentUser(request);
  if (!user) throw redirect(302, '/login');

  // Load current subscription and available plans
  const subscription = await getUserSubscription(user.id);
  const plans = await getAvailablePlans();

  return { subscription, plans };
};

export const actions: Actions = {
  upgrade: async ({ request }) => {
    const user = await getCurrentUser(request);
    if (!user) return fail(401, { message: 'Unauthorized' });

    const data = await request.formData();
    const priceId = data.get('priceId') as string;

    try {
      const session = await stripe.checkout.sessions.create({
        customer_email: user.email,
        line_items: [{ price: priceId, quantity: 1 }],
        mode: 'subscription',
        success_url: `${new URL(request.url).origin}/billing/success`,
        cancel_url: `${new URL(request.url).origin}/billing/cancel`,
        metadata: { userId: user.id },
      });

      throw redirect(303, session.url!);
    } catch (e) {
      if (e instanceof Response) throw e;
      return fail(500, { message: 'Failed to create checkout session' });
    }
  },
};
```

## Security Considerations

- **Row Level Security** with Supabase for data access control
- **CSRF Protection** via SvelteKit's built-in form actions
- **Input Validation** using Zod schemas for all user inputs
- **Secure Headers** with proper CSP and security policies
- **Rate Limiting** on authentication endpoints
- **Environment Variable Security** for API keys and secrets

## Monitoring & Analytics

- **Error Tracking** with integrated error reporting
- **Business Metrics** - MRR, churn, LTV tracking
- **Performance Monitoring** - Core Web Vitals and bundle analysis
- **User Analytics** for feature adoption and engagement
- **Health Checks** for external service dependencies

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm package manager
- Supabase project
- Stripe account
- Resend account for emails
- Vercel for deployment

### Quick Start
```bash
# Clone and set up
git clone <repository-url>
cd saas-starter-sveltekit
pnpm install

# Set up environment
cp .env.example .env.local
# Configure all required services

# Initialize database
pnpm run db:push

# Start development
pnpm dev
```

### Environment Configuration
```env
# .env.local
PUBLIC_SUPABASE_URL=your-supabase-url
PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

STRIPE_SECRET_KEY=sk_...
STRIPE_WEBHOOK_SECRET=whsec_...
PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_...

RESEND_API_KEY=re_...

DATABASE_URL=postgresql://...
```

## Related Examples

- [Shop Website →]({{ 'examples/shop-website/' | relative_url }}) - Payment integration patterns
- [Field CRM →]({{ 'examples/field-crm-marko/' | relative_url }}) - Authentication patterns
- [Enterprise Admin →]({{ 'examples/enterprise-admin-nuxt/' | relative_url }}) - Team management patterns