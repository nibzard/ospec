---
layout: cookbook
title: "Deployment Strategies"
description: "Proven deployment patterns and strategies for different environments and use cases"
tags: ["deployment", "ci-cd", "devops", "strategies"]
category: "deployment"
difficulty: "intermediate"
---

# Deployment Strategies

Comprehensive guide to deployment strategies and patterns for OSpec projects, from simple single-server deployments to complex multi-region orchestrations.

## Deployment Strategy Selection

### Strategy Comparison Matrix

| Strategy | Downtime | Risk | Complexity | Rollback Speed | Cost |
|----------|----------|------|------------|----------------|------|
| **Recreate** | High | Low | Low | Fast | Low |
| **Rolling** | Zero | Medium | Medium | Medium | Medium |
| **Blue-Green** | Zero | Low | Medium | Instant | High |
| **Canary** | Zero | Low | High | Fast | Medium |
| **A/B Testing** | Zero | Low | High | Fast | High |

### When to Use Each Strategy

```yaml
# Strategy selection guide
deployment_strategy_selection:
  recreate:
    use_when:
      - "development_environments"
      - "cost_is_primary_concern"
      - "simple_applications"
      - "downtime_acceptable"
    
  rolling:
    use_when:
      - "stateless_applications"
      - "resource_constraints"
      - "gradual_rollouts_needed"
      
  blue_green:
    use_when:
      - "zero_downtime_required"
      - "instant_rollback_needed"
      - "testing_in_production_like_environment"
      
  canary:
    use_when:
      - "high_risk_deployments"
      - "user_impact_testing_required"
      - "gradual_feature_rollout"
      
  ab_testing:
    use_when:
      - "feature_validation_needed"
      - "business_metrics_important"
      - "user_experience_optimization"
```

## Basic Deployment Patterns

### Recreate Deployment

```yaml
# Simple recreate deployment
deployment:
  strategy: "recreate"
  
  steps:
    - name: "stop_application"
      action: "service_stop"
      timeout_seconds: 30
      
    - name: "deploy_new_version"
      action: "deploy"
      source: "{{artifact_url}}"
      
    - name: "start_application"
      action: "service_start"
      health_check: true
      
  configuration:
    maintenance_page: true
    notification:
      start: "Deployment started - service unavailable"
      complete: "Deployment complete - service restored"
      
  rollback:
    automatic: true
    conditions:
      - "health_check_failed"
      - "startup_timeout"
```

### Rolling Deployment

```yaml
# Rolling deployment configuration
deployment:
  strategy: "rolling"
  
  configuration:
    batch_size: 25  # Percentage of instances to update at once
    max_unavailable: 1
    health_check_grace_period: 60
    
  phases:
    preparation:
      - "validate_artifact"
      - "run_pre_deployment_tests"
      - "backup_current_version"
      
    rolling_update:
      - name: "update_batch"
        batch_size: "{{deployment.configuration.batch_size}}%"
        wait_for_health: true
        rollback_on_failure: true
        
    verification:
      - "run_smoke_tests"
      - "validate_metrics"
      - "user_acceptance_validation"
      
  health_checks:
    http_endpoint: "/health"
    expected_status: 200
    timeout_seconds: 30
    retry_attempts: 3
    
  rollback:
    automatic: true
    conditions:
      - "health_check_failure_rate > 10%"
      - "error_rate > 5%"
      - "response_time_p95 > 2000ms"
```

## Advanced Deployment Patterns

### Blue-Green Deployment

```yaml
# Blue-Green deployment setup
deployment:
  strategy: "blue_green"
  
  environments:
    blue:
      status: "active"
      instances: 3
      load_balancer_weight: 100
      
    green:
      status: "staging"
      instances: 3
      load_balancer_weight: 0
      
  deployment_process:
    - name: "deploy_to_green"
      target: "green"
      parallel_deployment: true
      
    - name: "warm_up_green"
      actions:
        - "initialize_caches"
        - "warm_up_connections"
        - "run_health_checks"
        
    - name: "smoke_test_green"
      tests:
        - "api_functionality"
        - "database_connectivity"
        - "third_party_integrations"
        
    - name: "switch_traffic"
      method: "load_balancer_switch"
      duration_seconds: 10
      
    - name: "monitor_green"
      duration_seconds: 300
      metrics:
        - "error_rate"
        - "response_time"
        - "throughput"
        
  rollback:
    method: "instant_switch"
    conditions:
      - "error_rate > 1%"
      - "response_time_degradation > 50%"
      - "manual_trigger"
      
  cleanup:
    keep_blue_duration: "1 hour"
    automated_cleanup: true
```

