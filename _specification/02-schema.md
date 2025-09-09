---
layout: spec
title: "Schema Reference"
description: "Complete JSON Schema definition for OSpec v1.0"
permalink: /specification/schema/
order: 2
---

# OSpec Schema Reference

## JSON Schema Definition

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "OSpec v1.0",
  "type": "object",
  "required": ["ospec_version", "id", "name", "description", "outcome_type", "acceptance", "stack"],
  "properties": {
    "ospec_version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+\\.\\d+$",
      "description": "Semantic version of the OSpec format"
    },
    "id": {
      "type": "string",
      "pattern": "^[a-z][a-z0-9-]*$",
      "description": "Unique identifier in kebab-case"
    },
    "name": {
      "type": "string",
      "minLength": 3,
      "maxLength": 100,
      "description": "Human-readable project name"
    },
    "description": {
      "type": "string",
      "minLength": 10,
      "maxLength": 500,
      "description": "Detailed project description"
    },
    "outcome_type": {
      "type": "string",
      "enum": ["web-app", "api", "cli", "game", "library", "ml-pipeline", "mobile-app", "desktop-app", "infrastructure", "documentation"],
      "description": "Type of outcome to build"
    },
    "acceptance": {
      "type": "object",
      "properties": {
        "http_endpoints": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["path", "status"],
            "properties": {
              "path": {"type": "string"},
              "status": {"type": "integer"},
              "method": {"type": "string", "enum": ["GET", "POST", "PUT", "DELETE", "PATCH"]},
              "response_contains": {"type": "array", "items": {"type": "string"}}
            }
          }
        },
        "ux_flows": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["name", "steps"],
            "properties": {
              "name": {"type": "string"},
              "steps": {"type": "array", "items": {"type": "string"}}
            }
          }
        },
        "tests": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["file"],
            "properties": {
              "file": {"type": "string"},
              "type": {"type": "string", "enum": ["unit", "integration", "e2e"]},
              "coverage_threshold": {"type": "number", "minimum": 0, "maximum": 1}
            }
          }
        },
        "performance": {
          "type": "object",
          "properties": {
            "response_time_ms": {"type": "integer"},
            "throughput_rps": {"type": "integer"},
            "memory_mb": {"type": "integer"}
          }
        }
      }
    },
    "stack": {
      "type": "object",
      "additionalProperties": {"type": "string"},
      "description": "Technology stack components"
    },
    "guardrails": {
      "type": "object",
      "properties": {
        "tests_required": {"type": "boolean"},
        "min_test_coverage": {"type": "number", "minimum": 0, "maximum": 1},
        "lint": {"type": "boolean"},
        "type_check": {"type": "boolean"},
        "dependency_check": {"type": "boolean"},
        "security_scan": {"type": "boolean"},
        "license_whitelist": {"type": "array", "items": {"type": "string"}},
        "max_pr_size": {"type": "integer"},
        "human_approval_required": {"type": "array", "items": {"type": "string"}}
      }
    },
    "prompts": {
      "type": "object",
      "additionalProperties": {"type": "string"},
      "description": "Paths to prompt template files"
    },
    "scripts": {
      "type": "object",
      "additionalProperties": {"type": "string"},
      "description": "Paths to automation scripts"
    },
    "tasks": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["id", "title"],
        "properties": {
          "id": {"type": "string"},
          "title": {"type": "string"},
          "description": {"type": "string"},
          "dependencies": {"type": "array", "items": {"type": "string"}},
          "estimated_hours": {"type": "number"},
          "risk_level": {"type": "string", "enum": ["low", "medium", "high"]}
        }
      }
    },
    "metadata": {
      "type": "object",
      "properties": {
        "maintainers": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["name"],
            "properties": {
              "name": {"type": "string"},
              "email": {"type": "string", "format": "email"},
              "github": {"type": "string"}
            }
          }
        },
        "license": {"type": "string"},
        "version": {"type": "string"},
        "tags": {"type": "array", "items": {"type": "string"}},
        "estimated_effort": {"type": "string"}
      }
    },
    "secrets": {
      "type": "object",
      "properties": {
        "provider": {"type": "string"},
        "required": {"type": "array", "items": {"type": "string"}},
        "optional": {"type": "array", "items": {"type": "string"}}
      }
    }
  }
}
```

## Field Validation Rules

### Version String
- Must follow semantic versioning (MAJOR.MINOR.PATCH)
- Example: "1.0.0", "2.1.3"

### ID Format
- Lowercase letters, numbers, and hyphens only
- Must start with a letter
- Example: "shop-website", "api-gateway"

### Stack Components
Common stack keys:
- `frontend` - Frontend framework
- `backend` - Backend framework
- `database` - Database system
- `auth` - Authentication provider
- `payments` - Payment processor
- `deploy` - Deployment platform
- `ci` - CI/CD system
- `monitoring` - Monitoring solution

## Validation Tools

Use the OSpec validator to check your specifications:

```bash
# Install validator
npm install -g @ospec/validator

# Validate a spec file
ospec validate outcome.yaml
```