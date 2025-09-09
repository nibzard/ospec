---
layout: cookbook
title: "Security Recipes"
description: "Security patterns, configurations, and best practices for OSpec projects"
tags: ["security", "authentication", "encryption", "compliance"]
category: "security"
difficulty: "advanced"
---

# Security Recipes

Essential security patterns and configurations to build secure OSpec projects from the ground up.

## Authentication Patterns

### OAuth 2.0 + OIDC Implementation

```yaml
# Comprehensive OAuth configuration
authentication:
  provider: "custom_oauth"
  
  oauth2:
    authorization_code_flow: true
    pkce_enabled: true  # Proof Key for Code Exchange
    
    providers:
      google:
        client_id: "{{secrets.GOOGLE_CLIENT_ID}}"
        client_secret: "{{secrets.GOOGLE_CLIENT_SECRET}}"
        scopes: ["openid", "profile", "email"]
        
      github:
        client_id: "{{secrets.GITHUB_CLIENT_ID}}"
        client_secret: "{{secrets.GITHUB_CLIENT_SECRET}}"
        scopes: ["user:email", "read:user"]
        
      azure_ad:
        client_id: "{{secrets.AZURE_CLIENT_ID}}"
        client_secret: "{{secrets.AZURE_CLIENT_SECRET}}"
        tenant_id: "{{secrets.AZURE_TENANT_ID}}"
        scopes: ["openid", "profile", "email"]
  
  jwt_tokens:
    algorithm: "RS256"  # Asymmetric signing
    issuer: "https://auth.yourapp.com"
    audience: "https://api.yourapp.com"
    
    access_token:
      expires_in_seconds: 900  # 15 minutes
      
    refresh_token:
      expires_in_seconds: 2592000  # 30 days
      rotation_enabled: true
      
    id_token:
      expires_in_seconds: 3600  # 1 hour
      
  session_management:
    cookie_settings:
      secure: true
      http_only: true
      same_site: "strict"
      domain: ".yourapp.com"
      
    session_timeout: 28800  # 8 hours
    concurrent_sessions_limit: 3
    
  security_headers:
    strict_transport_security: "max-age=31536000; includeSubDomains"
    content_security_policy: "default-src 'self'; script-src 'self' 'unsafe-inline'"
    x_frame_options: "DENY"
    x_content_type_options: "nosniff"
```

### Multi-Factor Authentication (MFA)

```yaml
# MFA configuration
multi_factor_auth:
  required_for:
    - "admin_users"
    - "privileged_actions"
    - "production_deployments"
    
  factors:
    totp:
      enabled: true
      issuer: "YourApp"
      digits: 6
      period: 30
      
    sms:
      enabled: true
      provider: "twilio"
      rate_limit: 3  # per hour
      
    email:
      enabled: true
      rate_limit: 5  # per hour
      
    hardware_keys:
      enabled: true
      fido2_webauthn: true
      
  backup_codes:
    enabled: true
    count: 10
    single_use: true
    
  recovery:
    admin_override: true
    support_verification: true
    audit_logging: true
```

### Single Sign-On (SSO) Integration

```yaml
# Enterprise SSO configuration
sso:
  protocol: "SAML2"  # or OIDC
  
  identity_providers:
    corporate_ad:
      metadata_url: "{{secrets.SAML_METADATA_URL}}"
      certificate: "{{secrets.SAML_CERTIFICATE}}"
      
      attribute_mapping:
        email: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
        groups: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/group"
        
    okta:
      domain: "yourcompany.okta.com"
      client_id: "{{secrets.OKTA_CLIENT_ID}}"
      client_secret: "{{secrets.OKTA_CLIENT_SECRET}}"
      
  just_in_time_provisioning:
    enabled: true
    default_role: "user"
    group_mapping:
      "IT-Admin": "admin"
      "IT-Developer": "developer"
      "IT-ReadOnly": "viewer"
```

## Authorization Patterns

### Role-Based Access Control (RBAC)

