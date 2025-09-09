---
layout: cookbook
title: "Performance Optimization"
description: "Techniques and patterns for optimizing OSpec project performance"
tags: ["performance", "optimization", "scalability"]
category: "performance"
difficulty: "advanced"
redirect_from:
  - /cookbook/performance/
---

# Performance Optimization

Comprehensive guide to optimizing performance across all aspects of OSpec projects, from specification design to deployment.

## Specification-Level Optimizations

### Efficient Agent Task Design

```yaml
# ❌ Large, monolithic tasks
tasks:
  - id: "build-entire-application"
    estimated_hours: 40
    description: "Build complete web application with all features"

# ✅ Smaller, parallelizable tasks
tasks:
  - id: "setup-project-structure"
    estimated_hours: 2
    parallelizable: true
    
  - id: "implement-authentication"
    estimated_hours: 8
    depends_on: ["setup-project-structure"]
    
  - id: "build-user-interface"
    estimated_hours: 12
    depends_on: ["setup-project-structure"]
    parallelizable_with: ["implement-authentication"]
```

### Smart Resource Allocation

```yaml
# Dynamic resource scaling
resources:
  scaling_strategy: "demand_based"
  
  profiles:
    development:
      cpu_cores: 2
      memory_gb: 4
      auto_scale: false
      
    production:
      cpu_cores: 8
      memory_gb: 32
      auto_scale: true
      scale_metrics: ["cpu", "memory", "requests"]
      
  optimization:
    memory_management: "aggressive"
    cpu_scheduling: "fair"
    io_priority: "high"
```

### Dependency Optimization

```yaml
# Minimize dependency conflicts
stack:
  dependency_strategy: "minimal"
  
  core_only: true
  optional_dependencies:
    - name: "analytics"
      lazy_load: true
      condition: "production_only"
      
  dependency_caching:
    enabled: true
    cache_duration: "24h"
    shared_cache: true
```

## Build and Compilation Optimizations

### Parallel Build Configuration

```yaml
# Build optimization settings
build:
  parallelization:
    enabled: true
    max_workers: 4  # Number of CPU cores
    task_splitting: "automatic"
    
  caching:
    build_cache: true
    dependency_cache: true
    incremental_builds: true
    cache_strategy: "layered"
    
  optimization:
    minification: true
    tree_shaking: true
    code_splitting: true
    compression: "gzip + brotli"
```

### Asset Optimization

```yaml
# Asset pipeline optimization
assets:
  images:
    formats: ["webp", "avif", "jpg"]
    quality: 85
    lazy_loading: true
    responsive_images: true
    
  fonts:
    subset: true
    preload_critical: true
    swap_strategy: "swap"
    
  css:
    critical_css: "inline"
    non_critical: "async"
    unused_css_removal: true
    
  javascript:
    code_splitting: "route_based"
    lazy_loading: "component_based"
    polyfill_strategy: "selective"
```

## Database Performance

### Query Optimization

```yaml
# Database performance configuration
database:
  performance:
    connection_pooling:
      min_connections: 5
      max_connections: 100
      idle_timeout: 300
      
    query_optimization:
      prepared_statements: true
      query_plan_caching: true
      index_hints: true
      
    caching:
      query_cache: true
      result_cache: true
      cache_ttl: 3600  # 1 hour
      
  monitoring:
    slow_query_log: true
    slow_query_threshold: 1000  # ms
    explain_analyze: true
```

### Database Schema Optimization

```sql
-- Example optimized schema patterns
-- Use appropriate indexes
CREATE INDEX CONCURRENTLY idx_users_email_active 
ON users(email) WHERE active = true;

-- Partial indexes for common queries
CREATE INDEX idx_orders_status_recent 
ON orders(status, created_at) 
WHERE created_at > NOW() - INTERVAL '30 days';

-- Composite indexes for multi-column queries
CREATE INDEX idx_products_category_price 
ON products(category_id, price DESC);

-- Use appropriate data types
ALTER TABLE products 
ALTER COLUMN price TYPE DECIMAL(10,2);  -- Instead of FLOAT
```

