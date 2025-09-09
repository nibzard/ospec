---
layout: example
title: "Admin Dashboard"
outcome_type: "web-app"
difficulty: intermediate
stack:
  frontend: "React + TypeScript + Tailwind"
  backend: "Node.js + Express + PostgreSQL"
  deployment: "Docker + Railway"
---

# Admin Dashboard Example

A comprehensive admin dashboard for managing users, content, and system settings with role-based access control.

## Project Overview

This example demonstrates building a full-featured admin dashboard with:
- User management with RBAC
- Real-time analytics
- Content management
- System configuration
- Audit logging

## Complete OSpec

```yaml
# admin-dashboard.ospec.yml
ospec_version: "1.0"
project_name: "AdminDash Pro"
outcome_type: "web-app"

outcome:
  description: "A comprehensive admin dashboard for system management"
  success_criteria:
    - "Admins can manage users with role assignments"
    - "Dashboard displays real-time system metrics"
    - "Content can be created, edited, and published"
    - "All actions are logged for audit compliance"
    - "Responsive design works on desktop and tablet"

functional_requirements:
  authentication:
    - "Multi-factor authentication support"
    - "Session management with timeout"
    - "Password policy enforcement"
  
  user_management:
    - "Create, read, update, delete users"
    - "Role-based access control (Admin, Editor, Viewer)"
    - "Bulk user operations"
    - "User activity tracking"
  
  dashboard:
    - "Real-time metrics visualization"
    - "Customizable widget layout"
    - "Data export capabilities"
    - "Alert notifications"
  
  content_management:
    - "WYSIWYG content editor"
    - "Media upload and management"
    - "Content versioning"
    - "Publish/unpublish workflow"

technical_requirements:
  performance:
    - "Page load time under 2 seconds"
    - "Real-time updates with <500ms latency"
    - "Support 100+ concurrent admin users"
  
  security:
    - "OWASP top 10 compliance"
    - "Data encryption at rest and in transit"
    - "Regular security audit logging"
  
  accessibility:
    - "WCAG 2.1 AA compliance"
    - "Keyboard navigation support"
    - "Screen reader compatibility"

technology_stack:
  frontend:
    framework: "React 18"
    language: "TypeScript"
    styling: "Tailwind CSS"
    state_management: "Redux Toolkit"
    charts: "Chart.js"
    
  backend:
    framework: "Express.js"
    language: "Node.js + TypeScript"
    database: "PostgreSQL 14"
    orm: "Prisma"
    authentication: "JSON Web Tokens"
    
  infrastructure:
    hosting: "Railway"
    containerization: "Docker"
    cdn: "CloudFlare"
    monitoring: "Sentry"

development:
  team_size: 3
  timeline: "8 weeks"
  methodology: "Agile/Scrum"
  
  phases:
    - name: "Foundation"
      duration: "2 weeks"
      deliverables: ["Authentication system", "Basic user management"]
      
    - name: "Core Features"
      duration: "4 weeks"  
      deliverables: ["Dashboard with metrics", "Content management"]
      
    - name: "Polish & Deploy"
      duration: "2 weeks"
      deliverables: ["Performance optimization", "Production deployment"]

acceptance_tests:
  - name: "Admin Login Flow"
    steps:
      - "Navigate to admin login page"
      - "Enter valid admin credentials"
      - "Complete MFA challenge"
      - "Verify dashboard loads with user's permissions"
      
  - name: "User Management"
    steps:
      - "Access user management section"
      - "Create new user with Editor role"
      - "Verify user appears in user list"
      - "Edit user role to Viewer"
      - "Verify role change is reflected"
      
  - name: "Content Publishing"
    steps:
      - "Navigate to content management"
      - "Create new article with WYSIWYG editor"
      - "Upload and insert media"
      - "Set publish date and save as draft"
      - "Review and publish content"
      - "Verify content appears on frontend"

deployment:
  environments:
    - name: "development"
      url: "http://localhost:3000"
      database: "local PostgreSQL"
      
    - name: "staging"
      url: "https://admindash-staging.railway.app"
      database: "Railway PostgreSQL"
      
    - name: "production"
      url: "https://admindash.company.com"
      database: "Railway PostgreSQL with backups"
      
  ci_cd:
    provider: "GitHub Actions"
    triggers: ["push to main", "pull request"]
    steps:
      - "Run tests and linting"
      - "Build Docker image"
      - "Deploy to staging"
      - "Run E2E tests"
      - "Deploy to production (manual approval)"

monitoring:
  error_tracking: "Sentry"
  performance: "Railway metrics"
  uptime: "Pingdom"
  logs: "Railway logs"
  
  alerts:
    - condition: "Error rate > 5%"
      notify: ["team@company.com"]
    - condition: "Response time > 3s"
      notify: ["devops@company.com"]
```

