---
layout: guide  
title: "Deployment Strategies"
description: "Comprehensive guide to deploying OSpec applications across different platforms and environments"
difficulty: advanced
time: "40 minutes"
order: 5
---

# Deployment Strategies for OSpec Applications

Deployment is a critical phase where your OSpec-generated application becomes available to users. This guide covers deployment strategies, platforms, and best practices for reliable, scalable deployments.

## Deployment Fundamentals

### Core Principles

1. **Automated Deployments**: Manual deployments are error-prone and don't scale
2. **Environment Consistency**: Development, staging, and production should be identical
3. **Rollback Capability**: Always have a way to quickly revert problematic deployments
4. **Health Monitoring**: Continuously monitor application health and performance
5. **Security First**: Secure configurations, secrets management, and access controls

### Deployment Lifecycle

```
Code → Build → Test → Package → Deploy → Monitor → (Rollback if needed)
```

### OSpec Deployment Configuration

```yaml
# Example OSpec deployment section
stack:
  deploy: "Vercel" # or "Docker + Kubernetes", "AWS Lambda", etc.

scripts:
  build: "npm run build"
  test: "npm run test:production"
  deploy: "npm run deploy:production"
  rollback: "npm run rollback"
  health_check: "curl -f $HEALTH_CHECK_URL/health"

guardrails:
  deployment:
    tests_required: true
    security_scan_required: true
    human_approval_required: ["production"]
    rollback_timeout_minutes: 5
    health_check_retries: 3

secrets:
  provider: "vercel://env" # or your preferred secrets manager
  required:
    - "DATABASE_URL"
    - "API_KEY"
    - "JWT_SECRET"

monitoring:
  health_check_url: "${APP_URL}/health"
  error_tracking: "Sentry"
  performance_monitoring: "Vercel Analytics"
```

## Platform-Specific Deployment

### Vercel (Serverless Next.js)

Perfect for JAMstack applications, static sites, and serverless APIs.

#### Configuration
```yaml
# OSpec configuration
stack:
  frontend: "Next.js"
  backend: "Vercel Serverless Functions"
  database: "PlanetScale" # or "Supabase"
  deploy: "Vercel"

secrets:
  provider: "vercel://env"
  required:
    - "DATABASE_URL"
    - "NEXTAUTH_SECRET"
    - "NEXTAUTH_URL"
```

#### Deployment Files
```json
// vercel.json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/next"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/api/$1"
    }
  ],
  "env": {
    "DATABASE_URL": "@database_url",
    "NEXTAUTH_SECRET": "@nextauth_secret"
  },
  "functions": {
    "pages/api/**/*.js": {
      "maxDuration": 10
    }
  },
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options", 
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
```

#### GitHub Actions Workflow
```yaml
# .github/workflows/deploy-vercel.yml
name: Deploy to Vercel
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm run test
      
      - name: Build application
        run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          vercel-args: '--prod'
```

### Railway (Full-Stack Applications)

Great for full-stack applications with databases and background services.

#### Configuration
```yaml
# OSpec configuration  
stack:
  backend: "Node.js + Express"
  database: "PostgreSQL" 
  deploy: "Railway"

scripts:
  build: "npm run build"
  start: "npm run start:production"
  migrate: "npm run db:migrate"
```

#### Railway Configuration
```toml
# railway.toml
[build]
builder = "nixpacks"
buildCommand = "npm run build"

[deploy]
startCommand = "npm run start:production"
healthcheckPath = "/health"
healthcheckTimeout = 300
restartPolicyType = "always"

[[deploy.environmentVariables]]
name = "NODE_ENV"
value = "production"
```

#### Dockerfile (Alternative)
```dockerfile
# Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine AS runtime

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

RUN chown -R nextjs:nodejs /app
USER nextjs

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["npm", "start"]
```

### AWS (Enterprise Cloud Deployment)

Comprehensive cloud platform for large-scale, enterprise applications.

#### Container Deployment (ECS)
```yaml
# OSpec configuration for AWS
stack:
  backend: "Node.js + Express"  
  database: "RDS PostgreSQL"
  cache: "ElastiCache Redis"
  deploy: "AWS ECS with Fargate"
  load_balancer: "Application Load Balancer"
  monitoring: "CloudWatch"

secrets:
  provider: "aws-secrets-manager"
  region: "us-east-1"
```

