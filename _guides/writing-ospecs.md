---
layout: guide
title: "Writing Effective OSpecs"
description: "Best practices for creating OSpecs that eliminate decision paralysis for AI coding agents"
difficulty: intermediate
time: "30 minutes"
order: 2
---

# Writing Effective OSpecs

A good OSpec eliminates the thousands of micro-decisions that slow down AI coding agents. This guide covers best practices for creating specifications that provide clear direction on what to build and which proven tech stacks to use.

## Core Principles

### 1. Eliminate Decision Paralysis

The most important job of an OSpec is to eliminate the endless "what should I use?" questions that slow down AI coding agents:

**Decision Paralysis Examples:**
- "Postgres or SQLite or MongoDB?"
- "npm or yarn or pnpm?"  
- "Express or FastAPI or Rails?"
- "React or Vue or Svelte?"
- "Tailwind or styled-components or CSS modules?"

**OSpec Solution:**
```yaml
stack:
  # Specific version
  frontend: "Next.js@14"
  
  # Proven combination that works well together
  backend: "Supabase"         
  styling: "TailwindCSS"
  
  # Agent preference - no decision paralysis
  package_manager: "npm"
  
  # Integrated workflow
  deploy: "Vercel"
  
metadata:
  # Agent-specific optimization
  optimized_for: ["claude-code"]
  rationale: "This stack minimizes setup complexity and maximizes development velocity for web apps"
```

### 2. Outcome-First Thinking

Start with the end in mind. Define what success looks like before diving into implementation details.

**Good Example:**
```yaml
name: "Customer Support Chatbot"
description: "AI-powered chatbot that handles common customer inquiries with 90%+ accuracy and escalates complex issues to human agents"

acceptance:
  user_satisfaction: 4.2  # out of 5
  resolution_rate: 0.9
  escalation_rate: 0.15
  response_time_ms: 2000
```

**Poor Example:**
```yaml
name: "Python Chat Application"  
description: "A chat app built with Python and React"
# Vague, technology-focused, no measurable outcomes
```

### 2. Testable Acceptance Criteria

Every outcome must be objectively verifiable. Use specific, measurable criteria.

**Testable Criteria:**
```yaml
acceptance:
  http_endpoints:
    - path: "/api/users"
      method: "GET"
      status: 200
      response_time_ms: 100
      response_schema: "schemas/user_list.json"
  
  user_flows:
    - name: "user_registration"
      steps:
        - visit_signup_page
        - enter_valid_email
        - enter_secure_password
        - click_signup_button
        - receive_confirmation_email
        - verify_email_address
      success_rate: 0.95
```

**Non-Testable Criteria:**
```yaml
acceptance:
  - "Users should be happy"
  - "The system should be fast"
  - "It should look good"
```

### 3. Right Level of Detail

Balance specificity with flexibility. Be specific about outcomes, flexible about implementation.

**Good Balance:**
```yaml
stack:
  database: "Relational (PostgreSQL preferred)"
  auth: "OAuth 2.0 compatible"
  api: "RESTful with OpenAPI spec"

acceptance:
  authentication:
    providers: ["Google", "GitHub"]
    session_duration_hours: 24
    password_requirements:
      min_length: 12
      require_mixed_case: true
      require_numbers: true
```

**Too Rigid:**
```yaml
stack:
  database: "PostgreSQL 14.9 exactly"
  orm: "SQLAlchemy 2.0.15"
  auth: "Flask-Login 0.6.2"
# Overly prescriptive, limits agent flexibility
```

**Too Vague:**
```yaml
stack:
  database: "Something modern"
  auth: "Whatever works"
# Too ambiguous for reliable automation
```

## Acceptance Criteria Patterns

### HTTP API Patterns

```yaml
acceptance:
  http_endpoints:
    # Basic endpoint validation
    - path: "/api/health"
      method: "GET"
      status: 200
      response_contains: ["status", "ok"]
    
    # Authenticated endpoint
    - path: "/api/profile" 
      method: "GET"
      status: 200
      auth_required: true
      response_schema: "schemas/user_profile.json"
    
    # CRUD operations
    - path: "/api/posts"
      method: "POST"
      status: 201
      auth_required: true
      request_schema: "schemas/post_create.json"
      response_schema: "schemas/post_response.json"
    
    # Error handling
    - path: "/api/posts/invalid-id"
      method: "GET"
      status: 404
      response_contains: ["error", "Post not found"]
```