### Read Replicas and Sharding

```yaml
database:
  scaling:
    read_replicas:
      enabled: true
      replica_count: 2
      read_write_split: "automatic"
      
    sharding:
      strategy: "range_based"  # or hash_based
      shard_key: "user_id"
      shard_count: 4
      
    partitioning:
      table_partitioning: true
      partition_strategy: "date_range"
      partition_interval: "monthly"
```

## Application-Level Performance

### Caching Strategies

```yaml
# Multi-level caching configuration
caching:
  levels:
    application:
      type: "in_memory"
      size_mb: 512
      ttl_seconds: 3600
      eviction_policy: "LRU"
      
    distributed:
      type: "redis"
      cluster_enabled: true
      persistence: "rdb"
      
    cdn:
      provider: "cloudflare"
      edge_caching: true
      cache_rules:
        static_assets: "1 year"
        api_responses: "5 minutes"
        dynamic_content: "30 seconds"
```

### Async Processing

```yaml
# Asynchronous processing setup
async_processing:
  message_queue:
    provider: "redis"  # or rabbitmq, kafka
    workers: 4
    concurrency: 10
    
  background_jobs:
    - name: "email_sending"
      queue: "notifications"
      retry_attempts: 3
      
    - name: "image_processing"
      queue: "media"
      timeout_minutes: 10
      
  event_processing:
    pattern: "publish_subscribe"
    event_sourcing: true
    async_handlers: true
```

### Memory Management

```javascript
// JavaScript/Node.js memory optimization examples
// Efficient object creation
const objectPool = {
  pool: [],
  get() {
    return this.pool.pop() || {};
  },
  release(obj) {
    Object.keys(obj).forEach(key => delete obj[key]);
    this.pool.push(obj);
  }
};

// Stream processing for large datasets
const stream = require('stream');

class OptimizedProcessor extends stream.Transform {
  constructor() {
    super({ objectMode: true, highWaterMark: 16 });
  }
  
  _transform(chunk, encoding, callback) {
    // Process in chunks to avoid memory spikes
    setImmediate(() => {
      const processed = this.processChunk(chunk);
      callback(null, processed);
    });
  }
}

// Connection pooling
const pool = require('generic-pool');

const dbPool = pool.createPool({
  create: () => createDatabaseConnection(),
  destroy: (connection) => connection.close()
}, {
  max: 50,           // Maximum connections
  min: 5,            // Minimum connections
  acquireTimeoutMillis: 3000,
  idleTimeoutMillis: 30000
});
```

## Network and API Performance

### HTTP Optimizations

```yaml
# HTTP performance configuration
http:
  compression:
    enabled: true
    algorithms: ["gzip", "brotli"]
    min_size_bytes: 1024
    
  keep_alive:
    enabled: true
    timeout_seconds: 65
    max_requests: 100
    
  http2:
    enabled: true
    server_push: true
    multiplexing: true
    
  headers:
    cache_control: "public, max-age=31536000"  # 1 year for static
    etag: true
    last_modified: true
```

### API Response Optimization

```yaml
# API performance patterns
api:
  response_optimization:
    pagination:
      default_page_size: 20
      max_page_size: 100
      cursor_based: true  # More efficient than offset
      
    field_selection:
      enabled: true
      allow_sparse_fieldsets: true
      
    response_compression:
      json_compression: true
      response_streaming: true
      
  rate_limiting:
    requests_per_minute: 1000
    burst_capacity: 100
    rate_limiting_headers: true
```

### CDN and Edge Optimization

```yaml
# CDN configuration for performance
cdn:
  provider: "cloudflare"  # or aws_cloudfront, fastly
  
  edge_locations:
    global_coverage: true
    regional_failover: true
    
  optimization:
    minification:
      html: true
      css: true
      javascript: true
      
    image_optimization:
      auto_format: true  # WebP, AVIF based on browser
      quality_adjustment: "automatic"
      responsive_images: true
      
    brotli_compression: true
    http3_support: true
    
  cache_policies:
    static_assets: "1 year"
    dynamic_content: "5 minutes"
    api_responses: "private, no-cache"
```

