---
layout: example
title: "Cloud Infrastructure as Code"
description: "Complete cloud infrastructure setup using Terraform with monitoring, security, and auto-scaling"
outcome_type: "infrastructure"
complexity: "advanced"
stack: "Terraform + AWS + Kubernetes + Monitoring"
tags: ["infrastructure", "terraform", "aws", "kubernetes", "devops"]
---

# Cloud Infrastructure as Code

This example demonstrates setting up complete cloud infrastructure using Infrastructure as Code (IaC) principles, including compute resources, networking, security, monitoring, and CI/CD pipelines.

## OSpec Document

```yaml
ospec_version: "1.0.0"
id: "production-cloud-infrastructure"
name: "Production Cloud Infrastructure"
description: "Complete production-ready cloud infrastructure with auto-scaling, monitoring, and security"
outcome_type: "infrastructure"

# Infrastructure configuration
infrastructure:
  provider: "AWS"
  regions:
    primary: "us-east-1"
    secondary: "us-west-2"
  
  architecture: "multi-tier"
  deployment_model: "blue-green"
  disaster_recovery: "multi-region"
  
  # Environment definitions
  environments:
    development:
      instances: "small"
      high_availability: false
      auto_scaling: false
      backup_retention: 7
      
    staging:
      instances: "medium" 
      high_availability: true
      auto_scaling: true
      backup_retention: 14
      
    production:
      instances: "large"
      high_availability: true
      auto_scaling: true
      backup_retention: 30
      multi_az: true

stack:
  iac_tool: "Terraform@1.6"
  orchestration: "Kubernetes@1.28"
  service_mesh: "Istio@1.19"
  monitoring: "Prometheus + Grafana"
  logging: "ELK Stack"
  security: "AWS Security Hub + GuardDuty"
  ci_cd: "GitHub Actions + ArgoCD"
  secrets: "AWS Secrets Manager"

# Infrastructure components
components:
  networking:
    vpc:
      cidr: "10.0.0.0/16"
      availability_zones: 3
      public_subnets: 3
      private_subnets: 3
      database_subnets: 3
    
    security:
      nat_gateway: true
      internet_gateway: true
      vpc_endpoints: ["s3", "ecr", "logs"]
      flow_logs: true
    
    dns:
      route53: true
      ssl_certificates: "ACM managed"
      
  compute:
    kubernetes:
      cluster_version: "1.28"
      node_groups:
        - name: "general"
          instance_types: ["m5.large", "m5.xlarge"]
          min_size: 2
          max_size: 20
          desired_size: 3
        
        - name: "compute-intensive"
          instance_types: ["c5.xlarge", "c5.2xlarge"]
          min_size: 0
          max_size: 10
          desired_size: 0
      
      addons:
        - "aws-load-balancer-controller"
        - "cluster-autoscaler"
        - "ebs-csi-driver"
        - "metrics-server"
    
    auto_scaling:
      enabled: true
      metrics: ["cpu", "memory", "custom"]
      scale_up_cooldown: 300
      scale_down_cooldown: 900
      
  storage:
    databases:
      primary:
        engine: "PostgreSQL@14"
        instance_class: "db.r6g.xlarge"
        storage_type: "gp3"
        storage_size: 500
        backup_retention: 7
        multi_az: true
        
      cache:
        engine: "Redis@7"
        node_type: "cache.r6g.large"
        num_cache_nodes: 3
        
    object_storage:
      buckets:
        - name: "application-data"
          versioning: true
          encryption: "AES256"
          lifecycle_rules: true
        - name: "backup-storage"
          storage_class: "GLACIER"
          retention: 2555  # 7 years
          
  security:
    iam:
      principle: "least_privilege"
      role_based_access: true
      service_accounts: "IRSA"  # IAM Roles for Service Accounts
      
    network_security:
      security_groups: "application-specific"
      nacls: "subnet-level"
      waf: "cloudflare + aws_waf"
      
    compliance:
      frameworks: ["SOC2", "PCI-DSS", "GDPR"]
      encryption_at_rest: true
      encryption_in_transit: true
      audit_logging: true

# Acceptance criteria for infrastructure
acceptance:
  availability:
    uptime_target: 99.9  # 99.9% SLA
    rpo_hours: 4  # Recovery Point Objective
    rto_hours: 1  # Recovery Time Objective
    
  performance:
    application_latency_p95_ms: 200
    database_response_time_ms: 50
    cdn_cache_hit_ratio: 90
    
  scalability:
    horizontal_scaling: true
    auto_scaling_response_time_seconds: 180
    max_concurrent_users: 100000
    
  security:
    vulnerability_scan_passed: true
    penetration_test_passed: true
    compliance_audit_passed: true
    zero_critical_vulnerabilities: true
    
  cost_optimization:
    reserved_instance_coverage: 70
    spot_instance_usage: 30
    unused_resource_threshold: 5
    
  monitoring:
    metrics_retention_days: 90
    log_retention_days: 30
    alerting_response_time_minutes: 5
    dashboard_availability: 99.9

# Disaster recovery configuration
disaster_recovery:
  strategy: "pilot_light"  # pilot_light, warm_standby, multi_site
  
  backup_strategy:
    databases:
      frequency: "continuous"
      retention: "30_days"
      cross_region: true
      testing_schedule: "monthly"
      
    applications:
      frequency: "daily"
      retention: "7_days"
      automation: "full"
      
  failover:
    automatic: false  # Manual failover for production safety
    testing_schedule: "quarterly"
    documentation: "runbook_based"
    
  recovery_procedures:
    database_recovery: "point_in_time"
    application_recovery: "blue_green_switch"
    data_validation: "automated_checksums"

# Monitoring and observability
monitoring:
  metrics:
    infrastructure:
      - "cpu_utilization"
      - "memory_utilization" 
      - "disk_usage"
      - "network_throughput"
      - "load_balancer_latency"
      
    application:
      - "request_rate"
      - "error_rate"
      - "response_time"
      - "queue_depth"
      - "database_connections"
      
    business:
      - "user_registrations"
      - "transaction_volume"
      - "revenue_metrics"
      - "conversion_rate"
  
  alerting:
    channels: ["pagerduty", "slack", "email"]
    severity_levels: ["critical", "warning", "info"]
    
    rules:
      - name: "high_cpu_usage"
        condition: "cpu > 80% for 5 minutes"
        severity: "warning"
        
      - name: "application_errors"
        condition: "error_rate > 1% for 2 minutes"
        severity: "critical"
        
      - name: "database_connections"
        condition: "connections > 80% of max"
        severity: "warning"
  
  logging:
    centralized: true
    structured: true
    retention: "30 days hot, 90 days cold"
    
    log_levels:
      production: "WARN"
      staging: "INFO"
      development: "DEBUG"

# Security configuration
security:
  network_security:
    vpc_flow_logs: true
    ddos_protection: "AWS Shield Advanced"
    firewall: "AWS WAF + CloudFlare"
    
  access_control:
    mfa_required: true
    session_timeout: 8  # hours
    password_policy: "complex"
    audit_logging: true
    
  vulnerability_management:
    scanning_frequency: "weekly"
    patch_management: "automated_non_critical"
    penetration_testing: "quarterly"
    
  compliance:
    data_classification: "automatic"
    retention_policies: "gdpr_compliant"
    audit_trails: "immutable"
    encryption: "end_to_end"

# Cost management
cost_optimization:
  strategies:
    - "right_sizing"
    - "reserved_instances"
    - "spot_instances"
    - "lifecycle_policies"
    - "unused_resource_cleanup"
    
  budgets:
    monthly_limit: 10000  # USD
    alerts:
      - threshold: 50  # Percent
        notification: "email"
      - threshold: 80
        notification: "pagerduty"
      - threshold: 95
        notification: "auto_shutdown_non_critical"
        
  tagging_strategy:
    required_tags:
      - "Environment"
      - "Project"
      - "Owner"
      - "CostCenter"
      - "BackupRequired"

guardrails:
  infrastructure_safety:
    - "terraform_plan_review_required"
    - "infrastructure_changes_require_approval"
    - "no_direct_production_access"
    - "change_management_process"
    
  security_requirements:
    - "security_group_review"
    - "iam_policy_least_privilege"
    - "encryption_everywhere"
    - "regular_security_audits"
    
  compliance_checks:
    - "gdpr_compliance_validation"
    - "data_retention_policy_enforcement"
    - "audit_log_integrity"
    - "access_control_validation"

# CI/CD for infrastructure
deployment:
  pipeline_stages:
    plan:
      - "terraform_validate"
      - "terraform_plan"
      - "cost_estimation"
      - "security_scan"
      - "compliance_check"
      
    apply:
      - "manual_approval_required"
      - "terraform_apply"
      - "infrastructure_testing"
      - "monitoring_setup"
      - "documentation_update"
  
  environments_promotion:
    development: "automatic_on_merge"
    staging: "automatic_after_tests"
    production: "manual_approval_required"
    
  rollback_strategy:
    method: "terraform_state_rollback"
    testing: "automated_rollback_testing"
    documentation: "incident_runbooks"

metadata:
  business_context:
    purpose: "Support scalable web applications with high availability"
    sla_requirements: "99.9% uptime"
    compliance_requirements: ["SOC2", "GDPR", "PCI-DSS"]
    
  technical_context:
    expected_load: "100K concurrent users"
    data_volume: "10TB active, 100TB archived"
    geographic_scope: "North America, Europe"
    
  operational_context:
    team_size: "5 DevOps engineers"
    on_call_rotation: "24/7"
    maintenance_windows: "Sunday 2-4 AM EST"
    
  financial_context:
    monthly_budget: "$10,000"
    cost_per_user_target: "$0.10"
    reserved_instance_commitment: "1 year"
```

