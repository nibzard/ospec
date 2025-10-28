---
layout: example
title: "Realtime Whiteboard (Qwik City)"
description: "Large interactive whiteboard with instant TTI via resumability and real-time collaboration"
outcome_type: "web-app"
stack:
  meta_framework: "Qwik City@1.16"
  ui_library: "Qwik"
  styling: "TailwindCSS@4"
  graphics: "Konva + RoughJS"
  database: "PlanetScale MySQL + Redis"
  auth: "Auth.js (Qwik adapter)"
  realtime: "Liveblocks"
  deployment: "Cloudflare Pages + D1"
  package_manager: "pnpm@9"
complexity: "advanced"
---

# Realtime Whiteboard (Qwik City)

A sophisticated collaborative whiteboard application that demonstrates Qwik's revolutionary resumability paradigm. Features instant time-to-interactive performance, real-time collaboration, and complex interactive features without the typical hydration overhead.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "collab-whiteboard-qwik"
name: "Realtime Whiteboard (Qwik City)"
description: "Large interactive app with instant TTI via resumability; heavy client features without hydration cost."
outcome_type: "web-app"

technology_stack:
  meta_framework: "Qwik City@1.16"
  ui_library: "Qwik"
  styling: "TailwindCSS@4"
  graphics: "Konva (canvas) + RoughJS (sketch)"
  database: "PlanetScale MySQL (server) + Redis (presence)"
  auth: "Auth.js (Qwik adapter)"
  realtime: "Liveblocks"
  deployment: "Cloudflare Pages + D1 for presence cache"
  package_manager: "pnpm@9"

agents:
  primary: "qwik-maestro"
  secondary:
    deployment: "cf-edge-orchestrator"
    testing: "whitebox-e2e"

sub_agents:
  - name: "latency-minimizer"
    description: "Splits code at interaction boundaries; ensures qrl correctness."
    focus: ["lazy-handlers", "prefetch-strategies", "islands"]
    model: "opus"
  - name: "collab-engineer"
    description: "Cursors, locking, CRDT conflict resolution."
    focus: ["liveblocks", "undo/redo", "snapshotting"]
    model: "sonnet"

scripts:
  setup: |
    #!/usr/bin/env bash
    pnpm create qwik@latest app --starter qwik-city
    cd app
    pnpm add konva roughjs @liveblocks/client @liveblocks/qwik @auth/core zod
    pnpm add -D tailwindcss postcss autoprefixer @playwright/test
    pnpm dlx tailwindcss init -p
  dev: |
    #!/usr/bin/env bash
    pnpm dev
  deploy: |
    #!/usr/bin/env bash
    pnpm build && wrangler pages deploy dist

acceptance:
  performance:
    fcp_ms_p50: 60
    tti_ms_p50: 80
    interaction_latency_ms_p95: 120
  ux_flows:
    - name: "Multi-user board"
      steps:
        - "Create shapes/sticky notes"
        - "See live cursors/avatars"
        - "Conflict-free edits; undo/redo"
    - name: "Share link permissions"
      steps:
        - "Viewer/editor roles"
        - "Session handoff on mobile"
```

## Key Features

### Core Functionality
- ✅ **Real-time Collaboration** - Live cursors, selections, and simultaneous editing
- ✅ **Drawing Tools** - Shapes, freehand drawing, text, and sticky notes
- ✅ **Canvas Manipulation** - Pan, zoom, and infinite canvas capabilities
- ✅ **Undo/Redo System** - Comprehensive history with conflict resolution
- ✅ **Access Control** - View/edit permissions with secure sharing
- ✅ **Export Options** - PNG, SVG, and JSON export capabilities

### Qwik Performance Advantages
- **Instant TTI** - 80ms median time-to-interactive without hydration
- **Resumable Architecture** - Pauses and resumes execution at interaction boundaries
- **Fine-grained Lazy Loading** - Only downloads code for specific interactions
- **Edge-optimized** - Global distribution via Cloudflare Pages

## Architecture Highlights

### Qwik Resumability Pattern
```typescript
// src/components/whiteboard/Canvas.tsx
import { component$, useSignal, useVisibleTask$, $, useStore } from '@builder.io/qwik';
import { isBrowser } from '@builder.io/qwik/build';

