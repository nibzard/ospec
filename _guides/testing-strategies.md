---
layout: guide
title: "Testing Strategies"
description: "Comprehensive guide to testing approaches, frameworks, and best practices for OSpec projects"
difficulty: intermediate
time: "35 minutes"
order: 4
---

# Testing Strategies for OSpec Projects

Testing is fundamental to OSpec's reliability promise. This guide covers testing strategies, frameworks, and patterns for building confidence in agent-generated code.

## Testing Philosophy

### Core Testing Principles

1. **Test Pyramid Strategy**: More unit tests, fewer integration tests, minimal E2E tests
2. **Behavior-Driven Testing**: Focus on what the system should do, not how it does it
3. **Fail-Fast Approach**: Tests should quickly identify problems
4. **Continuous Feedback**: Tests run automatically and provide immediate feedback
5. **Test as Documentation**: Tests document expected behavior

### OSpec Testing Requirements

```yaml
acceptance:
  tests:
    - file: "tests/unit/*.test.js"
      type: "unit"
      coverage_threshold: 0.8
      framework: "Jest"
    
    - file: "tests/integration/*.test.js"  
      type: "integration"
      coverage_threshold: 0.7
      framework: "Jest + Supertest"
    
    - file: "tests/e2e/*.spec.js"
      type: "e2e"
      coverage_threshold: 0.6
      framework: "Playwright"

guardrails:
  tests_required: true
  min_test_coverage: 0.8
  test_types_required: ["unit", "integration"]
  performance_tests: true
  security_tests: true
```

## Testing Pyramid

### Unit Tests (70% of total tests)

Test individual functions, methods, and components in isolation.

#### JavaScript/Node.js Example
```javascript
// src/utils/validation.js
export function validateEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

export function sanitizeInput(input) {
  return input.trim().replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '');
}

// tests/unit/validation.test.js
import { validateEmail, sanitizeInput } from '../../src/utils/validation.js';

describe('Email Validation', () => {
  test('accepts valid email addresses', () => {
    expect(validateEmail('user@example.com')).toBe(true);
    expect(validateEmail('test.email+tag@domain.co.uk')).toBe(true);
  });

  test('rejects invalid email addresses', () => {
    expect(validateEmail('invalid')).toBe(false);
    expect(validateEmail('@domain.com')).toBe(false);
    expect(validateEmail('user@')).toBe(false);
  });

  test('handles edge cases', () => {
    expect(validateEmail('')).toBe(false);
    expect(validateEmail(null)).toBe(false);
    expect(validateEmail(undefined)).toBe(false);
  });
});

describe('Input Sanitization', () => {
  test('removes script tags', () => {
    const malicious = '<script>alert("xss")</script>Hello World';
    expect(sanitizeInput(malicious)).toBe('Hello World');
  });

  test('preserves safe HTML', () => {
    const safe = '<p>Safe content</p>';
    expect(sanitizeInput(safe)).toBe('<p>Safe content</p>');
  });

  test('trims whitespace', () => {
    expect(sanitizeInput('  hello world  ')).toBe('hello world');
  });
});
```

#### Python/FastAPI Example
```python
# src/models/user.py
from datetime import datetime
from typing import Optional

class User:
    def __init__(self, email: str, name: str, age: Optional[int] = None):
        if not self._is_valid_email(email):
            raise ValueError("Invalid email address")
        if not name.strip():
            raise ValueError("Name cannot be empty")
        if age is not None and age < 0:
            raise ValueError("Age cannot be negative")
        
        self.email = email.lower().strip()
        self.name = name.strip()
        self.age = age
        self.created_at = datetime.now()
    
    def _is_valid_email(self, email: str) -> bool:
        import re
        pattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$'
        return bool(re.match(pattern, email))

# tests/unit/test_user.py
import pytest
from datetime import datetime
from src.models.user import User

class TestUser:
    def test_valid_user_creation(self):
        user = User("test@example.com", "John Doe", 25)
        assert user.email == "test@example.com"
        assert user.name == "John Doe"
        assert user.age == 25
        assert isinstance(user.created_at, datetime)

    def test_email_normalization(self):
        user = User("  TEST@EXAMPLE.COM  ", "John Doe")
        assert user.email == "test@example.com"

    def test_name_trimming(self):
        user = User("test@example.com", "  John Doe  ")
        assert user.name == "John Doe"

    def test_invalid_email_raises_error(self):
        with pytest.raises(ValueError, match="Invalid email address"):
            User("invalid-email", "John Doe")

    def test_empty_name_raises_error(self):
        with pytest.raises(ValueError, match="Name cannot be empty"):
            User("test@example.com", "")

    def test_negative_age_raises_error(self):
        with pytest.raises(ValueError, match="Age cannot be negative"):
            User("test@example.com", "John Doe", -1)

    def test_optional_age(self):
        user = User("test@example.com", "John Doe")
        assert user.age is None
```