## Key Infrastructure Components

### 1. Network Architecture (Terraform)

```hcl
# networking/main.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
    Type = "networking"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = merge(local.common_tags, {
    Name                        = "${var.project_name}-public-${count.index + 1}"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  
  tags = merge(local.common_tags, {
    Name                                = "${var.project_name}-private-${count.index + 1}"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# Database Subnets
resource "aws_subnet" "database" {
  count = length(var.availability_zones)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 20)
  availability_zone = var.availability_zones[count.index]
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-database-${count.index + 1}"
    Type = "database"
  })
}

# NAT Gateways for private subnet internet access
resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  
  domain = "vpc"
  depends_on = [aws_internet_gateway.main]
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-${count.index + 1}"
  })
  
  depends_on = [aws_internet_gateway.main]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  })
}

# VPC Flow Logs
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/vpc/flowlogs/${var.project_name}"
  retention_in_days = 30
  
  tags = local.common_tags
}
```

### 2. Kubernetes Cluster Setup

```hcl
# eks/main.tf
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.kubernetes_version
  
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.public_access_cidrs
    
    security_group_ids = [aws_security_group.eks_cluster.id]
  }
  
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }
  
  enabled_cluster_log_types = [
    "api", "audit", "authenticator", "controllerManager", "scheduler"
  ]
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
    aws_cloudwatch_log_group.eks
  ]
  
  tags = local.common_tags
}

# EKS Node Groups
resource "aws_eks_node_group" "main" {
  for_each = var.node_groups
  
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnet_ids
  
  instance_types = each.value.instance_types
  ami_type       = each.value.ami_type
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size
  
  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }
  
  update_config {
    max_unavailable_percentage = 25
  }
  
  # Ensure proper node group lifecycle
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]
  
  tags = merge(local.common_tags, {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  })
}

# EKS Add-ons
resource "aws_eks_addon" "main" {
  for_each = var.cluster_addons
  
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = each.key
  addon_version            = each.value.version
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = each.value.service_account_role_arn
  
  depends_on = [aws_eks_node_group.main]
  
  tags = local.common_tags
}
```