### Canary Deployment

```yaml
# Canary deployment configuration
deployment:
  strategy: "canary"
  
  canary_configuration:
    initial_traffic: 5    # Start with 5% of traffic
    increment: 10         # Increase by 10% each step
    max_traffic: 100      # Full deployment
    step_duration: 300    # 5 minutes per step
    
  traffic_routing:
    method: "weighted_routing"
    load_balancer: "aws_alb"
    
    rules:
      - condition: "user_segment == 'beta'"
        traffic_percentage: 100
        
      - condition: "request_header['canary'] == 'true'"
        traffic_percentage: 100
        
      - condition: "random_percentage"
        traffic_percentage: "{{canary.current_percentage}}"
        
  monitoring:
    success_criteria:
      error_rate_threshold: 0.5    # 0.5%
      latency_p95_threshold: 500   # ms
      business_metric_threshold: 0.95  # conversion rate
      
    failure_criteria:
      error_rate_threshold: 2      # 2%
      latency_p95_threshold: 1000  # ms
      alert_count_threshold: 5
      
  progression_rules:
    automatic_progression: true
    progression_conditions:
      - "error_rate < 0.5%"
      - "latency_p95 < 500ms"
      - "no_critical_alerts"
      
    hold_conditions:
      - "business_hours_only"
      - "no_other_deployments"
      
  rollback:
    automatic: true
    rollback_conditions:
      - "error_rate > 2%"
      - "latency_p95 > 1000ms"
      - "business_metric_drop > 10%"
```

### Feature Flag Deployment

```yaml
# Feature flag based deployment
deployment:
  strategy: "feature_flags"
  
  feature_flag_service: "launchdarkly"  # or split, optimizely
  
  feature_rollout:
    - name: "new_checkout_flow"
      type: "boolean"
      default_value: false
      
      rollout_strategy:
        - stage: "internal_testing"
          percentage: 0
          targeting:
            - "user.email endsWith '@company.com'"
            
        - stage: "beta_users"
          percentage: 10
          targeting:
            - "user.segment == 'beta'"
            
        - stage: "gradual_rollout"
          percentage: 25
          increment: 25
          schedule: "daily"
          
        - stage: "full_rollout"
          percentage: 100
          
  monitoring_integration:
    metrics_tracking: true
    experiment_analysis: true
    
    kill_switch:
      enabled: true
      conditions:
        - "error_rate > 2%"
        - "conversion_rate_drop > 15%"
        - "manual_intervention"
```

## Environment-Specific Strategies

### Development Environment

```yaml
# Development deployment
development:
  deployment:
    strategy: "recreate"
    automation_level: "full"
    
  triggers:
    - event: "git_push"
      branch: "develop"
      auto_deploy: true
      
  features:
    hot_reload: true
    debug_mode: true
    seed_data: true
    
  notification:
    channels: ["slack_dev_channel"]
    events: ["deploy_start", "deploy_complete", "deploy_failed"]
```

### Staging Environment

```yaml
# Staging deployment
staging:
  deployment:
    strategy: "rolling"
    automation_level: "semi_automated"
    
  triggers:
    - event: "git_push"
      branch: "release/*"
      requires_approval: false
      
    - event: "pull_request_merge"
      target_branch: "main"
      requires_approval: true
      
  testing:
    automated_tests: true
    performance_tests: true
    security_scans: true
    
  data_management:
    production_like_data: true
    data_anonymization: true
    regular_refresh: "weekly"
```

### Production Environment

