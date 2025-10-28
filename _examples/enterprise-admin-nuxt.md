---
layout: example
title: "Enterprise Admin (Nuxt)"
description: "Mature ecosystem admin portal with comprehensive features and competitive mobile performance"
outcome_type: "web-app"
stack:
  meta_framework: "Nuxt@4"
  ui_library: "Vue@3"
  styling: "TailwindCSS@4 + Nuxt UI"
  database: "Postgres (Neon) via Prisma"
  auth: "Auth.js (Nuxt)"
  charts: "Apache ECharts"
  deployment: "Vercel (Node adapter)"
  cache: "Vercel KV"
  package_manager: "pnpm@9"
complexity: "advanced"
---

# Enterprise Admin (Nuxt)

A comprehensive enterprise admin portal that showcases Nuxt's mature ecosystem and Vue's composition API. Features complex data grids, role-based access control, interactive charts, and sophisticated admin workflows while maintaining excellent performance across devices.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "enterprise-admin-nuxt"
name: "Enterprise Admin (Nuxt)"
description: "Mature ecosystem admin portal with competitive mobile perf; SSR-first + modules."
outcome_type: "web-app"

technology_stack:
  meta_framework: "Nuxt@4"
  ui_library: "Vue@3"
  styling: "TailwindCSS@4 + Nuxt UI"
  database: "Postgres (Neon) via Prisma"
  auth: "Auth.js (Nuxt)"
  charts: "Apache ECharts"
  deployment: "Vercel (Node adapter)"
  cache: "Vercel KV"
  package_manager: "pnpm@9"

agents:
  primary: "nuxt-architect"
  secondary:
    deployment: "vercel-enterprise"
    testing: "vitest-playwright"

sub_agents:
  - name: "module-integrator"
    description: "Nuxt modules: i18n, image, security, og-image."
    focus: ["nuxt-security", "nuxt-image", "vue-i18n", "nitro"]
    model: "sonnet"
  - name: "accessibility-lead"
    description: "Admin grids/forms a11y; keyboard nav; screen readers."
    focus: ["aria", "focus-traps", "contrast"]
    model: "sage"

scripts:
  setup: |
    #!/usr/bin/env bash
    pnpm dlx nuxi@latest init admin
    cd admin
    pnpm add @nuxt/ui @auth/core @prisma/client prisma @vercel/kv echarts zod
    pnpm add -D tailwindcss postcss autoprefixer vitest @playwright/test
    pnpm dlx tailwindcss init -p
    npx prisma init
  dev: |
    #!/usr/bin/env bash
    pnpm dev
  deploy: |
    #!/usr/bin/env bash
    vercel --prod

acceptance:
  performance:
    lcp_ms_p75: 1300
    tbt_ms_p75: 50
    js_budget_dashboard_kb_gzip: 75
  ux_flows:
    - name: "Data grid ops"
      steps:
        - "Server-side filtering/sorting/pagination"
        - "Bulk actions with optimistic feedback"
    - name: "Role-based access"
      steps:
        - "RBAC per route/action"
        - "Audit logs visible by admins"
