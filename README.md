# OSpec - Build Products That Deliver Outcomes

[![Deploy Jekyll with GitHub Pages dependencies preinstalled](https://github.com/nibzard/ospec/actions/workflows/pages.yml/badge.svg)](https://github.com/nibzard/ospec/actions/workflows/pages.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

**The specification format for AI coding agents to build products with proven tech stacks.**

💌 **A love letter to AI** - OSpec is an outcome-driven specification that defines **what product to build** and **which tech stack to use**, allowing AI coding agents to scaffold, implement, and deploy projects with opinionated, battle-tested technology choices.

🌐 **Website**: [https://nibzard.github.io/ospec](https://nibzard.github.io/ospec)

## Why OSpec?

### 🤖 End the Tech Stack Decision Paralysis
**You** and your AI coding agents face the same endless choices: "React or Vue? Next.js or Remix? npm or pnpm?" This decision paralysis affects **both humans and AI agents**. While you debate frameworks, competitors ship products.

OSpec solves this with **shared, battle-tested recipes**—like having 1000+ developer teams tell you exactly what tech combination works for your use case.

### 🚀 Key Features
- 🎯 **Outcome-first approach** - Define what you want, not how to build it
- ⚡ **2025 Modern Tech Stacks** - Next.js 15, SvelteKit 2, Remix 2, React 18
- 🤖 **Multi-Agent Orchestration** - Primary agents + specialized sub-agents
- 🔧 **Embedded Automation** - Scripts and sub-agents directly in specs
- 🌐 **Community-Driven** - 2000+ hours of setup experience, distilled

## Quick Start - Modern 2025 Stack

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
  package_manager: "pnpm@9"         # 3x faster than npm

# Multi-agent workflow
agents:
  primary: "claude-code"            # Main development agent
  secondary:
    deployment: "deployment-specialist"  # Handles CI/CD setup
    testing: "test-engineer"            # E2E and unit test coverage

# Sub-agents with specific expertise (auto-created in .claude/agents/)
sub_agents:
  - name: "ecommerce-specialist"
    description: "Expert in payment flows, cart logic, and product management"
    focus: ["stripe-integration", "inventory-management", "order-processing"]
    model: "sonnet"
  
  - name: "performance-auditor" 
    description: "Optimizes Core Web Vitals, bundle size, and loading speed"
    focus: ["lighthouse-scores", "bundle-analysis", "caching-strategy"]
    model: "opus"

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
    response_time_ms: 1200
    memory_mb: 512
  ux_flows:
    - name: "Complete Purchase Flow"
      steps:
        - "User browses products with search"
        - "Add items to cart (persists across sessions)"
        - "Complete Stripe checkout in test mode"
        - "Receive order confirmation email"
```

## Development

### Environment Requirements

- **Ruby 3.3+** with Bundler (primary requirement)
- **Node.js 18+** with npm (optional, for validation tools)
- **Git** (for version control and GitHub Pages deployment)

### Initial Setup

```bash
# 1. IMPORTANT: Set gem path for current session
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"

# 2. Install Ruby dependencies (required)
bundle install

# 3. Install Node.js validation tools (optional)
npm install
```

**Critical**: Always set the gem path in your shell session or add to `~/.bashrc` for persistence:
```bash
echo 'export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Starting Development

#### Jekyll Server (Local Development)
```bash
# Development server with live reload (recommended)
bundle exec jekyll serve --host 127.0.0.1 --port 4000 --livereload

# Alternative using npm script
npm run dev

# Site available at: http://localhost:4000
```

#### Jekyll Server (Network Access)
```bash
# Allow access from other devices (useful for mobile testing or remote access)
bundle exec jekyll serve --host 0.0.0.0 --port 4000

# Site available at: http://your-ip:4000 (e.g., http://192.168.1.100:4000)
```

#### Production Build
```bash
# Build for production
bundle exec jekyll build
# Alternative: npm run build

# Clean build artifacts
bundle exec jekyll clean
# Alternative: npm run clean
```

### Jekyll-Specific Commands
```bash
# Check Jekyll configuration and health
bundle exec jekyll doctor

# Build with verbose output (helpful for debugging)
bundle exec jekyll build --verbose

# Serve with incremental builds (faster for large sites)
bundle exec jekyll serve --incremental --watch
```

### Project Structure

```
/
├── _config.yml           # Jekyll configuration
├── index.md             # Landing page
├── _specification/      # Core spec docs
├── _guides/             # How-to guides
├── _examples/           # Complete examples
├── _cookbook/           # Patterns and recipes
├── _layouts/            # Page layouts
├── _includes/           # Reusable components
└── assets/              # CSS, JS, images
```

### OSpec Validation

```bash
# Validate all OSpec files in the project
bundle exec rake validate_ospec
npm run validate-ospec

# Validate a specific OSpec file
bundle exec rake validate_ospec_file[path/to/spec.ospec.yml]

# Create new OSpec from template
bundle exec rake new_ospec[project-name]
```

### Testing and Quality Assurance

```bash
# Run full test suite (build + link checking)
npm test
bundle exec rake test

# Validate YAML frontmatter across all markdown files
bundle exec rake validate_yaml

# Check for broken internal links
bundle exec rake check_links
```

### GitHub Pages Deployment

This project is automatically deployed to GitHub Pages via GitHub Actions.

#### Automatic Deployment
- **Trigger**: Push to `main` branch
- **Build**: GitHub Actions workflow in `.github/workflows/pages.yml`
- **Environment**: Ubuntu latest with Ruby 3.3 and Jekyll 4.3.4
- **Output**: Deployed to `https://nibzard.github.io/ospec/`

#### Manual Deployment Steps
1. **Test locally**: `bundle exec jekyll build` (ensure no errors)
2. **Push to main**: `git push origin main`
3. **Monitor**: Check Actions tab in GitHub for deployment status
4. **Verify**: Visit `https://nibzard.github.io/ospec/` to confirm

#### GitHub Pages Configuration
- **Source**: GitHub Actions (not legacy Pages source)
- **Custom domain**: Not configured (uses default github.io subdomain)
- **HTTPS**: Enforced by default
- **Branch**: Deploys from `main` branch only

#### Troubleshooting Deployment
```bash
# Check build locally before pushing
bundle exec jekyll build --verbose

# Look for Jekyll errors in build output
bundle exec jekyll doctor

# Test production build exactly as GitHub Pages does
JEKYLL_ENV=production bundle exec jekyll build
```

If deployment fails:
1. Check the Actions tab in GitHub for detailed error logs
2. Ensure `Gemfile` and `_config.yml` are properly configured
3. Verify all required Jekyll plugins are listed in `_config.yml`
4. Test the build locally with `JEKYLL_ENV=production`

### Content Creation Workflow

#### Adding New Content
- **Specification docs**: Add to `_specification/` directory with `layout: spec` and `order: N` frontmatter
- **Guides**: Add to `_guides/` directory with `layout: guide`, `difficulty`, and `time` frontmatter  
- **Examples**: Add to `_examples/` directory with `layout: example`, `outcome_type`, and `stack` frontmatter
- **Cookbook recipes**: Add to `_cookbook/` directory with `layout: cookbook` and `tags` frontmatter

#### Jekyll Content Requirements
Each content type requires specific frontmatter:

**Specification** (`_specification/`):
```yaml
---
layout: spec
title: "Section Name"
order: 5
---
```

**Guides** (`_guides/`):
```yaml
---
layout: guide
title: "Guide Name"
difficulty: "beginner" # beginner|intermediate|advanced
time: "15 minutes"
---
```

**Examples** (`_examples/`):
```yaml
---
layout: example
title: "Example Name" 
outcome_type: "web-app" # web-app|api|cli|etc
stack:
  frontend: "Next.js@15"
  backend: "FastAPI"
---
```

**Cookbook** (`_cookbook/`):
```yaml
---
layout: cookbook
title: "Recipe Name"
tags: ["deployment", "testing", "performance"]
---
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Common Development Issues

#### Jekyll Build Errors
```bash
# Error: "Could not find gem"
# Solution: Ensure gem path is set and run bundle install
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"
bundle install

# Error: "Permission denied"
# Solution: Use --user-install flag for gem installation
gem install bundler --user-install

# Error: Liquid syntax errors in content files
# Solution: These are often harmless warnings from code examples using other template systems
```

#### Port Conflicts
```bash
# If port 4000 is occupied, use a different port
bundle exec jekyll serve --port 4001

# Check what's using port 4000
lsof -ti:4000
```

## Community

- **Website**: [https://nibzard.github.io/ospec](https://nibzard.github.io/ospec)
- **Issues**: [Report bugs or request features](https://github.com/nibzard/ospec/issues)
- **Specification**: [Read the full OSpec v1.0](https://nibzard.github.io/ospec/specification/)
- **Examples**: [Browse complete project examples](https://nibzard.github.io/ospec/examples/)
- **Guides**: [Step-by-step tutorials](https://nibzard.github.io/ospec/guides/)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by the OSpec community