### 3. Database Infrastructure

```hcl
# database/main.tf
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.database_subnet_ids
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

resource "aws_db_parameter_group" "main" {
  family = "postgres14"
  name   = "${var.project_name}-db-params"
  
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }
  
  parameter {
    name  = "log_statement"
    value = "all"
  }
  
  parameter {
    name  = "log_duration"
    value = "1"
  }
  
  tags = local.common_tags
}

resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-primary-db"
  
  # Engine
  engine                = "postgres"
  engine_version        = var.postgres_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_storage_size
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id           = aws_kms_key.rds.arn
  
  # Database
  db_name  = var.database_name
  username = var.database_username
  password = random_password.database.result
  
  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  
  # Backup
  backup_retention_period = var.backup_retention_days
  backup_window          = "03:00-04:00"
  maintenance_window     = "Sun:04:00-Sun:05:00"
  delete_automated_backups = false
  
  # Monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  # High Availability
  multi_az = var.environment == "production"
  
  # Performance
  performance_insights_enabled = true
  performance_insights_kms_key_id = aws_kms_key.rds.arn
  
  # Parameters
  parameter_group_name = aws_db_parameter_group.main.name
  
  # Deletion protection
  deletion_protection = var.environment == "production"
  skip_final_snapshot = var.environment != "production"
  final_snapshot_identifier = var.environment == "production" ? 
    "${var.project_name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmmss", timestamp())}" : null
  
  tags = local.common_tags
}

# Read Replica for read scaling
resource "aws_db_instance" "read_replica" {
  count = var.environment == "production" ? 1 : 0
  
  identifier = "${var.project_name}-read-replica"
  
  replicate_source_db = aws_db_instance.main.identifier
  instance_class      = var.db_instance_class
  publicly_accessible = false
  
  auto_minor_version_upgrade = true
  
  tags = merge(local.common_tags, {
    Role = "read-replica"
  })
}

# Redis Cache
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-cache-subnet"
  subnet_ids = var.database_subnet_ids
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${var.project_name}-cache"
  description                = "Redis cluster for ${var.project_name}"
  
  port                       = 6379
  parameter_group_name       = "default.redis7"
  node_type                  = var.cache_node_type
  num_cache_clusters         = var.cache_num_nodes
  
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = [aws_security_group.cache.id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = random_password.redis.result
  
  snapshot_retention_limit   = 7
  snapshot_window           = "03:00-05:00"
  maintenance_window        = "sun:05:00-sun:07:00"
  
  tags = local.common_tags
}
```