### Integration Tests (20% of total tests)

Test how different parts of the system work together.

#### API Integration Example
```javascript
// tests/integration/auth.test.js
import request from 'supertest';
import { app } from '../../src/app.js';
import { setupTestDb, cleanupTestDb } from '../helpers/database.js';

describe('Authentication API', () => {
  beforeAll(async () => {
    await setupTestDb();
  });

  afterAll(async () => {
    await cleanupTestDb();
  });

  describe('POST /auth/register', () => {
    test('creates new user with valid data', async () => {
      const userData = {
        email: 'newuser@example.com',
        password: 'SecurePass123!',
        name: 'New User'
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(201);

      expect(response.body).toHaveProperty('user');
      expect(response.body).toHaveProperty('token');
      expect(response.body.user.email).toBe(userData.email);
      expect(response.body.user).not.toHaveProperty('password');
    });

    test('rejects duplicate email', async () => {
      const userData = {
        email: 'duplicate@example.com',
        password: 'SecurePass123!',
        name: 'First User'
      };

      // Create first user
      await request(app).post('/auth/register').send(userData);

      // Attempt duplicate
      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(409);

      expect(response.body.error).toMatch(/email already exists/i);
    });

    test('validates password strength', async () => {
      const userData = {
        email: 'weakpass@example.com',
        password: '123',
        name: 'Weak Password User'
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(400);

      expect(response.body.error).toMatch(/password.*requirements/i);
    });
  });

  describe('POST /auth/login', () => {
    beforeEach(async () => {
      // Create test user
      await request(app)
        .post('/auth/register')
        .send({
          email: 'testuser@example.com',
          password: 'SecurePass123!',
          name: 'Test User'
        });
    });

    test('authenticates with valid credentials', async () => {
      const response = await request(app)
        .post('/auth/login')
        .send({
          email: 'testuser@example.com',
          password: 'SecurePass123!'
        })
        .expect(200);

      expect(response.body).toHaveProperty('token');
      expect(response.body).toHaveProperty('user');
    });

    test('rejects invalid password', async () => {
      const response = await request(app)
        .post('/auth/login')
        .send({
          email: 'testuser@example.com',
          password: 'WrongPassword'
        })
        .expect(401);

      expect(response.body.error).toMatch(/invalid credentials/i);
    });
  });
});
```

#### Database Integration Example
```python
# tests/integration/test_user_repository.py
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from src.database import Base
from src.repositories.user_repository import UserRepository
from src.models.user import User

@pytest.fixture(scope="function")
def db_session():
    # Create in-memory SQLite database for testing
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    
    SessionLocal = sessionmaker(bind=engine)
    session = SessionLocal()
    
    yield session
    
    session.close()

class TestUserRepository:
    def test_create_and_find_user(self, db_session):
        repo = UserRepository(db_session)
        
        # Create user
        user_data = {
            "email": "test@example.com",
            "name": "Test User",
            "password_hash": "hashed_password"
        }
        created_user = repo.create(user_data)
        
        # Find user
        found_user = repo.find_by_email("test@example.com")
        
        assert found_user is not None
        assert found_user.email == created_user.email
        assert found_user.id == created_user.id

    def test_find_nonexistent_user(self, db_session):
        repo = UserRepository(db_session)
        user = repo.find_by_email("nonexistent@example.com")
        assert user is None

    def test_update_user(self, db_session):
        repo = UserRepository(db_session)
        
        # Create user
        user_data = {
            "email": "update@example.com",
            "name": "Original Name",
            "password_hash": "hashed_password"
        }
        user = repo.create(user_data)
        
        # Update user
        updated_user = repo.update(user.id, {"name": "Updated Name"})
        
        assert updated_user.name == "Updated Name"
        assert updated_user.email == "update@example.com"  # Unchanged

    def test_delete_user(self, db_session):
        repo = UserRepository(db_session)
        
        # Create user
        user_data = {
            "email": "delete@example.com",
            "name": "To Be Deleted",
            "password_hash": "hashed_password"
        }
        user = repo.create(user_data)
        
        # Delete user
        repo.delete(user.id)
        
        # Verify deletion
        deleted_user = repo.find_by_id(user.id)
        assert deleted_user is None
```

