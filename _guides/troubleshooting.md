---
layout: guide
title: "Troubleshooting OSpec Projects"
description: "Common issues, debugging techniques, and solutions for OSpec projects"
tags: ["troubleshooting", "debugging", "problems"]
difficulty: "intermediate"
---

# Troubleshooting OSpec Projects

This guide helps you diagnose and resolve common issues when working with OSpec projects.

## Quick Diagnostics Checklist

Before diving into specific issues, run through this checklist:

- [ ] OSpec document validates against schema
- [ ] All required secrets are configured
- [ ] Agent roles have appropriate permissions  
- [ ] Network connectivity to external services
- [ ] Sufficient compute/storage resources available
- [ ] Dependencies and versions compatible

## Common Issues and Solutions

### 1. OSpec Validation Failures

#### Issue: Schema Validation Errors

```yaml
# ❌ Invalid OSpec - missing required fields
ospec_version: "1.0.0"
name: "My Project"  # Missing 'id' and 'description'
outcome_type: "web-app"
```

**Solution**: Ensure all required fields are present:

```yaml
# ✅ Valid OSpec
ospec_version: "1.0.0"
id: "my-project"  # Added required id
name: "My Project"
description: "A sample project"  # Added required description
outcome_type: "web-app"
acceptance: {}  # Added required acceptance section
stack: {}  # Added required stack section
```

#### Issue: Invalid Outcome Type

```bash
Error: Unknown outcome_type 'web-service'. 
Valid types: web-app, api, cli, game, library, ml-pipeline, mobile-app, desktop-app, infrastructure, documentation
```

**Solution**: Use a supported outcome type or define a custom one:

```yaml
# Option 1: Use supported type
outcome_type: "api"  # Instead of 'web-service'

# Option 2: Define custom type (requires plugin)
outcome_type: "web-service"
plugins:
  - "@company/web-service-plugin"
```

#### Issue: Malformed YAML Syntax

```bash
Error: Invalid YAML syntax at line 15:
  Expected ':' after key but found '|'
```

**Solution**: Check YAML syntax:

```yaml
# ❌ Invalid YAML
description: |
This is a multiline
  description  # Missing quotes for special characters

# ✅ Valid YAML  
description: |
  This is a multiline
  description with proper indentation
```

### 2. Agent Assignment and Execution Issues

#### Issue: No Available Agents

```bash
Error: No agents available with capabilities: [python, fastapi, postgresql]
```

**Solution**: Check agent availability and requirements:

```bash
# List available agents
ospec agents list

# Check specific agent capabilities
ospec agents describe agent-123

# Reduce capability requirements if too restrictive
```

```yaml
# Make requirements more flexible
requirements:
  agents:
    implementer:
      capabilities: ["python"]  # Remove specific framework requirements
      preferred: ["fastapi", "postgresql"]  # Mark as preferred instead
```

#### Issue: Agent Timeout

```bash
Error: Agent agent-123 timed out after 30 minutes
Last status: Implementing authentication system
```

**Solution**: Increase timeout or simplify scope:

```yaml
# Increase timeout for complex tasks
timeouts:
  implementation_minutes: 60  # Default is 30

# Or break down complex tasks
tasks:
  - id: "setup-auth-structure"
    estimated_hours: 1
  - id: "implement-user-model"
    estimated_hours: 2
  - id: "add-login-endpoints"
    estimated_hours: 2
```

### 3. Secret and Configuration Issues

#### Issue: Missing Secrets

```bash
Error: Required secret 'DATABASE_URL' not found in provider 'aws-secrets-manager'
```

**Solution**: Verify secret exists and permissions:

```bash
# Check if secret exists
aws secretsmanager describe-secret --secret-id DATABASE_URL

# Verify agent has access permissions
aws secretsmanager get-secret-value --secret-id DATABASE_URL
```

```yaml
# Alternative: Use different secret provider
secrets:
  provider: "environment"  # Fallback to env vars
  required:
    - "DATABASE_URL"
    - "API_KEY"
```

#### Issue: Secret Provider Configuration

```bash
Error: Unable to authenticate with secret provider 'vault'
Connection refused to vault.company.com:8200
```

**Solution**: Check provider configuration:

```yaml
# Fix Vault configuration
secrets:
  provider: "vault"
  config:
    url: "https://vault.company.com:8200"  # Ensure HTTPS and correct port
    auth_method: "aws"  # or appropriate auth method
    mount_path: "secret/ospec"
```

### 4. Dependency and Environment Issues

