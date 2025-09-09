---
layout: example
title: "JavaScript Library Package"
description: "Reusable JavaScript library with TypeScript, comprehensive testing, and NPM publishing"
outcome_type: "library"
complexity: "intermediate"
stack: "TypeScript + Jest + Rollup"
tags: ["library", "typescript", "npm", "testing"]
---

# JavaScript Library Package

This example demonstrates creating a reusable JavaScript library with TypeScript, comprehensive testing, documentation, and automated NPM publishing.

## OSpec Document

```yaml
ospec_version: "1.0.0"
id: "js-utility-library"
name: "JavaScript Utility Library"
description: "A collection of utility functions for JavaScript/TypeScript applications"
outcome_type: "library"

# Library-specific configuration
library:
  name: "@company/utils"
  description: "Common utility functions and helpers"
  version: "1.0.0"
  author: "Engineering Team <eng@company.com>"
  license: "MIT"
  
  # Supported environments
  targets:
    - "Node.js >= 16"
    - "Modern browsers (ES2020+)"
    - "TypeScript >= 4.5"
  
  # Entry points
  exports:
    main: "./dist/index.js"
    module: "./dist/index.esm.js"
    types: "./dist/index.d.ts"

stack:
  language: "TypeScript@5"
  build_tool: "Rollup@3"
  test_framework: "Jest@29"
  linter: "ESLint@8"
  formatter: "Prettier@3"
  docs: "TypeDoc@0.25"

# Testing requirements
acceptance:
  code_quality:
    test_coverage_min: 90
    type_coverage_min: 95
    linting_errors: 0
    
  build_outputs:
    - format: "CommonJS"
      file: "dist/index.js"
    - format: "ES Module"
      file: "dist/index.esm.js"
    - format: "UMD"
      file: "dist/index.umd.js"
    
  type_definitions:
    - file: "dist/index.d.ts"
      valid_typescript: true
    
  documentation:
    - file: "README.md"
      sections: ["installation", "usage", "api", "contributing"]
    - file: "docs/api.md"
      generated_from: "source_comments"

  package_json:
    required_fields:
      - "name"
      - "version"
      - "description" 
      - "main"
      - "module"
      - "types"
      - "author"
      - "license"
      - "repository"
      - "keywords"
    
    scripts:
      - "build"
      - "test"
      - "lint"
      - "type-check"

# API specification
api_design:
  modules:
    - name: "string-utils"
      functions:
        - name: "camelCase"
          signature: "(str: string) => string"
          description: "Convert string to camelCase"
        - name: "kebabCase"
          signature: "(str: string) => string" 
          description: "Convert string to kebab-case"
        - name: "truncate"
          signature: "(str: string, length: number, suffix?: string) => string"
          description: "Truncate string to specified length"
    
    - name: "array-utils"
      functions:
        - name: "chunk"
          signature: "<T>(array: T[], size: number) => T[][]"
          description: "Split array into chunks of specified size"
        - name: "unique"
          signature: "<T>(array: T[]) => T[]"
          description: "Remove duplicate values from array"
        - name: "groupBy"
          signature: "<T, K extends keyof T>(array: T[], key: K) => Record<string, T[]>"
          description: "Group array elements by property"
    
    - name: "object-utils"
      functions:
        - name: "pick"
          signature: "<T, K extends keyof T>(obj: T, keys: K[]) => Pick<T, K>"
          description: "Create object with only specified keys"
        - name: "omit"
          signature: "<T, K extends keyof T>(obj: T, keys: K[]) => Omit<T, K>"
          description: "Create object without specified keys"
        - name: "deepMerge"
          signature: "<T>(target: T, ...sources: Partial<T>[]) => T"
          description: "Deep merge objects"

# Publishing configuration
publishing:
  registry: "https://registry.npmjs.org"
  access: "public"  # or "restricted" for private packages
  
  # Automated publishing
  automated: true
  triggers:
    - event: "tag_pushed"
      pattern: "v*.*.*"
      branch: "main"
  
  # Release process
  release_process:
    - "run_tests"
    - "build_package"
    - "generate_docs"
    - "update_changelog"
    - "publish_to_npm"
    - "create_github_release"

guardrails:
  # Code quality gates
  quality_gates:
    - "all_tests_pass"
    - "coverage_threshold_met"
    - "no_linting_errors"
    - "type_check_passes"
    - "build_succeeds"
  
  # Security checks
  security_checks:
    - "dependency_audit"
    - "license_compliance"
    - "no_secrets_in_code"
  
  # Publishing safety
  publishing_safety:
    - "semver_compliance"
    - "changelog_updated"
    - "tag_matches_version"
    - "no_breaking_changes_in_patch"

# Development workflow
development:
  git_flow: "feature-branch"
  branch_protection:
    - "require_pull_request_reviews"
    - "require_status_checks"
    - "require_up_to_date_before_merge"
  
  ci_cd:
    provider: "GitHub Actions"
    workflows:
      - name: "test"
        triggers: ["push", "pull_request"]
        steps:
          - "checkout_code"
          - "install_dependencies"
          - "run_linter"
          - "run_tests"
          - "check_coverage"
          - "build_package"
      
      - name: "publish"
        triggers: ["tag_pushed"]
        steps:
          - "checkout_code"
          - "install_dependencies"
          - "run_full_test_suite"
          - "build_package"
          - "publish_to_npm"
          - "create_github_release"

# Documentation requirements
documentation:
  readme:
    sections:
      - title: "Installation"
        content: "npm install @company/utils"
      - title: "Usage"
        content: "import { camelCase } from '@company/utils';"
      - title: "API Reference"
        content: "Generated from TypeScript definitions"
      - title: "Contributing"
        content: "Guidelines for contributors"
  
  api_docs:
    generator: "TypeDoc"
    output_dir: "docs"
    include_private: false
    
  examples:
    location: "examples/"
    formats: ["typescript", "javascript"]

# Bundle configuration
bundling:
  tree_shaking: true
  minification: true
  source_maps: true
  
  formats:
    - name: "cjs"
      output: "dist/index.js"
      format: "commonjs"
    
    - name: "esm" 
      output: "dist/index.esm.js"
      format: "es"
    
    - name: "umd"
      output: "dist/index.umd.js"
      format: "umd"
      global_name: "CompanyUtils"

metadata:
  created_by: "Engineering Team"
  tags: ["utility", "typescript", "library"]
  estimated_hours: 40
  complexity: "intermediate"
```

