---
layout: spec
title: "Integration APIs"
description: "APIs for integrating OSpec with existing tools and workflows"
order: 8
---

# Integration APIs

OSpec provides standard APIs for integrating with existing development tools, CI/CD pipelines, and organizational workflows.

## Core API Surface

### OSpec Management API

RESTful API for managing OSpec documents and project lifecycle:

```http
# Create new project from OSpec
POST /api/v1/projects
Content-Type: application/yaml

ospec_version: "1.0.0"
id: "my-project"
name: "Example Project"
# ... rest of OSpec document

# Response
201 Created
{
  "project_id": "proj_abc123",
  "status": "specification",
  "created_at": "2024-01-15T10:00:00Z",
  "spec_url": "/api/v1/projects/proj_abc123/spec"
}
```

```http
# Get project status
GET /api/v1/projects/proj_abc123
Authorization: Bearer <token>

# Response
200 OK
{
  "project_id": "proj_abc123",
  "name": "Example Project",
  "status": "implementation",
  "progress": 0.65,
  "current_phase": "implementation",
  "agents": {
    "implementer": "agent_def456",
    "reviewer": "agent_ghi789"
  },
  "created_at": "2024-01-15T10:00:00Z",
  "updated_at": "2024-01-16T14:30:00Z"
}
```

### Agent Orchestration API

Manage agent assignments and workflows:

```http
# Assign agent to project role
PUT /api/v1/projects/proj_abc123/agents/implementer
{
  "agent_id": "agent_def456",
  "capabilities": ["javascript", "react", "nodejs"],
  "priority": "high"
}

# Get agent status
GET /api/v1/agents/agent_def456/status
{
  "agent_id": "agent_def456",
  "status": "busy",
  "current_project": "proj_abc123",
  "current_task": "implement-user-auth",
  "utilization": 0.85,
  "last_activity": "2024-01-16T14:30:00Z"
}
```

### Artifact Management API

Access generated artifacts and outputs:

```http
# List project artifacts
GET /api/v1/projects/proj_abc123/artifacts
{
  "artifacts": [
    {
      "type": "source_code",
      "path": "/src",
      "size_bytes": 245760,
      "modified": "2024-01-16T14:30:00Z"
    },
    {
      "type": "test_results",
      "path": "/reports/test-results.xml",
      "size_bytes": 12456,
      "modified": "2024-01-16T14:25:00Z"
    },
    {
      "type": "security_scan",
      "path": "/reports/security.json",
      "size_bytes": 8934,
      "modified": "2024-01-16T14:20:00Z"
    }
  ]
}

# Download artifact
GET /api/v1/projects/proj_abc123/artifacts/source_code
Content-Type: application/zip
Content-Disposition: attachment; filename="project-source.zip"
```

## Webhook Integration

### Event Notifications

Subscribe to project events via webhooks:

```http
# Register webhook
POST /api/v1/webhooks
{
  "url": "https://company.com/ospec-webhook",
  "events": [
    "project.created",
    "project.phase_completed",
    "project.failed",
    "agent.task_completed",
    "security.issue_detected"
  ],
  "secret": "webhook_secret_abc123"
}
```

Webhook payload structure:

```json
{
  "event": "project.phase_completed",
  "timestamp": "2024-01-16T14:30:00Z",
  "project_id": "proj_abc123",
  "data": {
    "phase": "planning",
    "next_phase": "implementation",
    "artifacts": [
      {
        "type": "task_breakdown",
        "url": "/api/v1/projects/proj_abc123/artifacts/tasks.yaml"
      }
    ]
  },
  "signature": "sha256=abc123..."
}
```

## CI/CD Integration

### GitHub Actions Integration

```yaml
# .github/workflows/ospec-deploy.yml
name: OSpec Deploy
on:
  push:
    paths: ['project.ospec.yaml']

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy with OSpec
        uses: ospec/deploy-action@v1
        with:
          ospec_file: 'project.ospec.yaml'
          api_token: ${{ secrets.OSPEC_API_TOKEN }}
          wait_for_completion: true
        
      - name: Get deployment status
        run: |
          project_id=$(cat ospec-project-id.txt)
          curl -H "Authorization: Bearer ${{ secrets.OSPEC_API_TOKEN }}" \
               "https://api.ospec.dev/v1/projects/$project_id/status"
```

### Jenkins Integration