```yaml
# RBAC implementation
authorization:
  model: "rbac"
  
  roles:
    super_admin:
      permissions: ["*"]
      inherits: []
      
    admin:
      permissions:
        - "users:*"
        - "projects:*"
        - "settings:read,write"
      inherits: []
      
    project_manager:
      permissions:
        - "projects:read,write,create"
        - "users:read"
        - "reports:read"
      inherits: ["user"]
      
    developer:
      permissions:
        - "projects:read,write"
        - "deployments:read"
        - "logs:read"
      inherits: ["user"]
      
    user:
      permissions:
        - "profile:read,write"
        - "notifications:read"
      inherits: []
  
  # Dynamic permissions based on context
  contextual_permissions:
    project_owner:
      condition: "user.id == project.owner_id"
      permissions:
        - "project:delete"
        - "project:transfer"
        
    team_member:
      condition: "user.id in project.team_members"
      permissions:
        - "project:read,write"
        - "project:deploy"
```

### Attribute-Based Access Control (ABAC)

```yaml
# Advanced ABAC configuration
authorization:
  model: "abac"
  policy_engine: "open_policy_agent"
  
  attributes:
    subject:
      - "user.id"
      - "user.department"
      - "user.clearance_level"
      - "user.location"
      
    resource:
      - "resource.type"
      - "resource.classification"
      - "resource.owner"
      - "resource.project"
      
    action:
      - "action.type"
      - "action.risk_level"
      
    environment:
      - "time.hour"
      - "network.location"
      - "device.trusted"
      
  policies:
    high_security_data:
      rule: |
        allow if {
          input.subject.clearance_level >= input.resource.classification
          input.environment.network.location == "corporate"
          input.environment.time.hour >= 9
          input.environment.time.hour <= 17
        }
        
    emergency_access:
      rule: |
        allow if {
          input.subject.role == "incident_responder"
          input.environment.emergency_mode == true
          input.action.type in ["read", "execute"]
        }
```

## Data Protection

### Encryption at Rest

```yaml
# Encryption configuration
encryption:
  at_rest:
    database:
      enabled: true
      algorithm: "AES-256-GCM"
      key_management: "aws_kms"
      key_rotation: "annual"
      
      table_level_encryption:
        users: "AES-256-GCM"
        payments: "AES-256-GCM"
        audit_logs: "AES-256-GCM"
        
    file_storage:
      enabled: true
      algorithm: "AES-256-CBC"
      key_per_file: true
      
    backups:
      enabled: true
      algorithm: "AES-256-GCM"
      key_escrow: true
      
  at_transit:
    api_communications:
      tls_version: "1.3"
      cipher_suites: ["TLS_AES_256_GCM_SHA384"]
      certificate_pinning: true
      
    database_connections:
      ssl_mode: "require"
      ssl_cert_verification: true
      
    internal_services:
      mutual_tls: true
      service_mesh_encryption: true
      
  key_management:
    provider: "aws_kms"  # or hashicorp_vault, azure_keyvault
    
    key_policies:
      rotation_schedule: "annual"
      multi_region_keys: true
      audit_logging: true
      
    access_control:
      key_usage_permissions: "role_based"
      cross_account_access: false
      deletion_protection: true
```

### Data Classification and Handling

```yaml
# Data classification system
data_classification:
  levels:
    public:
      encryption_required: false
      access_control: "none"
      retention_days: 2555  # 7 years
      
    internal:
      encryption_required: true
      access_control: "authentication_required"
      retention_days: 1825  # 5 years
      
    confidential:
      encryption_required: true
      access_control: "authorization_required"
      retention_days: 365   # 1 year
      masking_required: true
      
    restricted:
      encryption_required: true
      access_control: "high_privilege_required"
      retention_days: 90
      masking_required: true
      tokenization: true
      
  automatic_classification:
    enabled: true
    ml_model: "data_classification_model_v2"
    
    patterns:
      - pattern: "\\b\\d{3}-\\d{2}-\\d{4}\\b"
        classification: "restricted"  # SSN
        action: "tokenize"
        
      - pattern: "\\b\\d{4}[\\s-]?\\d{4}[\\s-]?\\d{4}[\\s-]?\\d{4}\\b"
        classification: "restricted"  # Credit card
        action: "tokenize"
        
      - pattern: "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b"
        classification: "confidential"  # Email
        action: "mask"
```