#### ECS Task Definition
```json
{
  "family": "ospec-app",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "executionRoleArn": "arn:aws:iam::123456789:role/ecsTaskExecutionRole",
  "taskRoleArn": "arn:aws:iam::123456789:role/ecsTaskRole",
  "containerDefinitions": [
    {
      "name": "app",
      "image": "123456789.dkr.ecr.us-east-1.amazonaws.com/ospec-app:latest",
      "portMappings": [
        {
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "production"
        }
      ],
      "secrets": [
        {
          "name": "DATABASE_URL",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789:secret:prod/database_url"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/ospec-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ]
}
```

#### CDK Deployment Script
```typescript
// infrastructure/app-stack.ts
import * as cdk from 'aws-cdk-lib';
import * as ecs from 'aws-cdk-lib/aws-ecs';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as elbv2 from 'aws-cdk-lib/aws-elasticloadbalancingv2';
import * as rds from 'aws-cdk-lib/aws-rds';
import { Construct } from 'constructs';

export class OSpecAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // VPC
    const vpc = new ec2.Vpc(this, 'OSpecVPC', {
      maxAzs: 2,
      natGateways: 1
    });

    // Database
    const database = new rds.DatabaseInstance(this, 'Database', {
      engine: rds.DatabaseInstanceEngine.postgres({
        version: rds.PostgresEngineVersion.VER_15
      }),
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T3, ec2.InstanceSize.MICRO),
      vpc,
      databaseName: 'ospecdb',
      deletionProtection: true,
      backupRetention: cdk.Duration.days(7)
    });

    // ECS Cluster
    const cluster = new ecs.Cluster(this, 'Cluster', {
      vpc,
      containerInsights: true
    });

    // Task Definition
    const taskDefinition = new ecs.FargateTaskDefinition(this, 'TaskDefinition', {
      memoryLimitMiB: 1024,
      cpu: 512
    });

    const container = taskDefinition.addContainer('app', {
      image: ecs.ContainerImage.fromRegistry('your-registry/ospec-app:latest'),
      environment: {
        NODE_ENV: 'production'
      },
      secrets: {
        DATABASE_URL: ecs.Secret.fromSecretsManager(database.secret!)
      },
      logging: ecs.LogDrivers.awsLogs({
        streamPrefix: 'ospec-app'
      }),
      healthCheck: {
        command: ['CMD-SHELL', 'curl -f http://localhost:3000/health || exit 1'],
        interval: cdk.Duration.seconds(30),
        timeout: cdk.Duration.seconds(5),
        retries: 3,
        startPeriod: cdk.Duration.seconds(60)
      }
    });

    container.addPortMappings({
      containerPort: 3000,
      protocol: ecs.Protocol.TCP
    });

    // ECS Service  
    const service = new ecs.FargateService(this, 'Service', {
      cluster,
      taskDefinition,
      desiredCount: 2,
      assignPublicIp: false
    });

    // Load Balancer
    const lb = new elbv2.ApplicationLoadBalancer(this, 'LoadBalancer', {
      vpc,
      internetFacing: true
    });

    const listener = lb.addListener('Listener', {
      port: 80,
      defaultAction: elbv2.ListenerAction.forward([
        service.loadBalancerTarget({
          containerName: 'app',
          containerPort: 3000
        })
      ])
    });

    // Auto Scaling
    const scaling = service.autoScaleTaskCount({
      minCapacity: 2,
      maxCapacity: 10
    });

    scaling.scaleOnCpuUtilization('CpuScaling', {
      targetUtilizationPercent: 70
    });

    scaling.scaleOnMemoryUtilization('MemoryScaling', {
      targetUtilizationPercent: 80
    });
  }
}
```

### Kubernetes (Container Orchestration)

For complex, microservice-based applications requiring advanced orchestration.

