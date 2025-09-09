---
layout: spec
title: "Schema Validation"
description: "OSpec schema validation tools and integration guide"
permalink: /specification/validation/
order: 3
---

# OSpec Schema Validation

OSpec includes comprehensive schema validation tools to ensure your specifications are valid and complete. The validation system uses JSON Schema to validate YAML files and provides detailed error messages for debugging.

## Quick Start

### Validate a Single File

```bash
# Using Rake (recommended)
bundle exec rake validate_ospec_file[examples/my-project.ospec.yml]

# Using the CLI script directly
./scripts/ospec-validate examples/my-project.ospec.yml
```

### Validate All OSpec Files

```bash
# Validate all OSpec files in the project
bundle exec rake validate_ospec

# Validate files in a specific directory
./scripts/ospec-validate ./examples --pattern "*.ospec.yml"
```

### Create a New OSpec File

```bash
# Create from template
bundle exec rake new_ospec[my-new-project]

# This creates: examples/my-new-project.ospec.yml
```

## Validation Tools

### 1. Rake Tasks

The validation system integrates with Rake for easy development workflow:

#### `rake validate_ospec`
- Validates all OSpec files in the project
- Searches multiple file patterns automatically
- Integrated into the default test suite
- Used in CI/CD pipeline

#### `rake validate_ospec_file[file]`
- Validates a specific OSpec file
- Provides detailed error messages
- Useful for development and debugging

#### `rake new_ospec[name]`
- Creates a new OSpec file from template
- Automatically validates the generated file
- Follows naming conventions

### 2. Command Line Tool

The standalone CLI tool (`scripts/ospec-validate`) provides advanced validation options:

```bash
./scripts/ospec-validate [FILE|DIRECTORY] [options]

Options:
  -p, --pattern PATTERN    File pattern for directory validation
  -v, --verbose           Enable verbose output
  -s, --strict            Treat warnings as errors
  -f, --format FORMAT     Output format (human, json, junit)
  -q, --quiet             Suppress non-error output
  --list-schemas          List available schema versions
  --schema-version VER    Use specific schema version
  -h, --help              Show help message
```

### 3. Ruby Library

Use the validation library programmatically:

```ruby
require_relative 'scripts/validate_ospec'

validator = OSpecValidator.new

# Validate a single file
success = validator.validate_file('my-project.ospec.yml')

# Validate a directory
success = validator.validate_directory('./examples')
```

## JSON Schema

The validation is based on a comprehensive JSON Schema located at `schemas/ospec-v1.0.json`. The schema validates:

### Required Fields
- `ospec_version` - Semantic version (e.g., "1.0.0")
- `id` - Kebab-case identifier
- `name` - Project name (3-100 chars)
- `description` - Project description (10-500 chars)
- `outcome_type` - Project type from allowed enum
- `acceptance` - At least one acceptance criterion
- `stack` - At least one technology component

### Field Validation Rules

#### ID Format
```yaml
id: "my-project-name"  ✅ Valid
id: "MyProjectName"    ❌ Invalid (not kebab-case)
id: "123-project"      ❌ Invalid (doesn't start with letter)
```

#### Outcome Types
Valid outcome types:
- `web-app` - Web applications
- `api` - REST/GraphQL APIs
- `cli` - Command-line tools
- `game` - Games and interactive apps
- `library` - Reusable libraries
- `ml-pipeline` - Machine learning pipelines
- `mobile-app` - Mobile applications
- `desktop-app` - Desktop applications
- `infrastructure` - Infrastructure as code
- `documentation` - Documentation projects

#### HTTP Endpoints
```yaml
acceptance:
  http_endpoints:
    - path: "/"           ✅ Valid (starts with /)
      status: 200         ✅ Valid (100-599)
      method: "GET"       ✅ Valid (optional, defaults to GET)
    - path: "api/users"   ❌ Invalid (missing leading /)
      status: 999         ❌ Invalid (not valid HTTP status)
```

#### Test Files
```yaml
acceptance:
  tests:
    - file: "tests/app.test.js"     ✅ Valid
    - file: "spec/user.spec.py"     ✅ Valid
    - file: "tests/integration.js"  ❌ Invalid (must contain .test. or .spec.)
```

#### Secret Variables
```yaml
secrets:
  required:
    - "DATABASE_URL"      ✅ Valid (uppercase with underscores)
    - "api_key"           ❌ Invalid (not uppercase)
```

## Semantic Validation

Beyond JSON Schema validation, the system performs additional semantic checks:

### Task Dependencies
```yaml
tasks:
  - id: "setup"
    title: "Setup Project"
  - id: "build"
    title: "Build Application"
    dependencies: ["setup"]      ✅ Valid (setup task exists)
  - id: "deploy"
    title: "Deploy to Production"
    dependencies: ["unknown"]    ❌ Error (unknown task dependency)
```