### User Experience Flows

```yaml
acceptance:
  ux_flows:
    - name: "purchase_flow"
      description: "Complete e-commerce purchase"
      steps:
        - action: "browse_products"
          success_indicators: ["products_displayed", "search_works"]
        - action: "add_to_cart"
          success_indicators: ["cart_updated", "quantity_correct"]
        - action: "checkout"
          success_indicators: ["payment_form_displayed"]
        - action: "complete_payment"
          success_indicators: ["order_confirmation", "email_sent"]
      completion_time_max_seconds: 120
      success_rate_threshold: 0.95
      abandonment_rate_max: 0.1
```

### Performance Requirements

```yaml
acceptance:
  performance:
    response_times:
      api_endpoints_p95_ms: 200
      page_load_p95_ms: 1500
      database_queries_p95_ms: 50
    
    throughput:
      concurrent_users: 1000
      requests_per_second: 500
      transactions_per_second: 100
    
    resource_usage:
      memory_usage_mb_max: 512
      cpu_usage_percent_max: 70
      disk_space_gb_max: 10
    
    availability:
      uptime_percentage: 99.9
      max_downtime_minutes_per_month: 43
```

## Stack Selection Strategies

### Technology Decision Framework

1. **Team Expertise**: Match stack to team skills
2. **Project Requirements**: Performance, scalability, security
3. **Time Constraints**: Proven vs. experimental technologies
4. **Maintenance Burden**: Long-term support considerations
5. **Integration Needs**: Existing systems compatibility

### Common Stack Patterns

#### Rapid Prototyping Stack
```yaml
stack:
  frontend: "Next.js@14"
  backend: "Supabase"
  styling: "TailwindCSS"
  auth: "Supabase Auth"
  deploy: "Vercel"
  
# Pros: Fast development, managed services, good defaults
# Cons: Vendor lock-in, less customization
# Best for: MVPs, small teams, quick validation
```

#### Enterprise Application Stack
```yaml
stack:
  frontend: "React@18 with TypeScript"
  backend: "Node.js with Express"
  database: "PostgreSQL"
  cache: "Redis"
  auth: "Auth0"
  monitoring: "Datadog"
  deploy: "AWS EKS"

# Pros: Scalable, customizable, enterprise support
# Cons: More complex, requires DevOps expertise
# Best for: Large teams, complex requirements, long-term projects
```

#### High-Performance API Stack
```yaml
stack:
  api: "Rust with Axum"
  database: "PostgreSQL with connection pooling"
  cache: "Redis Cluster"
  message_queue: "Apache Kafka"
  deploy: "Kubernetes"
  monitoring: "Prometheus + Grafana"

# Pros: Maximum performance, resource efficiency
# Cons: Steeper learning curve, fewer developers
# Best for: High-traffic APIs, resource-constrained environments
```

#### Mobile-First Stack
```yaml
stack:
  mobile: "React Native"
  backend: "Firebase"
  auth: "Firebase Auth"
  database: "Firestore"
  push_notifications: "Firebase Cloud Messaging"
  analytics: "Firebase Analytics"

# Pros: Cross-platform, integrated ecosystem
# Cons: Platform limitations, vendor lock-in
# Best for: Mobile-first apps, small teams, consumer apps
```

## Guardrails & Quality Standards

### Security-First Configuration

```yaml
guardrails:
  # Code quality
  tests_required: true
  min_test_coverage: 0.8
  lint: true
  type_check: true
  
  # Security scanning
  security_scan: true
  dependency_check: true
  secret_scan: true
  
  # License compliance
  license_whitelist: ["MIT", "Apache-2.0", "BSD-3-Clause"]
  
  # Human oversight for high-risk changes
  human_approval_required:
    - "authentication_changes"
    - "payment_processing"
    - "data_migration"
    - "production_deployment"
    - "security_configuration"

secrets:
  provider: "vault://production"
  required:
    - "DATABASE_PASSWORD"
    - "JWT_SECRET"
    - "API_KEYS"
  
  rotation_policy:
    database_password: 30  # days
    api_keys: 90
    jwt_secret: 365
```

