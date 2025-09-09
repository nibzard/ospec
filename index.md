---
layout: default
title: "OSpec - Build Products That Deliver Outcomes"
description: "Outcome-driven specifications for AI coding agents. Define what to build, not how to build it."
---

# OSpec v1.0
## Build Products That Deliver Outcomes

**The specification format for AI coding agents to build products with proven tech stacks.**

OSpec is an outcome-driven specification that defines **what product to build** and **which tech stack to use**, allowing AI coding agents to scaffold, implement, and deploy projects with opinionated, battle-tested technology choices.

## Why OSpec?

### 🤖 End the Tech Stack Decision Paralysis
**You** and your AI coding agents face the same endless choices: "React or Vue? Next.js or Remix? Svelte or React? Supabase or Firebase? npm or pnpm? Which versions actually work together?" 

This decision paralysis affects **both humans and AI agents**. While you debate frameworks, competitors ship products.

OSpec solves this with **shared, battle-tested recipes**—like having 1000+ developer teams tell you exactly what tech combination works for your use case.

### ⚡ Skip the Setup, Start Building
Like `rails new` or `create-react-app`, but **for any stack and any AI agent**. Drop in an OSpec file and your preferred coding agent scaffolds the entire project with proven tools, versions, and configurations.

**The community shares the setup knowledge. You focus on building your product.**

### 🎯 Outcome-Driven Development
Specify **what** you want (e-commerce site, CLI tool, API service) instead of **how** to build it. Multiple AI agents can work together—one for setup, another for deployment, another for testing.

### 🔧 Multi-Agent Optimization
Different coding agents excel at different tasks. OSpec specs can specify:
- **Primary agent** for development (Claude Code, Cursor, GitHub Copilot)
- **Specialized sub-agents** for deployment, testing, security reviews
- **Agent-specific preferences** (Claude Code loves TypeScript + Prisma, Cursor prefers Vite builds)

## Quick Start

Create an `outcome.yaml` file that tells your AI coding agents exactly what to build:

```yaml
ospec_version: "1.0.0"
id: "modern-shop"
name: "Modern E-commerce Platform" 
description: "High-performance shop with SSR and edge deployment"
outcome_type: "web-app"

# 2025 battle-tested stack - proven by 500+ projects
technology_stack:
  meta_framework: "Next.js@15"      # 78% of React projects use Next.js
  ui_library: "React@18"            # Still #1 with 39.5% popularity
  styling: "TailwindCSS@4"          # v4 with native CSS integration
  database: "Supabase"              # PostgreSQL + real-time + auth
  payments: "Stripe@13"             # Latest API with enhanced UX
  deployment: "Vercel"              # Edge runtime + ISR
  package_manager: "pnpm@9"         # 3x faster than npm, space efficient

# Multi-agent workflow
agents:
  primary: "claude-code"            # Main development agent
  deployment: "deployment-specialist" # Handles CI/CD setup
  testing: "test-engineer"          # E2E and unit test coverage
  
# Sub-agents with specific expertise (auto-created in .claude/agents/)
sub_agents:
  - name: "ecommerce-specialist"
    description: "Expert in payment flows, cart logic, and product management"
    focus: ["stripe-integration", "inventory-management", "order-processing"]
  
  - name: "performance-auditor" 
    description: "Optimizes Core Web Vitals, bundle size, and loading speed"
    focus: ["lighthouse-scores", "bundle-analysis", "caching-strategy"]

# Embedded automation scripts
scripts:
  setup: |
    #!/bin/bash
    echo "🚀 Setting up Modern Shop with Next.js 15..."
    pnpm create next-app@latest . --typescript --tailwind --app
    pnpm add @supabase/supabase-js stripe lucide-react
    
  deploy: |
    #!/bin/bash
    echo "🌍 Deploying to Vercel with edge optimizations..."
    vercel --prod --regions=fra1,sfo1,hnd1

# How to verify it works
acceptance:
  performance:
    - "Lighthouse score > 95 for all metrics"
    - "First Contentful Paint < 1.2s"
    - "Bundle size < 200KB gzipped"
  functionality:
    - "User can browse 1000+ products with search"
    - "Cart persists across sessions"
    - "Stripe checkout completes in test mode"
    - "Order confirmation emails are sent"
```

**Multi-Agent Workflow:**
1. **Claude Code** scaffolds the Next.js structure and core components
2. **Deployment Specialist** sets up Vercel config and CI/CD pipeline  
3. **Test Engineer** creates Playwright tests for critical user flows
4. **Performance Auditor** optimizes bundle and implements caching
5. All agents validate against your acceptance criteria

**Alternative 2025 Stacks:**

```yaml
# Performance-First Stack (Svelte)
technology_stack:
  meta_framework: "SvelteKit@2"     # 180% growth, 70% smaller bundles
  styling: "TailwindCSS@4"
  database: "PlanetScale" 
  deployment: "Cloudflare Pages"    # Edge-first with global distribution

# Full-Stack TypeScript (Remix)  
technology_stack:
  meta_framework: "Remix@2"         # Server-first, Web Standards
  runtime: "Bun@1.1"               # 3x faster than Node.js
  database: "Prisma + PostgreSQL"
  deployment: "Railway"
```

[Get Started →]({{ 'guides/getting-started/' | relative_url }})

## Key Features

### 📋 Comprehensive Project Recipes
YAML files that specify outcomes, tech stacks, agent workflows, and acceptance criteria—like a `package.json` for entire multi-agent projects.

### 🏗️ 2025 Battle-Tested Stacks  
Modern combinations that actually work: Next.js 15 + Supabase + Vercel, SvelteKit + PlanetScale + Cloudflare, Remix + Bun + Railway.

### 🤖 Multi-Agent Orchestration
- **Primary agents** (Claude Code, Cursor, GitHub Copilot) for development
- **Specialized sub-agents** for deployment, testing, security, performance
- **Agent handoffs** - one agent sets up, another deploys, another tests

### 🔧 Embedded Automation
- **Setup scripts** for project initialization 
- **Deployment scripts** for CI/CD pipeline setup
- **Sub-agent definitions** auto-created in `.claude/agents/` folders
- **Tool preferences** - eliminate "npm vs pnpm?" decisions forever

### 🌐 Community-Driven Knowledge
Share successful recipes, discover proven combinations, skip the research phase. **2000+ hours of setup experience, distilled into reusable specs.**

## Learn More

<div class="grid">
  <div class="card">
    <h3><a href="{{ 'specification/' | relative_url }}">📚 Read the Spec</a></h3>
    <p>Complete OSpec v1.0 specification with schema, lifecycle, and examples.</p>
  </div>
  
  <div class="card">
    <h3><a href="{{ 'guides/' | relative_url }}">🚀 Guides</a></h3>
    <p>Step-by-step tutorials for writing OSpecs and building compatible agents.</p>
  </div>
  
  <div class="card">
    <h3><a href="{{ 'examples/' | relative_url }}">💡 Examples</a></h3>
    <p>Real-world OSpec examples from simple websites to ML pipelines.</p>
  </div>
  
  <div class="card">
    <h3><a href="{{ 'cookbook/' | relative_url }}">📖 Cookbook</a></h3>
    <p>Common patterns, troubleshooting tips, and best practices.</p>
  </div>
</div>

## Community

- **GitHub**: [nibzard/ospec](https://github.com/nibzard/ospec)
- **Discussions**: Join the conversation
- **Issues**: Report bugs and request features
- **Contributing**: Help improve the specification

---

*OSpec is an open specification format for the AI coding era. Help us curate the best tech stacks and improve AI agent productivity.*