```

## Key Features

### Core Functionality
- ✅ **Advanced Data Grids** - Server-side operations with virtual scrolling
- ✅ **Role-Based Access Control** - Fine-grained permissions and audit trails
- ✅ **Interactive Dashboards** - Real-time charts and KPI monitoring
- ✅ **Multi-language Support** - Internationalization with dynamic locale switching
- ✅ **File Management** - Upload, organize, and manage enterprise assets
- ✅ **User Management** - Comprehensive user administration with team workflows

### Enterprise Features
- **SSO Integration** - Support for multiple identity providers
- **Audit Logging** - Complete activity tracking and compliance reporting
- **Data Export** - Multiple formats with customizable filtering
- **API Rate Limiting** - Built-in protection and fair usage policies
- **Security Headers** - Enterprise-grade security configurations
- **Performance Monitoring** - Built-in analytics and performance metrics

## Architecture Highlights

### Nuxt Modules Integration
```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  // Core modules
  modules: [
    '@nuxt/ui',
    '@nuxtjs/prisma',
    '@nuxtjs/auth',
    '@nuxtjs/i18n',
    '@nuxt/image',
    '@nuxt/security',
    '@nuxt/og-image',
    'nuxt-echarts',
  ],

  // UI configuration
  ui: {
    global: true,
    icons: ['heroicons', 'simple-icons']
  },

  // Security configuration
  security: {
    headers: {
      crossOriginEmbedderPolicy: false,
      contentSecurityPolicy: {
        'script-src': ["'self'", "'unsafe-inline'"],
      }
    }
  },

  // Image optimization
  image: {
    format: ['webp'],
    screens: {
      xs: 320,
      sm: 640,
      md: 768,
      lg: 1024,
      xl: 1280,
    },
  },

  // Internationalization
  i18n: {
    locales: [
      { code: 'en', file: 'en.json' },
      { code: 'es', file: 'es.json' },
      { code: 'fr', file: 'fr.json' },
      { code: 'de', file: 'de.json' },
    ],
    lazy: true,
    detectBrowserLanguage: {
      useCookie: true,
      redirectOn: 'root'
    }
  },

  // Runtime configuration
  runtimeConfig: {
    // Private keys (only available on server-side)
    authSecret: process.env.AUTH_SECRET,
    databaseUrl: process.env.DATABASE_URL,
    redisUrl: process.env.REDIS_URL,

    // Public keys (exposed to client-side)
    public: {
      apiBase: process.env.PUBLIC_API_BASE || '/api',
      appName: 'Enterprise Admin',
      appVersion: '1.0.0'
    }
  },

  // Performance optimizations
  nitro: {
    experimental: {
      wasm: true
    }
  },

  // Route rules for caching
  routeRules: {
    '/admin/**': { ssr: true },
    '/api/**': { cors: true },
    '/dashboard': { isr: 60 } // Revalidate every 60 seconds
  }
});
```

### Advanced Data Grid with Server-Side Operations
```vue
<!-- components/admin/DataGrid.vue -->
<template>
  <div class="data-grid-container">
    <!-- Toolbar -->
    <div class="flex justify-between items-center mb-4">
      <div class="flex space-x-2">
        <UInput
          v-model="searchQuery"
          placeholder="Search..."
          icon="i-heroicons-magnifying-glass"
          @input="debouncedSearch"
        />
        <USelectMenu
          v-model="selectedColumns"
          :options="availableColumns"
          multiple
          placeholder="Columns"
        />
      </div>

      <div class="flex space-x-2">
        <UButton
          icon="i-heroicons-arrow-down-tray"
          variant="outline"
          @click="exportData"
        >
          Export
        </UButton>
        <UButton
          icon="i-heroicons-funnel"
          variant="outline"
          @click="showFilters = !showFilters"
        >
          Filters
        </UButton>
      </div>
    </div>

    <!-- Filters Panel -->
    <UCard v-if="showFilters" class="mb-4">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div v-for="filter in filters" :key="filter.key">
          <UFormGroup :label="filter.label">
            <UInput
              v-if="filter.type === 'text'"
              v-model="filterValues[filter.key]"
              @input="applyFilters"
            />
            <USelectMenu
              v-else-if="filter.type === 'select'"
              v-model="filterValues[filter.key]"
              :options="filter.options"
              @change="applyFilters"
            />
            <UDatePicker
              v-else-if="filter.type === 'date'"
              v-model="filterValues[filter.key]"
              @input="applyFilters"
            />
          </UFormGroup>
        </div>
      </div>
    </UCard>

    <!-- Data Table -->
    <UTable
      :columns="tableColumns"
      :rows="data"
      :loading="loading"
      :empty-state="{ icon: 'i-heroicons-circle-stack-20-solid', label: 'No items.' }"
      class="w-full"
      @select="handleRowSelect"
    >
      <!-- Custom cell templates -->
      <template #name-data="{ row }">
        <div class="flex items-center space-x-2">
          <UAvatar
            :src="row.avatar"
            :alt="row.name"
            size="sm"
          />
          <div>
            <div class="font-medium">{{ row.name }}</div>
            <div class="text-sm text-gray-500">{{ row.email }}</div>
          </div>
        </div>
      </template>

      <template #status-data="{ row }">
        <UBadge
          :color="statusColors[row.status]"
          variant="subtle"
        >
          {{ row.status }}
        </UBadge>
      </template>

      <template #actions-data="{ row }">
        <UDropdown
          :items="getActionItems(row)"
          :popper="{ placement: 'bottom-start' }"
        >
          <UButton
            color="gray"
            variant="ghost"
            icon="i-heroicons-ellipsis-horizontal-20-solid"
          />
        </UDropdown>
      </template>
    </UTable>

    <!-- Pagination -->
    <div class="flex justify-between items-center mt-4">
      <div class="text-sm text-gray-600">
        Showing {{ (currentPage - 1) * pageSize + 1 }} to {{ Math.min(currentPage * pageSize, total) }} of {{ total }} items
      </div>

      <UPagination
        v-model="currentPage"
        :page-count="pageSize"
        :total="total"
        :ui="{ wrapper: 'space-x-1' }"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { debounce } from 'lodash-es'