```yaml
# Production deployment
production:
  deployment:
    strategy: "blue_green"
    automation_level: "supervised"
    
  approval_process:
    required_approvers: 2
    approver_roles: ["tech_lead", "product_owner"]
    approval_timeout: "4 hours"
    
  safety_measures:
    deployment_window: "business_hours"
    blackout_periods:
      - "friday_afternoons"
      - "holiday_periods"
      - "high_traffic_events"
      
  monitoring:
    enhanced_monitoring: true
    real_user_monitoring: true
    business_metrics: true
    
  rollback_plan:
    automated_rollback: true
    rollback_testing: "monthly"
    communication_plan: true
```

## Database Deployment Patterns

### Schema Migrations

```yaml
# Database deployment strategies
database_deployment:
  migration_strategy: "expand_contract"
  
  phases:
    expand:
      - "add_new_columns"
      - "create_new_tables"
      - "add_indexes"
      - "update_views"
      
    migrate:
      - "dual_writes"
      - "backfill_data"
      - "validate_data_consistency"
      
    contract:
      - "remove_old_columns"
      - "drop_unused_tables"
      - "cleanup_indexes"
      
  rollback_strategy:
    expand_phase: "drop_new_objects"
    migrate_phase: "stop_dual_writes"
    contract_phase: "recreate_dropped_objects"
    
  safety_measures:
    backup_before_migration: true
    migration_testing: "staging_environment"
    data_validation: "automated"
```

### Zero-Downtime Database Updates

```yaml
# Zero-downtime database deployment
database_zero_downtime:
  techniques:
    shadow_tables:
      enabled: true
      sync_mechanism: "triggers"
      validation: "checksum_comparison"
      
    online_schema_change:
      tool: "gh-ost"  # or pt-online-schema-change
      chunk_size: 1000
      throttling: "replication_lag_based"
      
    read_replicas:
      promotion_strategy: "automated"
      data_consistency_check: true
      
  application_compatibility:
    backward_compatible: true
    feature_flags: "database_changes"
    gradual_cutover: true
```

## Multi-Region Deployments

### Global Deployment Strategy

```yaml
# Multi-region deployment
multi_region:
  regions:
    primary: "us-east-1"
    secondary: ["us-west-2", "eu-west-1", "ap-southeast-1"]
    
  deployment_order:
    - "deploy_to_staging_all_regions"
    - "validate_staging_deployment"
    - "deploy_to_primary_production"
    - "validate_primary_deployment"
    - "deploy_to_secondary_regions"
    - "validate_global_deployment"
    
  traffic_management:
    dns_failover: true
    health_check_endpoints: ["/health", "/ready"]
    failover_threshold: 3
    
  data_consistency:
    replication_strategy: "master_slave"
    consistency_model: "eventual"
    conflict_resolution: "last_write_wins"
    
  disaster_recovery:
    rpo_target: "15 minutes"
    rto_target: "30 minutes"
    automated_failover: true
```

## CI/CD Pipeline Integration

### GitHub Actions Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deployment Pipeline

on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'staging'
        type: choice
        options: ['staging', 'production']

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: |
          npm ci
          npm run test
          npm run test:e2e
  
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build application
        run: |
          npm ci
          npm run build
      - name: Build Docker image
        run: |
          docker build -t app:${{ github.sha }} .
          docker tag app:${{ github.sha }} app:latest
  
  deploy-staging:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Deploy to staging
        run: |
          kubectl set image deployment/app app=app:${{ github.sha }}
          kubectl rollout status deployment/app
  
  deploy-production:
    needs: [build, deploy-staging]
    if: github.event_name == 'workflow_dispatch' && github.event.inputs.environment == 'production'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy to production
        run: |
          # Blue-green deployment
          kubectl apply -f k8s/green-deployment.yaml
          kubectl set image deployment/app-green app=app:${{ github.sha }}
          kubectl rollout status deployment/app-green
          
          # Switch traffic
          kubectl patch service app -p '{"spec":{"selector":{"version":"green"}}}'
          
          # Monitor for 5 minutes
          sleep 300
          
          # Cleanup old blue deployment
          kubectl delete deployment app-blue || true