### End-to-End Tests (10% of total tests)

Test complete user workflows from frontend to backend.

#### Web Application E2E Example
```javascript
// tests/e2e/user-registration.spec.js
const { test, expect } = require('@playwright/test');

test.describe('User Registration Flow', () => {
  test('complete user registration and login', async ({ page }) => {
    // Navigate to registration page
    await page.goto('/register');
    
    // Fill registration form
    await page.fill('[data-testid="email-input"]', 'e2e-user@example.com');
    await page.fill('[data-testid="password-input"]', 'SecurePass123!');
    await page.fill('[data-testid="confirm-password-input"]', 'SecurePass123!');
    await page.fill('[data-testid="name-input"]', 'E2E Test User');
    
    // Submit form
    await page.click('[data-testid="register-button"]');
    
    // Should redirect to verification page
    await expect(page).toHaveURL('/verify-email');
    await expect(page.locator('[data-testid="verification-message"]')).toBeVisible();
    
    // Simulate email verification (in real test, you'd check test email)
    // For now, directly navigate to login
    await page.goto('/login');
    
    // Login with new credentials
    await page.fill('[data-testid="login-email"]', 'e2e-user@example.com');
    await page.fill('[data-testid="login-password"]', 'SecurePass123!');
    await page.click('[data-testid="login-button"]');
    
    // Should be redirected to dashboard
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="user-name"]')).toHaveText('E2E Test User');
  });

  test('shows validation errors for invalid input', async ({ page }) => {
    await page.goto('/register');
    
    // Try to submit with invalid email
    await page.fill('[data-testid="email-input"]', 'invalid-email');
    await page.fill('[data-testid="password-input"]', 'weak');
    await page.click('[data-testid="register-button"]');
    
    // Should show validation errors
    await expect(page.locator('[data-testid="email-error"]')).toBeVisible();
    await expect(page.locator('[data-testid="password-error"]')).toBeVisible();
    
    // Form should not be submitted (still on registration page)
    await expect(page).toHaveURL('/register');
  });
});

// tests/e2e/shopping-cart.spec.js
test.describe('Shopping Cart Flow', () => {
  test('add items to cart and checkout', async ({ page }) => {
    // Login first
    await page.goto('/login');
    await page.fill('[data-testid="login-email"]', 'test@example.com');
    await page.fill('[data-testid="login-password"]', 'password');
    await page.click('[data-testid="login-button"]');
    
    // Navigate to products
    await page.goto('/products');
    
    // Add first product to cart
    await page.click('[data-testid="product-1"] [data-testid="add-to-cart"]');
    await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');
    
    // Add second product
    await page.click('[data-testid="product-2"] [data-testid="add-to-cart"]');
    await expect(page.locator('[data-testid="cart-count"]')).toHaveText('2');
    
    // Go to cart
    await page.click('[data-testid="cart-link"]');
    await expect(page).toHaveURL('/cart');
    
    // Verify items in cart
    await expect(page.locator('[data-testid="cart-item"]')).toHaveCount(2);
    
    // Proceed to checkout
    await page.click('[data-testid="checkout-button"]');
    await expect(page).toHaveURL('/checkout');
    
    // Fill checkout form
    await page.fill('[data-testid="shipping-address"]', '123 Test St');
    await page.fill('[data-testid="city"]', 'Test City');
    await page.selectOption('[data-testid="state"]', 'CA');
    await page.fill('[data-testid="zip"]', '90210');
    
    // Complete order (mock payment)
    await page.click('[data-testid="place-order"]');
    
    // Should show order confirmation
    await expect(page).toHaveURL(/\/order\/\d+/);
    await expect(page.locator('[data-testid="order-success"]')).toBeVisible();
  });
});
```

## Testing by Technology Stack

### React/Next.js Testing