### Data Masking and Tokenization

```yaml
# Data privacy protection
data_privacy:
  masking:
    strategies:
      static_masking:
        enabled: true
        environments: ["development", "testing"]
        
      dynamic_masking:
        enabled: true
        role_based: true
        
      format_preserving:
        enabled: true
        algorithms: ["FFX", "FPE"]
        
    rules:
      email_addresses:
        method: "partial_mask"
        pattern: "***@domain.com"
        
      phone_numbers:
        method: "format_preserving"
        preserve_format: true
        
      names:
        method: "synthetic_data"
        maintain_demographics: true
        
  tokenization:
    provider: "internal"  # or external tokenization service
    
    token_formats:
      credit_cards:
        format: "preserve_last_four"
        vault: "secure_vault"
        
      ssn:
        format: "random_alphanumeric"
        length: 11
        vault: "secure_vault"
        
    vault_security:
      encryption: "AES-256-GCM"
      access_logging: true
      key_rotation: "quarterly"
```

## Network Security

### Zero Trust Network Architecture

```yaml
# Zero trust implementation
zero_trust:
  principles:
    never_trust_always_verify: true
    least_privilege_access: true
    assume_breach: true
    
  network_segmentation:
    micro_segmentation: true
    software_defined_perimeter: true
    
    zones:
      dmz:
        trust_level: "untrusted"
        allowed_protocols: ["https", "dns"]
        
      application:
        trust_level: "limited"
        allowed_protocols: ["https", "grpc"]
        
      database:
        trust_level: "restricted"
        allowed_protocols: ["postgresql", "redis"]
        
  identity_verification:
    continuous_authentication: true
    device_trust: true
    location_awareness: true
    behavioral_analytics: true
    
  access_policies:
    default_deny: true
    context_aware: true
    risk_based: true
    
    policy_engine: "open_policy_agent"
    policy_as_code: true
```

### Network Monitoring and Intrusion Detection

```yaml
# Network security monitoring
network_security:
  intrusion_detection:
    network_ids: true
    host_ids: true
    
    signatures:
      update_frequency: "daily"
      custom_rules: true
      
    anomaly_detection:
      ml_based: true
      baseline_learning: 30  # days
      sensitivity: "medium"
      
  traffic_analysis:
    deep_packet_inspection: true
    flow_analysis: true
    dns_monitoring: true
    
    behavioral_analysis:
      user_behavior: true
      entity_behavior: true
      
  threat_intelligence:
    feeds:
      - "commercial_threat_feed"
      - "open_source_threat_feed"
      - "government_threat_feed"
      
    ioc_matching: true
    threat_hunting: true
    
  response_automation:
    auto_blocking: true
    quarantine_capability: true
    incident_escalation: true
```

## Application Security

### Input Validation and Sanitization

```yaml
# Input security configuration
input_security:
  validation:
    strict_typing: true
    length_limits: true
    character_whitelisting: true
    
    rules:
      email:
        pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        max_length: 254
        
      password:
        min_length: 12
        require_uppercase: true
        require_lowercase: true
        require_numbers: true
        require_special_chars: true
        
      username:
        pattern: "^[a-zA-Z0-9._-]{3,30}$"
        reserved_words: ["admin", "root", "system"]
        
  sanitization:
    html_sanitization: true
    sql_injection_prevention: true
    xss_prevention: true
    
    libraries:
      html_purifier: true
      dompurify: true
      
  rate_limiting:
    per_ip: 1000  # requests per hour
    per_user: 10000  # requests per hour
    per_endpoint: 100  # requests per minute
    
    progressive_delays: true
    captcha_trigger: true
```

