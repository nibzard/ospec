#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'json-schema'
require 'pathname'
require 'colorize'

class OSpecValidator
  SCHEMA_PATH = File.join(__dir__, '..', 'schemas', 'ospec-v1.0.json')
  
  def initialize
    @schema = load_schema
    @errors = []
    @warnings = []
  end
  
  def validate_file(file_path)
    puts "Validating OSpec file: #{file_path}".blue
    
    unless File.exist?(file_path)
      add_error("File does not exist: #{file_path}")
      return false
    end
    
    begin
      content = File.read(file_path)
      
      # Parse YAML
      ospec_data = YAML.safe_load(content)
      
      if ospec_data.nil?
        add_error("#{file_path}: File is empty or contains only comments")
        return false
      end
      
      unless ospec_data.is_a?(Hash)
        add_error("#{file_path}: Root element must be an object/hash")
        return false
      end
      
      # Validate against JSON Schema
      schema_errors = JSON::Validator.fully_validate(@schema, ospec_data)
      
      if schema_errors.any?
        schema_errors.each { |error| add_error("#{file_path}: #{error}") }
        return false
      end
      
      # Additional semantic validations
      validate_semantic_rules(ospec_data, file_path)
      
      if @errors.empty?
        puts "✅ #{file_path} is valid".green
        print_warnings if @warnings.any?
        return true
      else
        puts "❌ #{file_path} is invalid".red
        print_errors
        return false
      end
      
    rescue Psych::SyntaxError => e
      add_error("#{file_path}: YAML syntax error - #{e.message}")
      return false
    rescue JSON::Schema::ValidationError => e
      add_error("#{file_path}: Schema validation error - #{e.message}")
      return false
    rescue StandardError => e
      add_error("#{file_path}: Unexpected error - #{e.message}")
      return false
    end
  end
  
  def validate_directory(dir_path, pattern = '**/*.{ospec,ospec.yml,ospec.yaml}')
    puts "Validating OSpec files in: #{dir_path}".blue
    puts "Pattern: #{pattern}".light_blue
    
    files = Dir.glob(File.join(dir_path, pattern))
    
    if files.empty?
      puts "No OSpec files found matching pattern: #{pattern}".yellow
      return true
    end
    
    results = files.map { |file| validate_file(file) }
    valid_count = results.count(true)
    total_count = results.length
    
    puts "\n" + "="*50
    if results.all?
      puts "✅ All #{total_count} OSpec files are valid!".green
      return true
    else
      invalid_count = total_count - valid_count
      puts "❌ #{invalid_count} of #{total_count} OSpec files are invalid".red
      return false
    end
  end
  
  private
  
  def load_schema
    unless File.exist?(SCHEMA_PATH)
      raise "Schema file not found: #{SCHEMA_PATH}"
    end
    
    JSON.parse(File.read(SCHEMA_PATH))
  end
  
  def add_error(message)
    @errors << message
  end
  
  def add_warning(message)
    @warnings << message
  end
  
  def print_errors
    @errors.each { |error| puts "  ❌ #{error}".red }
  end
  
  def print_warnings
    @warnings.each { |warning| puts "  ⚠️  #{warning}".yellow }
  end
  
  def validate_semantic_rules(data, file_path)
    # Check if ID matches filename convention
    if data['id'] && File.basename(file_path, '.*') != data['id']
      add_warning("#{file_path}: ID '#{data['id']}' doesn't match filename convention")
    end
    
    # Check task dependencies exist
    if data['tasks']
      task_ids = data['tasks'].map { |task| task['id'] }
      data['tasks'].each do |task|
        if task['dependencies']
          task['dependencies'].each do |dep_id|
            unless task_ids.include?(dep_id)
              add_error("#{file_path}: Task '#{task['id']}' has unknown dependency '#{dep_id}'")
            end
          end
        end
      end
    end
    
    # Check that acceptance criteria has at least one validation method
    if data['acceptance']
      methods = %w[http_endpoints ux_flows tests performance]
      unless methods.any? { |method| data['acceptance'][method] }
        add_warning("#{file_path}: Acceptance criteria should include at least one validation method")
      end
    end
    
    # Validate file paths in prompts and scripts exist (if relative to project root)
    %w[prompts scripts].each do |section|
      next unless data[section]
      
      data[section].each do |key, file_path|
        # Skip absolute paths and URLs
        next if file_path.start_with?('/', 'http://', 'https://')
        
        project_root = File.dirname(File.expand_path(file_path))
        full_path = File.join(project_root, file_path)
        
        unless File.exist?(full_path)
          add_warning("#{file_path}: Referenced file does not exist: #{file_path}")
        end
      end
    end
    
    # Check version format consistency
    if data['ospec_version'] && data['metadata'] && data['metadata']['version']
      ospec_version = data['ospec_version']
      project_version = data['metadata']['version']
      
      # Extract major version for comparison
      ospec_major = ospec_version.split('.').first
      project_major = project_version.split('.').first
      
      if ospec_major != project_major && project_major != '0'
        add_warning("#{file_path}: OSpec version (#{ospec_version}) and project version (#{project_version}) have different major versions")
      end
    end
  end
end

# Command line interface
if __FILE__ == $0
  require 'optparse'
  
  options = {}
  
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options] [file_or_directory]"
    
    opts.on('-p', '--pattern PATTERN', 'File pattern for directory validation (default: **/*.{ospec,ospec.yml,ospec.yaml})') do |pattern|
      options[:pattern] = pattern
    end
    
    opts.on('-h', '--help', 'Show this help message') do
      puts opts
      exit
    end
    
    opts.on('--version', 'Show version') do
      puts "OSpec Validator v1.0.0"
      exit
    end
  end.parse!
  
  target = ARGV.first || '.'
  pattern = options[:pattern] || '**/*.{ospec,ospec.yml,ospec.yaml}'
  
  validator = OSpecValidator.new
  
  if File.file?(target)
    success = validator.validate_file(target)
  else
    success = validator.validate_directory(target, pattern)
  end
  
  exit(success ? 0 : 1)
end