// Props and emits
const props = defineProps<{
  endpoint: string
  columns: Column[]
  filters?: Filter[]
}>()

const emit = defineEmits<{
  rowSelect: [row: any]
  bulkAction: [action: string, rows: any[]]
}>()

// Reactive state
const searchQuery = ref('')
const selectedColumns = ref(props.columns.map(col => col.key))
const showFilters = ref(false)
const loading = ref(false)
const data = ref<any[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(20)
const sortColumn = ref('')
const sortDirection = ref<'asc' | 'desc'>('asc')
const filterValues = ref<Record<string, any>>({})

// Computed properties
const availableColumns = computed(() =>
  props.columns.filter(col => !col.hidden)
)

const tableColumns = computed(() =>
  props.columns
    .filter(col => selectedColumns.value.includes(col.key))
    .map(col => ({
      key: col.key,
      label: col.label,
      sortable: col.sortable,
      class: col.class
    }))
)

const statusColors = {
  active: 'green',
  inactive: 'gray',
  pending: 'yellow',
  suspended: 'red'
}

// Debounced search
const debouncedSearch = debounce(() => {
  currentPage.value = 1
  fetchData()
}, 300)

// Data fetching
const fetchData = async () => {
  loading.value = true

  try {
    const params = new URLSearchParams({
      page: currentPage.value.toString(),
      limit: pageSize.value.toString(),
      search: searchQuery.value,
      sort: sortColumn.value,
      order: sortDirection.value,
      ...filterValues.value
    })

    const response = await $fetch(`/api/${props.endpoint}?${params}`)
    data.value = response.data
    total.value = response.total
  } catch (error) {
    console.error('Failed to fetch data:', error)
  } finally {
    loading.value = false
  }
}

// Event handlers
const handleRowSelect = (row: any) => {
  emit('rowSelect', row)
}

const applyFilters = () => {
  currentPage.value = 1
  fetchData()
}

const exportData = async () => {
  try {
    const params = new URLSearchParams({
      format: 'csv',
      ...filterValues.value
    })

    const response = await $fetch(`/api/${props.endpoint}/export?${params}`)

    // Create download link
    const blob = new Blob([response], { type: 'text/csv' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `export-${Date.now()}.csv`
    a.click()
    window.URL.revokeObjectURL(url)
  } catch (error) {
    console.error('Export failed:', error)
  }
}

const getActionItems = (row: any) => [
  [{
    label: 'View',
    icon: 'i-heroicons-eye',
    click: () => navigateTo(`/admin/${props.endpoint}/${row.id}`)
  }],
  [{
    label: 'Edit',
    icon: 'i-heroicons-pencil',
    click: () => navigateTo(`/admin/${props.endpoint}/${row.id}/edit`)
  }],
  [{
    label: 'Delete',
    icon: 'i-heroicons-trash',
    click: () => deleteItem(row.id)
  }]
]

// Watch for changes
watch([currentPage, pageSize, sortColumn, sortDirection], fetchData)

// Initial load
onMounted(() => {
  fetchData()
})
</script>
```

### Role-Based Access Control
```typescript
// server/middleware/auth.ts
export default defineEventHandler(async (event) => {
  // Skip auth for public routes
  if (event.node.req.url?.startsWith('/api/public')) {
    return
  }

  // Get session from Auth.js
  const session = await authjsHandler(event)

  if (!session?.user) {
    throw createError({
      statusCode: 401,
      statusMessage: 'Unauthorized'
    })
  }

  // Get user permissions
  const userPermissions = await getUserPermissions(session.user.id)

  // Store in event context
  event.context.user = session.user
  event.context.permissions = userPermissions

  // Check route-specific permissions
  const route = getRoute(event.node.req.url!)
  const requiredPermission = getRequiredPermission(route)

  if (requiredPermission && !userPermissions.includes(requiredPermission)) {
    throw createError({
      statusCode: 403,
      statusMessage: 'Forbidden'
    })
  }
})

// server/utils/permissions.ts
export async function getUserPermissions(userId: string): Promise<string[]> {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: {
      roles: {
        include: {
          permissions: true
        }
      }
    }
  })

  if (!user) return []

  return user.roles.flatMap(role =>
    role.permissions.map(permission => permission.name)
  )
}

export function getRequiredPermission(route: string): string | null {
  const permissionMap: Record<string, string> = {
    '/api/users': 'users:read',
    '/api/users/create': 'users:create',
    '/api/users/*/update': 'users:update',
    '/api/users/*/delete': 'users:delete',
    '/api/admin/settings': 'admin:settings',
    '/api/reports': 'reports:read',
    '/api/audit': 'audit:read'
  }

  for (const [pattern, permission] of Object.entries(permissionMap)) {
    if (route.match(pattern.replace('*', '[^/]+'))) {
      return permission
    }
  }

  return null
}
```

### Interactive Dashboard with ECharts
```vue
<!-- components/admin/Dashboard.vue -->
<template>
  <div class="dashboard">
    <!-- KPI Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <div v-for="kpi in kpis" :key="kpi.key" class="kpi-card">
        <UCard>
          <div class="flex items-center justify-between">
            <div>
              <div class="text-sm font-medium text-gray-600">{{ kpi.label }}</div>
              <div class="text-2xl font-bold">{{ kpi.value }}</div>
              <div class="text-sm" :class="kpi.trend > 0 ? 'text-green-600' : 'text-red-600'">
                {{ kpi.trend > 0 ? '+' : '' }}{{ kpi.trend }}% from last month
              </div>
            </div>
            <div :class="`p-3 rounded-lg bg-${kpi.color}-100`">
              <UIcon :name="kpi.icon" :class="`text-${kpi.color}-600 text-xl`" />
            </div>
          </div>
        </UCard>
      </div>
    </div>

    <!-- Charts Row -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
      <!-- Revenue Chart -->
      <UCard>
        <template #header>
          <h3 class="text-lg font-semibold">Revenue Overview</h3>
        </template>
        <ClientOnly>
          <VChart
            :option="revenueChartOption"
            style="height: 300px"
            :loading="chartsLoading"
          />
        </ClientOnly>
      </UCard>

      <!-- User Growth Chart -->
      <UCard>
        <template #header>
          <h3 class="text-lg font-semibold">User Growth</h3>
        </template>
        <ClientOnly>
          <VChart
            :option="userGrowthChartOption"
            style="height: 300px"
            :loading="chartsLoading"
          />
        </ClientOnly>
      </UCard>
    </div>

    <!-- Activity Feed -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <UCard class="lg:col-span-2">
        <template #header>
          <h3 class="text-lg font-semibold">Recent Activity</h3>
        </template>
        <div class="space-y-4">
          <div
            v-for="activity in recentActivity"
            :key="activity.id"
            class="flex items-start space-x-3"
          >
            <UAvatar
              :src="activity.user.avatar"
              :alt="activity.user.name"
              size="sm"
            />
            <div class="flex-1">
              <div class="text-sm">
                <span class="font-medium">{{ activity.user.name }}</span>
                <span class="text-gray-600"> {{ activity.action }}</span>
              </div>
              <div class="text-xs text-gray-500">{{ formatTime(activity.timestamp) }}</div>
            </div>
          </div>
        </div>
      </UCard>

      <!-- System Status -->
      <UCard>
        <template #header>
          <h3 class="text-lg font-semibold">System Status</h3>
        </template>
        <div class="space-y-4">
          <div
            v-for="service in systemServices"
            :key="service.name"
            class="flex items-center justify-between"
          >
            <div class="flex items-center space-x-2">
              <div
                :class="`w-2 h-2 rounded-full ${
                  service.status === 'healthy' ? 'bg-green-500' : 'bg-red-500'
                }`"
              />
              <span class="text-sm font-medium">{{ service.name }}</span>
            </div>
            <span class="text-xs text-gray-500">{{ service.uptime }}%</span>
          </div>
        </div>
      </UCard>
    </div>
  </div>
</template>

<script setup lang="ts">
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'

// Register ECharts components
use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

// Reactive state
const chartsLoading = ref(true)
const kpis = ref([])
const recentActivity = ref([])
const systemServices = ref([])

// Chart options
const revenueChartOption = computed(() => ({
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'cross'
    }
  },
  legend: {
    data: ['Revenue', 'Profit']
  },
  xAxis: {
    type: 'category',
    data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
  },
  yAxis: {
    type: 'value'
  },
  series: [
    {
      name: 'Revenue',
      type: 'line',
      data: [12000, 15000, 18000, 22000, 25000, 28000],
      smooth: true,
      itemStyle: { color: '#3b82f6' }
    },
    {
      name: 'Profit',
      type: 'bar',
      data: [3000, 4500, 6000, 8000, 9500, 11000],
      itemStyle: { color: '#10b981' }
    }
  ]
}))

const userGrowthChartOption = computed(() => ({
  tooltip: {
    trigger: 'axis'
  },
  xAxis: {
    type: 'category',
    data: ['Week 1', 'Week 2', 'Week 3', 'Week 4']
  },
  yAxis: {
    type: 'value'
  },
  series: [
    {
      name: 'New Users',
      type: 'line',
      data: [150, 230, 180, 290],
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(59, 130, 246, 0.3)' },
            { offset: 1, color: 'rgba(59, 130, 246, 0.1)' }
          ]
        }
      },
      itemStyle: { color: '#3b82f6' }
    }
  ]
}))

// Data fetching
const fetchDashboardData = async () => {
  try {
    const [kpisData, activityData, servicesData] = await Promise.all([
      $fetch('/api/dashboard/kpis'),
      $fetch('/api/dashboard/activity'),
      $fetch('/api/dashboard/system-status')
    ])

    kpis.value = kpisData
    recentActivity.value = activityData
    systemServices.value = servicesData
  } catch (error) {
    console.error('Failed to fetch dashboard data:', error)
  } finally {
    chartsLoading.value = false
  }
}

// Utility functions
const formatTime = (timestamp: string) => {
  return new Intl.DateTimeFormat('en-US', {
    hour: 'numeric',
    minute: 'numeric',
    day: 'numeric',
    month: 'short'
  }).format(new Date(timestamp))
}

// Load data on mount
onMounted(() => {
  fetchDashboardData()
})
</script>
```

