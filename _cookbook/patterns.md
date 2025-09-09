---
layout: cookbook
title: "Common OSpec Patterns"
description: "Reusable patterns and best practices for writing effective OSpecs"
tags: ["patterns", "best-practices", "reusable"]
---

# Common OSpec Patterns

## Authentication Patterns

### OAuth 2.0 with Social Providers

```yaml
stack:
  auth: "NextAuth.js"
  providers: "Google, GitHub, Discord"

guardrails:
  human_approval_required: ["auth_provider_changes"]
  
secrets:
  required:
    - "GOOGLE_CLIENT_ID"
    - "GOOGLE_CLIENT_SECRET"
    - "GITHUB_CLIENT_ID"
    - "GITHUB_CLIENT_SECRET"
    - "NEXTAUTH_SECRET"
```

### JWT with Refresh Tokens

```yaml
stack:
  auth: "Custom JWT"
  token_storage: "HttpOnly Cookies"
  
acceptance:
  http_endpoints:
    - path: "/auth/login"
      method: "POST"
      status: 200
    - path: "/auth/refresh"
      method: "POST"
      status: 200
    - path: "/auth/logout"
      method: "POST"
      status: 204
```

## Database Patterns

### Multi-tenant SaaS

```yaml
stack:
  database: "PostgreSQL with Row Level Security"
  orm: "Prisma"
  
metadata:
  patterns:
    - "tenant_isolation"
    - "row_level_security"
    
guardrails:
  security_scan: true
  human_approval_required: ["database_migrations"]
```

### Event Sourcing

```yaml
stack:
  database: "EventStore"
  projections: "PostgreSQL"
  messaging: "RabbitMQ"
  
acceptance:
  performance:
    event_processing_ms: 100
    projection_lag_ms: 500
```

## API Patterns

### RESTful CRUD

```yaml
outcome_type: "api"

acceptance:
  http_endpoints:
    - path: "/api/resources"
      method: "GET"
      status: 200
    - path: "/api/resources"
      method: "POST"
      status: 201
    - path: "/api/resources/{id}"
      method: "GET"
      status: 200
    - path: "/api/resources/{id}"
      method: "PUT"
      status: 200
    - path: "/api/resources/{id}"
      method: "DELETE"
      status: 204
```

### GraphQL with Subscriptions

```yaml
stack:
  api: "GraphQL"
  server: "Apollo Server"
  subscriptions: "WebSockets"
  
acceptance:
  graphql:
    queries: ["users", "posts", "comments"]
    mutations: ["createPost", "updatePost", "deletePost"]
    subscriptions: ["postAdded", "postUpdated"]
```

## Testing Patterns

### BDD Testing

```yaml
acceptance:
  tests:
    - file: "features/*.feature"
      type: "bdd"
      framework: "Cucumber"
    - file: "tests/step_definitions/*.js"
      type: "step_definitions"
      
guardrails:
  min_test_coverage: 0.8
  tests_required: true
```

### Contract Testing

```yaml
acceptance:
  tests:
    - file: "tests/contracts/*.pact.json"
      type: "contract"
      framework: "Pact"
      
scripts:
  test_contracts: "npm run test:contracts"
  publish_contracts: "npm run pact:publish"
```

## Deployment Patterns

### Blue-Green Deployment

```yaml
stack:
  deploy: "AWS ECS with Blue-Green"
  load_balancer: "ALB"
  
scripts:
  deploy_blue: "scripts/deploy-blue.sh"
  deploy_green: "scripts/deploy-green.sh"
  switch_traffic: "scripts/switch-traffic.sh"
  
guardrails:
  human_approval_required: ["production_traffic_switch"]
```

### Canary Releases

```yaml
stack:
  deploy: "Kubernetes with Flagger"
  monitoring: "Prometheus"
  
metadata:
  canary:
    analysis_interval: "1m"
    threshold: 10
    max_weight: 50
    metrics:
      - request_success_rate
      - request_duration
      - error_rate
```

