---
layout: example
title: "Router-Centric App (TanStack + Solid)"
description: "Modern application showcasing TanStack Router's powerful data loading patterns with SolidJS performance"
outcome_type: "web-app"
stack:
  meta_framework: "TanStack Start@1.13x (Solid adapter)"
  ui_library: "SolidJS@1.9"
  routing: "TanStack Router (file-based)"
  styling: "TailwindCSS@4 + DaisyUI@4"
  data_layer: "Drizzle ORM + Postgres (Neon)"
  rpc: "Server Functions (isomorphic)"
  realtime: "Pusher or Ably"
  auth: "Lucia"
  deployment: "Vercel (Node) or Cloudflare Pages"
  package_manager: "pnpm@9"
complexity: "advanced"
---

# Router-Centric App (TanStack + Solid)

A sophisticated application that demonstrates TanStack Router's powerful data loading and state management capabilities combined with SolidJS's fine-grained reactivity. Features file-based routing, server functions, and advanced data synchronization patterns.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "router-app-tanstack-solid"
name: "Router-Centric App (TanStack Start + Solid)"
description: "Solid performance with TanStack Router ergonomics: loaders, mutations, nested layouts, and streaming SSR."
outcome_type: "web-app"

technology_stack:
  meta_framework: "TanStack Start@1.13x (Solid adapter)"
  ui_library: "SolidJS@1.9"
  routing: "TanStack Router (file-based)"
  styling: "TailwindCSS@4 + DaisyUI@4"
  data_layer: "Drizzle ORM + Postgres (Neon) | Zod for schemas"
  rpc: "Server Functions (isomorphic)"
  realtime: "Pusher or Ably (optional)"
  auth: "Lucia"
  deployment: "Vercel (Node) or Cloudflare Pages (per project)"
  package_manager: "pnpm@9"

agents:
  primary: "tanstack-solid-smith"
  secondary:
    deployment: "edge-deployer"
    testing: "playwright-vite"

sub_agents:
  - name: "loader-mutator"
    description: "Designs route loaders/mutations with fine-grained caching and optimistic UI."
    focus: ["routeContext", "invalidate", "prefetch", "suspense-boundaries"]
    model: "opus"
  - name: "access-control"
    description: "Route guards, protected layouts, and cookie-based sessions."
    focus: ["beforeLoad", "auth-redirects", "rbac"]
    model: "sonnet"

scripts:
  setup: |
    #!/usr/bin/env bash
    pnpm create @tanstack/start@latest app
    cd app
    pnpm add @tanstack/solid-router @tanstack/solid-start drizzle-orm zod lucia @neondatabase/serverless @vercel/kv
    pnpm add -D tailwindcss postcss autoprefixer @playwright/test vite-tsconfig-paths
    pnpm dlx tailwindcss init -p
  dev: |
    #!/usr/bin/env bash
    pnpm dev
  deploy: |
    #!/usr/bin/env bash
    pnpm build && vercel --prod

acceptance:
  performance:
    fcp_ms_p50: 45
    tti_ms_p50: 65
    js_budget_shell_kb_gzip: 60
    route_chunk_kb_gzip_max: 25
  ux_flows:
    - name: "Nested routes + data"
      steps:
        - "Parent layout streams skeleton"
        - "Child route loader hydrates list"
        - "Detail panel mutation updates cache optimistically"
    - name: "Prefetch & guard"
      steps:
        - "Hover link → prefetch loader"
        - "Unauthed user hits protected route → redirected to login"
    - name: "Offline mutation queue"
      steps:
        - "Create item while offline → queued"
        - "Reconnect → background sync → UI reconciles"
```

## Key Features

### Core Functionality
- ✅ **File-based Routing** - Automatic route generation with TypeScript support
- ✅ **Advanced Data Loading** - Route loaders with caching and invalidation
- ✅ **Optimistic Mutations** - Instant UI updates with background synchronization
- ✅ **Nested Layouts** - Complex UI hierarchies with independent data loading
- ✅ **Route Guards** - Authentication and authorization at the router level
- ✅ **Server Functions** - Isomorphic code that runs on both client and server

### Router-Centric Architecture
- **Data-Driven Routes** - Routes defined by their data requirements
- **Automatic Prefetching** - Smart data preloading based on user behavior
- **Suspense Boundaries** - Granular loading states and error handling
- **Type-Safe Navigation** - Full TypeScript support for routing and data

## Architecture Highlights

### File-based Route Structure
```
src/routes/
├── __root.tsx                    # Root layout
├── index.tsx                     # Home page
├── login.tsx                     # Authentication
├── dashboard/
│   ├── index.tsx                # Dashboard overview
│   ├── projects/
│   │   ├── index.tsx            # Projects list
│   │   ├── $projectId.tsx       # Project details
│   │   └── $projectId/
│   │       ├── settings.tsx     # Project settings
│   │       └── team.tsx         # Project team
│   └── analytics.tsx            # Analytics page
├── api/
│   ├── projects.server.ts       # Server functions
│   └── auth.server.ts           # Auth functions
└── __components/
    ├── layout.tsx               # Layout component
    ├── error.tsx                # Error boundary
    └── not-found.tsx            # 404 page