```groovy
// Jenkins pipeline integration
pipeline {
    agent any
    
    environment {
        OSPEC_API_TOKEN = credentials('ospec-api-token')
    }
    
    stages {
        stage('Deploy with OSpec') {
            steps {
                script {
                    def response = sh(
                        script: """
                            curl -X POST https://api.ospec.dev/v1/projects \
                                -H "Authorization: Bearer ${OSPEC_API_TOKEN}" \
                                -H "Content-Type: application/yaml" \
                                --data-binary @project.ospec.yaml
                        """,
                        returnStdout: true
                    )
                    
                    def project = readJSON(text: response)
                    env.PROJECT_ID = project.project_id
                }
            }
        }
        
        stage('Wait for Completion') {
            steps {
                script {
                    timeout(time: 30, unit: 'MINUTES') {
                        waitUntil {
                            def status = sh(
                                script: """
                                    curl -H "Authorization: Bearer ${OSPEC_API_TOKEN}" \
                                         "https://api.ospec.dev/v1/projects/${PROJECT_ID}"
                                """,
                                returnStdout: true
                            )
                            def project = readJSON(text: status)
                            return project.status in ['deployed', 'failed']
                        }
                    }
                }
            }
        }
    }
}
```

## IDE Integration

### VS Code Extension API

```javascript
// VS Code extension integration
const ospec = require('@ospec/vscode-extension');

// Register OSpec file validation
vscode.workspace.onDidChangeTextDocument(async (event) => {
    if (event.document.fileName.endsWith('.ospec.yaml')) {
        const validation = await ospec.validateDocument(event.document.getText());
        
        if (!validation.valid) {
            // Show validation errors
            ospec.showDiagnostics(event.document, validation.errors);
        }
    }
});

// Add OSpec commands
vscode.commands.registerCommand('ospec.deploy', async () => {
    const activeEditor = vscode.window.activeTextEditor;
    if (activeEditor && activeEditor.document.fileName.endsWith('.ospec.yaml')) {
        const project = await ospec.deploy(activeEditor.document.getText());
        vscode.window.showInformationMessage(`Deployed project: ${project.project_id}`);
    }
});
```

### IntelliJ Plugin API

```kotlin
// IntelliJ IDEA plugin integration
class OSpecDeployAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent) {
        val project = e.project ?: return
        val virtualFile = e.getData(PlatformDataKeys.VIRTUAL_FILE) ?: return
        
        if (virtualFile.extension == "yaml" && virtualFile.name.contains("ospec")) {
            val content = VfsUtil.loadText(virtualFile)
            
            ApplicationManager.getApplication().executeOnPooledThread {
                try {
                    val result = OSpecClient.deploy(content)
                    
                    SwingUtilities.invokeLater {
                        Messages.showInfoMessage(
                            "Project deployed: ${result.projectId}",
                            "OSpec Deploy"
                        )
                    }
                } catch (e: Exception) {
                    SwingUtilities.invokeLater {
                        Messages.showErrorDialog(
                            "Deployment failed: ${e.message}",
                            "OSpec Deploy Error"
                        )
                    }
                }
            }
        }
    }
}
```

## External Tool Integration

### Jira Integration

```yaml
# OSpec with Jira ticket tracking
metadata:
  integrations:
    jira:
      instance_url: "https://company.atlassian.net"
      project_key: "PROJ"
      issue_type: "Epic"
      
      # Automatic ticket creation
      create_tickets: true
      ticket_template:
        summary: "Implement {{ospec.name}}"
        description: |
          OSpec ID: {{ospec.id}}
          Outcome Type: {{ospec.outcome_type}}
          
          Acceptance Criteria:
          {{#each ospec.acceptance}}
          - {{this}}
          {{/each}}
        
        labels: ["ospec", "{{ospec.outcome_type}}"]
        priority: "Medium"
```

### Slack Integration

```yaml
# Slack notifications for project events
metadata:
  integrations:
    slack:
      webhook_url: "{{secrets.SLACK_WEBHOOK_URL}}"
      channel: "#dev-team"
      
      notifications:
        project_started: true
        phase_completed: true
        deployment_successful: true
        errors: true
        
      message_templates:
        phase_completed: |
          ✅ **{{project.name}}** completed {{phase}} phase
          
          Next: {{next_phase}}
          Progress: {{progress}}%
          
          <{{project.url}}|View Project>
```

### Monitoring Integration