export const Canvas = component$(() => {
  // Canvas state with Qwik signals
  const canvasRef = useSignal<HTMLCanvasElement>();
  const shapes = useStore<Shape[]>([]);
  const selectedTool = useSignal<Tool>('select');
  const isDrawing = useSignal(false);

  // Resumable canvas initialization
  useVisibleTask$(async ({ track }) => {
    track(() => canvasRef.value);

    if (!isBrowser || !canvasRef.value) return;

    const canvas = canvasRef.value;
    const ctx = canvas.getContext('2d')!;

    // Resumable drawing logic - only loads when needed
    const { initializeCanvas, setupEventListeners } = await import('./canvas-utils');

    initializeCanvas(canvas, ctx);
    setupEventListeners(canvas, {
      shapes,
      selectedTool,
      isDrawing,
      onShapeAdd: handleShapeAdd,
    });
  });

  // Lazy-loaded shape handling
  const handleShapeAdd = $(async (shapeData: ShapeData) => {
    const { addShape } = await import('./shape-manager');
    const newShape = addShape(shapes, shapeData);

    // Broadcast to other users
    await broadcastShapeChange(newShape);
  });

  return (
    <div class="canvas-container">
      <canvas
        ref={canvasRef}
        width={1200}
        height={800}
        class="border border-gray-300"
      />
      <Toolbar selectedTool={selectedTool} />
    </div>
  );
});
```

### Real-time Collaboration with Liveblocks
```typescript
// src/lib/liveblocks/client.ts
import { createClient } from '@liveblocks/client';
import { createLiveblocksContext } from '@liveblocks/react';
import { type LiveList, type LiveMap } from '@liveblocks/client';

const client = createClient({
  publicApiKey: process.env.PUBLIC_LIVEBLOCKS_KEY!,
  authEndpoint: '/api/auth/liveblocks',
});

// Presence for cursors and selections
type Presence = {
  cursor?: { x: number; y: number };
  selection?: string[];
  userId: string;
  user: { name: string; color: string };
};

// Storage for canvas data
type Storage = {
  shapes: LiveList<Shape>;
  metadata: LiveMap<{ lastModified: number; modifiedBy: string }>;
};

export const LiveblocksProvider = component$<{ children: any }>(({ children }) => {
  return (
    <RoomProvider id="whiteboard-room">
      <ClientSideSuspense fallback={<div>Loading...</div>}>
        {children}
      </ClientSideSuspense>
    </RoomProvider>
  );
});
```

### Konva Canvas Integration
```typescript
// src/components/whiteboard/KonvaCanvas.tsx
import { component$, useSignal, useOn, $ } from '@builder.io/qwik';
import Konva from 'konva';

export const KonvaCanvas = component$(() => {
  const containerRef = useSignal<HTMLDivElement>();
  const stageRef = useSignal<Konva.Stage>();

  useOn('qvisible', $(async () => {
    if (!containerRef.value) return;

    // Lazy load Konva only when canvas becomes visible
    const Konva = await import('konva');

    const stage = new Konva.default.Stage({
      container: containerRef.value,
      width: 1200,
      height: 800,
    });

    const layer = new Konva.default.Layer();
    stage.add(layer);

    stageRef.value = stage;

    // Resumable event handling
    stage.on('mousedown tap', handleMouseDown);
    stage.on('mousemove touchmove', handleMouseMove);
    stage.on('mouseup touchend', handleMouseUp);
  }));

  const handleMouseDown = $(async (e: Konva.KonvaEventObject<MouseEvent>) => {
    // Import shape handlers only when needed
    const { createShape } = await import('../shapes/shape-factory');
    const shape = createShape(e.target);

    if (shape) {
      await addShapeToLayer(shape);
    }
  });

  return (
    <div
      ref={containerRef}
      class="konva-container"
      style={{ width: '100%', height: '100%' }}
    />
  );
});
```

### Shape Management System
```typescript
// src/lib/shapes/ShapeManager.ts
export interface Shape {
  id: string;
  type: 'rectangle' | 'circle' | 'line' | 'text' | 'sticky';
  x: number;
  y: number;
  width?: number;
  height?: number;
  radius?: number;
  points?: number[];
  text?: string;
  color: string;
  createdBy: string;
  createdAt: number;
}

