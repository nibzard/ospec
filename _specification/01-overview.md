---
layout: spec
title: "OSpec Overview"
description: "Outcome-driven specification format for AI coding agents to build products"
permalink: /specification/
order: 1
---

# OSpec v1.0 Specification

## Core Concept — Recipe Format for AI Coding Agents

OSpec is a YAML specification format that solves the decision paralysis problem for AI coding agents. Instead of agents wasting time choosing between countless tech stack options, OSpec provides proven, battle-tested combinations that work well with specific AI coding agents.

### Key Principles

1. **Outcome-driven specification** — Define WHAT to build, not HOW to build it
2. **Proven tech stacks** — Curated combinations that actually work in production
3. **Agent optimization** — Stack choices optimized for specific AI coding agents
4. **Decision elimination** — No more "Postgres or SQLite? npm or yarn?" paralysis  
5. **Scaffolding automation** — Like `rails new` or `create-react-app` but for AI agents
6. **Acceptance criteria** — Clear verification that the outcome works as intended

## Core Concepts

### Outcome Types

OSpec supports various outcome types, each with tailored acceptance criteria:

- `web-app` - Full-stack web applications
- `api` - RESTful or GraphQL APIs
- `cli` - Command-line tools
- `game` - Interactive games
- `library` - Reusable code libraries
- `ml-pipeline` - Machine learning workflows
- `mobile-app` - Mobile applications
- `desktop-app` - Desktop applications
- `infrastructure` - Infrastructure as code
- `documentation` - Technical documentation

### How AI Agents Use OSpec

When an AI coding agent receives an OSpec file, it can immediately:

1. **Understand the outcome** — Know exactly what product to build
2. **Choose proven tools** — Use the specified tech stack without decision paralysis  
3. **Set up the project** — Scaffold directories, configs, and boilerplate code
4. **Install dependencies** — Use the correct package manager and versions
5. **Verify completion** — Test against the acceptance criteria

This eliminates the back-and-forth of "which framework should I use?" and gets straight to building.

## Specification Structure

### Core Fields

```yaml
# Version of OSpec format
ospec_version: "1.0.0"

# Unique project identifier  
id: "ecommerce-shop"

# Human-readable name
name: "E-commerce Website"

# What you're building
description: "Online shop with product catalog, cart, and checkout"

# Type of product
outcome_type: "web-app"

# The tech stack - eliminates decision paralysis
stack:
  # Specific versions
  frontend: "Next.js@14"
  
  # Proven combinations that work together
  backend: "Supabase"
  styling: "TailwindCSS"
  
  # Agent-optimized choices
  deploy: "Vercel"
  package_manager: "npm"

# How to verify it works  
acceptance:
  http_endpoints:
    - path: "/"
  user_flows:
    - "User can browse products and add to cart"
```

### Tooling Preferences

The `stack` section can specify preferences that eliminate micro-decisions:
- Package managers: `npm` vs `yarn` vs `pnpm`
- Python environments: `pyenv` vs `uv` vs `venv`
- Testing frameworks: `pytest` vs `unittest`
- Database tools: `prisma` vs `sqlalchemy`
- Deployment: `vercel` vs `railway` vs `fly.io`

## Next Steps

- [Schema Reference →](/specification/schema/)
- [Schema Validation →](/specification/validation/)