### Progressive Quality Gates

```yaml
# Different standards for different environments
guardrails:
  development:
    min_test_coverage: 0.6
    lint: "warn"
    security_scan: "warn"
  
  staging:
    min_test_coverage: 0.8
    lint: "error"
    security_scan: "error"
    performance_regression_threshold: 0.1
  
  production:
    min_test_coverage: 0.9
    lint: "block"
    security_scan: "block"
    human_approval_required: true
    rollback_capability: true
    monitoring_alerts: true
```

## Documentation & Context

### Agent-Friendly Documentation

Provide context that helps agents understand intent and constraints:

```yaml
prompts:
  specifier: |
    You are converting user requirements into OSpec format.
    Our team prefers TypeScript over JavaScript.
    We use PostgreSQL for all production databases.
    We have existing auth infrastructure with Auth0.
    Always include comprehensive error handling.
    
  implementer: |
    Follow our coding standards:
    - Use functional programming patterns where possible
    - Include JSDoc comments for all public functions
    - Write tests for all business logic
    - Use proper error types, not generic Error objects
    - Log all external API calls with request/response details
    
  reviewer: |
    Focus on these review areas:
    1. Security: Input validation, auth checks, data sanitization
    2. Performance: Database queries, caching, async operations
    3. Reliability: Error handling, retry logic, circuit breakers
    4. Maintainability: Code organization, documentation, tests
```

### Context Files

Include additional context files:

```yaml
metadata:
  context_files:
    - "docs/architecture.md"
    - "docs/coding_standards.md"
    - "docs/security_guidelines.md"
    - "examples/reference_implementation.md"
  
  related_projects:
    - name: "User Service"
      repo: "github.com/company/user-service"
      integration_points: ["authentication", "user_profiles"]
    
    - name: "Payment Gateway"
      repo: "github.com/company/payment-gateway"
      integration_points: ["payment_processing", "webhooks"]
```

## Common Patterns & Templates

### Microservice Template

```yaml
ospec_version: "1.0.0"
id: "{{service-name}}-service"
name: "{{ServiceName}} Service"
description: "Microservice for {{domain}} operations"
outcome_type: "api"

acceptance:
  http_endpoints:
    - path: "/health"
      status: 200
    - path: "/metrics"
      status: 200
    - path: "/{{resource}}"
      method: "GET"
      status: 200
      auth_required: true

stack:
  framework: "Express.js with TypeScript"
  database: "PostgreSQL"
  cache: "Redis"
  deploy: "Docker + Kubernetes"
  monitoring: "Prometheus + Grafana"

guardrails:
  tests_required: true
  min_test_coverage: 0.85
  security_scan: true
  human_approval_required: ["production_deploy"]
```

### CLI Tool Template

```yaml
ospec_version: "1.0.0"
id: "{{tool-name}}-cli"
name: "{{ToolName}} CLI"
description: "Command-line tool for {{purpose}}"
outcome_type: "cli"

acceptance:
  commands:
    - name: "{{tool-name}} --help"
      exit_code: 0
      output_contains: ["Usage:", "Options:"]
    
    - name: "{{tool-name}} --version"
      exit_code: 0
      output_format: "semver"
    
    - name: "{{tool-name}} {{primary-command}}"
      exit_code: 0
      performance:
        max_execution_time_ms: 5000

stack:
  language: "Rust"
  cli_framework: "clap"
  config: "serde with TOML"
  packaging: "cargo"

guardrails:
  tests_required: true
  min_test_coverage: 0.8
  cross_platform: true
  binary_size_limit_mb: 50
```

## Validation & Testing

### Continuous Validation

```yaml
# Validate your OSpec as you develop
validation:
  schema_check: true
  stack_compatibility: true
  acceptance_criteria_feasibility: true
  
  automated_checks:
    - "ospec validate outcome.yaml"
    - "ospec test-acceptance outcome.yaml"
    - "ospec estimate-effort outcome.yaml"
```

### A/B Testing Specifications

```yaml
# Test different approaches
variants:
  - id: "react-frontend"
    stack:
      frontend: "React"
      bundler: "Webpack"
    
  - id: "vue-frontend"
    stack:
      frontend: "Vue.js"
      bundler: "Vite"

evaluation_criteria:
  - development_speed
  - bundle_size
  - performance_metrics
  - developer_satisfaction
```

