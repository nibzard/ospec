---
layout: guide
title: "Getting Started with OSpec"
description: "Learn how to create your first OSpec and build AI-automated outcomes"
difficulty: beginner
time: "15 minutes"
permalink: /guides/getting-started/
---

# Getting Started with OSpec

This guide will walk you through creating your first OSpec and understanding the core concepts.

## Prerequisites

- Basic understanding of YAML
- Familiarity with software development concepts
- Text editor or IDE

## Step 1: Create Your First OSpec

Create a file named `outcome.yaml`:

```yaml
ospec_version: "1.0.0"
id: "hello-api"
name: "Hello World API"
description: "A simple REST API that returns greeting messages"
outcome_type: "api"

acceptance:
  http_endpoints:
    - path: "/"
      status: 200
      method: "GET"
    - path: "/hello"
      status: 200
      method: "GET"
      response_contains: ["Hello", "World"]
  tests:
    - file: "tests/test_api.py"
      type: "unit"
      coverage_threshold: 0.8

stack:
  backend: "FastAPI"
  database: "SQLite"
  deploy: "Docker"
  
guardrails:
  tests_required: true
  min_test_coverage: 0.8
  lint: true
  dependency_check: true
```

## Step 2: Understanding the Structure

### Core Components

**Header Section:**
- `ospec_version`: Specification version you're using
- `id`: Unique identifier for your project
- `name`: Human-readable project name
- `description`: What the project does
- `outcome_type`: Type of project (api, web-app, cli, etc.)

**Acceptance Criteria:**
Defines how to verify the outcome is successful:
- HTTP endpoints that must work
- UX flows that must function
- Tests that must pass
- Performance requirements

**Technology Stack:**
Recommended technologies for implementation:
- Frontend/backend frameworks
- Database systems
- Authentication providers
- Deployment platforms

## Step 3: Validation

Validate your OSpec to ensure it's correctly formatted:

```bash
# Using the online validator
# curl -X POST https://api.ospec.dev/validate \  # API coming soon!
  -H "Content-Type: application/yaml" \
  --data-binary @outcome.yaml

# Using local tools (if installed)
ospec validate outcome.yaml
```

## Step 4: Agent Execution

Once validated, AI agents can use your OSpec to:

1. **Plan** - Break down into tasks
2. **Implement** - Write code and tests
3. **Review** - Check against guardrails
4. **Deploy** - Push to production

### Example Agent Workflow

```bash
# Initialize project from OSpec
ospec init outcome.yaml my-project/

# Agent creates:
# - Project structure
# - Code implementation
# - Test suite
# - Documentation
# - CI/CD pipeline
```

## Step 5: Customization

### Adding Prompts

Create custom prompts for agents:

```yaml
prompts:
  planner: "prompts/planner.md"
  implementer: "prompts/implementer.md"
  reviewer: "prompts/reviewer.md"
```

### Adding Scripts

Include automation scripts:

```yaml
scripts:
  setup: "scripts/setup.sh"
  test: "scripts/test.sh"
  deploy: "scripts/deploy.sh"
```

### Setting Guardrails

Define quality and security requirements:

```yaml
guardrails:
  tests_required: true
  min_test_coverage: 0.8
  lint: true
  type_check: true
  security_scan: true
  license_whitelist: ["MIT", "Apache-2.0", "BSD"]
  human_approval_required: ["production_deploy", "database_migration"]
```

## Best Practices

1. **Start Simple**: Begin with basic requirements, add complexity gradually
2. **Be Specific**: Clear acceptance criteria lead to better outcomes
3. **Use Proven Stacks**: Stick to well-tested technology combinations
4. **Test Everything**: High test coverage ensures reliability
5. **Document Intent**: Help agents understand the "why" not just the "what"

## Common Patterns

### Web Application
```yaml
outcome_type: "web-app"
stack:
  frontend: "Next.js@14"
  backend: "Supabase"
  styling: "TailwindCSS"
  deploy: "Vercel"
```

### REST API
```yaml
outcome_type: "api"
stack:
  backend: "FastAPI"
  database: "PostgreSQL"
  cache: "Redis"
  deploy: "Railway"
```

### CLI Tool
```yaml
outcome_type: "cli"
stack:
  language: "Rust"
  framework: "Clap"
  package: "Cargo"
```

## Next Steps

- [Writing OSpecs →]({{ 'guides/writing-ospecs/' | relative_url }})
- [Stack Recommendations →]({{ 'guides/stacks/' | relative_url }})
- [Example: Shop Website →]({{ 'examples/shop-website/' | relative_url }})
- [Troubleshooting →]({{ 'cookbook/troubleshooting/' | relative_url }})

## Getting Help

- **GitHub Issues**: [github.com/nibzard/ospec/issues](https://github.com/nibzard/ospec/issues)
- **Issues**: [github.com/nibzard/ospec/issues](https://github.com/nibzard/ospec/issues)
- **Community Chat**: Coming soon!