## Infrastructure Performance

### Load Balancing

```yaml
# Load balancer configuration
load_balancing:
  algorithm: "least_connections"  # or round_robin, ip_hash
  
  health_checks:
    enabled: true
    interval_seconds: 10
    timeout_seconds: 5
    unhealthy_threshold: 3
    healthy_threshold: 2
    
  session_affinity:
    enabled: false  # Stateless is better for scaling
    
  connection_draining:
    enabled: true
    timeout_seconds: 300
```

### Auto-scaling Configuration

```yaml
# Intelligent auto-scaling
auto_scaling:
  metrics:
    - name: "cpu_utilization"
      target: 70
      weight: 0.4
      
    - name: "memory_utilization"
      target: 80
      weight: 0.3
      
    - name: "request_rate"
      target: 1000
      weight: 0.3
      
  scaling_policies:
    scale_up:
      cooldown_seconds: 300
      min_step: 1
      max_step: 5
      
    scale_down:
      cooldown_seconds: 900  # Longer cooldown for down-scaling
      min_step: 1
      max_step: 2
      
  predictive_scaling:
    enabled: true
    forecast_horizon_hours: 24
    schedule_based: true
```

### Container Optimization

```yaml
# Container performance optimization
containerization:
  base_image: "alpine"  # Smaller base images
  
  optimization:
    multi_stage_builds: true
    layer_caching: true
    unused_dependencies: "remove"
    
  resource_limits:
    memory_limit: "2Gi"
    cpu_limit: "1000m"
    memory_request: "1Gi"
    cpu_request: "500m"
    
  startup_optimization:
    init_containers: true
    readiness_probe:
      initial_delay_seconds: 10
      period_seconds: 5
    liveness_probe:
      initial_delay_seconds: 30
      period_seconds: 10
```

## Monitoring and Profiling

### Performance Monitoring

```yaml
# Comprehensive performance monitoring
monitoring:
  application_performance:
    apm_enabled: true
    tracing: "distributed"
    profiling: "continuous"
    
    metrics:
      - "response_time_percentiles"
      - "throughput"
      - "error_rate"
      - "database_query_time"
      - "memory_usage"
      - "garbage_collection_time"
      
  infrastructure_monitoring:
    system_metrics: true
    network_metrics: true
    disk_io_metrics: true
    
  custom_metrics:
    business_metrics: true
    user_experience_metrics: true
    conversion_tracking: true
```

### Performance Testing

```yaml
# Automated performance testing
performance_testing:
  load_testing:
    tool: "k6"  # or jmeter, artillery
    scenarios:
      - name: "baseline_load"
        virtual_users: 100
        duration: "10m"
        
      - name: "spike_test"
        virtual_users: 1000
        ramp_up: "30s"
        duration: "5m"
        
  stress_testing:
    max_users: 5000
    ramp_up_duration: "5m"
    failure_criteria:
      error_rate: 5  # %
      response_time_p95: 2000  # ms
      
  endurance_testing:
    duration: "2h"
    constant_load: 200
    resource_monitoring: true
```

### Profiling and Optimization

```javascript
// Example profiling setup (Node.js)
const { performance, PerformanceObserver } = require('perf_hooks');

// Memory usage monitoring
function trackMemoryUsage() {
  const usage = process.memoryUsage();
  console.log({
    rss: Math.round(usage.rss / 1024 / 1024) + 'MB',
    heapUsed: Math.round(usage.heapUsed / 1024 / 1024) + 'MB',
    heapTotal: Math.round(usage.heapTotal / 1024 / 1024) + 'MB',
    external: Math.round(usage.external / 1024 / 1024) + 'MB'
  });
}

// Performance timing
const obs = new PerformanceObserver((items) => {
  items.getEntries().forEach((entry) => {
    console.log(`${entry.name}: ${entry.duration}ms`);
  });
});
obs.observe({ entryTypes: ['measure'] });

// Measure function performance
function measurePerformance(name, fn) {
  return async (...args) => {
    performance.mark(`${name}-start`);
    const result = await fn(...args);
    performance.mark(`${name}-end`);
    performance.measure(name, `${name}-start`, `${name}-end`);
    return result;
  };
}
```

