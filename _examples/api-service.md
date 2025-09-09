---
layout: example
title: "Task Management API"
description: "RESTful API for task management with authentication, CRUD operations, and real-time updates"
outcome_type: "api"
complexity: "intermediate"
stack: "FastAPI + PostgreSQL + Redis"
github: "https://github.com/nibzard/ospec-examples/tree/main/task-api"
---

# Task Management API

A production-ready RESTful API built with FastAPI that provides comprehensive task management capabilities including user authentication, CRUD operations, real-time updates, and advanced filtering.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "task-management-api"
name: "Task Management API"
description: "RESTful API for task management with authentication, real-time updates, and advanced querying capabilities"
outcome_type: "api"

acceptance:
  http_endpoints:
    # Authentication endpoints
    - path: "/auth/register"
      method: "POST"
      status: 201
      request_schema: "schemas/user_register.json"
      response_schema: "schemas/user_response.json"
    
    - path: "/auth/login"
      method: "POST"
      status: 200
      request_schema: "schemas/user_login.json"
      response_schema: "schemas/auth_response.json"
    
    - path: "/auth/refresh"
      method: "POST"
      status: 200
      auth_required: true
      response_schema: "schemas/auth_response.json"
    
    # Task management endpoints
    - path: "/tasks"
      method: "GET"
      status: 200
      auth_required: true
      response_schema: "schemas/task_list.json"
      query_params:
        - name: "status"
          type: "string"
          enum: ["pending", "in_progress", "completed"]
        - name: "priority"
          type: "string"
          enum: ["low", "medium", "high", "urgent"]
        - name: "assigned_to"
          type: "integer"
        - name: "due_date_from"
          type: "string"
          format: "date"
        - name: "due_date_to"
          type: "string"
          format: "date"
        - name: "limit"
          type: "integer"
          default: 20
        - name: "offset"
          type: "integer"
          default: 0
    
    - path: "/tasks"
      method: "POST"
      status: 201
      auth_required: true
      request_schema: "schemas/task_create.json"
      response_schema: "schemas/task_response.json"
    
    - path: "/tasks/{task_id}"
      method: "GET"
      status: 200
      auth_required: true
      response_schema: "schemas/task_response.json"
    
    - path: "/tasks/{task_id}"
      method: "PUT"
      status: 200
      auth_required: true
      request_schema: "schemas/task_update.json"
      response_schema: "schemas/task_response.json"
    
    - path: "/tasks/{task_id}"
      method: "DELETE"
      status: 204
      auth_required: true
    
    - path: "/tasks/{task_id}/assign"
      method: "POST"
      status: 200
      auth_required: true
      request_schema: "schemas/task_assign.json"
      response_schema: "schemas/task_response.json"
    
    # Project endpoints
    - path: "/projects"
      method: "GET"
      status: 200
      auth_required: true
      response_schema: "schemas/project_list.json"
    
    - path: "/projects"
      method: "POST"
      status: 201
      auth_required: true
      request_schema: "schemas/project_create.json"
      response_schema: "schemas/project_response.json"
    
    # Health and monitoring
    - path: "/health"
      method: "GET"
      status: 200
      response_contains: ["status", "database", "redis"]
    
    - path: "/metrics"
      method: "GET"
      status: 200
      response_format: "prometheus"

  performance:
    response_time_p95_ms: 200
    response_time_p99_ms: 500
    throughput_rps: 1000
    concurrent_users: 500
    database_query_time_p95_ms: 50
    cache_hit_ratio: 0.8

  real_time:
    websocket_endpoint: "/ws"
    events:
      - "task_created"
      - "task_updated"
      - "task_assigned"
      - "task_completed"
    max_connections: 10000

  tests:
    - file: "tests/unit/**/*.py"
      type: "unit"
      coverage_threshold: 0.85
    - file: "tests/integration/**/*.py"
      type: "integration"
      coverage_threshold: 0.75
    - file: "tests/e2e/**/*.py"
      type: "e2e"
      coverage_threshold: 0.6

stack:
  backend: "FastAPI 0.104+"
  database: "PostgreSQL 15+"
  cache: "Redis 7+"
  auth: "JWT with refresh tokens"
  validation: "Pydantic v2"
  orm: "SQLAlchemy 2.0"
  migration: "Alembic"
  task_queue: "Celery with Redis"
  websockets: "FastAPI WebSockets"
  documentation: "OpenAPI/Swagger"
  containerization: "Docker"
  monitoring: "Prometheus + Grafana"