#### Issue: Conflicting Dependencies

```bash
Error: Cannot resolve dependency conflict:
  react@17.0.0 required by component-library
  react@18.0.0 required by web-app
```

**Solution**: Use dependency overrides or update constraints:

```yaml
# Pin specific versions
stack:
  frontend: "React@18"
  components: "component-library@^2.0.0"  # Version that supports React 18
  
# Or override dependencies
dependency_overrides:
  react: "18.0.0"
```

#### Issue: Environment Setup Failure

```bash
Error: Failed to install Node.js 18.16.0
Platform linux/arm64 not supported
```

**Solution**: Check platform compatibility:

```yaml
# Specify compatible platforms
deployment:
  platforms: ["linux/amd64"]  # Exclude unsupported platforms
  
# Or use different stack
stack:
  runtime: "Node.js@18"  # Let system choose compatible version
  preferred_version: "18.16.0"
```

### 5. Network and Connectivity Issues

#### Issue: External API Timeouts

```bash
Error: Timeout connecting to api.external-service.com
Request timed out after 30 seconds
```

**Solution**: Adjust timeout settings and add retries:

```yaml
# Configure network settings
network:
  timeouts:
    connect_seconds: 10
    read_seconds: 60
  
  retries:
    max_attempts: 3
    backoff_factor: 2
```

#### Issue: Firewall/Security Group Blocking

```bash
Error: Connection refused to database.internal.com:5432
```

**Solution**: Check network security rules:

```bash
# Test connectivity
telnet database.internal.com 5432

# For AWS, check security groups
aws ec2 describe-security-groups --group-ids sg-123456789
```

```yaml
# Document network requirements
infrastructure:
  network_access_required:
    - destination: "database.internal.com"
      port: 5432
      protocol: "TCP"
    - destination: "api.external.com"
      port: 443
      protocol: "HTTPS"
```

### 6. Resource and Performance Issues

#### Issue: Out of Memory

```bash
Error: Process killed due to memory limit exceeded
Agent used 2.1GB, limit was 2GB
```

**Solution**: Increase resource limits:

```yaml
# Increase resource allocation
resources:
  memory_gb: 4  # Increase from default 2GB
  cpu_cores: 2
  
  # Or optimize for memory usage
  optimize_for: "memory"  # vs "speed"
```

#### Issue: Slow Performance

```bash
Warning: Task 'run-tests' took 45 minutes (expected 10 minutes)
```

**Solution**: Optimize resource allocation and parallelization:

```yaml
# Optimize performance settings
performance:
  parallel_tasks: 4  # Run tasks in parallel when possible
  cache_dependencies: true
  optimize_builds: true

# Or adjust expectations
timeouts:
  test_execution_minutes: 60
```

### 7. Testing and Validation Issues

#### Issue: Acceptance Criteria Failures

```bash
Test failed: HTTP endpoint /api/users returned 404, expected 200
```

**Solution**: Debug endpoint implementation:

```bash
# Check if service is running
curl -v http://localhost:8000/api/users

# Review service logs
ospec logs --service api-service --tail 100

# Verify routing configuration
```

```yaml
# Add debugging information to acceptance criteria
acceptance:
  http_endpoints:
    - path: "/api/users"
      method: "GET"
      expected_status: 200
      timeout_seconds: 30
      debug: true  # Enable detailed debugging
```

#### Issue: Test Environment Inconsistencies

```bash
Error: Tests pass locally but fail in CI environment
Missing environment variable NODE_ENV
```

**Solution**: Ensure environment parity:

```yaml
# Define consistent test environment
testing:
  environment:
    NODE_ENV: "test"
    DATABASE_URL: "{{secrets.TEST_DATABASE_URL}}"
  
  # Validate environment setup
  pre_test_checks:
    - "environment_variables_present"
    - "database_connectivity"
    - "external_services_available"
```

### 8. Deployment Issues

#### Issue: Deployment Rollback

```bash
Error: Deployment failed health checks
Rolling back to previous version...
```

**Solution**: Improve health checks and deployment strategy:

```yaml
# Better health check configuration
deployment:
  health_checks:
    path: "/health"
    interval_seconds: 30
    timeout_seconds: 10
    retries: 3
    initial_delay_seconds: 60  # Allow startup time
  
  # Safer deployment strategy
  strategy: "rolling"
  rollback:
    automatic: true
    max_unavailable: "25%"
```

#### Issue: Container Build Failures

```bash
Error: Docker build failed
unable to resolve package dependencies
```

