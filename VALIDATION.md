# OSpec Schema Validation System

A comprehensive validation system for OSpec (Outcome Specification) files that ensures specifications meet the required format and standards.

## Features

- ✅ **JSON Schema Validation** - Complete schema validation against OSpec v1.0 specification
- ✅ **Semantic Rule Checking** - Advanced validation beyond schema constraints  
- ✅ **Multiple Runtime Support** - Ruby (Rake) and Node.js implementations
- ✅ **CI/CD Integration** - Automated validation in GitHub Actions
- ✅ **Developer-Friendly** - Clear error messages and warnings
- ✅ **Batch Validation** - Validate multiple files and directories
- ✅ **Extensible** - Easy to add custom validation rules

## Quick Start

### Option 1: Ruby/Rake (Recommended for Jekyll projects)

```bash
# Install dependencies
bundle install

# Validate all OSpec files
bundle exec rake validate_ospec

# Validate specific file
bundle exec rake validate_ospec_file[examples/my-project.ospec.yml]

# Create new OSpec from template
bundle exec rake new_ospec[my-project]
```

### Option 2: Node.js (Standalone)

```bash
# Install dependencies
npm install

# Validate all OSpec files
npm run validate-ospec

# Validate specific file
node scripts/validate-ospec.js examples/my-project.ospec.yml

# Validate directory with custom pattern
node scripts/validate-ospec.js ./examples --pattern="*.ospec.yml"
```

## File Structure

```
├── schemas/
│   └── ospec-v1.0.json           # JSON Schema definition
├── scripts/
│   ├── validate_ospec.rb         # Ruby validation library
│   ├── ospec-validate            # Ruby CLI tool
│   └── validate-ospec.js         # Node.js validation tool
├── examples/
│   ├── shop-website-basic.ospec.yml  # Valid example
│   ├── minimal-valid.ospec.yml        # Minimal valid example
│   └── invalid-example.ospec.yml      # Invalid example for testing
├── _specification/
│   └── 03-validation.md          # Complete validation documentation
├── Rakefile                      # Ruby tasks integration
├── package.json                  # Node.js dependencies
└── .github/workflows/pages.yml   # CI/CD integration
```

## Supported File Patterns

The validator automatically detects OSpec files with these patterns:

- `*.ospec` - Simple extension
- `*.ospec.yml` - YAML with OSpec marker  
- `*.ospec.yaml` - Alternative YAML extension

## Validation Rules

### Required Fields

All OSpec files must contain:

- `ospec_version` - Semantic version (e.g., "1.0.0")
- `id` - Kebab-case identifier (e.g., "my-project")
- `name` - Human-readable project name
- `description` - Project description (10-500 characters)
- `outcome_type` - Project type from allowed enum
- `acceptance` - At least one acceptance criterion
- `stack` - At least one technology component

### Format Validation

#### ID Format
```yaml
✅ id: "my-project-name"      # Valid kebab-case
❌ id: "My_Project_Name"      # Invalid: not kebab-case
❌ id: "123-project"          # Invalid: must start with letter
```

#### Outcome Types
Valid values: `web-app`, `api`, `cli`, `game`, `library`, `ml-pipeline`, `mobile-app`, `desktop-app`, `infrastructure`, `documentation`

#### HTTP Endpoints
```yaml
acceptance:
  http_endpoints:
    - path: "/"               ✅ Valid: starts with /
      status: 200             ✅ Valid: HTTP status code
    - path: "api/users"       ❌ Invalid: missing leading /
      status: 999             ❌ Invalid: not valid HTTP status
```

#### Test Files
```yaml
acceptance:
  tests:
    - file: "tests/app.test.js"      ✅ Valid: contains .test.
    - file: "spec/user.spec.py"      ✅ Valid: contains .spec.
    - file: "tests/integration.js"   ❌ Invalid: missing .test. or .spec.
```

### Semantic Validation

Beyond schema validation, the system checks:

- **Task Dependencies** - Referenced tasks exist
- **File References** - Prompt and script files exist (relative paths)
- **Version Consistency** - OSpec and project versions align
- **Acceptance Criteria** - At least one validation method present

