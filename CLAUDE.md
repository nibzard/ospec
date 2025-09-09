# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OSpec is a specification system for outcome-driven AI agent frameworks. This is a **Jekyll 4.3.4 documentation website** that serves as the authoritative reference for the OSpec v1.0 specification, with integrated validation tools and specialized sub-agents.

**Status**: ✅ **Fully migrated to Jekyll** and ready for GitHub Pages deployment at `https://nibzard.github.io/ospec/`

## Development Commands

### Local Development
```bash
# IMPORTANT: Set gem path for current session
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"

# Install dependencies
bundle install           # Ruby/Jekyll dependencies (required)
npm install             # Node.js validation tools (optional)

# Development server (with live reload)
bundle exec jekyll serve --host 127.0.0.1 --port 4000 --livereload
# Alternative: npm run dev

# Production build
bundle exec jekyll build
# Alternative: npm run build

# Clean build artifacts
bundle exec jekyll clean
# Alternative: npm run clean

# Site available at: http://localhost:4000/ospec/
```

### Jekyll-Specific Commands
```bash
# Check Jekyll version and plugins
bundle exec jekyll --version
bundle exec jekyll doctor

# Build with verbose output for debugging
bundle exec jekyll build --verbose

# Serve with incremental builds (faster development)
bundle exec jekyll serve --incremental --watch
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

### Testing and Quality
```bash
# Run full test suite (build + link checking)
npm test
bundle exec rake test

# Validate YAML frontmatter across all markdown files
bundle exec rake validate_yaml

# Check for broken internal links
bundle exec rake check_links
```

## Architecture Overview

### Jekyll-Based Documentation Site
The project is built on Jekyll 4.3.4 with GitHub Pages compatibility:
- **Primary Runtime**: Ruby 3.3+ with Jekyll and bundler
- **Secondary Runtime**: Node.js (optional validation and build tools)
- **Deployment**: GitHub Actions → GitHub Pages at `https://nibzard.github.io/ospec/`

### Content Architecture
- **`_specification/`**: Core OSpec technical documentation (8 sections) → `/specification/`
- **`_guides/`**: Step-by-step tutorials with difficulty levels → `/guides/`
- **`_examples/`**: Complete project examples by outcome type → `/examples/`
- **`_cookbook/`**: Reusable patterns and troubleshooting recipes → `/cookbook/`
- **`_layouts/`**: Jekyll page templates (default, spec, guide, example, cookbook)
- **`_includes/`**: Reusable Jekyll components (header, footer, breadcrumbs)
- **`assets/`**: Static CSS and JavaScript files
- **`schemas/`**: JSON Schema definitions and validation logic
- **`scripts/`**: Build tools, validation scripts, setup automation

### Jekyll Collections System
Each content type is a Jekyll collection with specific frontmatter requirements:
- **Specification** (`_specification/`): `layout: spec`, `order: N`, `title: "Section Name"`
- **Guides** (`_guides/`): `layout: guide`, `difficulty: beginner|intermediate|advanced`, `time: "15 minutes"`
- **Examples** (`_examples/`): `layout: example`, `outcome_type: "web-app|api|cli|etc"`, `stack: {...}`
- **Cookbook** (`_cookbook/`): `layout: cookbook`, `tags: [pattern, deployment, etc]`

### GitHub Pages Deployment
- **Auto-deployment**: Triggered on push to `main` branch via `.github/workflows/pages.yml`
- **Build environment**: Ubuntu latest with Ruby 3.3 and Jekyll
- **Base URL**: `/ospec` (configured in `_config.yml`)

### Specialized Sub-Agents
Located in `.claude/sub-agents/`, these define specialized AI agents for different tasks:
- **dev.md**: OSpec implementation and code generation
- **tester.md**: Testing strategies and quality assurance
- **validator.md**: Schema and semantic validation
- **doc-writer.md**: Documentation creation and maintenance
- **ospec-writer.md**: Creating new OSpec specifications
- **git-manager.md**: Git operations with conventional commits

## Key Development Patterns