### API Security

```yaml
# API security configuration
api_security:
  authentication:
    oauth2_bearer_tokens: true
    api_keys: true
    mutual_tls: true
    
  authorization:
    scope_based: true
    rate_limiting: true
    quota_management: true
    
  security_headers:
    cors:
      allowed_origins: ["https://app.yourcompany.com"]
      allowed_methods: ["GET", "POST", "PUT", "DELETE"]
      allowed_headers: ["Authorization", "Content-Type"]
      credentials: true
      
    content_type: "application/json"
    x_api_version: "v1"
    
  request_validation:
    schema_validation: true
    request_signing: true
    replay_attack_prevention: true
    
  response_security:
    data_filtering: true
    error_message_sanitization: true
    response_compression: true
    
  api_gateway:
    request_transformation: true
    response_transformation: true
    threat_protection: true
    analytics: true
```

### Secure Code Practices

```yaml
# Secure development configuration
secure_development:
  static_analysis:
    tools:
      - "sonarqube"
      - "checkmarx"
      - "veracode"
      
    scan_frequency: "every_commit"
    quality_gates: true
    
  dynamic_analysis:
    tools:
      - "owasp_zap"
      - "burp_suite"
      
    scan_frequency: "nightly"
    automated_testing: true
    
  dependency_scanning:
    vulnerability_scanning: true
    license_compliance: true
    outdated_dependency_detection: true
    
    tools:
      - "snyk"
      - "dependabot"
      - "whitesource"
      
  secrets_management:
    no_hardcoded_secrets: true
    secret_scanning: true
    
    tools:
      - "truffelhog"
      - "gitleaks"
      - "detect-secrets"
      
  code_review:
    mandatory_reviews: true
    security_focused_reviews: true
    automated_security_checks: true
```

## Compliance and Auditing

### GDPR Compliance

```yaml
# GDPR compliance configuration
gdpr_compliance:
  data_protection_principles:
    lawfulness_fairness_transparency: true
    purpose_limitation: true
    data_minimisation: true
    accuracy: true
    storage_limitation: true
    integrity_confidentiality: true
    accountability: true
    
  individual_rights:
    right_to_information: true
    right_of_access: true
    right_to_rectification: true
    right_to_erasure: true
    right_to_restrict_processing: true
    right_to_data_portability: true
    right_to_object: true
    
  technical_measures:
    privacy_by_design: true
    privacy_by_default: true
    pseudonymisation: true
    data_encryption: true
    
  organizational_measures:
    privacy_impact_assessments: true
    data_protection_officer: true
    staff_training: true
    vendor_agreements: true
    
  data_processing:
    consent_management:
      explicit_consent: true
      granular_consent: true
      consent_withdrawal: true
      consent_records: true
      
    data_retention:
      automatic_deletion: true
      retention_schedules: true
      legal_holds: true
```

### SOC 2 Compliance

```yaml
# SOC 2 compliance controls
soc2_compliance:
  trust_principles:
    security:
      logical_access: true
      network_security: true
      system_operations: true
      change_management: true
      risk_mitigation: true
      
    availability:
      system_monitoring: true
      incident_response: true
      backup_recovery: true
      
    processing_integrity:
      input_validation: true
      output_verification: true
      error_handling: true
      
    confidentiality:
      data_classification: true
      encryption: true
      access_controls: true
      
    privacy:
      notice_choice: true
      collection_use: true
      access_correction: true
      disclosure_notification: true
      
  controls:
    access_management:
      user_provisioning: "automated"
      access_reviews: "quarterly"
      privileged_access: "restricted"
      
    system_monitoring:
      continuous_monitoring: true
      log_management: true
      vulnerability_scanning: true
      
    incident_management:
      incident_response_plan: true
      incident_tracking: true
      post_incident_review: true
```

### Audit Logging

