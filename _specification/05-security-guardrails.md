---
layout: spec
title: "Security & Guardrails"
description: "Comprehensive security framework and quality assurance guardrails"
order: 5
redirect_from:
  - /specification/security-guardrails/
---

# Security & Guardrails

OSpec enforces security and quality standards through configurable guardrails that prevent dangerous operations and ensure reliable outcomes.

## Security Framework

### Core Security Principles

1. **Defense in Depth**: Multiple layers of security controls
2. **Least Privilege**: Minimal necessary permissions
3. **Fail Secure**: Default to secure state on errors
4. **Security by Default**: Secure configurations out of the box
5. **Principle of Least Surprise**: Predictable security behavior

### Threat Model

#### Trusted Components
- **OSpec Specification**: Authored by trusted developers
- **Agent Runtime**: Sandboxed execution environment
- **Development Environment**: Isolated from production

#### Untrusted Components
- **Generated Code**: Must be validated before execution
- **External Dependencies**: Require approval and scanning
- **User Input**: Always sanitized and validated
- **Network Requests**: Filtered and rate-limited

#### Attack Vectors
- **Code Injection**: Malicious code in generated output
- **Dependency Confusion**: Malicious packages with similar names
- **Privilege Escalation**: Unauthorized access to system resources
- **Data Exfiltration**: Unauthorized data access or transmission
- **Supply Chain**: Compromised dependencies or tools

## Guardrail Categories

### Code Quality Guardrails

#### Linting
Enforce consistent code style and catch common errors:

```yaml
guardrails:
  lint: true
  lint_config:
    rules:
      - "no-unused-vars"
      - "no-console"
      - "prefer-const"
    max_warnings: 0
    fail_on_error: true
```

#### Type Checking
Prevent type-related runtime errors:

```yaml
guardrails:
  type_check: true
  type_config:
    strict: true
    no_implicit_any: true
    strict_null_checks: true
    strict_function_types: true
```

#### Complexity Limits
Maintain code readability and testability:

```yaml
guardrails:
  complexity_limit: 10
  max_function_length: 50
  max_file_length: 500
  nesting_depth_limit: 4
```

#### Code Coverage
Ensure comprehensive testing:

```yaml
guardrails:
  min_test_coverage: 0.8
  coverage_config:
    exclude_patterns:
      - "tests/**"
      - "**/*.test.*"
      - "mocks/**"
    require_branches: true
    require_functions: true
    require_lines: true
```

### Security Guardrails

#### Dependency Scanning
Identify known vulnerabilities in dependencies:

```yaml
guardrails:
  dependency_check: true
  dependency_config:
    vulnerability_database: "npm-audit"
    severity_threshold: "moderate"
    max_age_days: 30
    auto_fix: true
    exceptions:
      - package: "lodash"
        version: "4.17.20"
        reason: "No fix available, mitigated by input validation"
        expiry: "2024-12-31"
```

#### License Compliance
Ensure only approved licenses are used:

```yaml
guardrails:
  license_whitelist:
    - "MIT"
    - "Apache-2.0"
    - "BSD-3-Clause"
    - "ISC"
  license_config:
    allow_copyleft: false
    require_attribution: true
    check_transitive: true
    exceptions:
      - package: "gpl-library"
        license: "GPL-3.0"
        reason: "Used only in development"
        scope: "devDependencies"
```

#### Static Security Analysis
Automated security scanning of generated code:

```yaml
guardrails:
  security_scan: true
  security_config:
    rules:
      - "sql-injection"
      - "xss-prevention"
      - "insecure-random"
      - "hardcoded-secrets"
      - "unsafe-regex"
    severity_threshold: "medium"
    exclude_files:
      - "tests/**"
      - "mocks/**"
```

#### Secret Detection
Prevent secrets from being committed to code:

```yaml
guardrails:
  secret_scan: true
  secret_config:
    patterns:
      - "password"
      - "api_key"
      - "secret"
      - "token"
      - "private_key"
    entropy_threshold: 4.5
    whitelist_files:
      - ".env.example"
      - "tests/fixtures/fake_secrets.json"
```

### Human Approval Gates

#### High-Risk Operations
Require human review for dangerous operations:

```yaml
guardrails:
  human_approval_required:
    - "production_deploy"
    - "database_migration"
    - "payment_integration"
    - "auth_provider_changes"
    - "data_deletion"
    - "privilege_elevation"
    - "external_api_integration"
    - "infrastructure_changes"
```

#### Approval Workflow
```yaml
approval_config:
  reviewers:
    - role: "security_engineer"
      required_for: ["security_changes", "payment_integration"]
    - role: "senior_developer"
      required_for: ["architecture_changes"]
    - role: "devops_engineer"
      required_for: ["infrastructure_changes"]
  
  approval_rules:
    - any: ["security_engineer", "tech_lead"]
      for: ["moderate_risk"]
    - all: ["security_engineer", "tech_lead", "product_owner"]
      for: ["high_risk"]
  
  timeout_hours: 24
  escalation_hours: 8
  bypass_roles: ["emergency_responder"]
```