## Development Workflow

### 1. Project Setup
```bash
# Create Nuxt project
pnpm dlx nuxi@latest init enterprise-admin
cd enterprise-admin

# Install dependencies
pnpm add @nuxt/ui @auth/core @prisma/client prisma @vercel/kv echarts zod
pnpm add -D tailwindcss postcss autoprefixer vitest @playwright/test

# Initialize Prisma
npx prisma init
npx prisma generate

# Initialize Tailwind
pnpm dlx tailwindcss init -p
```

### 2. Prisma Schema
```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id            String    @id @default(cuid())
  email         String    @unique
  name          String?
  avatar        String?
  emailVerified DateTime?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  // Relations
  roles          UserRole[]
  sessions       Session[]
  auditLogs      AuditLog[]
}

model Role {
  id          String @id @default(cuid())
  name        String @unique
  description String?
  createdAt   DateTime @default(now())

  // Relations
  users       UserRole[]
  permissions RolePermission[]
}

model UserRole {
  id     String @id @default(cuid())
  userId String
  roleId String

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  role Role @relation(fields: [roleId], references: [id], onDelete: Cascade)

  @@unique([userId, roleId])
}

model Permission {
  id          String @id @default(cuid())
  name        String @unique
  description String?
  resource    String
  action      String

  // Relations
  roles RolePermission[]
}

model RolePermission {
  id           String @id @default(cuid())
  roleId       String
  permissionId String

  role       Role       @relation(fields: [roleId], references: [id], onDelete: Cascade)
  permission Permission @relation(fields: [permissionId], references: [id], onDelete: Cascade)

  @@unique([roleId, permissionId])
}

model AuditLog {
  id        String   @id @default(cuid())
  userId    String
  action    String
  resource  String
  details   Json?
  ipAddress String?
  userAgent String?
  createdAt DateTime @default(now())

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@index([createdAt])
}
```