### 4. Monitoring and Observability

```hcl
# monitoring/main.tf
# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-overview"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EKS", "cluster_failed_request_count", "ClusterName", var.cluster_name],
            [".", "cluster_node_count", ".", "."],
            [".", "cluster_pod_count", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "EKS Cluster Metrics"
        }
      },
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.main.id],
            [".", "DatabaseConnections", ".", "."],
            [".", "FreeableMemory", ".", "."],
            [".", "ReadLatency", ".", "."],
            [".", "WriteLatency", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RDS Metrics"
        }
      }
    ]
  })
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
  
  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "${var.project_name}-database-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }
  
  tags = local.common_tags
}

# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
  
  tags = local.common_tags
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "application" {
  name              = "/application/${var.project_name}"
  retention_in_days = var.log_retention_days
  
  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days
  
  tags = local.common_tags
}
```

### 5. Kubernetes Applications (Helm Charts)

```yaml
# k8s/monitoring/prometheus-values.yaml
prometheus:
  prometheusSpec:
    retention: 90d
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: gp3
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 100Gi
    
    resources:
      requests:
        memory: "2Gi"
        cpu: "1"
      limits:
        memory: "4Gi"
        cpu: "2"
    
    # Service discovery
    serviceMonitorSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false
    ruleSelectorNilUsesHelmValues: false
    
    # Additional scrape configs
    additionalScrapeConfigs:
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true

grafana:
  adminPassword: "{{.Values.global.grafana.adminPassword}}"
  
  persistence:
    enabled: true
    storageClassName: gp3
    size: 20Gi
  
  datasources:
    datasources.yaml:
      apiVersion: 1
      datasources:
        - name: Prometheus
          type: prometheus
          url: http://prometheus-server:80
          access: proxy
          isDefault: true
        - name: Loki
          type: loki
          url: http://loki:3100
          access: proxy
  
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
        - name: 'default'
          orgId: 1
          folder: ''
          type: file
          disableDeletion: false
          editable: true
          options:
            path: /var/lib/grafana/dashboards/default
  
  dashboards:
    default:
      kubernetes-cluster-monitoring:
        gnetId: 7249
        revision: 1
        datasource: Prometheus
      kubernetes-pod-monitoring:
        gnetId: 6417
        revision: 1
        datasource: Prometheus
```