```yaml
# Comprehensive audit logging
audit_logging:
  events_to_log:
    authentication:
      - "login_attempts"
      - "logout_events"
      - "password_changes"
      - "mfa_events"
      
    authorization:
      - "permission_grants"
      - "permission_denials"
      - "role_changes"
      
    data_access:
      - "data_reads"
      - "data_modifications"
      - "data_deletions"
      - "export_events"
      
    system_events:
      - "configuration_changes"
      - "system_starts_stops"
      - "error_events"
      
  log_format:
    timestamp: "iso8601"
    user_identification: true
    source_ip: true
    user_agent: true
    session_id: true
    request_id: true
    
  log_integrity:
    digital_signatures: true
    hash_chaining: true
    tamper_detection: true
    
  log_retention:
    retention_period: "7_years"
    archival_strategy: "cold_storage"
    deletion_policies: "automated"
    
  monitoring_alerts:
    suspicious_activities: true
    policy_violations: true
    system_anomalies: true
```

## Security Monitoring

### Security Information and Event Management (SIEM)

```yaml
# SIEM configuration
siem:
  log_sources:
    - "application_logs"
    - "system_logs"
    - "network_logs"
    - "security_device_logs"
    - "cloud_provider_logs"
    
  correlation_rules:
    brute_force_detection:
      condition: "failed_logins > 5 in 5_minutes"
      severity: "high"
      
    privilege_escalation:
      condition: "role_change AND admin_access"
      severity: "critical"
      
    data_exfiltration:
      condition: "large_data_export AND unusual_time"
      severity: "high"
      
  threat_hunting:
    proactive_hunting: true
    threat_intelligence: true
    behavioral_analytics: true
    
  incident_response:
    automated_response: true
    playbook_execution: true
    stakeholder_notification: true
```

### Security Metrics and KPIs

```yaml
# Security metrics tracking
security_metrics:
  vulnerability_metrics:
    - "mean_time_to_patch"
    - "vulnerability_density"
    - "critical_vulnerability_count"
    
  incident_metrics:
    - "mean_time_to_detection"
    - "mean_time_to_response"
    - "mean_time_to_recovery"
    
  access_metrics:
    - "failed_login_rate"
    - "privileged_access_usage"
    - "dormant_account_count"
    
  compliance_metrics:
    - "policy_violation_count"
    - "audit_finding_count"
    - "compliance_score"
    
  dashboards:
    executive_dashboard: true
    operational_dashboard: true
    tactical_dashboard: true
```

## Security Testing

### Penetration Testing

```yaml
# Penetration testing program
penetration_testing:
  frequency: "quarterly"
  scope: "full_application_infrastructure"
  
  testing_types:
    network_penetration: true
    web_application: true
    mobile_application: true
    social_engineering: true
    physical_security: true
    
  methodology: "owasp_testing_guide"
  
  automated_testing:
    continuous_scanning: true
    integration_testing: true
    
  reporting:
    executive_summary: true
    technical_details: true
    remediation_guidance: true
    
  remediation_tracking:
    sla_based: true
    risk_based_prioritization: true
    retest_validation: true
```

### Security Test Automation

```yaml
# Automated security testing
security_testing:
  static_testing:
    frequency: "every_commit"
    tools: ["sonarqube", "checkmarx"]
    
  dynamic_testing:
    frequency: "nightly"
    tools: ["owasp_zap", "burp_suite"]
    
  interactive_testing:
    frequency: "weekly"
    tools: ["contrast_security", "hdiv"]
    
  dependency_testing:
    frequency: "daily"
    tools: ["snyk", "whitesource"]
    
  infrastructure_testing:
    frequency: "weekly"
    tools: ["nessus", "openvas"]
    
  compliance_testing:
    frequency: "monthly"
    frameworks: ["cis_benchmarks", "nist"]
```

---

*Remember: Security is not a one-time implementation but an ongoing process. Regularly review and update your security measures, stay informed about new threats, and ensure your team is trained on security best practices.*