## Troubleshooting Common Issues

### 1. Vague Requirements
**Problem**: "Build a social media app"
**Solution**: Ask specific questions
- What are the core features? (posts, comments, DMs?)
- Who are the users? (consumers, businesses, specific demographics?)
- What's the scale? (100 users or 100,000?)
- What makes this different from existing solutions?

### 2. Over-Engineering
**Problem**: Specifying complex architecture for simple needs
**Solution**: Start simple, add complexity incrementally
```yaml
# Start with this
stack:
  backend: "FastAPI"
  database: "SQLite"
  deploy: "Single server"

# Not this for a prototype
stack:
  backend: "Microservices with Kubernetes"
  database: "Distributed PostgreSQL cluster"
  message_queue: "Apache Kafka"
  service_mesh: "Istio"
```

### 3. Untestable Acceptance Criteria
**Problem**: "Users should love the interface"
**Solution**: Define measurable proxies
```yaml
acceptance:
  user_experience:
    user_satisfaction_score: 4.0  # out of 5
    task_completion_rate: 0.9
    average_session_duration_minutes: 15
    bounce_rate_max: 0.3
```

### 4. Technology Lock-in
**Problem**: Specifying exact versions without flexibility
**Solution**: Use ranges and alternatives
```yaml
stack:
  database: "PostgreSQL 14+" # Allow newer versions
  alternatives: ["MySQL 8+", "SQLite for development"]
  
  frontend: "React 18+"
  alternatives: ["Vue.js 3+", "Svelte 4+"]
```

## Advanced Techniques

### Conditional Logic

```yaml
# Adapt based on context
stack:
  database: >
    {% raw %}{{#if team_experience.postgresql}}
      "PostgreSQL"
    {{else if team_experience.mongodb}}
      "MongoDB"
    {{else}}
      "SQLite" 
    {{/if}}{% endraw %}

acceptance:
  performance:
    response_time_ms: >
      {% raw %}{{#if expected_users > 10000}}
        50
      {{else if expected_users > 1000}}
        100
      {{else}}
        200
      {{/if}}{% endraw %}
```

### Environment-Specific Configuration

```yaml
environments:
  development:
    stack:
      database: "SQLite"
      deploy: "local"
    guardrails:
      tests_required: false
  
  staging:
    stack:
      database: "PostgreSQL"
      deploy: "Docker"
    guardrails:
      tests_required: true
      min_test_coverage: 0.7
  
  production:
    stack:
      database: "PostgreSQL with replicas"
      deploy: "Kubernetes"
    guardrails:
      tests_required: true
      min_test_coverage: 0.9
      human_approval_required: true
```

### Dependency Management

```yaml
dependencies:
  internal:
    - name: "user-service"
      version: "^2.1.0"
      endpoint: "${USER_SERVICE_URL}"
      
  external:
    - name: "stripe-api"
      version: "2023-10-16"
      rate_limits:
        requests_per_second: 100
      
  optional:
    - name: "analytics-service"
      fallback: "local_logging"
      timeout_ms: 1000
```

## Best Practices Summary

1. **Start with Outcomes**: Define success criteria first
2. **Be Specific**: Use measurable, testable requirements
3. **Allow Flexibility**: Avoid over-constraining implementation
4. **Think Long-term**: Consider maintenance and evolution
5. **Include Context**: Help agents understand the "why"
6. **Validate Early**: Check feasibility before implementation
7. **Iterate Frequently**: Refine based on results
8. **Document Decisions**: Explain trade-offs and constraints
9. **Plan for Failure**: Include error handling and recovery
10. **Security First**: Build in security from the beginning

## Common Anti-Patterns to Avoid

- ❌ Technology-driven specifications ("Build with React")
- ❌ Unmeasurable success criteria ("Make it user-friendly")
- ❌ Over-prescriptive implementation details
- ❌ Ignoring non-functional requirements
- ❌ Single point of failure designs
- ❌ Hardcoded configuration values
- ❌ Missing error handling scenarios
- ❌ Inadequate test coverage requirements
- ❌ No consideration for monitoring/observability
- ❌ Unclear acceptance criteria

By following these guidelines, you'll create OSpecs that consistently lead to successful, maintainable, and secure automated outcomes.