## Key Implementation Details

### Authentication & Security
```typescript
// JWT middleware with role checking
export const requireRole = (roles: Role[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({ error: 'Insufficient permissions' });
    }
    next();
  };
};

// Usage in routes
app.get('/api/admin/users', 
  authenticateToken, 
  requireRole(['ADMIN']), 
  getUsersController
);
```

### Real-time Dashboard
```typescript
// WebSocket connection for real-time metrics
const wsServer = new WebSocketServer({ port: 8080 });

wsServer.on('connection', (ws, req) => {
  const user = authenticateWebSocket(req);
  if (!user || !['ADMIN', 'EDITOR'].includes(user.role)) {
    ws.close(1008, 'Unauthorized');
    return;
  }
  
  // Send real-time metrics every 5 seconds
  const interval = setInterval(() => {
    ws.send(JSON.stringify({
      type: 'METRICS_UPDATE',
      data: getSystemMetrics()
    }));
  }, 5000);
  
  ws.on('close', () => clearInterval(interval));
});
```

### Content Management
```typescript
// Rich text editor with media upload
export const ContentEditor: React.FC<{content: Content}> = ({content}) => {
  const [editorState, setEditorState] = useState(
    EditorState.createWithContent(convertFromHTML(content.html))
  );
  
  const handleImageUpload = async (file: File) => {
    const formData = new FormData();
    formData.append('image', file);
    
    const response = await fetch('/api/media/upload', {
      method: 'POST',
      body: formData,
      headers: { 'Authorization': `Bearer ${token}` }
    });
    
    return response.json();
  };
  
  return (
    <Editor
      editorState={editorState}
      onChange={setEditorState}
      plugins={[imagePlugin]}
      handleUpload={handleImageUpload}
    />
  );
};
```

## Development Workflow

### 1. Project Setup
```bash
# Clone and setup
git clone <repo-url>
cd admin-dashboard
npm install

# Database setup
npx prisma generate
npx prisma migrate dev

# Start development
npm run dev
```

### 2. Testing Strategy
```bash
# Unit tests
npm run test

# Integration tests
npm run test:integration

# E2E tests
npm run test:e2e

# Accessibility tests
npm run test:a11y
```

### 3. Deployment
```bash
# Build for production
npm run build

# Docker build
docker build -t admin-dashboard .

# Deploy to Railway
railway deploy
```

## Performance Optimizations

- **Code splitting** by route and feature
- **Image optimization** with Next.js Image component
- **Database indexing** on frequently queried fields
- **Caching** of dashboard metrics with Redis
- **Bundle analysis** to identify optimization opportunities

## Security Considerations

- Input validation and sanitization
- SQL injection prevention with parameterized queries
- XSS protection with CSP headers
- Rate limiting on API endpoints
- Regular dependency vulnerability scanning

## Lessons Learned

1. **Role-based access control** should be implemented early
2. **Real-time features** require careful connection management
3. **Rich text editors** need proper sanitization
4. **Dashboard performance** benefits from data aggregation
5. **Audit logging** is essential for compliance

## Next Steps

- Add advanced analytics with custom metrics
- Implement notification system
- Add multi-tenancy support
- Integrate with external APIs
- Add mobile app companion

---

*Want to build this project? Check out the [full repository](https://github.com/nibzard/ospec-examples/tree/main/admin-dashboard) or join our [Discord](https://discord.gg/ospec) for help.*