---
layout: example
title: "Kanban for Teams (SolidStart)"
description: "Real-time collaborative Kanban board with tiny bundles and fine-grained reactivity"
outcome_type: "web-app"
stack:
  meta_framework: "@solidjs/start@1"
  ui_library: "SolidJS@1.9"
  styling: "TailwindCSS@4 + DaisyUI@4"
  database: "Turso (libSQL) + Drizzle ORM"
  auth: "Lucia"
  realtime: "Ably"
  deployment: "Cloudflare Pages + Workers"
  package_manager: "pnpm@9"
complexity: "intermediate"
---

# Kanban for Teams (SolidStart)

A real-time collaborative Kanban board that showcases SolidJS's fine-grained reactivity and excellent performance characteristics. Built with edge-first architecture for global team collaboration with minimal JavaScript bundles.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "kanban-solidstart"
name: "Kanban for Teams (SolidStart)"
description: "Real-time Kanban with tiny bundles; JSX ergonomics sans React tax."
outcome_type: "web-app"

technology_stack:
  meta_framework: "@solidjs/start@1"
  ui_library: "SolidJS@1.9"
  styling: "TailwindCSS@4 + DaisyUI@4"
  database: "Turso (libSQL) + Drizzle ORM"
  auth: "Lucia"
  realtime: "Ably (channels)"
  deployment: "Cloudflare Pages + Workers"
  package_manager: "pnpm@9"

agents:
  primary: "solid-crafter"
  secondary:
    deployment: "cf-workerizer"
    testing: "playwright-guru"

sub_agents:
  - name: "drag-drop-specialist"
    description: "Accessible DnD with keyboard parity."
    focus: ["@thisbeyond/solid-dnd", "a11y", "optimistic-updates"]
    model: "sonnet"
  - name: "edge-data-engineer"
    description: "Drizzle schema & edge-safe adapters."
    focus: ["schema", "migrations", "r2-backups"]
    model: "opus"

scripts:
  setup: |
    #!/usr/bin/env bash
    pnpm create solid@latest app --template start
    cd app
    pnpm add @thisbeyond/solid-dnd drizzle-orm @libsql/client zod lucia ably
    pnpm add -D tailwindcss postcss autoprefixer daisyui @playwright/test
    pnpm dlx tailwindcss init -p
  dev: |
    #!/usr/bin/env bash
    pnpm dev
  deploy: |
    #!/usr/bin/env bash
    pnpm run build
    wrangler pages deploy ./dist --project-name kanban-solidstart

acceptance:
  performance:
    fcp_ms_p50: 40
    tti_ms_p50: 60
    js_budget_home_kb_gzip: 45
  ux_flows:
    - name: "Board CRUD"
      steps:
        - "Create board"
        - "Add lists/cards"
        - "Drag reorder; offline optimistic"
    - name: "Collaboration"
      steps:
        - "Invite teammate"
        - "See live presence & cursor ghosts"
    - name: "Mobile-first gestures"
      steps:
        - "Press/hold to drag"
        - "Swipe to complete"
```

## Key Features

### Core Functionality
- ✅ **Real-time Collaboration** - Live presence cursors and instant updates
- ✅ **Drag & Drop** - Smooth card movement with optimistic updates
- ✅ **Board Management** - Create, edit, and organize multiple boards
- ✅ **Team Collaboration** - Invite members and assign cards to people
- ✅ **Keyboard Navigation** - Full accessibility support for power users
- ✅ **Mobile Gestures** - Touch-optimized interface with swipe actions

### Performance Characteristics
- **Tiny Bundles** - 45KB gzip budget for home route
- **Fast FCP** - Sub-40ms first contentful paint on median
- **SolidJS Reactivity** - Fine-grained updates without virtual DOM overhead
- **Edge Deployment** - Global distribution via Cloudflare Pages
- **Optimistic UI** - Instant feedback with background sync

## Architecture Highlights

### SolidJS Reactive Patterns
```typescript
// Fine-grained reactivity with createSignal
const [cards, setCards] = createSignal<Card[]>([]);
const [draggedCard, setDraggedCard] = createSignal<Card | null>(null);

// Efficient computed values with createMemo
const cardsByList = createMemo(() => {
  const cardsList = cards();
  return lists().reduce((acc, list) => {
    acc[list.id] = cardsList.filter(card => card.listId === list.id);
    return acc;
  }, {} as Record<string, Card[]>);
});