**Solution**: Fix Docker configuration:

```dockerfile
# Use specific base image versions
FROM node:18.16.0-alpine

# Set proper working directory
WORKDIR /app

# Copy dependency files first for better caching
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY . .

# Use multi-stage builds for optimization
```

## Debugging Techniques

### 1. Enable Verbose Logging

```yaml
# Add debug configuration to OSpec
debug:
  level: "verbose"  # off, error, warn, info, verbose, debug
  log_agent_actions: true
  log_api_calls: true
  save_intermediate_files: true
```

### 2. Use Interactive Debugging

```bash
# Start interactive debugging session
ospec debug --project-id proj_123 --agent-id agent_456

# Step through agent actions
> step
> inspect variables
> view logs
> continue
```

### 3. Examine Agent Context

```bash
# View agent's current context
ospec agents context --agent-id agent_123

# See what the agent "sees"
ospec agents vision --agent-id agent_123 --file src/app.py
```

### 4. Test Components Independently

```yaml
# Test individual components
testing:
  component_tests:
    - component: "database"
      test: "SELECT 1"
      expected: "success"
    
    - component: "api"
      test: "GET /health"
      expected: "200 OK"
    
    - component: "auth"
      test: "validate_token"
      expected: "valid"
```

## Recovery Procedures

### 1. Agent Recovery

```bash
# If agent becomes unresponsive
ospec agents restart --agent-id agent_123

# Or reassign to different agent
ospec projects reassign --project-id proj_123 --role implementer --agent-id agent_456
```

### 2. Project State Recovery

```bash
# Reset project to last known good state
ospec projects rollback --project-id proj_123 --checkpoint checkpoint_456

# Or restart from specific phase
ospec projects restart --project-id proj_123 --from-phase planning
```

### 3. Data Recovery

```yaml
# Configure backup and recovery
disaster_recovery:
  backup_frequency: "hourly"
  retention_days: 30
  
  recovery_procedures:
    database:
      - "stop_application"
      - "restore_from_backup"
      - "verify_data_integrity"
      - "restart_application"
```

## Prevention Strategies

### 1. Proactive Monitoring

```yaml
# Set up monitoring and alerting
monitoring:
  metrics:
    - "agent_response_time"
    - "deployment_success_rate"
    - "test_failure_rate"
    - "resource_utilization"
  
  alerts:
    - metric: "agent_response_time"
      threshold: 300  # seconds
      action: "notify_team"
    
    - metric: "deployment_success_rate"
      threshold: 0.95  # 95%
      action: "escalate"
```

### 2. Regular Health Checks

```bash
# Schedule regular health checks
crontab -e
0 */6 * * * ospec health-check --all-projects
```

### 3. Documentation and Runbooks

```yaml
# Document common procedures
documentation:
  runbooks:
    - name: "Agent Timeout Recovery"
      location: "docs/runbooks/agent-timeout.md"
    - name: "Deployment Rollback"
      location: "docs/runbooks/deployment-rollback.md"
  
  escalation:
    - level: 1
      contact: "dev-team-slack"
      response_time_minutes: 30
    - level: 2
      contact: "engineering-manager"
      response_time_minutes: 60
```

## Getting Help

### 1. Community Resources

- **Documentation**: [OSpec Docs](https://ospec.dev/docs)
- **GitHub Issues**: [Report bugs and request features](https://github.com/nibzard/ospec/issues)
- **Discord**: [Join community discussions](https://discord.gg/ospec)
- **Stack Overflow**: Tag questions with `ospec`

### 2. Diagnostic Information to Include

When seeking help, include:

```bash
# Generate diagnostic report
ospec diagnose --project-id proj_123 --output report.json

# Include:
# - OSpec version
# - Agent versions and capabilities
# - Error messages and stack traces
# - Relevant configuration sections
# - Steps to reproduce
```

### 3. Professional Support

For enterprise customers:

- **Support Portal**: Access to dedicated support team
- **SLA Response Times**: Guaranteed response times by severity
- **Expert Consultation**: Architecture and best practices guidance
- **Training Programs**: Team training and certification

## Next Steps

- [Advanced Patterns →]({{ 'guides/advanced-patterns/' | relative_url }})
- [Security Best Practices →]({{ 'specification/security-guardrails/' | relative_url }})
- [Performance Optimization →]({{ 'cookbook/performance/' | relative_url }})

---

*Remember: Most issues can be prevented with careful specification design and thorough testing. When in doubt, start simple and add complexity gradually.*