### 6. Security Configuration

```hcl
# security/main.tf
# Security Groups
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project_name}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id
  
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = local.common_tags
}

resource "aws_security_group" "database" {
  name        = "${var.project_name}-database-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id
  
  ingress {
    description     = "PostgreSQL"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }
  
  tags = local.common_tags
}

# KMS Keys
resource "aws_kms_key" "main" {
  description             = "KMS key for ${var.project_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableIAMUserPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
  
  tags = local.common_tags
}

# WAF
resource "aws_wafv2_web_acl" "main" {
  name  = "${var.project_name}-waf"
  scope = "REGIONAL"
  
  default_action {
    allow {}
  }
  
  # Rate limiting rule
  rule {
    name     = "RateLimitRule"
    priority = 1
    
    action {
      block {}
    }
    
    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-rate-limit"
      sampled_requests_enabled   = true
    }
  }
  
  # AWS managed rules
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10
    
    override_action {
      none {}
    }
    
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-common-rules"
      sampled_requests_enabled   = true
    }
  }
  
  tags = local.common_tags
}
```

### 7. CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/infrastructure.yml
name: Infrastructure Deployment

on:
  push:
    branches: [main]
    paths: ['terraform/**']
  pull_request:
    branches: [main]
    paths: ['terraform/**']

env:
  TF_VERSION: '1.6.0'
  AWS_REGION: 'us-east-1'

jobs:
  terraform-plan:
    name: Terraform Plan
    runs-on: ubuntu-latest
    environment: ${{ github.ref == 'refs/heads/main' && 'production' || 'development' }}
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: ${{ env.TF_VERSION }}
      
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: Terraform Format Check
        run: terraform fmt -check -recursive
        working-directory: terraform/
      
      - name: Terraform Init
        run: terraform init
        working-directory: terraform/
      
      - name: Terraform Validate
        run: terraform validate
        working-directory: terraform/
      
      - name: Terraform Plan
        run: |
          terraform plan \
            -var-file="environments/${{ github.ref == 'refs/heads/main' && 'production' || 'development' }}.tfvars" \
            -out=tfplan
        working-directory: terraform/
      
      - name: Upload Plan
        uses: actions/upload-artifact@v4
        with:
          name: terraform-plan
          path: terraform/tfplan
      
      - name: Cost Estimation
        uses: infracost/actions/breakdown@v2
        with:
          path: terraform/
          terraform_plan_path: terraform/tfplan
        env:
          INFRACOST_API_KEY: ${{ secrets.INFRACOST_API_KEY }}
      
      - name: Security Scan
        uses: aquasecurity/tfsec-action@v1.0.3
        with:
          working_directory: terraform/
  
  terraform-apply:
    name: Terraform Apply
    needs: terraform-plan
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: ${{ env.TF_VERSION }}
      
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: Download Plan
        uses: actions/download-artifact@v4
        with:
          name: terraform-plan
          path: terraform/
      
      - name: Terraform Init
        run: terraform init
        working-directory: terraform/
      
      - name: Terraform Apply
        run: terraform apply tfplan
        working-directory: terraform/
      
      - name: Update Infrastructure Documentation
        run: |
          terraform-docs markdown table --output-file ../docs/infrastructure.md terraform/
      
      - name: Notify Deployment Success
        uses: 8398a7/action-slack@v3
        with:
          status: success
          text: "Infrastructure deployment completed successfully"
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## Project Structure