// Efficient effects for real-time updates
createEffect(() => {
  const channel = ably.channels.get(`board-${boardId()}`);
  channel.subscribe('card-moved', handleCardMove);

  return () => channel.unsubscribe();
});
```

### Drag & Drop Implementation
```typescript
import { DragDropProvider, DragDropSensors, Draggable, Droppable } from '@thisbeyond/solid-dnd';

function KanbanBoard() {
  const [draggedCard, setDraggedCard] = createSignal<Card | null>(null);

  return (
    <DragDropProvider onDragEnd={handleDragEnd}>
      <DragDropSensors />
      <div class="kanban-board">
        <For each={lists()}>
          {list => (
            <Droppable id={list.id} onDrop={handleCardDrop}>
              <DroppableDragOverlay>
                <KanbanList list={list} />
              </DroppableDragOverlay>
            </Droppable>
          )}
        </For>
      </div>
    </DragDropProvider>
  );
}
```

### Real-time Integration
```typescript
// Ably real-time channel management
class RealtimeService {
  private client: ably.Realtime;

  constructor() {
    this.client = new ably.Realtime(process.env.ABLY_API_KEY);
  }

  subscribeToBoard(boardId: string, callbacks: {
    onCardMove: (move: CardMove) => void;
    onPresenceUpdate: (users: PresenceUser[]) => void;
  }) {
    const channel = this.client.channels.get(`board-${boardId}`);

    // Card movement events
    channel.subscribe('card-moved', callbacks.onCardMove);

    // Presence for live cursors
    channel.presence.subscribe('enter', callbacks.onPresenceUpdate);
    channel.presence.subscribe('leave', callbacks.onPresenceUpdate);

    // Enter presence
    channel.presence.enter('active');
  }

  broadcastCardMove(boardId: string, move: CardMove) {
    const channel = this.client.channels.get(`board-${boardId}`);
    channel.publish('card-moved', move);
  }
}
```

## Development Workflow

### 1. Project Setup
```bash
# Create SolidStart project
pnpm create solid@latest kanban-app --template start
cd kanban-app

# Install dependencies
pnpm add @thisbeyond/solid-dnd drizzle-orm @libsql/client zod lucia ably
pnpm add -D tailwindcss postcss autoprefixer daisyui @playwright/test

# Initialize Tailwind
pnpm dlx tailwindcss init -p
```

### 2. Database Schema with Drizzle
```typescript
// src/db/schema.ts
import { sqliteTable, text, integer, real } from 'drizzle-orm/sqlite-core';

export const boards = sqliteTable('boards', {
  id: text('id').primaryKey(),
  title: text('title').notNull(),
  ownerId: text('owner_id').notNull(),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull(),
});

export const lists = sqliteTable('lists', {
  id: text('id').primaryKey(),
  title: text('title').notNull(),
  boardId: text('board_id').notNull().references(() => boards.id),
  position: integer('position').notNull(),
});

export const cards = sqliteTable('cards', {
  id: text('id').primaryKey(),
  title: text('title').notNull(),
  description: text('description'),
  listId: text('list_id').notNull().references(() => lists.id),
  position: real('position').notNull(),
  assigneeId: text('assignee_id'),
  dueDate: integer('due_date', { mode: 'timestamp' }),
});
```

### 3. API Routes with SolidStart
```typescript
// src/routes/api/boards/[boardId]/cards/[cardId].ts
import { json } from 'solid-start/api';
import { getServerSession } from 'solid-start/auth';
import { db } from '~/db';
import { cards } from '~/db/schema';

export async function PUT(request: Request, { params }: { params: { boardId: string, cardId: string } }) {
  const session = await getServerSession(request);
  if (!session) return json({ error: 'Unauthorized' }, { status: 401 });

  const body = await request.json();
  const { listId, position } = body;

  await db.update(cards)
    .set({ listId, position })
    .where(eq(cards.id, params.cardId));

  return json({ success: true });
}
```

## Performance Optimization

### Bundle Analysis
```javascript
// vite.config.ts
import { defineConfig } from 'vite';
import solid from 'solid-start';

