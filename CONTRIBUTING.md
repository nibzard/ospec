# Contributing to OSpec

Thank you for your interest in contributing to OSpec! This document provides guidelines and instructions for contributing to the specification and website.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:
- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Accept feedback gracefully

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use issue templates when available
3. Provide clear reproduction steps for bugs
4. Include relevant environment details

### Suggesting Enhancements

1. Open a discussion first for major changes
2. Explain the problem your enhancement solves
3. Provide examples and use cases
4. Consider backward compatibility

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`rake test`)
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

### Prerequisites

- Ruby 3.0+
- Bundler
- Node.js 18+ (optional, for npm scripts)
- Git

### Local Development

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/ospec.git
cd ospec

# Install dependencies
bundle install

# Start development server
bundle exec jekyll serve --livereload

# Run tests
rake test

# Check links
rake check_links
```

### Project Structure

```
/
├── _specification/    # Core specification documents
├── _guides/          # How-to guides
├── _examples/        # Example implementations
├── _cookbook/        # Patterns and recipes
├── _layouts/         # Jekyll layouts
├── _includes/        # Reusable components
├── assets/           # CSS, JS, images
└── index.md          # Homepage
```

## Content Guidelines

### Writing Specification Documents

- Use clear, precise language
- Include code examples
- Follow semantic versioning for spec changes
- Document breaking changes clearly

### Creating Guides

- Start with prerequisites
- Use step-by-step instructions
- Include troubleshooting sections
- Test all code examples

### Adding Examples

- Provide complete, working code
- Include all necessary configuration
- Document environment setup
- Link to live demos when possible

## Style Guide

### Markdown

- Use ATX-style headers (`#`, `##`, etc.)
- Prefer fenced code blocks with language hints
- Use reference-style links for repeated URLs
- Keep lines under 120 characters when possible

### Code Examples

```yaml
# Good: Clear structure with comments
ospec_version: "1.0.0"  # Required: spec version
id: "example-id"        # Required: unique identifier
```

```yaml
# Avoid: No context or explanation
ospec_version: "1.0.0"
id: "example-id"
```

### Commit Messages

Follow conventional commits:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Formatting changes
- `refactor:` Code refactoring
- `test:` Test additions/changes
- `chore:` Maintenance tasks

Examples:
```
feat: add support for mobile app outcome type
fix: correct JSON schema validation for arrays
docs: improve getting started guide examples
```

## Testing

### Running Tests

```bash
# Run all tests
rake test

# Validate YAML front matter
rake validate_yaml

# Check for broken links
rake check_links

# Build site without serving
rake build
```

### Writing Tests

- Test all new functionality
- Include edge cases
- Document test purpose
- Keep tests focused and isolated

## Documentation

### API Documentation

- Document all public APIs
- Include request/response examples
- Specify error conditions
- Version all endpoints

### Schema Changes

1. Update JSON schema
2. Update documentation
3. Provide migration guide
4. Test backward compatibility

## Release Process

1. Update version in `_config.yml`
2. Update CHANGELOG.md
3. Create release PR
4. Tag release after merge
5. Deploy to production

## Getting Help

- **Discussions**: [GitHub Discussions](https://github.com/nibzard/ospec/discussions)
- **Chat**: Coming soon!
- **Email**: ospec@example.com

## Recognition

Contributors are recognized in:
- CONTRIBUTORS.md file
- Release notes
- Website credits page

## License

By contributing, you agree that your contributions will be licensed under the Apache 2.0 License.