#### Kubernetes Manifests
```yaml
# k8s/namespace.yml
apiVersion: v1
kind: Namespace
metadata:
  name: ospec-app

---
# k8s/deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ospec-app
  namespace: ospec-app
  labels:
    app: ospec-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: ospec-app
  template:
    metadata:
      labels:
        app: ospec-app
    spec:
      containers:
      - name: app
        image: your-registry/ospec-app:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
        securityContext:
          runAsNonRoot: true
          runAsUser: 1001
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true

---
# k8s/service.yml
apiVersion: v1
kind: Service
metadata:
  name: ospec-app-service
  namespace: ospec-app
spec:
  selector:
    app: ospec-app
  ports:
  - port: 80
    targetPort: 3000
    protocol: TCP
  type: ClusterIP

---
# k8s/ingress.yml  
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ospec-app-ingress
  namespace: ospec-app
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/rate-limit: "100"
spec:
  tls:
  - hosts:
    - your-app.com
    secretName: ospec-app-tls
  rules:
  - host: your-app.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ospec-app-service
            port:
              number: 80

---
# k8s/hpa.yml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ospec-app-hpa
  namespace: ospec-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ospec-app
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

#### Helm Chart (Package Management)
```yaml
# helm/ospec-app/Chart.yaml
apiVersion: v2
name: ospec-app
description: OSpec Application Helm Chart
type: application
version: 1.0.0
appVersion: "1.0.0"

# helm/ospec-app/values.yaml
replicaCount: 3

image:
  repository: your-registry/ospec-app
  tag: "latest"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
  targetPort: 3000

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: your-app.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: ospec-app-tls
      hosts:
        - your-app.com

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 20
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80

nodeSelector: {}
tolerations: []
affinity: {}
```

## Deployment Strategies

### Blue-Green Deployment

Run two identical production environments, switching traffic between them.

```yaml
# OSpec configuration for blue-green
deployment:
  strategy: "blue_green"
  environments:
    blue:
      url: "https://blue.your-app.com"
      instances: 3
    green:  
      url: "https://green.your-app.com"
      instances: 3
  
  traffic_switching:
    validation_checks:
      - health_check
      - smoke_tests
      - performance_baseline
    rollback_threshold_seconds: 300
```

#### Implementation Script
```bash
#!/bin/bash
# scripts/blue-green-deploy.sh

set -e

CURRENT_ENV=$(kubectl get service app-service -o jsonpath='{.spec.selector.version}')
NEW_ENV=$([ "$CURRENT_ENV" = "blue" ] && echo "green" || echo "blue")

echo "Current environment: $CURRENT_ENV"
echo "Deploying to: $NEW_ENV"

# Deploy to new environment
kubectl set image deployment/app-$NEW_ENV app=your-registry/ospec-app:$BUILD_VERSION
kubectl rollout status deployment/app-$NEW_ENV

# Run health checks
echo "Running health checks on $NEW_ENV..."
for i in {1..30}; do
  if curl -f "https://$NEW_ENV.your-app.com/health"; then
    echo "Health check passed"
    break
  fi
  echo "Health check failed, retrying in 10s..."
  sleep 10
done

# Run smoke tests
echo "Running smoke tests..."
npm run test:smoke -- --env=$NEW_ENV

# Switch traffic
echo "Switching traffic to $NEW_ENV..."
kubectl patch service app-service -p '{"spec":{"selector":{"version":"'$NEW_ENV'"}}}'

# Verify traffic switch
echo "Verifying traffic switch..."
sleep 30
if curl -f "https://your-app.com/health"; then
  echo "Traffic switch successful"
  
  # Scale down old environment
  kubectl scale deployment app-$CURRENT_ENV --replicas=0
  echo "Blue-green deployment completed successfully"
else
  echo "Traffic switch failed, rolling back..."
  kubectl patch service app-service -p '{"spec":{"selector":{"version":"'$CURRENT_ENV'"}}}'
  exit 1
fi
```

### Canary Deployment

Gradually roll out changes to a subset of users.

```yaml
# Istio Canary Configuration
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: ospec-app
spec:
  http:
  - match:
    - headers:
        canary:
          exact: "true"
    route:
    - destination:
        host: ospec-app-canary
      weight: 100
  - route:
    - destination:
        host: ospec-app-stable
      weight: 90
    - destination:
        host: ospec-app-canary
      weight: 10

---
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: ospec-app
spec:
  host: ospec-app
  subsets:
  - name: stable
    labels:
      version: stable
  - name: canary
    labels:
      version: canary