## Performance Optimization

### Route Rules and Caching
```typescript
// nuxt.config.ts (continued)
export default defineNuxtConfig({
  routeRules: {
    // Static pages with ISR
    '/': { isr: 120 }, // 2 minutes
    '/about': { isr: 3600 }, // 1 hour

    // Admin pages with SSR
    '/admin/**': { ssr: true, headers: { 'Cache-Control': 'no-cache' } },

    // API routes
    '/api/admin/stats': { isr: 60 }, // 1 minute
    '/api/admin/users': { cors: true },
    '/api/public/**': { prerender: true },

    // Assets
    '/assets/**': { cache: { maxAge: 60 * 60 * 24 * 365 } } // 1 year
  }
})
```

### Nitro Server Optimization
```typescript
// server/api/dashboard/kpis.get.ts
export default defineEventHandler(async (event) => {
  // Use Redis for caching KPIs
  const cacheKey = 'dashboard:kpis'
  const cached = await useStorage('redis').getItem(cacheKey)

  if (cached) {
    return cached
  }

  // Calculate KPIs
  const [
    totalUsers,
    activeUsers,
    monthlyRevenue,
    totalRevenue
  ] = await Promise.all([
    prisma.user.count(),
    prisma.user.count({
      where: {
        updatedAt: { gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) }
      }
    }),
    calculateMonthlyRevenue(),
    calculateTotalRevenue()
  ])

  const kpis = [
    {
      key: 'totalUsers',
      label: 'Total Users',
      value: totalUsers.toLocaleString(),
      trend: 12.5,
      color: 'blue',
      icon: 'i-heroicons-users'
    },
    {
      key: 'activeUsers',
      label: 'Active Users',
      value: activeUsers.toLocaleString(),
      trend: 8.3,
      color: 'green',
      icon: 'i-heroicons-user-group'
    },
    {
      key: 'monthlyRevenue',
      label: 'Monthly Revenue',
      value: `$${monthlyRevenue.toLocaleString()}`,
      trend: 15.7,
      color: 'purple',
      icon: 'i-heroicons-currency-dollar'
    },
    {
      key: 'totalRevenue',
      label: 'Total Revenue',
      value: `$${totalRevenue.toLocaleString()}`,
      trend: 23.4,
      color: 'yellow',
      icon: 'i-heroicons-chart-bar'
    }
  ]

  // Cache for 5 minutes
  await useStorage('redis').setItem(cacheKey, kpis, { ttl: 300 })

  return kpis
})
```

