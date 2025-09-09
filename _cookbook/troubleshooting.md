---
layout: cookbook
title: "Troubleshooting Guide"
description: "Common issues, debugging techniques, and solutions for OSpec projects"
tags: ["troubleshooting", "debugging", "solutions"]
category: "debugging"
difficulty: "intermediate"
---

# Troubleshooting Guide

Quick solutions to common problems you might encounter while working with OSpec projects.

## Quick Diagnostic Commands

### Check OSpec Status
```bash
# Get overall project status
ospec status --project-id your-project-id

# Check agent health
ospec agents health --all

# Validate OSpec document
ospec validate project.ospec.yaml

# Check dependencies
ospec dependencies check
```

### Debug Agent Issues
```bash
# View agent logs
ospec logs --agent-id agent-123 --tail 100

# Check agent capabilities
ospec agents describe agent-123

# Test agent connectivity
ospec agents ping agent-123

# Force agent restart
ospec agents restart agent-123
```

## Common Error Patterns

### 1. "Agent Timeout" Errors

**Symptoms:**
```
Error: Agent timeout after 30 minutes
Status: Task 'implement-auth' incomplete
```

**Quick Fixes:**
```yaml
# Increase timeout in OSpec
timeouts:
  task_execution_minutes: 60
  agent_response_minutes: 10

# Or break down the task
tasks:
  - id: "setup-auth-structure"
    estimated_hours: 1
  - id: "implement-user-model"  
    estimated_hours: 2
```

### 2. "Dependency Conflict" Errors

**Symptoms:**
```
Error: Cannot resolve dependency conflict
Package A requires version 1.0
Package B requires version 2.0
```

**Quick Fixes:**
```yaml
# Pin specific versions
stack:
  dependencies:
    package_a: "1.5.0"  # Compatible middle version
    package_b: "1.8.0"

# Or use overrides
dependency_overrides:
  conflicting_package: "2.0.0"
```

### 3. "Secret Not Found" Errors

**Symptoms:**
```
Error: Required secret 'DATABASE_URL' not found
Provider: aws-secrets-manager
```

**Quick Fixes:**
```bash
# Check if secret exists
aws secretsmanager describe-secret --secret-id DATABASE_URL

# Create missing secret
aws secretsmanager create-secret \
  --name DATABASE_URL \
  --secret-string "postgresql://..."

# Use environment fallback
```

```yaml
secrets:
  fallback_providers:
    - "aws-secrets-manager"
    - "environment"
    - "dotenv_file"
```

### 4. "Test Failures" in Acceptance

**Symptoms:**
```
Test failed: HTTP endpoint /api/health returned 404
Expected: 200 OK
```

**Quick Fixes:**
```bash
# Check if service is running
curl -v http://localhost:8000/api/health

# Check service logs
ospec logs --service api --tail 50

# Verify port mapping
ospec inspect --service api --ports
```

```yaml
# Add debugging to acceptance criteria
acceptance:
  http_endpoints:
    - path: "/api/health"
      status: 200
      timeout_seconds: 30
      debug: true
      retry_attempts: 3
```

## Environment-Specific Issues

### Development Environment

**Issue: Hot reload not working**
```yaml
# Enable development features
development:
  hot_reload: true
  auto_restart: true
  debug_mode: true
  detailed_logging: true
```

**Issue: Resource constraints**
```yaml
# Reduce resource usage for development
resources:
  memory_gb: 2  # Reduce from 8GB
  cpu_cores: 1  # Reduce from 4
  optimize_for: "speed"  # vs "memory"
```

### Production Environment

**Issue: Performance degradation**
```yaml
# Add performance monitoring
monitoring:
  performance_metrics: true
  profiling: true
  resource_tracking: true
  
# Enable caching
caching:
  enabled: true
  levels: ["application", "database", "cdn"]
```

**Issue: Scaling problems**
```yaml
# Configure auto-scaling
scaling:
  auto_scale: true
  metrics: ["cpu", "memory", "requests_per_second"]
  scale_up_threshold: 70
  scale_down_threshold: 30
```

## Network and Connectivity Issues

### Connection Timeouts

```yaml
# Increase timeouts
network:
  connect_timeout_seconds: 30
  read_timeout_seconds: 120
  retry_attempts: 3
  retry_backoff: "exponential"
```

### Firewall Issues

```bash
# Test connectivity
telnet your-service.com 443
nc -zv your-service.com 443

# Check security groups (AWS)
aws ec2 describe-security-groups --group-ids sg-123456

# Add required ports
```

```yaml
infrastructure:
  firewall_rules:
    - port: 80
      protocol: "TCP"
      source: "0.0.0.0/0"
    - port: 443
      protocol: "TCP" 
      source: "0.0.0.0/0"
```

## Database Issues

### Connection Pool Exhaustion

```yaml
# Increase connection pool
database:
  connection_pool:
    min_connections: 5
    max_connections: 50
    idle_timeout_minutes: 10
    
# Add connection monitoring
monitoring:
  database_connections: true
  slow_query_log: true
```

### Migration Failures

```bash
# Check migration status
ospec db migrate --status

# Rollback failed migration
ospec db rollback --steps 1

# Force migration (careful!)
ospec db migrate --force
```

## Security Issues

### Certificate Errors

```bash
# Check certificate expiry
openssl x509 -in cert.crt -text -noout | grep "Not After"

# Auto-renew certificates
```