```

#### Automated Canary with Flagger
```yaml
apiVersion: flagger.app/v1beta1
kind: Canary
metadata:
  name: ospec-app
  namespace: ospec-app
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ospec-app
  progressDeadlineSeconds: 60
  service:
    port: 3000
    targetPort: 3000
  analysis:
    interval: 30s
    threshold: 5
    maxWeight: 50
    stepWeight: 10
    metrics:
    - name: request-success-rate
      thresholdRange:
        min: 99
      interval: 30s
    - name: request-duration
      thresholdRange:
        max: 500
      interval: 30s
    webhooks:
    - name: smoke-tests
      type: pre-rollout
      url: http://flagger-loadtester.test/
      timeout: 15s
      metadata:
        type: bash
        cmd: "curl -sd 'test' http://ospec-app-canary.ospec-app:3000/health"
```

### Rolling Deployment

Default Kubernetes strategy, gradually replacing old instances.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ospec-app
spec:
  replicas: 6
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 2
  template:
    spec:
      containers:
      - name: app
        image: your-registry/ospec-app:latest
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 10
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 2
```

## Environment Management

### Environment Configuration Strategy

```yaml
# Base OSpec configuration
environments:
  development:
    stack:
      database: "SQLite"
      cache: "in-memory"
      deploy: "local"
    
    guardrails:
      tests_required: false
      security_scan: "warn"
    
    secrets:
      provider: "local://env"

  staging:
    stack:
      database: "PostgreSQL (shared)"
      cache: "Redis (shared)"
      deploy: "Railway"
    
    guardrails:
      tests_required: true
      min_test_coverage: 0.7
      security_scan: "error"
    
    secrets:
      provider: "railway://env"

  production:
    stack:
      database: "PostgreSQL (dedicated)"
      cache: "Redis Cluster"
      deploy: "AWS ECS"
    
    guardrails:
      tests_required: true
      min_test_coverage: 0.9
      security_scan: "block"
      human_approval_required: true
    
    secrets:
      provider: "aws-secrets-manager"
    
    monitoring:
      apm: "Datadog"
      logging: "CloudWatch"
      alerting: "PagerDuty"
```

### Configuration Management

#### Environment-Specific Configs
```javascript
// config/index.js
const config = {
  development: {
    port: 3000,
    database: {
      url: process.env.DATABASE_URL || 'sqlite:./dev.db'
    },
    redis: {
      url: 'redis://localhost:6379'
    },
    logging: {
      level: 'debug'
    }
  },
  
  staging: {
    port: process.env.PORT || 3000,
    database: {
      url: process.env.DATABASE_URL,
      ssl: true,
      pool: { min: 2, max: 10 }
    },
    redis: {
      url: process.env.REDIS_URL,
      ssl: true
    },
    logging: {
      level: 'info'
    }
  },
  
  production: {
    port: process.env.PORT || 3000,
    database: {
      url: process.env.DATABASE_URL,
      ssl: true,
      pool: { min: 5, max: 20 }
    },
    redis: {
      url: process.env.REDIS_URL,
      ssl: true,
      cluster: true
    },
    logging: {
      level: 'warn'
    }
  }
};

module.exports = config[process.env.NODE_ENV || 'development'];
```

## Monitoring & Health Checks

### Health Check Implementation

```javascript
// routes/health.js
import express from 'express';
import { checkDatabase, checkRedis, checkExternalServices } from '../utils/health.js';

const router = express.Router();

// Basic health check
router.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION || 'unknown'
  });
});

// Comprehensive readiness check
router.get('/ready', async (req, res) => {
  const checks = {
    database: false,
    redis: false,
    external_services: false
  };

  try {
    // Check database connection
    checks.database = await checkDatabase();
    
    // Check Redis connection  
    checks.redis = await checkRedis();
    
    // Check external service dependencies
    checks.external_services = await checkExternalServices();

    const allHealthy = Object.values(checks).every(check => check === true);

    res.status(allHealthy ? 200 : 503).json({
      status: allHealthy ? 'ready' : 'not_ready',
      timestamp: new Date().toISOString(),
      checks
    });
  } catch (error) {
    res.status(503).json({
      status: 'error',
      timestamp: new Date().toISOString(),
      error: error.message,
      checks
    });
  }
});

// Liveness probe (simpler check)
router.get('/alive', (req, res) => {
  res.status(200).json({ status: 'alive' });
});

export default router;
```