## Security Considerations

- **Authentication & Authorization** with Auth.js and RBAC
- **Input Validation** using Zod schemas for all API inputs
- **SQL Injection Prevention** via Prisma ORM
- **XSS Protection** with proper content security policies
- **CSRF Protection** on state-changing operations
- **Rate Limiting** on API endpoints
- **Audit Logging** for all administrative actions
- **Secure Headers** configured via Nuxt Security module

## Getting Started

### Prerequisites
- Node.js 18+
- pnpm package manager
- PostgreSQL database (Neon recommended)
- Redis cache (Vercel KV recommended)
- Auth.js configuration

### Quick Start
```bash
# Clone and set up
git clone <repository-url>
cd enterprise-admin-nuxt
pnpm install

# Configure environment
cp .env.example .env.local
# Set up database and auth providers

# Initialize database
npx prisma migrate dev
npx prisma db seed

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

# API Keys
PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_...
STRIPE_SECRET_KEY=sk_...
```

## Related Examples

- [SaaS Starter →]({{ 'examples/saas-starter-sveltekit/' | relative_url }}) - Authentication and billing patterns
- [Field CRM →]({{ 'examples/field-crm-marko/' | relative_url }}) - Data management patterns
- [Shop Website →]({{ 'examples/shop-website/' | relative_url }}) - Admin dashboard patterns