guardrails:
  tests_required: true
  min_test_coverage: 0.8
  lint: true
  type_check: true
  security_scan: true
  dependency_check: true
  license_whitelist: ["MIT", "Apache-2.0", "BSD-3-Clause"]
  human_approval_required: ["database_migration", "production_deploy"]

prompts:
  implementer: |
    You are building a production-ready REST API with FastAPI.
    
    Key requirements:
    - Follow REST principles strictly
    - Use proper HTTP status codes
    - Implement comprehensive error handling
    - Add request/response validation with Pydantic
    - Include proper logging with correlation IDs
    - Implement rate limiting and security headers
    - Use database transactions appropriately
    - Add comprehensive API documentation
    - Follow Python best practices (PEP 8, type hints)
    - Implement proper async/await patterns
    
  reviewer: |
    Focus on these critical areas:
    1. API Security: Authentication, authorization, input validation
    2. Performance: Query optimization, caching, async operations
    3. Reliability: Error handling, transaction management, idempotency
    4. Standards Compliance: REST principles, OpenAPI spec accuracy
    5. Code Quality: Type safety, error handling, logging

scripts:
  setup: "scripts/setup.sh"
  test: "scripts/test.sh"
  lint: "scripts/lint.sh"
  build: "scripts/build.sh"
  migrate: "scripts/migrate.sh"
  seed: "scripts/seed_data.sh"
  dev: "scripts/dev.sh"
  production: "scripts/production.sh"

secrets:
  provider: "hashicorp-vault"
  required:
    - "DATABASE_URL"
    - "REDIS_URL"
    - "JWT_SECRET_KEY"
    - "JWT_REFRESH_SECRET_KEY"
  optional:
    - "SENTRY_DSN"
    - "SMTP_PASSWORD"
    - "MONITORING_TOKEN"

metadata:
  estimated_effort: "5-7 days"
  complexity: "intermediate"
  tags: ["rest-api", "fastapi", "postgresql", "redis", "jwt", "websockets"]
  version: "1.0.0"
  maintainers:
    - name: "API Team"
      email: "api-team@company.com"
```

## Features

### Core API Features
- ✅ **RESTful Architecture**: Proper REST principles with resource-based URLs
- ✅ **JWT Authentication**: Secure authentication with access and refresh tokens
- ✅ **CRUD Operations**: Complete Create, Read, Update, Delete for tasks and projects
- ✅ **Advanced Filtering**: Query tasks by status, priority, assignee, date ranges
- ✅ **Pagination**: Efficient pagination with limit/offset and cursor support
- ✅ **Real-time Updates**: WebSocket connections for live task updates
- ✅ **Role-based Access**: Different permissions for users, managers, and admins

### Technical Features
- ✅ **Async/Await**: Full async implementation for maximum performance
- ✅ **Database Transactions**: ACID compliance with proper transaction management
- ✅ **Caching Strategy**: Multi-layer caching with Redis for performance
- ✅ **Rate Limiting**: API rate limiting to prevent abuse
- ✅ **Input Validation**: Comprehensive request/response validation
- ✅ **Error Handling**: Structured error responses with correlation IDs
- ✅ **API Documentation**: Interactive OpenAPI/Swagger documentation
- ✅ **Monitoring**: Prometheus metrics and health checks

## API Architecture

### Database Schema

```sql
-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'user',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Projects table
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    owner_id INTEGER REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tasks table
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    priority VARCHAR(20) DEFAULT 'medium',
    project_id INTEGER REFERENCES projects(id),
    created_by INTEGER REFERENCES users(id),
    assigned_to INTEGER REFERENCES users(id),
    due_date TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Task comments table
