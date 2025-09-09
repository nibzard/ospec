#!/usr/bin/env node

/**
 * OSpec JSON Schema Validator (Node.js version)
 * 
 * This is a standalone Node.js validator that can be used when Ruby is not available.
 * Requires: Node.js 16+ with npm packages: ajv, yaml, glob, chalk
 */

const fs = require('fs');
const path = require('path');
const yaml = require('yaml');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');
const { glob } = require('glob');
const chalk = require('chalk');

class OSpecValidator {
  constructor() {
    this.ajv = new Ajv({ allErrors: true, verbose: true });
    addFormats(this.ajv);
    
    // Load schema
    const schemaPath = path.join(__dirname, '..', 'schemas', 'ospec-v1.0.json');
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found: ${schemaPath}`);
    }
    
    this.schema = JSON.parse(fs.readFileSync(schemaPath, 'utf8'));
    this.validate = this.ajv.compile(this.schema);
    
    this.errors = [];
    this.warnings = [];
  }
  
  validateFile(filePath) {
    console.log(chalk.blue(`Validating OSpec file: ${filePath}`));
    
    if (!fs.existsSync(filePath)) {
      this.addError(`File does not exist: ${filePath}`);
      return false;
    }
    
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      
      // Parse YAML
      const ospecData = yaml.parse(content);
      
      if (!ospecData) {
        this.addError(`${filePath}: File is empty or contains only comments`);
        return false;
      }
      
      if (typeof ospecData !== 'object' || Array.isArray(ospecData)) {
        this.addError(`${filePath}: Root element must be an object`);
        return false;
      }
      
      // Validate against JSON Schema
      const valid = this.validate(ospecData);
      
      if (!valid) {
        this.validate.errors.forEach(error => {
          this.addError(`${filePath}: ${this.formatError(error)}`);
        });
      }
      
      // Additional semantic validations
      this.validateSemanticRules(ospecData, filePath);
      
      if (this.errors.length === 0) {
        console.log(chalk.green(`✅ ${filePath} is valid`));
        if (this.warnings.length > 0) {
          this.printWarnings();
        }
        return true;
      } else {
        console.log(chalk.red(`❌ ${filePath} is invalid`));
        this.printErrors();
        return false;
      }
      
    } catch (error) {
      if (error.name === 'YAMLParseError') {
        this.addError(`${filePath}: YAML syntax error - ${error.message}`);
      } else {
        this.addError(`${filePath}: Unexpected error - ${error.message}`);
      }
      return false;
    }
  }
  
  async validateDirectory(dirPath, pattern = '**/*.{ospec,ospec.yml,ospec.yaml}') {
    console.log(chalk.blue(`Validating OSpec files in: ${dirPath}`));
    console.log(chalk.cyan(`Pattern: ${pattern}`));
    
    const files = await glob(pattern, { cwd: dirPath });
    
    if (files.length === 0) {
      console.log(chalk.yellow(`No OSpec files found matching pattern: ${pattern}`));
      return true;
    }
    
    const results = [];
    for (const file of files) {
      const fullPath = path.join(dirPath, file);
      this.clearMessages();
      const valid = this.validateFile(fullPath);
      results.push(valid);
    }
    
    const validCount = results.filter(r => r).length;
    const totalCount = results.length;
    
    console.log('\n' + '='.repeat(50));
    if (results.every(r => r)) {
      console.log(chalk.green(`✅ All ${totalCount} OSpec files are valid!`));
      return true;
    } else {
      const invalidCount = totalCount - validCount;
      console.log(chalk.red(`❌ ${invalidCount} of ${totalCount} OSpec files are invalid`));
      return false;
    }
  }
  
  formatError(error) {
    const { instancePath, schemaPath, message } = error;
    const path = instancePath || 'root';
    return `Property '${path}' ${message}`;
  }
  
  validateSemanticRules(data, filePath) {
    // Check if ID matches filename convention
    if (data.id && path.basename(filePath, path.extname(filePath)).replace('.ospec', '') !== data.id) {
      this.addWarning(`${filePath}: ID '${data.id}' doesn't match filename convention`);
    }
    
    // Check task dependencies exist
    if (data.tasks) {
      const taskIds = data.tasks.map(task => task.id);
      data.tasks.forEach(task => {
        if (task.dependencies) {
          task.dependencies.forEach(depId => {
            if (!taskIds.includes(depId)) {
              this.addError(`${filePath}: Task '${task.id}' has unknown dependency '${depId}'`);
            }
          });
        }
      });
    }
    
    // Check acceptance criteria has at least one validation method
    if (data.acceptance) {
      const methods = ['http_endpoints', 'ux_flows', 'tests', 'performance'];
      if (!methods.some(method => data.acceptance[method])) {
        this.addWarning(`${filePath}: Acceptance criteria should include at least one validation method`);
      }
    }
    
    // Check version format consistency
    if (data.ospec_version && data.metadata?.version) {
      const ospecMajor = data.ospec_version.split('.')[0];
      const projectMajor = data.metadata.version.split('.')[0];
      
      if (ospecMajor !== projectMajor && projectMajor !== '0') {
        this.addWarning(
          `${filePath}: OSpec version (${data.ospec_version}) and project version (${data.metadata.version}) have different major versions`
        );
      }
    }
  }
  
  addError(message) {
    this.errors.push(message);
  }
  
  addWarning(message) {
    this.warnings.push(message);
  }
  
  printErrors() {
    this.errors.forEach(error => console.log(chalk.red(`  ❌ ${error}`)));
  }
  
  printWarnings() {
    this.warnings.forEach(warning => console.log(chalk.yellow(`  ⚠️  ${warning}`)));
  }
  
  clearMessages() {
    this.errors = [];
    this.warnings = [];
  }
}

// Command line interface
async function main() {
  const args = process.argv.slice(2);
  
  if (args.includes('--help') || args.includes('-h')) {
    console.log(`
OSpec Validator (Node.js) v1.0.0

Usage: node validate-ospec.js [file-or-directory] [options]

Options:
  --pattern PATTERN    File pattern for directory validation
  --help, -h          Show this help message
  --version           Show version

Examples:
  node validate-ospec.js my-project.ospec.yml
  node validate-ospec.js ./examples --pattern "*.ospec.yml"
`);
    process.exit(0);
  }
  
  if (args.includes('--version')) {
    console.log('OSpec Validator (Node.js) v1.0.0');
    process.exit(0);
  }
  
  const target = args.find(arg => !arg.startsWith('--')) || '.';
  const patternArg = args.find(arg => arg.startsWith('--pattern='));
  const pattern = patternArg ? patternArg.split('=')[1] : '**/*.{ospec,ospec.yml,ospec.yaml}';
  
  try {
    const validator = new OSpecValidator();
    
    const stats = fs.statSync(target);
    let success;
    
    if (stats.isFile()) {
      success = validator.validateFile(target);
    } else if (stats.isDirectory()) {
      success = await validator.validateDirectory(target, pattern);
    } else {
      console.error(`Error: '${target}' is not a valid file or directory`);
      process.exit(1);
    }
    
    process.exit(success ? 0 : 1);
    
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
}

// Run if this script is executed directly
if (require.main === module) {
  main().catch(error => {
    console.error(error);
    process.exit(1);
  });
}

module.exports = { OSpecValidator };