#### Component Testing
```jsx
// components/UserProfile.jsx
import React from 'react';

export function UserProfile({ user, onEdit }) {
  if (!user) {
    return <div data-testid="loading">Loading...</div>;
  }

  return (
    <div data-testid="user-profile">
      <h1 data-testid="user-name">{user.name}</h1>
      <p data-testid="user-email">{user.email}</p>
      <p data-testid="user-role">{user.role}</p>
      <button data-testid="edit-button" onClick={() => onEdit(user)}>
        Edit Profile
      </button>
    </div>
  );
}

// tests/components/UserProfile.test.jsx
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { UserProfile } from '../../components/UserProfile';

describe('UserProfile', () => {
  const mockUser = {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    role: 'admin'
  };

  test('renders user information', () => {
    const onEdit = jest.fn();
    render(<UserProfile user={mockUser} onEdit={onEdit} />);

    expect(screen.getByTestId('user-name')).toHaveTextContent('John Doe');
    expect(screen.getByTestId('user-email')).toHaveTextContent('john@example.com');
    expect(screen.getByTestId('user-role')).toHaveTextContent('admin');
  });

  test('shows loading state when user is null', () => {
    const onEdit = jest.fn();
    render(<UserProfile user={null} onEdit={onEdit} />);

    expect(screen.getByTestId('loading')).toBeInTheDocument();
  });

  test('calls onEdit when edit button is clicked', () => {
    const onEdit = jest.fn();
    render(<UserProfile user={mockUser} onEdit={onEdit} />);

    fireEvent.click(screen.getByTestId('edit-button'));
    expect(onEdit).toHaveBeenCalledWith(mockUser);
  });
});
```

#### Next.js API Route Testing
```javascript
// pages/api/users/[id].js
export default async function handler(req, res) {
  const { id } = req.query;
  
  if (req.method === 'GET') {
    try {
      const user = await getUserById(id);
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
      res.status(200).json(user);
    } catch (error) {
      res.status(500).json({ error: 'Internal server error' });
    }
  } else {
    res.setHeader('Allow', ['GET']);
    res.status(405).json({ error: 'Method not allowed' });
  }
}

// tests/api/users.test.js
import handler from '../../pages/api/users/[id]';
import { createMocks } from 'node-mocks-http';

jest.mock('../../lib/database', () => ({
  getUserById: jest.fn()
}));

import { getUserById } from '../../lib/database';

describe('/api/users/[id]', () => {
  test('returns user when found', async () => {
    const mockUser = { id: '1', name: 'John Doe', email: 'john@example.com' };
    getUserById.mockResolvedValue(mockUser);

    const { req, res } = createMocks({
      method: 'GET',
      query: { id: '1' }
    });

    await handler(req, res);

    expect(res._getStatusCode()).toBe(200);
    expect(JSON.parse(res._getData())).toEqual(mockUser);
  });

  test('returns 404 when user not found', async () => {
    getUserById.mockResolvedValue(null);

    const { req, res } = createMocks({
      method: 'GET',
      query: { id: '999' }
    });

    await handler(req, res);

    expect(res._getStatusCode()).toBe(404);
    expect(JSON.parse(res._getData())).toEqual({ error: 'User not found' });
  });

  test('returns 405 for unsupported methods', async () => {
    const { req, res } = createMocks({
      method: 'DELETE',
      query: { id: '1' }
    });

    await handler(req, res);

    expect(res._getStatusCode()).toBe(405);
    expect(res._getHeaders()).toHaveProperty('allow', ['GET']);
  });
});
```

### FastAPI/Python Testing

#### API Endpoint Testing
```python
# app/routers/users.py
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserResponse

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/", response_model=UserResponse)
async def create_user(user: UserCreate, db: Session = Depends(get_db)):
    # Check if user exists
    existing_user = db.query(User).filter(User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=409, detail="Email already registered")
    
    # Create new user
    db_user = User(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return db_user

# tests/test_users.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.database import get_db, Base

# Test database setup
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

@pytest.fixture(scope="function")
def client():
    Base.metadata.create_all(bind=engine)
    with TestClient(app) as c:
        yield c
    Base.metadata.drop_all(bind=engine)

def test_create_user_success(client):
    user_data = {
        "email": "test@example.com",
        "name": "Test User",
        "password": "securepassword"
    }
    
    response = client.post("/users/", json=user_data)
    
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == user_data["email"]
    assert data["name"] == user_data["name"]
    assert "id" in data
    assert "password" not in data  # Password should not be returned

def test_create_user_duplicate_email(client):
    user_data = {
        "email": "duplicate@example.com",
        "name": "First User",
        "password": "securepassword"
    }
    
    # Create first user
    client.post("/users/", json=user_data)
    
    # Try to create duplicate
    response = client.post("/users/", json=user_data)
    
    assert response.status_code == 409
    assert "Email already registered" in response.json()["detail"]

def test_create_user_invalid_data(client):
    invalid_data = {
        "email": "not-an-email",
        "name": "",
        "password": "123"  # Too short
    }
    
    response = client.post("/users/", json=invalid_data)
    
    assert response.status_code == 422  # Validation error
```