```yaml
security:
  ssl_certificates:
    auto_renewal: true
    renewal_days_before: 30
    provider: "letsencrypt"
```

### Access Denied Errors

```yaml
# Check IAM permissions
permissions:
  check_access: true
  audit_enabled: true
  
# Use least privilege principle
iam_policies:
  - name: "S3ReadOnly"
    actions: ["s3:GetObject", "s3:ListBucket"]
    resources: ["arn:aws:s3:::my-bucket/*"]
```

## Performance Issues

### High Memory Usage

```yaml
# Add memory profiling
profiling:
  memory: true
  cpu: true
  duration_minutes: 10
  
# Optimize garbage collection (Node.js)
runtime_options:
  node_options: "--max-old-space-size=4096"
  
# Add memory limits
resources:
  memory_limit_gb: 8
  memory_monitoring: true
```

### Slow Response Times

```yaml
# Add performance monitoring
monitoring:
  response_times: true
  slow_request_threshold_ms: 1000
  
# Enable caching
caching:
  redis: true
  application_cache: true
  database_cache: true
  
# Database optimization
database:
  connection_pooling: true
  query_optimization: true
  indexing_hints: true
```

## Deployment Issues

### Build Failures

```bash
# Check build logs
ospec logs --build --tail 100

# Clear cache and rebuild
ospec build --clean --verbose

# Check dependencies
ospec dependencies check --fix
```

### Rollback Procedures

```bash
# Rollback to previous version
ospec deploy rollback --version previous

# Rollback to specific version
ospec deploy rollback --version v1.2.3

# Check rollback status
ospec deploy status --show-history
```

## Monitoring and Alerting

### Missing Metrics

```yaml
# Add comprehensive monitoring
monitoring:
  metrics:
    - "request_rate"
    - "error_rate"
    - "response_time"
    - "cpu_usage"
    - "memory_usage"
    - "disk_usage"
  
  custom_metrics:
    - name: "business_conversions"
      type: "counter"
    - name: "user_sessions"
      type: "gauge"
```

### Alert Fatigue

```yaml
# Configure smart alerting
alerting:
  deduplication: true
  severity_filtering: true
  business_hours_only: false
  
  rules:
    - name: "critical_errors"
      condition: "error_rate > 5%"
      severity: "critical"
      cooldown_minutes: 15
      
    - name: "high_latency"
      condition: "p95_response_time > 2000ms"
      severity: "warning"  
      cooldown_minutes: 30
```

## Debugging Techniques

### Enable Debug Mode

```yaml
# Global debug settings
debug:
  level: "verbose"
  save_intermediate_files: true
  detailed_error_messages: true
  agent_action_logging: true
```

### Interactive Debugging

```bash
# Start interactive debug session
ospec debug --interactive

# Step through agent actions
> step
> inspect state
> view context
> continue
```

### Log Analysis

```bash
# Search logs for errors
ospec logs search --query "ERROR" --last 24h

# Analyze patterns
ospec logs analyze --pattern "timeout" --service api

# Export logs for analysis
ospec logs export --format json --output debug.log
```

## Recovery Procedures

### Data Recovery

```bash
# List available backups
ospec backup list --service database

# Restore from backup
ospec backup restore --backup-id backup-123 --confirm

# Verify data integrity
ospec backup verify --backup-id backup-123
```

### Service Recovery

```bash
# Restart failed services
ospec services restart --all

# Check service health
ospec services health --detailed

# Rebuild from scratch (last resort)
ospec rebuild --service api --confirm
```

## Prevention Strategies

### Health Checks

```yaml
health_checks:
  enabled: true
  interval_seconds: 30
  timeout_seconds: 5
  
  endpoints:
    - path: "/health"
      expected_status: 200
    - path: "/metrics"
      expected_status: 200
```

### Automated Testing

```yaml
testing:
  continuous: true
  types: ["unit", "integration", "e2e"]
  
  smoke_tests:
    - "api_health_check"
    - "database_connectivity"
    - "external_service_availability"
```

### Monitoring Setup

```yaml
monitoring:
  proactive: true
  predictive_alerts: true
  
  sli_slo:  # Service Level Indicators/Objectives
    availability: 99.9
    latency_p95: 500  # ms
    error_rate: 0.1   # %
```

## Getting Help

### Documentation Links
- [OSpec Troubleshooting](/guides/troubleshooting/)
- [Agent Documentation](/specification/agents-roles/)
- [Security Guide](/specification/security-guardrails/)

### Community Resources
- **Discord**: [OSpec Community](https://discord.gg/ospec)
- **GitHub**: [Issues and Discussions](https://github.com/nibzard/ospec/issues)
- **Stack Overflow**: Tag with `ospec`

### Support Channels
- **Community Support**: Free community help
- **Professional Support**: Priority support for enterprises
- **Training Programs**: Workshops and certification

## Emergency Contacts

### Severity Levels

**Critical (P0)**: Complete service outage
- Response time: 15 minutes
- Contact: PagerDuty + Phone

**High (P1)**: Major functionality impaired  
- Response time: 1 hour
- Contact: Slack + Email

**Medium (P2)**: Minor issues
- Response time: 4 hours
- Contact: Email

**Low (P3)**: Feature requests
- Response time: 24 hours
- Contact: GitHub Issues

---

*Remember: Most issues can be prevented with proper monitoring, testing, and documentation. When in doubt, check the basics first: network connectivity, permissions, and resource availability.*