CREATE TABLE task_comments (
    id SERIAL PRIMARY KEY,
    task_id INTEGER REFERENCES tasks(id),
    user_id INTEGER REFERENCES users(id),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
```

### Project Structure

```
task-management-api/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI application setup
│   ├── config.py            # Configuration management
│   ├── database.py          # Database connection and session
│   ├── models/              # SQLAlchemy models
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── project.py
│   │   ├── task.py
│   │   └── comment.py
│   ├── schemas/             # Pydantic schemas
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── project.py
│   │   ├── task.py
│   │   └── common.py
│   ├── routers/             # API route handlers
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── users.py
│   │   ├── projects.py
│   │   ├── tasks.py
│   │   └── websocket.py
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   ├── auth_service.py
│   │   ├── task_service.py
│   │   ├── project_service.py
│   │   └── notification_service.py
│   ├── utils/               # Utility functions
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── cache.py
│   │   ├── pagination.py
│   │   └── validators.py
│   └── middleware/          # Custom middleware
│       ├── __init__.py
│       ├── auth.py
│       ├── cors.py
│       ├── rate_limit.py
│       └── logging.py
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── migrations/              # Alembic database migrations
├── scripts/                 # Deployment and utility scripts
├── docker/
├── docs/
├── requirements/
│   ├── base.txt
│   ├── development.txt
│   └── production.txt
├── Dockerfile
├── docker-compose.yml
├── pyproject.toml
└── README.md
```

## Key Implementation Examples

### Authentication Middleware

```python
# app/middleware/auth.py
from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
from app.config import settings
from app.services.auth_service import AuthService

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    auth_service: AuthService = Depends()
):
    """Extract and validate JWT token to get current user."""
    try:
        payload = jwt.decode(
            credentials.credentials, 
            settings.JWT_SECRET_KEY, 
            algorithms=[settings.JWT_ALGORITHM]
        )
        user_id: int = payload.get("sub")
        if user_id is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Could not validate credentials",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        user = await auth_service.get_user_by_id(user_id)
        if user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found",
            )
        
        return user
        
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

def require_role(required_role: str):
    """Decorator to require specific user role."""
    def role_checker(current_user = Depends(get_current_user)):
        if current_user.role != required_role and current_user.role != "admin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions"
            )
        return current_user
    return role_checker
```

### Task Service with Business Logic

```python
# app/services/task_service.py
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_, or_
from app.models.task import Task
from app.models.user import User
from app.schemas.task import TaskCreate, TaskUpdate, TaskFilter
from app.utils.cache import cache_service
from app.services.notification_service import NotificationService

class TaskService:
    def __init__(self, db: Session):
        self.db = db
        self.notification_service = NotificationService()

    async def create_task(self, task_data: TaskCreate, created_by_id: int) -> Task:
        """Create a new task with validation and notifications."""
        # Validate project access
        if task_data.project_id:
            project = self.db.query(Project).filter(
                Project.id == task_data.project_id
            ).first()
            if not project:
                raise ValueError("Project not found")

        # Create task
        db_task = Task(
            **task_data.dict(),
            created_by=created_by_id
        )
        self.db.add(db_task)
        self.db.commit()
        self.db.refresh(db_task)

        # Send notifications
        await self.notification_service.notify_task_created(db_task)
        
        # Invalidate cache
        await cache_service.delete_pattern(f"tasks:user:{created_by_id}:*")
        
        return db_task

    async def get_tasks(
        self, 
        user_id: int, 
        filters: TaskFilter,
        skip: int = 0, 
        limit: int = 20
    ) -> List[Task]:
        """Get filtered tasks with caching."""
        
        # Try cache first
        cache_key = f"tasks:user:{user_id}:{hash(str(filters))}:{skip}:{limit}"
        cached_tasks = await cache_service.get(cache_key)
        if cached_tasks:
            return cached_tasks

        # Build query
        query = self.db.query(Task)
        
        # Apply filters
        if filters.status:
            query = query.filter(Task.status == filters.status)
        if filters.priority:
            query = query.filter(Task.priority == filters.priority)
        if filters.assigned_to:
            query = query.filter(Task.assigned_to == filters.assigned_to)
        if filters.project_id:
            query = query.filter(Task.project_id == filters.project_id)
        if filters.due_date_from:
            query = query.filter(Task.due_date >= filters.due_date_from)
        if filters.due_date_to:
            query = query.filter(Task.due_date <= filters.due_date_to)

        # Apply user access control
        query = query.filter(
            or_(
                Task.created_by == user_id,
                Task.assigned_to == user_id,
                Task.project_id.in_(
                    self.db.query(Project.id).filter(Project.owner_id == user_id)
                )
            )
        )

        # Execute query
        tasks = query.offset(skip).limit(limit).all()
        
        # Cache results
        await cache_service.set(cache_key, tasks, expire=300)  # 5 minutes
        
        return tasks

    async def update_task(
        self, 
        task_id: int, 
        task_data: TaskUpdate, 
        user_id: int
    ) -> Optional[Task]:
        """Update task with authorization and change tracking."""
        
        task = self.db.query(Task).filter(Task.id == task_id).first()
        if not task:
            return None
            
        # Check permissions
        if not self._can_modify_task(task, user_id):
            raise PermissionError("Insufficient permissions to modify task")
        
        # Track changes for notifications
        changes = {}
        for field, value in task_data.dict(exclude_unset=True).items():
            if getattr(task, field) != value:
                changes[field] = {
                    'old': getattr(task, field),
                    'new': value
                }
                setattr(task, field, value)
        
        self.db.commit()
        self.db.refresh(task)
        
        # Send notifications for important changes
        if changes:
            await self.notification_service.notify_task_updated(task, changes)
        
        # Invalidate cache
        await self._invalidate_task_cache(task_id)
        
        return task

    def _can_modify_task(self, task: Task, user_id: int) -> bool:
        """Check if user can modify the task."""
        return (
            task.created_by == user_id or
            task.assigned_to == user_id or
            task.project.owner_id == user_id
        )

    async def _invalidate_task_cache(self, task_id: int):
        """Invalidate all cache entries related to a task."""
        await cache_service.delete_pattern(f"tasks:*")
        await cache_service.delete(f"task:{task_id}")