## Key Features

### 1. Multi-Format Builds

The library builds to multiple formats to support different consumption patterns:

- **CommonJS** (`dist/index.js`) - For Node.js and bundlers
- **ES Modules** (`dist/index.esm.js`) - For modern bundlers with tree-shaking
- **UMD** (`dist/index.umd.js`) - For browser script tags and AMD loaders
- **TypeScript Definitions** (`dist/index.d.ts`) - For TypeScript consumers

### 2. Comprehensive Testing Strategy

```typescript
// Example test structure
describe('String Utils', () => {
  describe('camelCase', () => {
    it('converts kebab-case to camelCase', () => {
      expect(camelCase('hello-world')).toBe('helloWorld');
    });
    
    it('handles edge cases', () => {
      expect(camelCase('')).toBe('');
      expect(camelCase('single')).toBe('single');
      expect(camelCase('UPPER-CASE')).toBe('upperCase');
    });
  });
});
```

### 3. Type Safety and Documentation

```typescript
/**
 * Convert a string to camelCase format
 * @param str - The input string to convert
 * @returns The camelCased string
 * @example
 * ```typescript
 * camelCase('hello-world'); // 'helloWorld'
 * camelCase('user_name'); // 'userName'
 * ```
 */
export function camelCase(str: string): string {
  return str
    .replace(/[-_\s]+(.)?/g, (_, char) => char ? char.toUpperCase() : '')
    .replace(/^[A-Z]/, char => char.toLowerCase());
}
```

### 4. Automated Publishing Pipeline

The library includes automated publishing when tags are pushed:

```yaml
# .github/workflows/publish.yml
name: Publish Package

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          registry-url: 'https://registry.npmjs.org'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Build package
        run: npm run build
      
      - name: Publish to NPM
        run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

## Usage Examples

### Installation

```bash
npm install @company/utils
# or
yarn add @company/utils
```

### Basic Usage

```typescript
import { camelCase, chunk, pick } from '@company/utils';

// String utilities
const result = camelCase('hello-world'); // 'helloWorld'

// Array utilities
const chunks = chunk([1, 2, 3, 4, 5], 2); // [[1, 2], [3, 4], [5]]

// Object utilities
const user = { id: 1, name: 'John', email: 'john@example.com', age: 30 };
const publicData = pick(user, ['id', 'name']); // { id: 1, name: 'John' }
```

### Node.js CommonJS

```javascript
const { camelCase, chunk, pick } = require('@company/utils');

console.log(camelCase('hello-world')); // 'helloWorld'
```

### Browser UMD

```html
<script src="https://unpkg.com/@company/utils/dist/index.umd.js"></script>
<script>
  console.log(CompanyUtils.camelCase('hello-world')); // 'helloWorld'
</script>
```

## Project Structure

```
js-utility-library/
├── src/
│   ├── string-utils.ts      # String utility functions
│   ├── array-utils.ts       # Array utility functions
│   ├── object-utils.ts      # Object utility functions
│   └── index.ts            # Main entry point
├── tests/
│   ├── string-utils.test.ts
│   ├── array-utils.test.ts
│   └── object-utils.test.ts
├── examples/
│   ├── typescript.ts       # TypeScript usage examples
│   └── javascript.js       # JavaScript usage examples
├── docs/                   # Generated documentation
├── dist/                   # Built files
│   ├── index.js           # CommonJS build
│   ├── index.esm.js       # ES Module build
│   ├── index.umd.js       # UMD build
│   └── index.d.ts         # TypeScript definitions
├── package.json
├── tsconfig.json
├── rollup.config.js
├── jest.config.js
└── README.md
```

## Benefits

### For Library Authors
- **Automated workflow** from development to publishing
- **Multiple format support** reaches all consumers
- **Comprehensive testing** ensures reliability
- **Type safety** reduces bugs and improves DX

### For Library Consumers
- **Universal compatibility** works in any environment
- **Tree-shakable** modules for smaller bundles
- **Excellent TypeScript support** with full type definitions
- **Well-documented** with examples and API docs

## Advanced Features

### Custom Build Configuration

```typescript
// rollup.config.js
export default {
  input: 'src/index.ts',
  output: [
    {
      file: 'dist/index.js',
      format: 'cjs',
      sourcemap: true
    },
    {
      file: 'dist/index.esm.js', 
      format: 'es',
      sourcemap: true
    },
    {
      file: 'dist/index.umd.js',
      format: 'umd',
      name: 'CompanyUtils',
      sourcemap: true
    }
  ],
  plugins: [
    typescript({
      declaration: true,
      outDir: 'dist'
    }),
    terser()
  ]
};
```

### Performance Testing

```typescript
// Performance benchmarks
describe('Performance Tests', () => {
  it('camelCase should handle large strings efficiently', () => {
    const largeString = 'a'.repeat(10000) + '-' + 'b'.repeat(10000);
    
    const start = performance.now();
    const result = camelCase(largeString);
    const end = performance.now();
    
    expect(end - start).toBeLessThan(100); // Should complete in <100ms
    expect(result).toBeDefined();
  });
});
```

## Related Examples

- [API Service →]({{ 'examples/api-service/' | relative_url }}) - Backend API development
- [CLI Tool →]({{ 'examples/cli-tool/' | relative_url }}) - Command-line utilities
- [Mobile App →]({{ 'examples/mobile-app/' | relative_url }}) - React Native applications

## Next Steps

1. **Extend functionality** - Add more utility modules
2. **Performance optimization** - Benchmark and optimize hot paths
3. **Framework integrations** - Create React/Vue/Angular adapters
4. **Localization** - Add i18n support for string utilities
5. **Plugin system** - Allow extending with custom utilities