## Performance Budgets

### Setting Performance Targets

```yaml
# Performance budget configuration
performance_budget:
  page_load_time:
    target_ms: 1500
    warning_ms: 1200
    error_ms: 2000
    
  first_contentful_paint:
    target_ms: 800
    warning_ms: 600
    error_ms: 1200
    
  largest_contentful_paint:
    target_ms: 2000
    warning_ms: 1500
    error_ms: 3000
    
  cumulative_layout_shift:
    target: 0.1
    warning: 0.05
    error: 0.25
    
  bundle_sizes:
    javascript_kb: 300
    css_kb: 50
    images_kb: 500
    
  api_response_times:
    p95_target_ms: 200
    p99_target_ms: 500
    error_rate_max: 0.1  # 0.1%
```

### Performance Monitoring Alerts

```yaml
# Alert configuration for performance issues
alerts:
  performance_degradation:
    - metric: "response_time_p95"
      threshold: 500  # ms
      duration: "5m"
      severity: "warning"
      
    - metric: "error_rate"
      threshold: 1  # %
      duration: "2m"
      severity: "critical"
      
  resource_utilization:
    - metric: "cpu_usage"
      threshold: 80  # %
      duration: "10m"
      severity: "warning"
      
    - metric: "memory_usage"
      threshold: 90  # %
      duration: "5m"
      severity: "critical"
```

## Optimization Checklists

### Frontend Performance Checklist

- [ ] **Bundle optimization**: Code splitting, tree shaking, minification
- [ ] **Image optimization**: WebP/AVIF formats, lazy loading, responsive images
- [ ] **Font optimization**: Font display swap, font preloading
- [ ] **CSS optimization**: Critical CSS, unused CSS removal
- [ ] **JavaScript optimization**: Async loading, defer attributes
- [ ] **Caching**: Service workers, HTTP caching headers
- [ ] **CDN**: Global content distribution
- [ ] **Performance monitoring**: Core Web Vitals tracking

### Backend Performance Checklist

- [ ] **Database optimization**: Indexing, query optimization, connection pooling
- [ ] **Caching**: Multi-level caching strategy
- [ ] **Async processing**: Background jobs, message queues
- [ ] **API optimization**: Pagination, field selection, compression
- [ ] **Memory management**: Garbage collection tuning, memory leaks prevention
- [ ] **Monitoring**: APM, distributed tracing, performance metrics
- [ ] **Load testing**: Regular performance testing
- [ ] **Auto-scaling**: Responsive scaling policies

### Infrastructure Performance Checklist

- [ ] **Load balancing**: Proper algorithm selection, health checks
- [ ] **Auto-scaling**: Multi-metric scaling policies
- [ ] **Container optimization**: Resource limits, startup optimization
- [ ] **Network optimization**: CDN, compression, HTTP/2
- [ ] **Storage optimization**: SSD storage, backup strategies
- [ ] **Monitoring**: Comprehensive infrastructure monitoring
- [ ] **Cost optimization**: Right-sizing, reserved instances
- [ ] **Disaster recovery**: Performance impact assessment

## Best Practices Summary

### 1. **Measure First**
Always establish baseline measurements before optimizing.

### 2. **Optimize Bottlenecks**
Focus on the biggest performance impact areas first.

### 3. **Monitor Continuously**
Set up comprehensive monitoring and alerting.

### 4. **Test Performance Changes**
Validate that optimizations actually improve performance.

### 5. **Consider User Experience**
Optimize for perceived performance, not just raw metrics.

### 6. **Budget for Performance**
Set performance budgets and stick to them.

### 7. **Automate Optimization**
Use tools and processes to maintain performance over time.

---

*Remember: Premature optimization is the root of all evil, but deliberate performance engineering is essential for scalable applications. Always measure, optimize incrementally, and validate improvements.*