```

### WebSocket Real-time Updates

```python
# app/routers/websocket.py
from fastapi import WebSocket, WebSocketDisconnect, Depends
from typing import List
import json
from app.utils.auth import verify_websocket_token
from app.services.notification_service import NotificationService

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []
        self.user_connections: dict = {}

    async def connect(self, websocket: WebSocket, user_id: int):
        await websocket.accept()
        self.active_connections.append(websocket)
        if user_id not in self.user_connections:
            self.user_connections[user_id] = []
        self.user_connections[user_id].append(websocket)

    def disconnect(self, websocket: WebSocket, user_id: int):
        self.active_connections.remove(websocket)
        if user_id in self.user_connections:
            self.user_connections[user_id].remove(websocket)
            if not self.user_connections[user_id]:
                del self.user_connections[user_id]

    async def send_to_user(self, user_id: int, message: dict):
        if user_id in self.user_connections:
            for connection in self.user_connections[user_id]:
                await connection.send_text(json.dumps(message))

    async def broadcast_to_project(self, project_id: int, message: dict):
        # Get all users in project and send message
        # Implementation depends on your project membership logic
        pass

manager = ConnectionManager()

@router.websocket("/ws")
async def websocket_endpoint(
    websocket: WebSocket,
    token: str,
    notification_service: NotificationService = Depends()
):
    # Verify token and get user
    user = await verify_websocket_token(token)
    if not user:
        await websocket.close(code=4001, reason="Invalid token")
        return

    await manager.connect(websocket, user.id)
    
    try:
        while True:
            # Keep connection alive
            data = await websocket.receive_text()
            
            # Handle ping/pong for connection health
            if data == "ping":
                await websocket.send_text("pong")
                
    except WebSocketDisconnect:
        manager.disconnect(websocket, user.id)
```

## Performance Optimizations

### Database Query Optimization

```python
# app/models/task.py with optimized queries
from sqlalchemy import Index
from sqlalchemy.orm import relationship, selectinload

class Task(Base):
    # ... model definition ...
    
    @classmethod
    def get_with_relations(cls, db: Session, task_id: int):
        """Optimized query with eager loading."""
        return db.query(cls).options(
            selectinload(cls.assignee),
            selectinload(cls.creator),
            selectinload(cls.project),
            selectinload(cls.comments).selectinload(TaskComment.user)
        ).filter(cls.id == task_id).first()

# Database indexes for common queries
task_status_idx = Index('idx_task_status', Task.status)
task_assigned_to_idx = Index('idx_task_assigned_to', Task.assigned_to)  
task_due_date_idx = Index('idx_task_due_date', Task.due_date)
task_compound_idx = Index(
    'idx_task_compound', 
    Task.status, 
    Task.priority, 
    Task.assigned_to
)
```

### Caching Strategy

```python
# app/utils/cache.py
import redis
import json
import pickle
from typing import Any, Optional
from app.config import settings

class CacheService:
    def __init__(self):
        self.redis_client = redis.from_url(
            settings.REDIS_URL,
            encoding="utf-8",
            decode_responses=False
        )

    async def get(self, key: str) -> Optional[Any]:
        """Get cached value."""
        try:
            value = self.redis_client.get(key)
            if value:
                return pickle.loads(value)
            return None
        except Exception as e:
            logger.error(f"Cache get error: {e}")
            return None

    async def set(self, key: str, value: Any, expire: int = 3600) -> bool:
        """Set cached value with expiration."""
        try:
            serialized_value = pickle.dumps(value)
            return self.redis_client.setex(key, expire, serialized_value)
        except Exception as e:
            logger.error(f"Cache set error: {e}")
            return False

    async def delete(self, key: str) -> bool:
        """Delete cached value."""
        try:
            return bool(self.redis_client.delete(key))
        except Exception as e:
            logger.error(f"Cache delete error: {e}")
            return False

    async def delete_pattern(self, pattern: str) -> int:
        """Delete all keys matching pattern."""
        try:
            keys = self.redis_client.keys(pattern)
            if keys:
                return self.redis_client.delete(*keys)
            return 0
        except Exception as e:
            logger.error(f"Cache delete pattern error: {e}")
            return 0