export class ShapeManager {
  private shapes: Map<string, Shape> = new Map();
  private history: Shape[][] = [];
  private historyIndex = -1;

  addShape(shape: Shape): void {
    this.shapes.set(shape.id, shape);
    this.saveToHistory();
    this.broadcastShapeChange(shape);
  }

  updateShape(shapeId: string, updates: Partial<Shape>): void {
    const shape = this.shapes.get(shapeId);
    if (shape) {
      Object.assign(shape, updates);
      this.saveToHistory();
      this.broadcastShapeChange(shape);
    }
  }

  deleteShape(shapeId: string): void {
    this.shapes.delete(shapeId);
    this.saveToHistory();
    this.broadcastShapeDelete(shapeId);
  }

  undo(): boolean {
    if (this.historyIndex > 0) {
      this.historyIndex--;
      this.restoreFromHistory();
      return true;
    }
    return false;
  }

  redo(): boolean {
    if (this.historyIndex < this.history.length - 1) {
      this.historyIndex++;
      this.restoreFromHistory();
      return true;
    }
    return false;
  }

  private saveToHistory(): void {
    // Remove any history after current index
    this.history = this.history.slice(0, this.historyIndex + 1);

    // Add current state
    this.history.push(Array.from(this.shapes.values()));
    this.historyIndex++;

    // Limit history size
    if (this.history.length > 50) {
      this.history.shift();
      this.historyIndex--;
    }
  }

  private restoreFromHistory(): void {
    const shapes = this.history[this.historyIndex];
    this.shapes.clear();
    shapes.forEach(shape => this.shapes.set(shape.id, shape));
  }
}
```

## Development Workflow

### 1. Project Setup
```bash
# Create Qwik City project
pnpm create qwik@latest whiteboard-app --starter qwik-city
cd whiteboard-app

# Install dependencies
pnpm add konva roughjs @liveblocks/client @liveblocks/qwik @auth/core zod
pnpm add -D tailwindcss postcss autoprefixer @playwright/test

# Initialize Tailwind
pnpm dlx tailwindcss init -p
```

### 2. Liveblocks Integration
```typescript
// src/routes/api/auth/liveblocks/index.ts
import type { RequestHandler } from '@builder.io/qwik-city';
import { getAuth } from '@auth/qwik';
import { LIVEBLOCKS_SECRET_KEY } from '../../../env.server';

export const onGet: RequestHandler = async ({ request, sharedMap }) => {
  const session = await getAuth(request);

  if (!session?.user) {
    throw new Error('Unauthorized');
  }

  const response = await fetch('https://api.liveblocks.io/v2/rooms', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${LIVEBLOCKS_SECRET_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      id: `whiteboard-${session.user.id}`,
      defaultAccesses: [],
      usersAccesses: [
        {
          userId: session.user.id,
          allow: true,
        },
      ],
    }),
  });

  const { room } = await response.json();

  return {
    token: room.token,
    roomId: room.id,
  };
};
```

### 3. Canvas Tools Implementation
```typescript
// src/components/whiteboard/Toolbar.tsx
import { component$, $, useSignal } from '@builder.io/qwik';

interface ToolbarProps {
  selectedTool: Signal<string>;
}