```
production-cloud-infrastructure/
├── terraform/
│   ├── environments/
│   │   ├── development.tfvars
│   │   ├── staging.tfvars
│   │   └── production.tfvars
│   ├── modules/
│   │   ├── networking/
│   │   ├── compute/
│   │   ├── database/
│   │   ├── monitoring/
│   │   └── security/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── k8s/
│   ├── applications/
│   ├── monitoring/
│   ├── ingress/
│   └── security/
├── scripts/
│   ├── backup.sh
│   ├── disaster-recovery.sh
│   └── health-check.sh
├── docs/
│   ├── architecture.md
│   ├── runbooks/
│   └── disaster-recovery.md
└── .github/
    └── workflows/
```

## Benefits

### Technical Benefits
- **Infrastructure as Code** provides version control and repeatability
- **Multi-environment support** with consistent configurations
- **Auto-scaling** handles traffic spikes automatically
- **High availability** with multi-AZ deployments
- **Comprehensive monitoring** enables proactive issue resolution

### Operational Benefits
- **Reduced manual work** through automation
- **Faster disaster recovery** with tested procedures
- **Cost optimization** through right-sizing and reserved instances
- **Security compliance** with built-in security controls
- **Audit trail** for all infrastructure changes

## Advanced Features

### Multi-Region Disaster Recovery

```hcl
# disaster-recovery/main.tf
resource "aws_db_instance" "replica" {
  provider = aws.disaster_recovery_region
  
  identifier = "${var.project_name}-dr-replica"
  
  replicate_source_db = aws_db_instance.main.arn
  instance_class      = var.dr_db_instance_class
  
  # Cross-region replica specific settings
  auto_minor_version_upgrade = false
  backup_retention_period    = 7
  backup_window             = "09:00-10:00"  # Different window than primary
  
  tags = merge(local.common_tags, {
    Role = "disaster-recovery"
    Region = var.disaster_recovery_region
  })
}
```

### Cost Optimization Automation

```python
# scripts/cost-optimizer.py
import boto3
import json
from datetime import datetime, timedelta

class CostOptimizer:
    def __init__(self):
        self.ec2 = boto3.client('ec2')
        self.cloudwatch = boto3.client('cloudwatch')
    
    def identify_underutilized_resources(self):
        """Identify underutilized EC2 instances for right-sizing"""
        instances = self.ec2.describe_instances()
        recommendations = []
        
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                if instance['State']['Name'] == 'running':
                    cpu_utilization = self.get_average_cpu_utilization(
                        instance['InstanceId']
                    )
                    
                    if cpu_utilization < 10:  # Less than 10% average CPU
                        recommendations.append({
                            'InstanceId': instance['InstanceId'],
                            'InstanceType': instance['InstanceType'],
                            'CPUUtilization': cpu_utilization,
                            'Recommendation': 'Consider downsizing or stopping'
                        })
        
        return recommendations
    
    def get_average_cpu_utilization(self, instance_id, days=7):
        """Get average CPU utilization for the last N days"""
        end_time = datetime.utcnow()
        start_time = end_time - timedelta(days=days)
        
        response = self.cloudwatch.get_metric_statistics(
            Namespace='AWS/EC2',
            MetricName='CPUUtilization',
            Dimensions=[
                {'Name': 'InstanceId', 'Value': instance_id}
            ],
            StartTime=start_time,
            EndTime=end_time,
            Period=3600,  # 1 hour
            Statistics=['Average']
        )
        
        if response['Datapoints']:
            return sum(dp['Average'] for dp in response['Datapoints']) / len(response['Datapoints'])
        
        return 0
```

## Related Examples

- [API Service →]({{ 'examples/api-service/' | relative_url }}) - Applications running on this infrastructure
- [ML Pipeline →]({{ 'examples/ml-pipeline/' | relative_url }}) - ML workloads on Kubernetes
- [Mobile App →]({{ 'examples/mobile-app/' | relative_url }}) - Mobile backend infrastructure

## Next Steps

1. **Service Mesh** - Implement Istio for advanced traffic management
2. **GitOps** - Add ArgoCD for Kubernetes application deployment
3. **Chaos Engineering** - Implement chaos testing with tools like Chaos Monkey
4. **Edge Computing** - Add CDN and edge locations for global performance
5. **Compliance Automation** - Implement continuous compliance monitoring