### File References
The validator checks that referenced files exist (for relative paths):

```yaml
prompts:
  implementer: "prompts/web-app.md"    # Warns if file doesn't exist

scripts:
  build: "scripts/build.sh"           # Warns if file doesn't exist
```

### Version Consistency
Warns if OSpec version and project version have different major versions:

```yaml
ospec_version: "1.0.0"
metadata:
  version: "2.1.0"  # Warning: major version mismatch
```

## Error Messages

The validation system provides clear, actionable error messages:

### Schema Errors
```
❌ examples/invalid.ospec.yml: The property '#/id' value "Invalid_ID" 
   did not match the regex '^[a-z][a-z0-9-]*$'
```

### Semantic Errors
```
❌ examples/project.ospec.yml: Task 'deploy' has unknown dependency 'missing-task'
```

### Warnings
```
⚠️ examples/project.ospec.yml: Referenced file does not exist: scripts/missing.sh
```

## CI/CD Integration

### GitHub Actions

The validation is automatically integrated into the GitHub Pages workflow:

```yaml
- name: Validate OSpec files
  run: bundle exec rake validate_ospec

- name: Build with Jekyll
  run: bundle exec jekyll build
```

If validation fails, the build stops and deployment is prevented.

### Other CI Systems

Use the CLI tool with different output formats:

```bash
# JSON output for programmatic parsing
./scripts/ospec-validate . --format json

# JUnit XML for test reporting
./scripts/ospec-validate . --format junit

# Exit codes: 0 = success, 1 = validation failed
```

## Validation Patterns

### File Naming Conventions

The validator supports multiple file naming patterns:

- `*.ospec` - Simple extension
- `*.ospec.yml` - YAML with OSpec marker
- `*.ospec.yaml` - Alternative YAML extension

### Directory Structure

Recommended directory structure:
```
project/
├── specs/
│   ├── backend.ospec.yml
│   ├── frontend.ospec.yml
│   └── infrastructure.ospec.yml
├── examples/
│   └── sample-project.ospec.yml
└── schemas/
    └── ospec-v1.0.json
```

## Common Validation Issues

### Missing Required Fields
```yaml
# ❌ Missing required fields
ospec_version: "1.0.0"
name: "My Project"
# Missing: id, description, outcome_type, acceptance, stack
```

### Invalid ID Format
```yaml
# ❌ Invalid ID (not kebab-case)
id: "My_Project_Name"

# ✅ Valid ID
id: "my-project-name"
```

### Empty Acceptance Criteria
```yaml
# ❌ Empty acceptance object
acceptance: {}

# ✅ At least one acceptance criterion
acceptance:
  tests:
    - file: "tests/basic.test.js"
```

### Empty Stack
```yaml
# ❌ Empty stack object
stack: {}

# ✅ At least one stack component
stack:
  runtime: "Node.js@20"
```

## Extending Validation

### Custom Validation Rules

Add custom semantic validation in `scripts/validate_ospec.rb`:

```ruby
def validate_semantic_rules(data, file_path)
  # Add your custom validation logic here
  if data['outcome_type'] == 'web-app' && !data['stack']['frontend']
    add_warning("#{file_path}: Web apps should specify a frontend framework")
  end
end
```

### Schema Updates

To update the JSON Schema:

1. Edit `schemas/ospec-v1.0.json`
2. Update the version number if making breaking changes
3. Test with existing OSpec files
4. Update documentation

## Best Practices

### Development Workflow

1. Create OSpec file: `rake new_ospec[project-name]`
2. Edit the generated file
3. Validate: `rake validate_ospec_file[examples/project-name.ospec.yml]`
4. Iterate until valid
5. Run full validation: `rake validate_ospec`

### Team Collaboration

- Include validation in pre-commit hooks
- Validate in pull request CI checks
- Use strict mode for production specifications
- Document custom validation rules

### Schema Evolution

- Use semantic versioning for schema updates
- Maintain backward compatibility within major versions
- Provide migration guides for breaking changes
- Test against real-world OSpec files before releasing

## Troubleshooting

### Common Installation Issues

Missing gems:
```bash
bundle install  # Install required dependencies
```

Permission errors:
```bash
chmod +x scripts/ospec-validate
```

### Debugging Validation Failures

Use verbose mode for detailed output:
```bash
./scripts/ospec-validate examples/ --verbose
```

Check the JSON Schema directly:
```bash
# Validate against raw schema
cat examples/project.ospec.yml | yq . | \
jq -f schemas/ospec-v1.0.json
```

### Performance Considerations

For large numbers of files:
- Use specific patterns to limit scope
- Run validation in parallel CI jobs
- Consider caching validation results

The validation system is designed to be fast, accurate, and developer-friendly, ensuring that your OSpec files meet the specification requirements while providing clear guidance for fixes.