## Monitoring Patterns

### Observability Stack

```yaml
stack:
  logging: "ELK Stack"
  metrics: "Prometheus + Grafana"
  tracing: "Jaeger"
  errors: "Sentry"
  
scripts:
  setup_monitoring: "scripts/setup-monitoring.sh"
  
secrets:
  required:
    - "SENTRY_DSN"
    - "ELASTIC_CLOUD_ID"
    - "ELASTIC_API_KEY"
```

### Health Checks

```yaml
acceptance:
  http_endpoints:
    - path: "/health"
      status: 200
      response_contains: ["status", "ok"]
    - path: "/health/ready"
      status: 200
    - path: "/health/live"
      status: 200
      
monitoring:
  health_check_interval: 30
  timeout: 5
  unhealthy_threshold: 3
```

## Security Patterns

### Zero Trust Architecture

```yaml
guardrails:
  security_scan: true
  dependency_check: true
  license_whitelist: ["MIT", "Apache-2.0"]
  
stack:
  auth: "OAuth 2.0 + OIDC"
  authorization: "OPA (Open Policy Agent)"
  secrets: "HashiCorp Vault"
  tls: "mTLS between services"
```

### API Rate Limiting

```yaml
stack:
  rate_limiting: "Redis + express-rate-limit"
  
metadata:
  rate_limits:
    anonymous: "100 requests per 15 minutes"
    authenticated: "1000 requests per 15 minutes"
    premium: "10000 requests per 15 minutes"
```

## Performance Patterns

### Caching Strategy

```yaml
stack:
  cache_layers:
    - "CloudFlare CDN"
    - "Redis Cache"
    - "In-memory LRU"
    
metadata:
  cache_ttl:
    static_assets: 31536000  # 1 year
    api_responses: 300        # 5 minutes
    user_sessions: 3600       # 1 hour
```

### Async Processing

```yaml
stack:
  queue: "Bull (Redis-backed)"
  workers: "Node.js Workers"
  
acceptance:
  async_jobs:
    - name: "email_notification"
      max_processing_time: 5000
    - name: "image_processing"
      max_processing_time: 30000
    - name: "report_generation"
      max_processing_time: 60000
```

## State Management Patterns

### Event-Driven Architecture

```yaml
stack:
  messaging: "Apache Kafka"
  schema_registry: "Confluent Schema Registry"
  
metadata:
  topics:
    - name: "user-events"
      partitions: 10
      retention_ms: 604800000  # 7 days
    - name: "order-events"
      partitions: 20
      retention_ms: 2592000000  # 30 days
```

### CQRS Pattern

```yaml
stack:
  write_model: "PostgreSQL"
  read_model: "Elasticsearch"
  sync: "Debezium CDC"
  
acceptance:
  consistency:
    eventual_consistency_lag_ms: 1000
    read_after_write: true
```

## Development Patterns

### Monorepo Structure

```yaml
metadata:
  structure: "monorepo"
  packages:
    - "packages/api"
    - "packages/web"
    - "packages/mobile"
    - "packages/shared"
    
scripts:
  setup: "npm install && npm run bootstrap"
  test: "npm run test:all"
  build: "npm run build:all"
```

### Feature Flags

```yaml
stack:
  feature_flags: "LaunchDarkly"
  
metadata:
  flags:
    - key: "new-checkout-flow"
      default: false
      rollout_percentage: 10
    - key: "dark-mode"
      default: true
      rollout_percentage: 100
```

## Best Practices

1. **Keep patterns focused** - Each pattern should solve one specific problem
2. **Document assumptions** - Make prerequisites and constraints clear
3. **Provide examples** - Include working code snippets
4. **Version patterns** - Track changes to patterns over time
5. **Test thoroughly** - Ensure patterns work in real scenarios
6. **Share learnings** - Document what works and what doesn't