### Application Metrics

```javascript
// utils/metrics.js
import promClient from 'prom-client';

// Create metrics registry
const register = promClient.register;

// HTTP request duration histogram
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.25, 0.5, 1, 2.5, 5, 10]
});

// Active connections gauge
const activeConnections = new promClient.Gauge({
  name: 'active_connections',
  help: 'Number of active connections'
});

// Request counter
const httpRequestTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Database query duration
const dbQueryDuration = new promClient.Histogram({
  name: 'database_query_duration_seconds',
  help: 'Duration of database queries in seconds',
  labelNames: ['query_type', 'table']
});

// Export metrics endpoint
export const metricsHandler = (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(register.metrics());
};

// Middleware to track HTTP requests
export const trackHttpRequests = (req, res, next) => {
  const startTime = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - startTime) / 1000;
    const labels = {
      method: req.method,
      route: req.route?.path || req.path,
      status_code: res.statusCode
    };
    
    httpRequestDuration.observe(labels, duration);
    httpRequestTotal.inc(labels);
  });
  
  next();
};

export { httpRequestDuration, activeConnections, httpRequestTotal, dbQueryDuration };
```

## Security in Deployment

### Secure Container Images

```dockerfile
# Multi-stage build for security
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

FROM node:18-alpine AS runtime

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001 -G nodejs

# Install security updates
RUN apk update && apk upgrade && apk add --no-cache dumb-init

WORKDIR /app

# Copy application files
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --chown=nextjs:nodejs . .

# Remove unnecessary files
RUN rm -rf tests/ docs/ .git/ *.md

# Set up proper permissions
RUN chown -R nextjs:nodejs /app && \
    chmod -R 755 /app

# Switch to non-root user
USER nextjs

# Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["npm", "start"]
```

### Network Security

```yaml
# Kubernetes NetworkPolicy
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ospec-app-netpol
  namespace: ospec-app
spec:
  podSelector:
    matchLabels:
      app: ospec-app
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 3000
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: database
    ports:
    - protocol: TCP
      port: 5432
  - to: []
    ports:
    - protocol: TCP
      port: 443  # HTTPS
    - protocol: TCP  
      port: 53   # DNS
    - protocol: UDP
      port: 53   # DNS
```

### Secrets Management

```yaml
# Kubernetes Secret
apiVersion: v1
kind: Secret
metadata:
  name: ospec-app-secrets
  namespace: ospec-app
type: Opaque
data:
  database-url: <base64-encoded-value>
  jwt-secret: <base64-encoded-value>
  api-key: <base64-encoded-value>

---
# External Secrets Operator (recommended)
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: aws-secrets-store
  namespace: ospec-app
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets-sa

---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ospec-app-external-secret
  namespace: ospec-app
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-store
    kind: SecretStore
  target:
    name: ospec-app-secrets
    creationPolicy: Owner
  data:
  - secretKey: database-url
    remoteRef:
      key: prod/ospec-app/database-url
  - secretKey: jwt-secret
    remoteRef:
      key: prod/ospec-app/jwt-secret
```

## Rollback Strategies

### Automated Rollback

```bash
#!/bin/bash
# scripts/rollback.sh

set -e

NAMESPACE="ospec-app"
DEPLOYMENT="ospec-app"

echo "Checking current deployment status..."
if ! kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=60s; then
  echo "Deployment is unhealthy, initiating rollback..."
  
  # Roll back to previous revision
  kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE
  
  echo "Waiting for rollback to complete..."
  kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=300s
  
  # Verify rollback success
  echo "Running health checks after rollback..."
  sleep 30
  
  if curl -f "https://your-app.com/health"; then
    echo "Rollback successful"
    
    # Send notification
    curl -X POST "$SLACK_WEBHOOK" \
      -H 'Content-type: application/json' \
      -d '{"text":"🚨 Automatic rollback completed for ospec-app"}'
  else
    echo "Rollback failed, manual intervention required"
    exit 1
  fi
fi
```

### Database Migration Rollback