## Error Messages

### Schema Validation Errors
```
❌ examples/invalid.ospec.yml: The property '#/id' value "Invalid_ID" 
   did not match the regex '^[a-z][a-z0-9-]*$'
```

### Semantic Validation Errors
```
❌ examples/project.ospec.yml: Task 'deploy' has unknown dependency 'missing-task'
```

### Warnings
```
⚠️  examples/project.ospec.yml: Referenced file does not exist: scripts/missing.sh
```

## CI/CD Integration

### GitHub Actions

The validation is automatically integrated:

```yaml
# .github/workflows/pages.yml
- name: Validate OSpec files
  run: bundle exec rake validate_ospec

- name: Build with Jekyll  
  run: bundle exec jekyll build
```

### Other CI Systems

#### Exit Codes
- `0` - All files valid
- `1` - Validation failed

#### JSON Output
```bash
node scripts/validate-ospec.js . --format=json
```

#### JUnit XML Output  
```bash
./scripts/ospec-validate . --format junit
```

## Development Workflow

### 1. Create New OSpec
```bash
bundle exec rake new_ospec[my-project]
# Creates: examples/my-project.ospec.yml
```

### 2. Edit and Validate
```bash
# Edit the file...
vim examples/my-project.ospec.yml

# Validate
bundle exec rake validate_ospec_file[examples/my-project.ospec.yml]
```

### 3. Iterate Until Valid
```bash
# Fix validation errors and re-run validation
# Repeat until all errors are resolved
```

### 4. Full Project Validation
```bash
bundle exec rake validate_ospec
```

## Examples

### Valid Minimal OSpec
```yaml
ospec_version: "1.0.0"
id: "minimal-example"
name: "Minimal Valid Example"
description: "This is a minimal but valid OSpec file that meets all requirements."
outcome_type: "cli"

acceptance:
  tests:
    - file: "tests/basic.test.js"

stack:
  runtime: "Node.js@20"
```

### Complete OSpec Example
See `examples/shop-website-basic.ospec.yml` for a comprehensive example with all sections.

## Installation

### Ruby Environment
```bash
# Install Ruby dependencies
bundle install

# The validation system is ready to use
bundle exec rake validate_ospec
```

### Node.js Environment  
```bash
# Install Node.js dependencies
npm install

# Run validation
npm run validate-ospec
```

### System Requirements

#### Ruby Version (Jekyll Environment)
- Ruby 3.0+
- Bundler 2.0+
- Required gems: `json-schema`, `colorize`, `yaml`

#### Node.js Version (Standalone)
- Node.js 16+
- Required packages: `ajv`, `ajv-formats`, `yaml`, `glob`, `chalk`

## Troubleshooting

### Common Issues

#### Missing Dependencies
```bash
# Ruby
bundle install

# Node.js  
npm install
```

#### Permission Issues
```bash
chmod +x scripts/ospec-validate
```

#### Large File Validation
For projects with many OSpec files:

```bash
# Validate specific directory
./scripts/ospec-validate ./specs --pattern="*.ospec.yml"

# Use Ruby version for better performance
bundle exec rake validate_ospec
```

### Debug Mode

Enable verbose output:

```bash
# Ruby
ruby scripts/validate_ospec.rb examples/ --verbose

# Node.js
node scripts/validate-ospec.js examples/ --verbose
```

## Extending the System

### Custom Validation Rules

Add to `scripts/validate_ospec.rb`:

```ruby
def validate_semantic_rules(data, file_path)
  # Custom validation logic
  if data['outcome_type'] == 'web-app' && !data['stack']['frontend']
    add_warning("#{file_path}: Web apps should specify a frontend framework")
  end
end
```

### Schema Updates

1. Edit `schemas/ospec-v1.0.json`
2. Update version for breaking changes
3. Test against existing files
4. Update documentation

## Contributing

1. Add validation rules in both Ruby and Node.js versions
2. Update schema and tests
3. Document new rules in `_specification/03-validation.md`
4. Test against real-world OSpec files

## License

This validation system is part of the OSpec project and follows the same Apache-2.0 license.