## Performance Testing

### Load Testing with Artillery
```yaml
# tests/performance/load-test.yml
config:
  target: "http://localhost:3000"
  phases:
    - duration: 60
      arrivalRate: 10
      name: "Warm up"
    - duration: 300
      arrivalRate: 50
      name: "Sustained load"
    - duration: 60
      arrivalRate: 100
      name: "Peak load"

scenarios:
  - name: "User registration and login"
    weight: 30
    flow:
      - post:
          url: "/auth/register"
          json:
            email: "user{% raw %}{{ $randomNumber() }}{% endraw %}@example.com"
            password: "SecurePass123!"
            name: "Load Test User"
          capture:
            - json: "$.token"
              as: "token"
      - post:
          url: "/auth/login"
          json:
            email: "{{ email }}"
            password: "SecurePass123!"

  - name: "API browsing"
    weight: 70
    flow:
      - get:
          url: "/api/products"
          headers:
            Authorization: "Bearer {{ token }}"
      - get:
          url: "/api/products/{% raw %}{{ $randomNumber(1, 100) }}{% endraw %}"
          headers:
            Authorization: "Bearer {{ token }}"
      - post:
          url: "/api/cart/add"
          headers:
            Authorization: "Bearer {{ token }}"
          json:
            productId: "{% raw %}{{ $randomNumber(1, 100) }}{% endraw %}"
            quantity: "{% raw %}{{ $randomNumber(1, 3) }}{% endraw %}"
```

### Performance Test with K6
```javascript
// tests/performance/stress-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

export let errorRate = new Rate('errors');

export let options = {
  stages: [
    { duration: '2m', target: 100 }, // Below normal load
    { duration: '5m', target: 100 },
    { duration: '2m', target: 200 }, // Normal load
    { duration: '5m', target: 200 },
    { duration: '2m', target: 300 }, // Around the breaking point
    { duration: '5m', target: 300 },
    { duration: '2m', target: 400 }, // Beyond the breaking point
    { duration: '5m', target: 400 },
    { duration: '10m', target: 0 }, // Scale down. Recovery stage.
  ],
  thresholds: {
    http_req_duration: ['p(99)<1500'], // 99% of requests must complete below 1.5s
    'logged in successfully': ['p(99)<1500'], // 99% of auth requests must complete below 1.5s
    errors: ['rate<0.1'], // Error rate must be less than 10%
  },
};

const BASE_URL = 'http://localhost:3000';

export default function () {
  // Test authentication
  let loginRes = http.post(`${BASE_URL}/auth/login`, {
    email: 'test@example.com',
    password: 'password123'
  });

  check(loginRes, {
    'logged in successfully': (resp) => resp.json('token') !== '',
  }) || errorRate.add(1);

  let authHeaders = {
    headers: {
      Authorization: `Bearer ${loginRes.json('token')}`,
    },
  };

  // Test API endpoints
  let responses = http.batch([
    ['GET', `${BASE_URL}/api/users/profile`, null, authHeaders],
    ['GET', `${BASE_URL}/api/products`, null, authHeaders],
    ['GET', `${BASE_URL}/api/orders`, null, authHeaders],
  ]);

  check(responses[0], {
    'profile fetch successful': (resp) => resp.status === 200,
  }) || errorRate.add(1);

  check(responses[1], {
    'products fetch successful': (resp) => resp.status === 200,
  }) || errorRate.add(1);

  check(responses[2], {
    'orders fetch successful': (resp) => resp.status === 200,
  }) || errorRate.add(1);

  sleep(1);
}
```

## Security Testing