```

### GitLab CI Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy-staging
  - deploy-production

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

test:
  stage: test
  script:
    - npm ci
    - npm run test
    - npm run test:integration

build:
  stage: build
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE
  only:
    - main

deploy-staging:
  stage: deploy-staging
  script:
    - helm upgrade --install app-staging ./helm-chart 
      --set image.tag=$CI_COMMIT_SHA
      --set environment=staging
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - main

deploy-production:
  stage: deploy-production
  script:
    - |
      # Canary deployment
      helm upgrade --install app-production ./helm-chart \
        --set image.tag=$CI_COMMIT_SHA \
        --set environment=production \
        --set canary.enabled=true \
        --set canary.weight=10
      
      # Monitor canary
      ./scripts/monitor-canary.sh
      
      # Full rollout if successful
      helm upgrade app-production ./helm-chart \
        --set canary.enabled=false
  environment:
    name: production
    url: https://example.com
  when: manual
  only:
    - main
```

## Monitoring and Observability

### Deployment Monitoring

```yaml
# Deployment monitoring configuration
deployment_monitoring:
  metrics:
    deployment_frequency: true
    deployment_success_rate: true
    lead_time: true
    recovery_time: true
    
  alerts:
    deployment_failure:
      severity: "critical"
      channels: ["pagerduty", "slack"]
      
    slow_deployment:
      threshold: "30 minutes"
      severity: "warning"
      
    rollback_triggered:
      severity: "high"
      escalation: true
      
  dashboards:
    deployment_pipeline: true
    environment_health: true
    release_metrics: true
    
  post_deployment:
    health_check_duration: "15 minutes"
    performance_baseline: "24 hours"
    user_feedback_collection: true
```

### Rollback Monitoring

```yaml
# Rollback and recovery monitoring
rollback_monitoring:
  automatic_rollback:
    health_check_failures: 3
    error_rate_threshold: 5  # percent
    response_time_threshold: 2000  # ms
    
  manual_rollback:
    approval_required: false
    notification_required: true
    incident_creation: true
    
  post_rollback:
    root_cause_analysis: true
    incident_review: "within_24_hours"
    process_improvement: true
```

## Best Practices

### Deployment Checklist

#### Pre-Deployment
- [ ] **Code review completed** and approved
- [ ] **All tests passing** (unit, integration, e2e)
- [ ] **Security scans** completed with no critical issues
- [ ] **Performance tests** show no regression
- [ ] **Database migrations** tested in staging
- [ ] **Rollback plan** documented and tested
- [ ] **Monitoring and alerts** configured
- [ ] **Team notification** sent

#### During Deployment
- [ ] **Deployment started** within planned window
- [ ] **Health checks** passing at each step
- [ ] **Metrics monitoring** active
- [ ] **Error rates** within acceptable limits
- [ ] **Performance metrics** stable
- [ ] **User experience** validation

#### Post-Deployment
- [ ] **Smoke tests** completed successfully
- [ ] **Business metrics** validated
- [ ] **Performance baseline** established
- [ ] **Monitoring alerts** verified
- [ ] **Documentation** updated
- [ ] **Team notification** of completion
- [ ] **Post-deployment review** scheduled

### Common Anti-Patterns to Avoid

1. **Big Bang Deployments**
   - Deploy everything at once
   - No gradual rollout
   - High risk of total failure

2. **No Rollback Plan**
   - Assume deployment will always succeed
   - No tested rollback procedure
   - Extended downtime during issues

3. **Manual Deployment Steps**
   - Prone to human error
   - Not reproducible
   - Difficult to scale

4. **Insufficient Testing**
   - Skip testing in production-like environment
   - No performance validation
   - Missing edge case testing

5. **Poor Monitoring**
   - No deployment-specific monitoring
   - Late detection of issues
   - No business impact visibility

### Success Metrics

```yaml
# Deployment success metrics
deployment_metrics:
  dora_metrics:
    deployment_frequency: "daily"
    lead_time_for_changes: "< 1 hour"
    change_failure_rate: "< 15%"
    time_to_restore_service: "< 1 hour"
    
  business_metrics:
    deployment_success_rate: "> 95%"
    rollback_rate: "< 5%"
    mean_time_to_deployment: "< 30 minutes"
    
  quality_metrics:
    post_deployment_incidents: "< 2%"
    customer_satisfaction: "> 4.5/5"
    team_confidence: "> 8/10"
```

---

*Remember: The best deployment strategy depends on your specific requirements, risk tolerance, and technical constraints. Start simple and evolve your deployment practices as your application and team mature.*