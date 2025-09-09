---
layout: spec
title: "AI Agent Integration"
description: "How different AI coding agents can use OSpec to build products"
order: 4
redirect_from:
  - /specification/agents-roles/
---

# AI Agent Integration

OSpec is designed to work with any AI coding agent by providing a standardized specification format. Different agents can interpret OSpec files and use them to scaffold, build, and deploy projects.

## Common Integration Pattern

```
User Requirements → [Human creates OSpec] → outcome.yaml
                                               ↓
outcome.yaml → [AI Coding Agent] → Working Product
```

The OSpec file eliminates decision paralysis by specifying exactly which tools, versions, and patterns to use.

## Agent-Specific Optimizations

Different AI coding agents have different strengths and preferred tools. OSpec can specify which agent a stack is optimized for:

### Claude Code Integration
```yaml
stack:
  # Works well with Claude Code
  frontend: "Next.js@14"
  
  # Good documentation, clear APIs
  backend: "Supabase"
  
  # Composable, well-understood
  styling: "TailwindCSS"
  
  # Reliable, widely supported
  package_manager: "npm"
  
metadata:
  optimized_for: ["claude-code"]
```

### GitHub Copilot Integration  
```yaml
stack:
  # Popular patterns in training data
  backend: "Express.js"
  
  # Well-documented, mature
  database: "PostgreSQL"
  
  # Type-safe, good autocomplete
  orm: "Prisma"
  
metadata:
  optimized_for: ["github-copilot"]
```

### Cursor Integration
```yaml
stack:
  # Python ecosystem strength
  framework: "FastAPI"
  
  # Simple setup
  database: "SQLite"
  
  # Pythonic patterns
  testing: "pytest"
  
metadata:
  optimized_for: ["cursor"]
```

## Implementation Commands

AI coding agents can implement standard commands to work with OSpec files:

### Project Scaffolding
```bash
# Initialize project from OSpec
ospec scaffold outcome.yaml ./my-project

# This should:
# 1. Create directory structure
# 2. Install dependencies with correct package manager
# 3. Generate boilerplate code
# 4. Set up basic configuration files
```

### Verification
```bash
# Test against acceptance criteria
ospec verify outcome.yaml ./my-project

# This should:
# 1. Run acceptance tests
# 2. Check HTTP endpoints
# 3. Validate user flows
# 4. Report success/failure
```

## Stack-Specific Workflows

### Next.js + Supabase Stack
```yaml
stack:
  frontend: "Next.js@14"
  backend: "Supabase" 
  styling: "TailwindCSS"
  deploy: "Vercel"

# AI agent workflow:
# 1. npx create-next-app --typescript
# 2. npm install @supabase/supabase-js
# 3. Configure supabase client
# 4. Set up TailwindCSS
# 5. Deploy to Vercel
```

### FastAPI + PostgreSQL Stack
```yaml
stack:
  backend: "FastAPI"
  database: "PostgreSQL"
  orm: "SQLAlchemy"
  deploy: "Railway"

# AI agent workflow:  
# 1. Create FastAPI project structure
# 2. Set up PostgreSQL connection
# 3. Configure SQLAlchemy models
# 4. Generate API endpoints
# 5. Deploy to Railway
```

## Agent Capabilities

### Required Capabilities
For an AI coding agent to work with OSpec, it should be able to:

1. **Parse YAML** - Read and understand OSpec files
2. **Scaffold projects** - Create directory structure and boilerplate
3. **Install dependencies** - Use package managers (npm, pip, cargo, etc.)
4. **Generate code** - Create implementation based on stack choice
5. **Run tests** - Execute acceptance criteria validation

### Optional Capabilities
Enhanced agents might also:

1. **Generate OSpecs** - Convert natural language to OSpec YAML
2. **Update dependencies** - Keep tech stacks current
3. **Optimize performance** - Profile and improve generated code
4. **Handle deployment** - Push to specified hosting platforms

## Integration Examples

### Command Line Tool
```bash
$ ospec --help
Commands:
  scaffold <file> <dir>  Create project from OSpec
  verify <file> <dir>    Test against acceptance criteria
  validate <file>        Check OSpec syntax
  generate <prompt>      Create OSpec from description
```

### API Integration
```python
import ospec

# Load specification
spec = ospec.load("outcome.yaml")

# Create project
ospec.scaffold(spec, "./project")

# Verify implementation
result = ospec.verify(spec, "./project")
```

### IDE Extension
```javascript
// VS Code extension example
vscode.commands.registerCommand('ospec.scaffold', async () => {
  const ospecFile = await vscode.window.showOpenDialog();
  const targetDir = await vscode.window.showOpenDialog();
  
  await ospec.scaffold(ospecFile[0], targetDir[0]);
  vscode.window.showInformationMessage('Project scaffolded successfully!');
});
```

This approach keeps AI coding agents focused on their core strength: building products quickly with proven tech stacks.