### Input Validation Tests
```javascript
// tests/security/input-validation.test.js
import request from 'supertest';
import { app } from '../../src/app.js';

describe('Security - Input Validation', () => {
  describe('SQL Injection Protection', () => {
    test('prevents SQL injection in search', async () => {
      const maliciousInput = "'; DROP TABLE users; --";
      
      const response = await request(app)
        .get('/api/search')
        .query({ q: maliciousInput })
        .expect(400);  // Should be rejected, not cause error
      
      expect(response.body.error).toMatch(/invalid input/i);
    });

    test('prevents SQL injection in user lookup', async () => {
      const maliciousId = "1 OR 1=1";
      
      const response = await request(app)
        .get(`/api/users/${maliciousId}`)
        .expect(400);
      
      expect(response.body.error).toMatch(/invalid.*id/i);
    });
  });

  describe('XSS Protection', () => {
    test('sanitizes HTML input in user profile', async () => {
      const xssPayload = '<script>alert("xss")</script>';
      
      const response = await request(app)
        .post('/api/users/profile')
        .send({
          name: xssPayload,
          bio: 'Normal bio content'
        })
        .expect(400);
      
      expect(response.body.error).toMatch(/invalid.*characters/i);
    });

    test('allows safe HTML tags', async () => {
      const safeHtml = '<p>Safe <strong>content</strong></p>';
      
      const response = await request(app)
        .post('/api/users/profile')
        .send({
          name: 'John Doe',
          bio: safeHtml
        })
        .expect(200);
      
      expect(response.body.profile.bio).toBe(safeHtml);
    });
  });

  describe('Authentication Security', () => {
    test('rate limits login attempts', async () => {
      const loginData = {
        email: 'test@example.com',
        password: 'wrongpassword'
      };

      // Make multiple failed attempts
      for (let i = 0; i < 5; i++) {
        await request(app)
          .post('/auth/login')
          .send(loginData)
          .expect(401);
      }

      // 6th attempt should be rate limited
      const response = await request(app)
        .post('/auth/login')
        .send(loginData)
        .expect(429);
      
      expect(response.body.error).toMatch(/rate limit/i);
    });

    test('requires strong passwords', async () => {
      const userData = {
        email: 'weak@example.com',
        password: '123',  // Weak password
        name: 'Weak User'
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(400);
      
      expect(response.body.error).toMatch(/password.*requirements/i);
    });
  });
});
```

### Dependency Security Testing
```yaml
# .github/workflows/security.yml
name: Security Scan
on: [push, pull_request]

jobs:
  dependency-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run npm audit
        run: npm audit --audit-level moderate
      
      - name: Run Snyk security scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high

  code-security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run ESLint Security
        run: npx eslint . --ext .js,.jsx,.ts,.tsx --config .eslintrc.security.js
      
      - name: Run Semgrep
        uses: returntocorp/semgrep-action@v1
        with:
          config: >-
            p/security-audit
            p/secrets
            p/owasp-top-ten
```

## Test Organization & Best Practices

### Test File Structure
```
tests/
├── unit/
│   ├── utils/
│   ├── models/
│   ├── services/
│   └── components/
├── integration/
│   ├── api/
│   ├── database/
│   └── services/
├── e2e/
│   ├── user-flows/
│   ├── admin-flows/
│   └── mobile/
├── performance/
│   ├── load-tests/
│   └── stress-tests/
├── security/
│   ├── auth/
│   ├── input-validation/
│   └── api-security/
├── helpers/
│   ├── database.js
│   ├── auth.js
│   └── fixtures/
└── setup/
    ├── jest.config.js
    ├── playwright.config.js
    └── test-db.js
```

### Test Data Management

#### Factories and Fixtures
```javascript
// tests/helpers/factories.js
import { faker } from '@faker-js/faker';

export const UserFactory = {
  build: (overrides = {}) => ({
    email: faker.internet.email(),
    name: faker.name.fullName(),
    password: 'SecurePass123!',
    age: faker.datatype.number({ min: 18, max: 80 }),
    createdAt: faker.date.past(),
    ...overrides
  }),

  buildList: (count, overrides = {}) => {
    return Array.from({ length: count }, () => UserFactory.build(overrides));
  }
};

export const ProductFactory = {
  build: (overrides = {}) => ({
    name: faker.commerce.productName(),
    price: parseFloat(faker.commerce.price()),
    description: faker.commerce.productDescription(),
    category: faker.commerce.department(),
    inStock: faker.datatype.boolean(),
    ...overrides
  })
};

// Usage in tests
import { UserFactory, ProductFactory } from '../helpers/factories.js';

test('user can purchase product', () => {
  const user = UserFactory.build({ email: 'buyer@example.com' });
  const product = ProductFactory.build({ price: 29.99, inStock: true });
  
  // Test logic here
});
```