## Secrets Management

### Secret Provider Integration
Secure storage and retrieval of sensitive data:

```yaml
secrets:
  provider: "hashicorp-vault"
  config:
    url: "https://vault.company.com"
    auth_method: "kubernetes"
    mount_path: "secret/myapp"
  
  required:
    - key: "database_password"
      path: "database/password"
    - key: "api_key"
      path: "external_services/api_key"
  
  optional:
    - key: "sentry_dsn"
      path: "monitoring/sentry_dsn"
      default: null
```

### Supported Providers

#### HashiCorp Vault
```yaml
secrets:
  provider: "hashicorp-vault"
  config:
    url: "https://vault.example.com"
    auth_method: "token"  # or kubernetes, aws, azure, etc.
    token_path: "/var/secrets/vault-token"
```

#### AWS Secrets Manager
```yaml
secrets:
  provider: "aws-secrets-manager"
  config:
    region: "us-east-1"
    role_arn: "arn:aws:iam::123456789012:role/SecretsRole"
```

#### Azure Key Vault
```yaml
secrets:
  provider: "azure-keyvault"
  config:
    vault_url: "https://myvault.vault.azure.net/"
    tenant_id: "${AZURE_TENANT_ID}"
    client_id: "${AZURE_CLIENT_ID}"
```

#### Kubernetes Secrets
```yaml
secrets:
  provider: "kubernetes"
  config:
    namespace: "default"
    secret_name: "app-secrets"
```

#### Environment Variables (Development Only)
```yaml
secrets:
  provider: "env"
  config:
    file: ".env.local"
    required_prefix: "MYAPP_"
```

### Secret Rotation
Automated secret rotation policies:

```yaml
secrets:
  rotation:
    enabled: true
    policies:
      - secrets: ["database_password"]
        interval_days: 30
        notification_days: 7
      - secrets: ["api_keys"]
        interval_days: 90
        notification_days: 14
```

## Input Validation & Sanitization

### API Input Validation
Comprehensive input validation for all API endpoints:

```yaml
acceptance:
  input_validation:
    - endpoint: "/api/users"
      method: "POST"
      schema: "schemas/user_create.json"
      sanitization:
        - "trim_whitespace"
        - "escape_html"
        - "normalize_unicode"
    
    - endpoint: "/api/search"
      method: "GET"
      parameters:
        - name: "query"
          type: "string"
          max_length: 200
          pattern: "^[a-zA-Z0-9\\s]+$"
        - name: "limit"
          type: "integer"
          min: 1
          max: 100
          default: 20
```

### SQL Injection Prevention
Mandatory use of parameterized queries:

```yaml
guardrails:
  sql_injection_prevention: true
  database_config:
    require_parameterized_queries: true
    forbidden_patterns:
      - "string concatenation in SQL"
      - "dynamic table names"
      - "user input in ORDER BY"
    allowed_orm_methods:
      - "prisma.user.findMany"
      - "db.execute_query"
    forbidden_orm_methods:
      - "prisma.$queryRaw"
      - "db.raw_query"
```

### XSS Prevention
Cross-site scripting protection:

```yaml
guardrails:
  xss_prevention: true
  xss_config:
    content_security_policy:
      default_src: "'self'"
      script_src: "'self' 'unsafe-inline'"
      style_src: "'self' 'unsafe-inline'"
      img_src: "'self' data: https:"
    
    output_encoding:
      html_entities: true
      javascript_escaping: true
      css_escaping: true
      url_encoding: true
    
    input_sanitization:
      allow_html_tags: ["b", "i", "em", "strong"]
      remove_javascript: true
      remove_css_expressions: true
```

## Authentication & Authorization

### Authentication Requirements
Strong authentication patterns:

```yaml
stack:
  auth: "OAuth 2.0 + OIDC"
  
guardrails:
  auth_requirements:
    password_policy:
      min_length: 12
      require_uppercase: true
      require_lowercase: true
      require_numbers: true
      require_symbols: true
      prevent_reuse_count: 5
    
    session_management:
      timeout_minutes: 30
      absolute_timeout_hours: 8
      secure_cookie: true
      httponly_cookie: true
      samesite_strict: true
    
    multi_factor_auth:
      required_for: ["admin_users", "sensitive_operations"]
      methods: ["totp", "sms", "push_notification"]
```

### Authorization Patterns
Role-based and attribute-based access control:

```yaml
acceptance:
  authorization:
    model: "rbac"  # or abac
    
    roles:
      - name: "admin"
        permissions: ["*"]
      - name: "user"
        permissions: ["read:own_profile", "update:own_profile"]
      - name: "moderator"
        permissions: ["read:all_posts", "update:all_posts", "delete:inappropriate_posts"]
    
    resources:
      - name: "user_profile"
        actions: ["read", "update", "delete"]
        ownership_field: "user_id"
      - name: "admin_panel"
        actions: ["access"]
        roles_required: ["admin"]
```