### OSpec Validation Integration
The project has dual validation systems that must be kept in sync:
- Ruby validation via `scripts/validate_ospec.rb` and Rake tasks
- Node.js validation via `scripts/validate-ospec.js`
- Both use the same `schemas/ospec-v1.0.json` schema file

### Content Creation Workflow
1. **Add content** to appropriate Jekyll collection directory (`_specification/`, `_guides/`, etc.)
2. **Use required frontmatter** for the collection type (layout, order, difficulty, etc.)
3. **Test locally**: `bundle exec jekyll serve --livereload`
4. **Validate build**: `bundle exec jekyll build` (check for Liquid errors)
5. **Check links**: `bundle exec rake check_links` (if Rake tasks available)
6. **Deploy**: Push to `main` branch (auto-deploys to GitHub Pages)

### Jekyll Build System
- **Layouts**: Custom Jekyll layouts in `_layouts/` (default, spec, guide, example, cookbook)
- **Includes**: Reusable components in `_includes/` (header, footer, breadcrumbs)
- **Assets**: Static CSS/JS in `assets/` directory (no Sass compilation)
- **Output**: Built site in `_site/` directory (excluded from git)
- **Collections**: Markdown files in `_*` directories become HTML pages

### Critical File Locations
- **Configuration**: `_config.yml` (Jekyll settings, collections, navigation)
- **Layouts**: `_layouts/*.html` (page templates)
- **Navigation**: Defined in `_config.yml` under `navigation` key
- **Dependencies**: `Gemfile` (Ruby), `package.json` (Node.js)
- **Deployment**: `.github/workflows/pages.yml` (GitHub Actions)

## Environment Requirements

- **Ruby 3.3+** with Bundler (primary requirement)
- **Gem path**: `$HOME/.local/share/gem/ruby/3.3.0/bin` must be in PATH
- **Node.js 18+** with npm (optional, for validation tools)
- **Git** (for version control and GitHub Pages deployment)

### Setup on Ubuntu/Linux
```bash
# Install Ruby and build tools
sudo apt update && sudo apt install ruby-full build-essential zlib1g-dev

# Install bundler
gem install bundler --user-install

# Add gem path to shell
echo 'export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"' >> ~/.bashrc
source ~/.bashrc
```

## Common Jekyll Workflows

### Adding New Content
```bash
# Add new specification section
# 1. Create file in _specification/ with frontmatter:
---
layout: spec
title: "New Section Title"
order: 9
---

# 2. Test locally
bundle exec jekyll serve --livereload

# 3. Validate build
bundle exec jekyll build
```

### Troubleshooting Jekyll Issues
```bash
# Check Jekyll configuration
bundle exec jekyll doctor

# Clear cache and rebuild
bundle exec jekyll clean
bundle exec jekyll build --verbose

# Check for broken links (if htmlproofer available)
bundle exec htmlproofer ./_site --disable-external

# Monitor Liquid warnings for template conflicts
# (Warnings are expected for code examples using other template syntaxes)
```

### Content Collection Structure
- **`_specification/`** → `/specification/` (Technical docs, ordered by frontmatter `order`)
- **`_guides/`** → `/guides/` (Tutorials with `difficulty` and `time` frontmatter)
- **`_examples/`** → `/examples/` (Complete examples with `outcome_type` and `stack`)
- **`_cookbook/`** → `/cookbook/` (Patterns and recipes with `tags`)

## Important Notes

### Liquid Template Conflicts
Some content files contain code examples using other template syntaxes (Handlebars, GitHub Actions, etc.) which generate Liquid warnings during Jekyll builds. These warnings are **expected and harmless** - they don't break the build or affect the site functionality.

### Gem Path Setup
**Critical**: Always set the gem path in your shell session:
```bash
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"
```
Or add to `~/.bashrc` for persistence.

## ast-grep Usage
You run in an environment where ast-grep (sg) is available; whenever a search requires syntax-aware or structural matching, default to sg --lang rust -p '<pattern>' (or set --lang appropriately) and avoid falling back to text-only tools like rg or grep unless explicitly requested for plain-text search.