### Mock and Stub Patterns

#### Service Mocking
```javascript
// tests/unit/order-service.test.js
import { OrderService } from '../../src/services/order-service.js';

// Mock external dependencies
jest.mock('../../src/services/payment-service.js');
jest.mock('../../src/services/inventory-service.js');
jest.mock('../../src/services/email-service.js');

import { PaymentService } from '../../src/services/payment-service.js';
import { InventoryService } from '../../src/services/inventory-service.js';
import { EmailService } from '../../src/services/email-service.js';

describe('OrderService', () => {
  beforeEach(() => {
    // Reset mocks before each test
    jest.clearAllMocks();
  });

  test('processes order successfully', async () => {
    // Setup mocks
    PaymentService.processPayment.mockResolvedValue({ 
      success: true, 
      transactionId: 'txn_123' 
    });
    InventoryService.reserveItems.mockResolvedValue(true);
    EmailService.sendConfirmation.mockResolvedValue(true);

    const orderService = new OrderService();
    const orderData = {
      userId: 1,
      items: [{ productId: 1, quantity: 2 }],
      totalAmount: 59.98
    };

    const result = await orderService.createOrder(orderData);

    expect(result.success).toBe(true);
    expect(PaymentService.processPayment).toHaveBeenCalledWith({
      amount: 59.98,
      userId: 1
    });
    expect(InventoryService.reserveItems).toHaveBeenCalledWith(orderData.items);
    expect(EmailService.sendConfirmation).toHaveBeenCalledWith(
      expect.objectContaining({ orderId: result.orderId })
    );
  });

  test('handles payment failure gracefully', async () => {
    // Mock payment failure
    PaymentService.processPayment.mockResolvedValue({ 
      success: false, 
      error: 'Insufficient funds' 
    });

    const orderService = new OrderService();
    const orderData = {
      userId: 1,
      items: [{ productId: 1, quantity: 2 }],
      totalAmount: 59.98
    };

    const result = await orderService.createOrder(orderData);

    expect(result.success).toBe(false);
    expect(result.error).toBe('Payment failed: Insufficient funds');
    
    // Should not call other services if payment fails
    expect(InventoryService.reserveItems).not.toHaveBeenCalled();
    expect(EmailService.sendConfirmation).not.toHaveBeenCalled();
  });
});
```

## Continuous Integration

### GitHub Actions Test Pipeline
```yaml
# .github/workflows/test.yml
name: Test Suite
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20]
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run unit tests
        run: npm run test:unit -- --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info

  integration-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run database migrations
        run: npm run db:migrate
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
          REDIS_URL: redis://localhost:6379
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
          REDIS_URL: redis://localhost:6379

  e2e-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Build application
        run: npm run build
      
      - name: Start application
        run: npm start &
        
      - name: Wait for application
        run: npx wait-on http://localhost:3000
      
      - name: Run E2E tests
        run: npm run test:e2e
      
      - uses: actions/upload-artifact@v3
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/
```

## Testing Checklist

### Pre-Development
- [ ] Define acceptance criteria with measurable outcomes
- [ ] Choose appropriate testing frameworks for your stack
- [ ] Set up test database and mock services
- [ ] Create test data factories and fixtures
- [ ] Configure CI/CD pipeline for automated testing

### During Development
- [ ] Write tests before or alongside implementation (TDD/BDD)
- [ ] Ensure each test is isolated and repeatable
- [ ] Mock external dependencies appropriately  
- [ ] Test both success and failure scenarios
- [ ] Verify error handling and edge cases

### Testing Coverage
- [ ] Unit tests for business logic and utilities
- [ ] Integration tests for API endpoints and database operations
- [ ] End-to-end tests for critical user workflows
- [ ] Performance tests for load and stress scenarios
- [ ] Security tests for input validation and authentication

### Quality Gates
- [ ] Minimum test coverage thresholds met
- [ ] All tests pass in CI/CD pipeline
- [ ] Performance benchmarks satisfied
- [ ] Security scans show no high-severity issues
- [ ] Code quality metrics within acceptable ranges

By following these testing strategies and patterns, OSpec projects will have robust test suites that provide confidence in agent-generated code and enable rapid, safe iteration.