```javascript
// migrations/rollback-strategy.js
export class MigrationRollback {
  static async safeRollback(migrationVersion) {
    const migration = await this.getMigration(migrationVersion);
    
    if (!migration.rollback) {
      throw new Error(`Migration ${migrationVersion} does not support rollback`);
    }
    
    // Create backup before rollback
    await this.createBackup(`pre-rollback-${migrationVersion}`);
    
    try {
      // Execute rollback
      await migration.rollback();
      
      // Verify rollback
      await this.verifyRollback(migrationVersion);
      
      console.log(`Successfully rolled back migration ${migrationVersion}`);
    } catch (error) {
      // Restore backup on rollback failure
      await this.restoreBackup(`pre-rollback-${migrationVersion}`);
      throw new Error(`Rollback failed: ${error.message}`);
    }
  }
  
  static async verifyRollback(migrationVersion) {
    // Add verification logic specific to your application
    const criticalTables = await this.checkCriticalTables();
    const dataIntegrity = await this.checkDataIntegrity();
    
    if (!criticalTables || !dataIntegrity) {
      throw new Error('Rollback verification failed');
    }
  }
}
```

## Monitoring & Observability

### Application Monitoring

```yaml
# OSpec monitoring configuration
monitoring:
  health_checks:
    - endpoint: "/health"
      interval_seconds: 30
      timeout_seconds: 5
    - endpoint: "/ready" 
      interval_seconds: 10
      timeout_seconds: 3
  
  metrics:
    - name: "response_time_p95"
      threshold: 500  # milliseconds
    - name: "error_rate"
      threshold: 0.01  # 1%
    - name: "cpu_usage"
      threshold: 0.8   # 80%
    - name: "memory_usage"
      threshold: 0.9   # 90%
  
  alerts:
    - name: "High Error Rate"
      condition: "error_rate > 0.05"
      severity: "critical"
      channels: ["slack", "pagerduty"]
    
    - name: "High Response Time"
      condition: "response_time_p95 > 1000"
      severity: "warning"
      channels: ["slack"]
```

### Distributed Tracing

```javascript
// utils/tracing.js
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { JaegerExporter } from '@opentelemetry/exporter-jaeger';

const jaegerExporter = new JaegerExporter({
  endpoint: process.env.JAEGER_ENDPOINT || 'http://localhost:14268/api/traces',
});

const sdk = new NodeSDK({
  traceExporter: jaegerExporter,
  instrumentations: [getNodeAutoInstrumentations()],
  serviceName: 'ospec-app',
});

sdk.start();

export default sdk;
```

## Performance Optimization

### CDN Configuration

```yaml
# Cloudflare configuration
cdn:
  provider: "Cloudflare"
  settings:
    cache_level: "aggressive"
    browser_ttl: 86400  # 24 hours
    edge_ttl: 2592000   # 30 days
    minify:
      html: true
      css: true
      js: true
    compression: "gzip"
    
    rules:
      - pattern: "*.css"
        cache_ttl: 31536000  # 1 year
      - pattern: "*.js"
        cache_ttl: 31536000  # 1 year
      - pattern: "*.png|*.jpg|*.jpeg|*.gif|*.ico"
        cache_ttl: 31536000  # 1 year
      - pattern: "/api/*"
        cache_ttl: 0         # No cache for API
```

### Database Optimization

```javascript
// config/database.js
export const productionConfig = {
  pool: {
    min: 5,
    max: 20,
    acquire: 30000,
    idle: 10000
  },
  
  // Enable connection pooling
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false
    }
  },
  
  // Query optimization
  benchmark: true,
  logging: (msg, timing) => {
    if (timing > 1000) {
      console.warn(`Slow query (${timing}ms): ${msg}`);
    }
  },
  
  // Read replicas for scaling
  replication: {
    read: [
      { host: 'read-replica-1.db.com', username: 'reader', password: process.env.DB_READ_PASSWORD },
      { host: 'read-replica-2.db.com', username: 'reader', password: process.env.DB_READ_PASSWORD }
    ],
    write: { host: 'primary.db.com', username: 'writer', password: process.env.DB_WRITE_PASSWORD }
  }
};
```

This comprehensive deployment guide covers the essential aspects of deploying OSpec applications across different platforms and environments. The key is to match your deployment strategy to your application's requirements, team capabilities, and organizational constraints while maintaining security, reliability, and performance standards.