```

### Route Loaders with Data Dependencies
```typescript
// src/routes/dashboard/projects/$projectId.tsx
import { createFileRoute, useNavigate } from '@tanstack/solid-router';
import { createQuery, useQueryClient } from '@tanstack/solid-query';
import { Show, Suspense } from 'solid-js';
import { getProject, getProjectMembers, updateProject } from '~/api/projects.server';

export const Route = createFileRoute('/dashboard/projects/$projectId')({
  // Route-level loader
  loader: async ({ params }) => {
    const project = await getProject(params.projectId);
    if (!project) {
      throw new Error('Project not found');
    }
    return { project };
  },

  // Component for this route
  component: ProjectDetail,
  // Nested routes
  childRoutes: [
    createFileRoute('/dashboard/projects/$projectId/settings')(),
    createFileRoute('/dashboard/projects/$projectId/team')(),
  ],
});

function ProjectDetail() {
  const params = Route.useParams();
  const navigate = useNavigate();
  const queryClient = useQueryClient();

  // Create queries with automatic cache management
  const projectQuery = createQuery(() => ({
    queryKey: ['project', params.projectId],
    queryFn: () => getProject(params.projectId),
    initialData: Route.useLoaderData().project,
  }));

  const membersQuery = createQuery(() => ({
    queryKey: ['project-members', params.projectId],
    queryFn: () => getProjectMembers(params.projectId),
    enabled: !!projectQuery.data,
  }));

  // Optimistic mutation
  const updateProjectMutation = createMutation({
    mutationFn: updateProject,
    onMutate: async (newProject) => {
      // Cancel any outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['project', params.projectId] });

      // Snapshot the previous value
      const previousProject = queryClient.getQueryData(['project', params.projectId]);

      // Optimistically update to the new value
      queryClient.setQueryData(['project', params.projectId], newProject);

      // Return a context object with the snapshotted value
      return { previousProject };
    },
    onError: (err, newProject, context) => {
      // If the mutation fails, use the context returned from onMutate to roll back
      if (context?.previousProject) {
        queryClient.setQueryData(['project', params.projectId], context.previousProject);
      }
    },
    onSettled: () => {
      // Always refetch after error or success
      queryClient.invalidateQueries({ queryKey: ['project', params.projectId] });
    },
  });

  return (
    <div class="project-detail">
      <Suspense fallback={<div class="animate-pulse">Loading project...</div>}>
        <Show when={projectQuery.data} fallback={<div>Project not found</div>}>
          {(project) => (
            <div class="space-y-6">
              {/* Project header */}
              <div class="flex justify-between items-start">
                <div>
                  <h1 class="text-2xl font-bold">{project().name}</h1>
                  <p class="text-gray-600">{project().description}</p>
                </div>

                <div class="flex space-x-2">
                  <button
                    onClick={() => navigate({ to: '/dashboard/projects/$projectId/settings', params })}
                    class="px-4 py-2 border rounded-lg hover:bg-gray-50"
                  >
                    Settings
                  </button>
                  <button
                    onClick={() => updateProjectMutation.mutate({
                      ...project(),
                      status: project().status === 'active' ? 'inactive' : 'active'
                    })}
                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50"
                    disabled={updateProjectMutation.isLoading}
                  >
                    {updateProjectMutation.isLoading ? 'Updating...' :
                     project().status === 'active' ? 'Archive' : 'Activate'}
                  </button>
                </div>
              </div>

              {/* Project content with nested routes */}
              <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div class="lg:col-span-2">
                  <div class="bg-white rounded-lg shadow p-6">
                    <h2 class="text-lg font-semibold mb-4">Project Overview</h2>
                    <div class="space-y-4">
                      <div>
                        <label class="block text-sm font-medium text-gray-700">Status</label>
                        <span class={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          project().status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                        }`}>
                          {project().status}
                        </span>
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-gray-700">Created</label>
                        <p>{new Date(project().createdAt).toLocaleDateString()}</p>
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-gray-700">Last Updated</label>
                        <p>{new Date(project().updatedAt).toLocaleDateString()}</p>
                      </div>
                    </div>
                  </div>

                  {/* Outlet for nested routes */}
                  <div class="mt-6">
                    <Route.Outlet />
                  </div>
                </div>

                {/* Team members sidebar */}
                <div class="bg-white rounded-lg shadow p-6">
                  <h3 class="text-lg font-semibold mb-4">Team Members</h3>
                  <Suspense fallback={<div class="animate-pulse">Loading team...</div>}>
                    <Show when={membersQuery.data}>
                      {(members) => (
                        <div class="space-y-3">
                          <For each={members()}>
                            {(member) => (
                              <div class="flex items-center space-x-3">
                                <img
                                  src={member.avatar}
                                  alt={member.name}
                                  class="w-8 h-8 rounded-full"
                                />
                                <div>
                                  <div class="font-medium">{member.name}</div>
                                  <div class="text-sm text-gray-500">{member.role}</div>
                                </div>
                              </div>
                            )}
                          </For>
                        </div>
                      )}
                    </Show>
                  </Suspense>
                </div>
              </div>
            </div>
          )}
        </Show>
      </Suspense>
    </div>
  );
}
```

### Route Guards and Authentication
```typescript
// src/routes/__root.tsx
import { createFileRoute, redirect, useRouterState } from '@tanstack/solid-router';
import { Layout } from '~/__components/layout';
import { getAuth } from '~/api/auth.server';

export const Route = createFileRoute('/')({
  component: Layout,
  beforeLoad: async ({ context }) => {
    // Check authentication on all routes
    const auth = await getAuth();

    if (!auth?.user) {
      // Redirect to login if not authenticated
      throw redirect({
        to: '/login',
        search: { redirect: location.pathname }
      });
    }

    // Store auth in context for child routes
    return {
      auth,
      invalidateAuth: () => {
        // Function to invalidate auth cache
        context.queryClient.invalidateQueries(['auth']);
      }
    };
  },
  errorComponent: ({ error }) => (
    <div class="min-h-screen flex items-center justify-center">
      <div class="text-center">
        <h2 class="text-2xl font-bold text-red-600 mb-2">Something went wrong</h2>
        <p class="text-gray-600 mb-4">{error.message}</p>
        <button
          onClick={() => window.location.reload()}
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
        >
          Try again
        </button>
      </div>
    </div>
  ),
  notFoundComponent: () => (
    <div class="min-h-screen flex items-center justify-center">
      <div class="text-center">
        <h2 class="text-2xl font-bold text-gray-600 mb-2">Page not found</h2>
        <p class="text-gray-600 mb-4">The page you're looking for doesn't exist.</p>
        <a href="/" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          Go home
        </a>
      </div>
    </div>
  ),
});

// src/routes/login.tsx
import { createFileRoute, redirect, useNavigate } from '@tanstack/solid-router';
import { createMutation } from '@tanstack/solid-query';
import { login } from '~/api/auth.server';

export const Route = createFileRoute('/login')({
  component: Login,
  beforeLoad: async ({ context }) => {
    // Redirect to dashboard if already authenticated
    const auth = await getAuth();
    if (auth?.user) {
      throw redirect({ to: '/dashboard' });
    }
  },
});

function Login() {
  const navigate = useNavigate();

  const loginMutation = createMutation({
    mutationFn: login,
    onSuccess: (data) => {
      // Redirect to intended destination or dashboard
      const redirectTo = new URLSearchParams(location.search).get('redirect') || '/dashboard';
      navigate({ to: redirectTo });
    },
  });

  const handleSubmit = (e: Event) => {
    e.preventDefault();
    const formData = new FormData(e.target as HTMLFormElement);
    loginMutation.mutate({
      email: formData.get('email') as string,
      password: formData.get('password') as string,
    });
  };

  return (
    <div class="min-h-screen flex items-center justify-center bg-gray-50">
      <div class="max-w-md w-full space-y-8">
        <div>
          <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Sign in to your account
          </h2>
        </div>
        <form class="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div class="space-y-4">
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700">
                Email address
              </label>
              <input
                id="email"
                name="email"
                type="email"
                required
                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label for="password" class="block text-sm font-medium text-gray-700">
                Password
              </label>
              <input
                id="password"
                name="password"
                type="password"
                required
                class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
          </div>

          {loginMutation.error && (
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
              {loginMutation.error.message}
            </div>
          )}

          <button
            type="submit"
            disabled={loginMutation.isLoading}
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50"
          >
            {loginMutation.isLoading ? 'Signing in...' : 'Sign in'}
          </button>
        </form>
      </div>
    </div>
  );
}
```

### Server Functions (Isomorphic Code)
```typescript
// src/routes/api/projects.server.ts
import { createServerFn } from '@tanstack/solid-start';
import { z } from 'zod';
import { db } from '~/db';
import { projects, projectMembers } from '~/db/schema';
import { eq } from 'drizzle-orm';

// Define schemas for validation
const CreateProjectSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().max(500).optional(),
  status: z.enum(['active', 'inactive', 'archived']).default('active'),
});

const UpdateProjectSchema = CreateProjectSchema.partial();

// Server function for creating projects
export const createProject = createServerFn()
  .validator(CreateProjectSchema)
  .handler(async ({ data }) => {
    // This function can run on both client and server
    if (typeof window !== 'undefined') {
      // Client-side: optimistic update or local state
      console.log('Creating project on client:', data);
    }

    // Server-side: database operation
    const [project] = await db.insert(projects)
      .values({
        ...data,
        createdAt: new Date(),
        updatedAt: new Date(),
      })
      .returning();

    return project;
  });

// Server function for updating projects
export const updateProject = createServerFn()
  .validator(UpdateProjectSchema.extend({
    id: z.string(),
  }))
  .handler(async ({ data }) => {
    const { id, ...updateData } = data;

    const [project] = await db.update(projects)
      .set({
        ...updateData,
        updatedAt: new Date(),
      })
      .where(eq(projects.id, id))
      .returning();

    if (!project) {
      throw new Error('Project not found');
    }

    return project;
  });

// Server function for fetching project details
export const getProject = createServerFn()
  .validator(z.object({ id: z.string() }))
  .handler(async ({ data }) => {
    const project = await db.query.projects.findFirst({
      where: eq(projects.id, data.id),
      with: {
        members: {
          with: {
            user: true,
          },
        },
      },
    });

    return project;
  });

// Server function for fetching project members
export const getProjectMembers = createServerFn()
  .validator(z.object({ projectId: z.string() }))
  .handler(async ({ data }) => {
    const members = await db.query.projectMembers.findMany({
      where: eq(projectMembers.projectId, data.projectId),
      with: {
        user: true,
      },
    });

    return members.map(member => ({
      id: member.user.id,
      name: member.user.name,
      email: member.user.email,
      avatar: member.user.avatar,
      role: member.role,
    }));
  });
```

### Advanced Prefetching and Caching
```typescript
// src/components/ProjectCard.tsx
import { createMemo, createSignal } from 'solid-js';
import { useQuery, useQueryClient } from '@tanstack/solid-query';
import { Link } from '@tanstack/solid-router';

interface ProjectCardProps {
  project: {
    id: string;
    name: string;
    description: string;
    status: string;
    updatedAt: string;
  };
}

export function ProjectCard(props: ProjectCardProps) {
  const [isHovered, setIsHovered] = createSignal(false);
  const queryClient = useQueryClient();

  // Prefetch project details on hover
  const prefetchProject = () => {
    queryClient.prefetchQuery({
      queryKey: ['project', props.project.id],
      queryFn: () => getProject({ id: props.project.id }),
      staleTime: 5 * 60 * 1000, // 5 minutes
    });
  };

  // Memoized computed values
  const statusColor = createMemo(() => {
    switch (props.project.status) {
      case 'active': return 'bg-green-100 text-green-800';
      case 'inactive': return 'bg-gray-100 text-gray-800';
      case 'archived': return 'bg-red-100 text-red-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  });

  const lastUpdated = createMemo(() => {
    return new Date(props.project.updatedAt).toLocaleDateString();
  });

  return (
    <div
      class="bg-white rounded-lg shadow hover:shadow-lg transition-shadow p-6"
      onMouseEnter={() => {
        setIsHovered(true);
        prefetchProject();
      }}
      onMouseLeave={() => setIsHovered(false)}
    >
      <div class="flex justify-between items-start mb-3">
        <h3 class="text-lg font-semibold text-gray-900">{props.project.name}</h3>
        <span class={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${statusColor()}`}>
          {props.project.status}
        </span>
      </div>

      <p class="text-gray-600 mb-4 line-clamp-2">{props.project.description}</p>

      <div class="flex justify-between items-center">
        <span class="text-sm text-gray-500">Updated {lastUpdated()}</span>

        <Link
          to="/dashboard/projects/$projectId"
          params={{ projectId: props.project.id }}
          class="inline-flex items-center px-3 py-1 text-sm font-medium text-blue-600 hover:text-blue-800 transition-colors"
        >
          View
          <svg class="ml-1 w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"/>
          </svg>
        </Link>
      </div>

      {/* Loading indicator for prefetch */}
      <Show when={isHovered()}>
        <div class="mt-3 pt-3 border-t">
          <div class="flex items-center text-sm text-gray-500">
            <div class="animate-spin w-3 h-3 border-2 border-blue-500 border-t-transparent rounded-full mr-2"></div>
            Loading preview...
          </div>
        </div>
      </Show>
    </div>
  );
}
```

## Development Workflow

### 1. Project Setup
```bash
# Create TanStack Start project
pnpm create @tanstack/start@latest router-app
cd router-app

# Install additional dependencies
pnpm add @tanstack/solid-router @tanstack/solid-start drizzle-orm zod lucia @neondatabase/serverless @vercel/kv
pnpm add -D tailwindcss postcss autoprefixer @playwright/test vite-tsconfig-paths

# Initialize Tailwind
pnpm dlx tailwindcss init -p
```

### 2. Database Schema with Drizzle
```typescript
// src/db/schema.ts
import { pgTable, text, timestamp, boolean, uuid, jsonb } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  avatar: text('avatar'),
  emailVerified: boolean('email_verified').default(false),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const projects = pgTable('projects', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: text('name').notNull(),
  description: text('description'),
  status: text('status').notNull().default('active'),
  ownerId: uuid('owner_id').references(() => users.id),
  metadata: jsonb('metadata'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const projectMembers = pgTable('project_members', {
  id: uuid('id').defaultRandom().primaryKey(),
  projectId: uuid('project_id').references(() => projects.id),
  userId: uuid('user_id').references(() => users.id),
  role: text('role').notNull(), // owner, admin, member, viewer
  joinedAt: timestamp('joined_at').defaultNow(),
});
```

## Performance Optimization

### Route-based Code Splitting
```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import solid from 'vite-plugin-solid';
import solidRouter from 'vite-plugin-solid-router';

export default defineConfig({
  plugins: [
    solid(),
    solidRouter(),
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['@tanstack/solid-router', '@tanstack/solid-query'],
          db: ['drizzle-orm', '@neondatabase/serverless'],
          ui: ['tailwindcss'],
        }
      }
    }
  },
  optimizeDeps: {
    include: ['@tanstack/solid-router', '@tanstack/solid-query'],
  }
});
```

### Query Client Configuration
```typescript
// src/lib/query-client.ts
import { QueryClient } from '@tanstack/solid-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
      retry: (failureCount, error) => {
        // Don't retry on 4xx errors
        if (error && typeof error === 'object' && 'status' in error) {
          const status = error.status as number;
          return status >= 500 && failureCount < 3;
        }
        return failureCount < 3;
      },
      refetchOnWindowFocus: false,
      refetchOnReconnect: true,
    },
    mutations: {
      retry: 1,
    },
  },
});
```

## Security Considerations

- **Authentication** with Lucia and secure session management
- **Route Guards** with proper authorization checks
- **Input Validation** using Zod schemas for all server functions
- **CSRF Protection** on state-changing operations
- **Rate Limiting** on API endpoints
- **Type Safety** throughout the stack to prevent runtime errors

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm package manager
- PostgreSQL database (Neon recommended)
- Redis cache (Vercel KV recommended)

### Quick Start
```bash
# Clone and set up
git clone <repository-url>
cd router-app-tanstack-solid
pnpm install

# Configure environment
cp .env.example .env.local
# Set up database and auth providers

# Initialize database
pnpm run db:push
pnpm run db:seed

# Start development
pnpm dev
```

### Environment Variables
```env
# Database
DATABASE_URL=postgresql://...

# Auth
AUTH_SECRET=your-secret-key
AUTH_ORIGIN=http://localhost:3000

# Redis
REDIS_URL=redis://...

# Deployment
VERCEL_URL=your-app.vercel.app
```

## Related Examples

- [Kanban SolidStart →]({{ 'examples/kanban-solidstart/' | relative_url }}) - SolidJS patterns
- [SaaS Starter →]({{ 'examples/saas-starter-sveltekit/' | relative_url }}) - Database and auth patterns
- [Enterprise Admin →]({{ 'examples/enterprise-admin-nuxt/' | relative_url }}) - Advanced data management patterns