```yaml
# Integration with monitoring tools
deployment:
  monitoring:
    datadog:
      api_key: "{{secrets.DATADOG_API_KEY}}"
      dashboards:
        - name: "{{project.name}} Overview"
          metrics:
            - "ospec.project.health"
            - "ospec.agent.utilization"
            - "ospec.deployment.success_rate"
    
    prometheus:
      metrics_endpoint: "/metrics"
      labels:
        project_id: "{{project.id}}"
        outcome_type: "{{project.outcome_type}}"
```

## SDK and Client Libraries

### Python SDK

```python
# Python SDK example
import ospec

# Initialize client
client = ospec.Client(api_token='your_token')

# Create project from file
with open('project.ospec.yaml') as f:
    project = client.create_project(f.read())

print(f"Created project: {project.id}")

# Monitor progress
for update in client.watch_project(project.id):
    print(f"Status: {update.status}, Progress: {update.progress}")
    
    if update.status in ['deployed', 'failed']:
        break

# Get final artifacts
artifacts = client.get_artifacts(project.id)
for artifact in artifacts:
    client.download_artifact(project.id, artifact.path, f"./{artifact.name}")
```

### JavaScript SDK

```javascript
// Node.js SDK example
const OSpec = require('@ospec/sdk');

const client = new OSpec.Client({
    apiToken: process.env.OSPEC_API_TOKEN
});

async function deployProject() {
    const spec = fs.readFileSync('project.ospec.yaml', 'utf8');
    
    // Create and monitor project
    const project = await client.createProject(spec);
    console.log(`Created project: ${project.id}`);
    
    // Wait for completion
    const final = await client.waitForCompletion(project.id, {
        timeout: 30 * 60 * 1000, // 30 minutes
        onProgress: (progress) => {
            console.log(`Progress: ${progress.percentage}%`);
        }
    });
    
    if (final.status === 'deployed') {
        console.log('Deployment successful!');
        
        // Download artifacts
        const artifacts = await client.getArtifacts(project.id);
        for (const artifact of artifacts) {
            await client.downloadArtifact(project.id, artifact.path, `./output/${artifact.name}`);
        }
    } else {
        throw new Error(`Deployment failed: ${final.error}`);
    }
}
```

## Error Handling and Resilience

### Retry Mechanisms

```yaml
# API client configuration
api_client:
  retries:
    max_attempts: 3
    backoff: "exponential"  # exponential, linear, fixed
    base_delay_ms: 1000
    max_delay_ms: 30000
    
  timeouts:
    connection_timeout_ms: 5000
    read_timeout_ms: 30000
    
  circuit_breaker:
    failure_threshold: 5
    recovery_timeout_ms: 60000
```

### Graceful Degradation

```javascript
// Client-side graceful degradation
class OSpecClient {
    async deploy(spec, options = {}) {
        try {
            return await this.apiDeploy(spec, options);
        } catch (error) {
            if (options.fallback === 'local') {
                console.warn('API unavailable, falling back to local deployment');
                return await this.localDeploy(spec, options);
            }
            throw error;
        }
    }
}
```

## Authentication and Authorization

### API Key Management

```http
# API key creation
POST /api/v1/auth/api-keys
Authorization: Bearer <user_token>
{
  "name": "CI/CD Pipeline",
  "scopes": ["projects:create", "projects:read", "artifacts:download"],
  "expires_at": "2025-01-01T00:00:00Z"
}

# Response
201 Created
{
  "api_key_id": "ak_abc123",
  "api_key": "ospec_sk_def456...",
  "scopes": ["projects:create", "projects:read", "artifacts:download"],
  "created_at": "2024-01-15T10:00:00Z",
  "expires_at": "2025-01-01T00:00:00Z"
}
```

### OAuth 2.0 Integration

```yaml
# OAuth configuration for enterprise
oauth:
  provider: "custom"  # github, google, azure, custom
  client_id: "{{secrets.OAUTH_CLIENT_ID}}"
  client_secret: "{{secrets.OAUTH_CLIENT_SECRET}}"
  scopes: ["read:user", "read:org"]
  
  # User role mapping
  role_mapping:
    "admin": "ospec:admin"
    "developer": "ospec:user"
    "viewer": "ospec:readonly"
```

## Next Steps

- [Lifecycle Management →](/specification/lifecycle-management/)
- [Extensibility →](/specification/extensibility-plugins/)
- [Security & Guardrails →](/specification/security-guardrails/)