export const Toolbar = component$<ToolbarProps>(({ selectedTool }) => {
  const tools = [
    { id: 'select', icon: '↖', label: 'Select' },
    { id: 'rectangle', icon: '▢', label: 'Rectangle' },
    { id: 'circle', icon: '○', label: 'Circle' },
    { id: 'line', icon: '╱', label: 'Line' },
    { id: 'text', icon: 'T', label: 'Text' },
    { id: 'sticky', icon: '📝', label: 'Sticky Note' },
  ];

  const colors = ['#000000', '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF'];

  return (
    <div class="toolbar bg-white border border-gray-300 rounded-lg p-2 shadow-lg">
      <div class="flex flex-col space-y-2">
        {/* Tools */}
        <div class="flex flex-col space-y-1">
          {tools.map(tool => (
            <button
              key={tool.id}
              onClick$={() => selectedTool.value = tool.id}
              class={`p-2 rounded hover:bg-gray-100 ${
                selectedTool.value === tool.id ? 'bg-blue-100 text-blue-600' : ''
              }`}
              title={tool.label}
            >
              <span class="text-xl">{tool.icon}</span>
            </button>
          ))}
        </div>

        {/* Color Picker */}
        <div class="border-t pt-2">
          <div class="text-xs font-semibold mb-2">Colors</div>
          <div class="grid grid-cols-2 gap-1">
            {colors.map(color => (
              <button
                key={color}
                onClick$={() => selectedColor.value = color}
                class="w-6 h-6 rounded border-2 border-gray-300"
                style={{ backgroundColor: color }}
              />
            ))}
          </div>
        </div>

        {/* Actions */}
        <div class="border-t pt-2 space-y-1">
          <button
            onClick$={handleUndo}
            class="p-2 rounded hover:bg-gray-100 text-sm"
          >
            ↶ Undo
          </button>
          <button
            onClick$={handleRedo}
            class="p-2 rounded hover:bg-gray-100 text-sm"
          >
            ↷ Redo
          </button>
        </div>
      </div>
    </div>
  );
});

// Lazy-loaded action handlers
const handleUndo = $(async () => {
  const { shapeManager } = await import('../../lib/shapes/ShapeManager');
  shapeManager.undo();
});

const handleRedo = $(async () => {
  const { shapeManager } = await import('../../lib/shapes/ShapeManager');
  shapeManager.redo();
});
```

## Performance Optimization

### QRL (Qwik URL) Strategy
```typescript
// QRLs for optimal lazy loading
export const handleCanvasInteraction = $(async (event: MouseEvent) => {
  // This code only downloads when interaction happens
  const { processInteraction } = await import('../lib/canvas-interactions');
  await processInteraction(event);
});

// Prefetch strategies for likely interactions
export const prefetchInteractionHandlers = $(async () => {
  // Prefetch common interaction handlers
  await import('../lib/canvas-interactions');
  await import('../lib/shape-factory');
  await import('../lib/undo-redo');
});
```

### Code Splitting at Interaction Boundaries
```typescript
// src/routes/dashboard/index.tsx
import { component$, $, useOnDocument } from '@builder.io/qwik';

export default component$(() => {
  useOnDocument('mousemove', $(async () => {
    // Preload canvas interaction code on first mouse move
    await import('../components/whiteboard/Canvas');
  }));

  return (
    <div class="dashboard">
      <h1>Whiteboard Dashboard</h1>
      <WhiteboardCanvas />
    </div>
  );
});
```

## Security Considerations

- **Authentication** with Auth.js and session management
- **Room Access Control** via Liveblocks permissions
- **Input Sanitization** for user-generated content
- **Rate Limiting** on API endpoints
- **CORS Configuration** for cross-origin requests
- **Content Security Policy** for XSS prevention

## Deployment on Cloudflare Pages

### Build Configuration
```typescript
// wrangler.toml
name = "whiteboard-qwik"
compatibility_date = "2023-10-01"

[[d1_databases]]
binding = "DB"
database_name = "whiteboard-db"
database_id = "your-database-id"

[env.production]
vars = { ENVIRONMENT = "production" }

[env.preview]
vars = { ENVIRONMENT = "preview" }
```

### Environment Setup
```env
# .env.local
PUBLIC_LIVEBLOCKS_KEY=pk_live_...
LIVEBLOCKS_SECRET_KEY=sk_...
AUTH_SECRET=your-auth-secret
DATABASE_URL=your-database-url
```

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm package manager
- Liveblocks account
- Auth.js configuration
- Cloudflare account

### Quick Start
```bash
# Clone and set up
git clone <repository-url>
cd collab-whiteboard-qwik
pnpm install

# Configure environment
cp .env.example .env.local
# Set up authentication and Liveblocks

# Start development
pnpm dev
```

## Related Examples

- [Kanban SolidStart →]({{ 'examples/kanban-solidstart/' | relative_url }}) - Another real-time collaboration example
- [Field CRM →]({{ 'examples/field-crm-marko/' | relative_url }}) - Performance optimization patterns
- [Router App →]({{ 'examples/router-app-tanstack-solid/' | relative_url }}) - Advanced state management patterns