cache_service = CacheService()
```

## API Testing Examples

### Unit Tests

```python
# tests/unit/test_task_service.py
import pytest
from unittest.mock import Mock, AsyncMock
from app.services.task_service import TaskService
from app.schemas.task import TaskCreate
from app.models.task import Task

class TestTaskService:
    @pytest.fixture
    def mock_db(self):
        return Mock()

    @pytest.fixture
    def task_service(self, mock_db):
        return TaskService(mock_db)

    @pytest.mark.asyncio
    async def test_create_task_success(self, task_service, mock_db):
        # Arrange
        task_data = TaskCreate(
            title="Test Task",
            description="Test Description",
            priority="high"
        )
        created_by_id = 1

        mock_task = Task(
            id=1,
            title=task_data.title,
            description=task_data.description,
            priority=task_data.priority,
            created_by=created_by_id
        )
        
        mock_db.add.return_value = None
        mock_db.commit.return_value = None
        mock_db.refresh.return_value = None

        # Mock notification service
        task_service.notification_service = AsyncMock()

        # Act
        result = await task_service.create_task(task_data, created_by_id)

        # Assert
        mock_db.add.assert_called_once()
        mock_db.commit.assert_called_once()
        mock_db.refresh.assert_called_once()
        task_service.notification_service.notify_task_created.assert_called_once()
```

### Integration Tests

```python
# tests/integration/test_task_api.py
import pytest
from httpx import AsyncClient
from app.main import app
from app.database import get_db
from tests.conftest import override_get_db, test_db

@pytest.mark.asyncio
async def test_create_task_endpoint(test_db, authenticated_client):
    # Create test data
    task_data = {
        "title": "Integration Test Task",
        "description": "Test task creation via API",
        "priority": "medium",
        "status": "pending"
    }

    # Make request
    response = await authenticated_client.post("/tasks", json=task_data)

    # Assert response
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == task_data["title"]
    assert data["description"] == task_data["description"]
    assert data["priority"] == task_data["priority"]
    assert data["status"] == task_data["status"]
    assert "id" in data
    assert "created_at" in data

@pytest.mark.asyncio
async def test_get_tasks_with_filters(test_db, authenticated_client):
    # Create test tasks
    await create_test_tasks(test_db)

    # Test filtering by status
    response = await authenticated_client.get("/tasks?status=pending")
    assert response.status_code == 200
    data = response.json()
    assert len(data["tasks"]) > 0
    assert all(task["status"] == "pending" for task in data["tasks"])

    # Test filtering by priority
    response = await authenticated_client.get("/tasks?priority=high")
    assert response.status_code == 200
    data = response.json()
    assert all(task["priority"] == "high" for task in data["tasks"])
```

## Performance Benchmarks

Expected performance characteristics:

- **Response Time**: 
  - P95: < 200ms for simple queries
  - P99: < 500ms for complex queries
- **Throughput**: 1000+ requests per second
- **Concurrent Users**: 500+ simultaneous users
- **Database**: Query times < 50ms (P95)
- **Cache Hit Ratio**: > 80% for frequently accessed data

## Security Features

- **JWT Authentication**: Secure token-based authentication
- **Role-based Authorization**: User, manager, and admin roles
- **Input Validation**: Comprehensive request validation with Pydantic
- **Rate Limiting**: API rate limiting to prevent abuse
- **CORS Configuration**: Proper cross-origin resource sharing setup
- **Security Headers**: Comprehensive security headers
- **SQL Injection Prevention**: Parameterized queries with SQLAlchemy
- **Password Security**: Bcrypt hashing with salt

## Deployment

### Docker Configuration

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements/production.txt .
RUN pip install --no-cache-dir -r production.txt

# Copy application code
COPY . .

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Live Demo

[View Live API Documentation →](https://task-api-ospec.railway.app/docs)

## Source Code

[View on GitHub →](https://github.com/nibzard/ospec-examples/tree/main/task-api)

This comprehensive API example demonstrates how OSpec can generate a production-ready REST API with all the essential features for a real-world application.