## Monitoring & Alerting

### Security Event Monitoring
Track security-relevant events:

```yaml
guardrails:
  security_monitoring:
    events:
      - "failed_authentication_attempts"
      - "privilege_escalation_attempts"
      - "unusual_data_access_patterns"
      - "admin_actions"
      - "configuration_changes"
    
    thresholds:
      failed_login_attempts: 5
      rapid_api_requests: 100
      large_data_downloads: "100MB"
    
    alert_channels:
      - "security_team_slack"
      - "security_incidents_email"
```

### Quality Metrics
Track code quality and security posture:

```yaml
monitoring:
  metrics:
    security:
      - "vulnerability_count_by_severity"
      - "secret_scan_violations"
      - "dependency_age_distribution"
      - "security_test_coverage"
    
    quality:
      - "code_coverage_percentage"
      - "complexity_distribution"
      - "test_pass_rate"
      - "lint_violation_count"
    
    alerts:
      - metric: "high_severity_vulnerabilities"
        threshold: "> 0"
        severity: "critical"
      - metric: "code_coverage"
        threshold: "< 0.8"
        severity: "warning"
```

## Incident Response

### Security Incident Workflow
Automated response to security events:

```yaml
incident_response:
  triggers:
    - event: "high_severity_vulnerability"
      actions:
        - "disable_affected_components"
        - "notify_security_team"
        - "create_incident_ticket"
    
    - event: "secret_leaked"
      actions:
        - "revoke_compromised_secret"
        - "rotate_related_secrets"
        - "audit_access_logs"
        - "escalate_to_security_team"
  
  escalation:
    levels:
      - name: "low"
        response_time_minutes: 60
        assignees: ["on_call_developer"]
      - name: "medium"
        response_time_minutes: 30
        assignees: ["security_engineer", "tech_lead"]
      - name: "high"
        response_time_minutes: 15
        assignees: ["security_team", "engineering_manager"]
      - name: "critical"
        response_time_minutes: 5
        assignees: ["incident_commander", "security_team", "cto"]
```

## Compliance & Auditing

### Audit Trail
Comprehensive logging for compliance:

```yaml
guardrails:
  audit_logging:
    enabled: true
    events:
      - "code_generation"
      - "configuration_changes"
      - "security_scan_results"
      - "human_approvals"
      - "deployment_events"
    
    retention_days: 2555  # 7 years
    
    storage:
      provider: "aws_cloudtrail"
      encryption: "AES-256"
      immutable: true
    
    access_control:
      read_roles: ["auditor", "security_team", "compliance_officer"]
      admin_roles: ["security_admin"]
```

### Compliance Frameworks
Support for common compliance standards:

```yaml
compliance:
  frameworks:
    - "SOC2_TYPE2"
    - "PCI_DSS_v3.2.1"
    - "GDPR"
    - "HIPAA"
  
  controls:
    soc2:
      - id: "CC6.1"
        description: "Logical Access Controls"
        implementation: "rbac_authorization"
        evidence: "access_logs"
      - id: "CC7.2"  
        description: "System Monitoring"
        implementation: "security_monitoring"
        evidence: "monitoring_logs"
    
    pci_dss:
      - requirement: "1.1"
        description: "Firewall Configuration"
        implementation: "network_segmentation"
      - requirement: "3.4"
        description: "Cryptographic Protection"
        implementation: "encryption_at_rest"
```

## Best Practices

### Guardrail Configuration
1. **Start Strict**: Begin with strict settings, relax as needed
2. **Environment-Specific**: Different rules for dev/staging/prod
3. **Gradual Rollout**: Introduce new guardrails incrementally
4. **Regular Review**: Periodically assess and update rules

### Security Testing
1. **Shift Left**: Security testing early in development
2. **Automate Everything**: No manual security checks
3. **Continuous Scanning**: Regular vulnerability assessments
4. **Penetration Testing**: Professional security audits

### Incident Management
1. **Preparation**: Have incident response plans ready
2. **Detection**: Comprehensive monitoring and alerting
3. **Response**: Quick containment and remediation
4. **Recovery**: Restore services safely
5. **Lessons Learned**: Post-incident reviews and improvements

## Integration Examples

### CI/CD Pipeline Integration
```yaml
# .github/workflows/ospec-guardrails.yml
name: OSpec Guardrails
on: [push, pull_request]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Security Scan
        uses: ospec/security-action@v1
        with:
          ospec-file: "outcome.yaml"
          fail-on-high: true
      - name: Upload Results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: security-results.sarif
```

### Docker Integration
```dockerfile
FROM ospec/runtime:latest

# Copy guardrail configuration
COPY outcome.yaml /app/
COPY .guardrails/ /app/.guardrails/

# Run security validation
RUN ospec validate --security-check /app/outcome.yaml

# Continue with application setup
COPY . /app/
RUN ospec build /app/
```

This comprehensive security and guardrails framework ensures that OSpec-generated software maintains high security and quality standards while providing flexibility for different environments and requirements.