export default defineConfig({
  plugins: [solid()],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['@solidjs/router', '@solidjs/meta'],
          dnd: ['@thisbeyond/solid-dnd'],
          realtime: ['ably'],
        }
      }
    }
  },
  server: {
    prerender: false // Enable for static pages
  }
});
```

### Code Splitting Strategy
```typescript
// Lazy load heavy components
const KanbanBoard = lazy(() => import('~/components/KanbanBoard'));
const BoardSettings = lazy(() => import('~/components/BoardSettings'));

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" component={KanbanBoard} />
        <Route path="/settings" component={BoardSettings} />
      </Routes>
    </Router>
  );
}
```

## Accessibility Implementation

### Keyboard Navigation
```typescript
// Accessible drag and drop with keyboard support
function AccessibleCard(props: CardProps) {
  const [isDragging, setIsDragging] = createSignal(false);
  const cardRef = useRef<HTMLDivElement>();

  const handleKeyDown = (e: KeyboardEvent) => {
    switch (e.key) {
      case ' ':
      case 'Enter':
        e.preventDefault();
        startKeyboardDrag();
        break;
      case 'Escape':
        cancelDrag();
        break;
    }
  };

  return (
    <div
      ref={cardRef}
      role="button"
      tabIndex={0}
      onKeyDown={handleKeyDown}
      aria-describedby={`card-${props.id}-description`}
      class="kanban-card"
    >
      <h3>{props.title}</h3>
      <p id={`card-${props.id}-description`}>{props.description}</p>
    </div>
  );
}
```

### Screen Reader Support
```typescript
// Live regions for dynamic content updates
function LiveAnnouncements() {
  const [announcement, setAnnouncement] = createSignal('');

  createEffect(() => {
    // Clear announcement after it's read
    const timer = setTimeout(() => setAnnouncement(''), 1000);
    return () => clearTimeout(timer);
  });

  return (
    <div
      role="status"
      aria-live="polite"
      aria-atomic="true"
      class="sr-only"
    >
      {announcement()}
    </div>
  );
}
```

## Deployment on Cloudflare Pages

### Build Configuration
```toml
# wrangler.toml
name = "kanban-solidstart"
compatibility_date = "2023-10-01"

[[kv_namespaces]]
binding = "KV_CACHE"
id = "your-kv-namespace-id"

[vars]
NODE_ENV = "production"
TURSO_DATABASE_URL = "libsql://your-db-url"
```

### Environment Variables
```env
# .env.production
TURSO_DATABASE_URL=libsql://your-db.turso.io
TURSO_AUTH_TOKEN=your-auth-token
ABLY_API_KEY=your-ably-api-key
LUCIA_AUTH_SECRET=your-secret-key
```

## Testing Strategy

### End-to-End Tests with Playwright
```typescript
// tests/kanban.spec.ts
import { test, expect } from '@playwright/test';

test('drag and drop cards', async ({ page }) => {
  await page.goto('/');

  const sourceCard = page.locator('[data-testid="card-1"]');
  const targetList = page.locator('[data-testid="list-2"]');

  await sourceCard.dragTo(targetList);

  // Verify card moved
  await expect(sourceCard).toBeIn(targetList);
});

test('real-time collaboration', async ({ page, context }) => {
  // Create two browser contexts for two users
  const user2 = await context.newPage();

  await page.goto('/');
  await user2.goto('/');

  // User 1 moves card
  const card = page.locator('[data-testid="card-1"]');
  await card.dragTo(page.locator('[data-testid="list-2"]'));

  // User 2 should see the change
  await expect(user2.locator('[data-testid="card-1"]')).toBeIn(
    user2.locator('[data-testid="list-2"]')
  );
});
```

## Security Considerations

- **Authentication** with Lucia and secure session management
- **Authorization** checks for board access permissions
- **Input Validation** using Zod schemas for all API endpoints
- **CSRF Protection** on state-changing operations
- **Rate Limiting** to prevent abuse
- **CORS Configuration** for API security

## Monitoring & Analytics

- **Performance Metrics** - Core Web Vitals and bundle size monitoring
- **Error Tracking** with integrated error reporting
- **User Analytics** for feature usage and collaboration patterns
- **Real-time Metrics** - Connection health and latency monitoring
- **Database Performance** with Turso's built-in analytics

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm package manager
- Turso database account
- Ably real-time service
- Cloudflare account for deployment

### Quick Start
```bash
# Clone and install
git clone <repository-url>
cd kanban-solidstart
pnpm install

# Set up environment
cp .env.example .env.local
# Configure database and real-time services

# Initialize database
pnpm run db:push

# Start development
pnpm dev
```

## Related Examples

- [Collab Whiteboard →]({{ 'examples/collab-whiteboard-qwik/' | relative_url }}) - Another real-time collaboration example
- [Field CRM →]({{ 'examples/field-crm-marko/' | relative_url }}) - Mobile-first patterns
- [Enterprise Admin →]({{ 'examples/enterprise-admin-nuxt/' | relative_url }}) - Board management patterns