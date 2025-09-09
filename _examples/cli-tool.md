---
layout: example
title: "Project Management CLI"
description: "Cross-platform command-line tool for managing projects, tasks, and workflows with offline support"
outcome_type: "cli"
complexity: "intermediate"
stack: "Rust + Clap"
github: "https://github.com/nibzard/ospec-examples/tree/main/pmcli"
---

# Project Management CLI (pmcli)

A powerful, cross-platform command-line tool built with Rust that provides comprehensive project management capabilities including task tracking, time management, and workflow automation with both online and offline support.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "project-management-cli"
name: "Project Management CLI (pmcli)"
description: "Cross-platform CLI tool for project management with task tracking, time logging, and workflow automation"
outcome_type: "cli"

acceptance:
  commands:
    # Core help and version
    - name: "pmcli --help"
      exit_code: 0
      output_contains: ["Usage:", "Commands:", "Options:"]
      max_execution_time_ms: 1000

    - name: "pmcli --version"
      exit_code: 0
      output_format: "semver"
      max_execution_time_ms: 500

    # Project management
    - name: "pmcli project create"
      subcommands:
        - "pmcli project create --name 'Test Project' --description 'A test project'"
          exit_code: 0
          output_contains: ["Created project", "Test Project"]
        
        - "pmcli project create --name 'Test' --template web-app"
          exit_code: 0
          output_contains: ["Created project from template"]

    - name: "pmcli project list"
      exit_code: 0
      output_format: "table"
      columns: ["ID", "Name", "Status", "Tasks", "Created"]

    - name: "pmcli project show <id>"
      exit_code: 0
      output_contains: ["Project Details", "Tasks:", "Statistics:"]

    # Task management
    - name: "pmcli task add"
      subcommands:
        - "pmcli task add --title 'New Task' --priority high"
          exit_code: 0
          output_contains: ["Created task", "New Task"]
        
        - "pmcli task add --title 'Feature' --project 1 --due 2024-12-31"
          exit_code: 0
          output_contains: ["Created task", "Feature"]

    - name: "pmcli task list"
      exit_code: 0
      output_format: "table"
      filters:
        - "--status pending"
        - "--priority high"
        - "--project 1"
        - "--assigned-to me"

    - name: "pmcli task complete <id>"
      exit_code: 0
      output_contains: ["Task completed"]

    # Time tracking
    - name: "pmcli time start <task_id>"
      exit_code: 0
      output_contains: ["Timer started for task"]

    - name: "pmcli time stop"
      exit_code: 0
      output_contains: ["Timer stopped", "Duration:"]

    - name: "pmcli time report"
      exit_code: 0
      output_format: "table"
      columns: ["Date", "Task", "Duration", "Project"]

    # Configuration
    - name: "pmcli config set <key> <value>"
      exit_code: 0
      output_contains: ["Configuration updated"]

    - name: "pmcli config get <key>"
      exit_code: 0
      max_execution_time_ms: 500

    # Sync and backup
    - name: "pmcli sync"
      exit_code: 0
      output_contains: ["Sync completed"]
      timeout_ms: 10000

    - name: "pmcli backup create"
      exit_code: 0
      output_contains: ["Backup created"]

  performance:
    startup_time_ms: 100
    command_response_time_ms: 1000
    large_dataset_response_ms: 5000
    memory_usage_mb_max: 50
    binary_size_mb_max: 20

  cross_platform:
    supported_os: ["linux", "macos", "windows"]
    supported_architectures: ["x86_64", "aarch64"]
    
  offline_support:
    local_database: true
    sync_conflict_resolution: true
    offline_time_tracking: true

  data_formats:
    export_formats: ["json", "csv", "markdown"]
    import_formats: ["json", "csv", "trello", "asana"]

  integrations:
    git_integration: true
    editor_plugins: ["vscode", "vim", "emacs"]
    shell_completions: ["bash", "zsh", "fish", "powershell"]

  tests:
    - file: "tests/unit/**/*.rs"
      type: "unit"
      coverage_threshold: 0.8
    - file: "tests/integration/**/*.rs"
      type: "integration"
      coverage_threshold: 0.7
    - file: "tests/cli/**/*.rs"
      type: "cli"
      coverage_threshold: 0.6

stack:
  language: "Rust 1.70+"
  cli_framework: "clap 4.0"
  database: "SQLite with rusqlite"
  serialization: "serde with serde_json"
  http_client: "reqwest"
  async_runtime: "tokio"
  testing: "cargo test + assert_cmd"
  packaging: "cargo"
  cross_compilation: "cross"
  configuration: "config-rs"
  logging: "tracing + tracing-subscriber"

guardrails:
  tests_required: true
  min_test_coverage: 0.8
  lint: true
  security_scan: true
  dependency_check: true
  cross_platform_testing: true
  performance_benchmarks: true
  license_whitelist: ["MIT", "Apache-2.0", "BSD-3-Clause"]

prompts:
  implementer: |
    You are building a professional CLI tool with Rust and clap.
    
    Requirements:
    - Follow Rust best practices and idioms
    - Use proper error handling with Result types
    - Implement comprehensive logging with tracing
    - Create intuitive command structure and help text
    - Support both interactive and scripting modes
    - Include progress bars for long operations
    - Implement proper signal handling (Ctrl+C)
    - Add shell completion generation
    - Use structured logging for debugging
    - Follow semantic versioning
    - Cross-platform compatibility
    - Offline-first design with sync capabilities

scripts:
  setup: "scripts/setup.sh"
  build: "cargo build --release"
  test: "cargo test"
  lint: "cargo clippy -- -D warnings"
  format: "cargo fmt --check"
  benchmark: "cargo bench"
  cross_compile: "scripts/cross-compile.sh"
  package: "scripts/package.sh"
  install: "cargo install --path ."

secrets:
  provider: "env://local"
  optional:
    - "API_TOKEN"
    - "SYNC_ENDPOINT"
    - "ANALYTICS_TOKEN"

metadata:
  estimated_effort: "4-6 days"
  complexity: "intermediate"
  tags: ["cli", "rust", "project-management", "sqlite", "cross-platform"]
  version: "1.0.0"
  maintainers:
    - name: "CLI Team"
      email: "cli-team@company.com"
```

## Features

### Core Features
- ✅ **Project Management**: Create, organize, and track multiple projects
- ✅ **Task Management**: Full CRUD operations for tasks with priorities and due dates
- ✅ **Time Tracking**: Built-in timer for tracking work sessions
- ✅ **Offline Support**: Works completely offline with optional sync
- ✅ **Cross-Platform**: Native binaries for Linux, macOS, and Windows
- ✅ **Git Integration**: Automatic task creation from commit messages
- ✅ **Export/Import**: Multiple format support (JSON, CSV, Markdown)
- ✅ **Templates**: Project templates for common workflows

### Technical Features
- ✅ **Fast Performance**: Rust's speed with sub-100ms startup time
- ✅ **Low Memory Usage**: Efficient memory usage under 50MB
- ✅ **Shell Completions**: Auto-completion for all major shells
- ✅ **Structured Logging**: Comprehensive logging with tracing
- ✅ **Configuration Management**: Flexible configuration system
- ✅ **Progress Indicators**: Visual progress bars for long operations
- ✅ **Error Recovery**: Graceful error handling and recovery

## Architecture

### Project Structure

```
pmcli/
├── src/
│   ├── main.rs              # CLI entry point and argument parsing
│   ├── lib.rs               # Library exports
│   ├── cli/                 # CLI command handlers
│   │   ├── mod.rs
│   │   ├── project.rs       # Project commands
│   │   ├── task.rs          # Task commands  
│   │   ├── time.rs          # Time tracking commands
│   │   ├── sync.rs          # Sync commands
│   │   ├── config.rs        # Configuration commands
│   │   └── export.rs        # Export/import commands
│   ├── core/                # Core business logic
│   │   ├── mod.rs
│   │   ├── project.rs       # Project management
│   │   ├── task.rs          # Task management
│   │   ├── timer.rs         # Time tracking
│   │   └── sync.rs          # Synchronization
│   ├── db/                  # Database layer
│   │   ├── mod.rs
│   │   ├── connection.rs    # Database connection
│   │   ├── migrations.rs    # Schema migrations
│   │   ├── models.rs        # Data models
│   │   └── queries.rs       # Database queries
│   ├── config/              # Configuration management
│   │   ├── mod.rs
│   │   └── settings.rs
│   ├── sync/                # Synchronization
│   │   ├── mod.rs
│   │   ├── client.rs        # HTTP sync client
│   │   └── conflict.rs      # Conflict resolution
│   ├── utils/               # Utilities
│   │   ├── mod.rs
│   │   ├── error.rs         # Error types
│   │   ├── time.rs          # Time utilities
│   │   └── format.rs        # Output formatting
│   └── integrations/        # External integrations
│       ├── mod.rs
│       ├── git.rs           # Git integration
│       └── editor.rs        # Editor integration
├── tests/
│   ├── unit/
│   ├── integration/
│   └── cli/
├── benches/                 # Performance benchmarks
├── scripts/                 # Build and utility scripts
├── completions/             # Shell completion files
├── docs/
├── Cargo.toml
└── README.md
```

### Database Schema

```sql
-- SQLite schema for local storage
CREATE TABLE projects (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'active',
    template TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    sync_id TEXT UNIQUE,
    last_synced DATETIME
);

CREATE TABLE tasks (
    id INTEGER PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    title TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'pending',
    priority TEXT DEFAULT 'medium',
    due_date DATETIME,
    completed_at DATETIME,
    estimated_hours REAL,
    actual_hours REAL DEFAULT 0.0,
    tags TEXT, -- JSON array
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    sync_id TEXT UNIQUE,
    last_synced DATETIME
);

CREATE TABLE time_entries (
    id INTEGER PRIMARY KEY,
    task_id INTEGER REFERENCES tasks(id),
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    duration_seconds INTEGER,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    sync_id TEXT UNIQUE,
    last_synced DATETIME
);

CREATE TABLE sync_log (
    id INTEGER PRIMARY KEY,
    operation TEXT NOT NULL,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'pending'
);

-- Indexes for performance
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_time_entries_task_id ON time_entries(task_id);
CREATE INDEX idx_sync_log_status ON sync_log(status);
```

## Implementation Examples

### Main CLI Structure

```rust
// src/main.rs
use clap::{Arg, ArgMatches, Command};
use tracing::{info, error};
use pmcli::cli::{project, task, time, config, sync};
use pmcli::utils::error::{Result, CliError};
use pmcli::config::Settings;

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize logging
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    // Load configuration
    let settings = Settings::load()?;

    // Build CLI
    let app = Command::new("pmcli")
        .version(env!("CARGO_PKG_VERSION"))
        .author("CLI Team <cli-team@company.com>")
        .about("A powerful project management CLI tool")
        .subcommand_required(true)
        .arg_required_else_help(true)
        .subcommand(project::build_command())
        .subcommand(task::build_command())
        .subcommand(time::build_command())
        .subcommand(config::build_command())
        .subcommand(sync::build_command())
        .subcommand(
            Command::new("completions")
                .about("Generate shell completions")
                .arg(
                    Arg::new("shell")
                        .help("Shell to generate completions for")
                        .required(true)
                        .value_parser(["bash", "zsh", "fish", "powershell"])
                )
        );

    let matches = app.get_matches();

    // Route to appropriate handler
    let result = match matches.subcommand() {
        Some(("project", sub_matches)) => project::handle_command(sub_matches, &settings).await,
        Some(("task", sub_matches)) => task::handle_command(sub_matches, &settings).await,
        Some(("time", sub_matches)) => time::handle_command(sub_matches, &settings).await,
        Some(("config", sub_matches)) => config::handle_command(sub_matches, &settings).await,
        Some(("sync", sub_matches)) => sync::handle_command(sub_matches, &settings).await,
        Some(("completions", sub_matches)) => handle_completions(sub_matches),
        _ => unreachable!(),
    };

    match result {
        Ok(_) => {
            info!("Command completed successfully");
            Ok(())
        }
        Err(e) => {
            error!("Command failed: {}", e);
            eprintln!("Error: {}", e);
            std::process::exit(1);
        }
    }
}

fn handle_completions(matches: &ArgMatches) -> Result<()> {
    use clap_complete::{generate, Shell};
    use std::io;
    
    let shell = matches
        .get_one::<String>("shell")
        .unwrap()
        .parse::<Shell>()
        .map_err(|e| CliError::InvalidInput(format!("Invalid shell: {}", e)))?;

    let mut app = Command::new("pmcli"); // Rebuild app for completions
    generate(shell, &mut app, "pmcli", &mut io::stdout());
    Ok(())
}
```

### Task Management Commands

```rust
// src/cli/task.rs
use clap::{Arg, ArgMatches, Command};
use tracing::{info, debug};
use crate::core::task::{TaskManager, Task, TaskFilter, Priority, Status};
use crate::config::Settings;
use crate::utils::error::{Result, CliError};
use crate::utils::format::{format_table, format_task_details};

pub fn build_command() -> Command {
    Command::new("task")
        .about("Task management commands")
        .subcommand_required(true)
        .subcommand(
            Command::new("add")
                .about("Create a new task")
                .arg(
                    Arg::new("title")
                        .short('t')
                        .long("title")
                        .help("Task title")
                        .required(true)
                        .value_name("TITLE")
                )
                .arg(
                    Arg::new("description")
                        .short('d')
                        .long("description")
                        .help("Task description")
                        .value_name("DESCRIPTION")
                )
                .arg(
                    Arg::new("priority")
                        .short('p')
                        .long("priority")
                        .help("Task priority")
                        .value_parser(["low", "medium", "high", "urgent"])
                        .default_value("medium")
                )
                .arg(
                    Arg::new("project")
                        .long("project")
                        .help("Project ID or name")
                        .value_name("PROJECT")
                )
                .arg(
                    Arg::new("due")
                        .long("due")
                        .help("Due date (YYYY-MM-DD)")
                        .value_name("DATE")
                )
                .arg(
                    Arg::new("tags")
                        .long("tags")
                        .help("Comma-separated tags")
                        .value_name("TAGS")
                )
        )
        .subcommand(
            Command::new("list")
                .about("List tasks")
                .arg(
                    Arg::new("status")
                        .short('s')
                        .long("status")
                        .help("Filter by status")
                        .value_parser(["pending", "in_progress", "completed"])
                )
                .arg(
                    Arg::new("priority")
                        .short('p')
                        .long("priority")
                        .help("Filter by priority")
                        .value_parser(["low", "medium", "high", "urgent"])
                )
                .arg(
                    Arg::new("project")
                        .long("project")
                        .help("Filter by project ID or name")
                        .value_name("PROJECT")
                )
                .arg(
                    Arg::new("assigned-to")
                        .long("assigned-to")
                        .help("Filter by assignee")
                        .value_name("USER")
                )
                .arg(
                    Arg::new("format")
                        .short('f')
                        .long("format")
                        .help("Output format")
                        .value_parser(["table", "json", "csv"])
                        .default_value("table")
                )
        )
        .subcommand(
            Command::new("show")
                .about("Show task details")
                .arg(
                    Arg::new("id")
                        .help("Task ID")
                        .required(true)
                        .value_name("ID")
                )
        )
        .subcommand(
            Command::new("complete")
                .about("Mark task as completed")
                .arg(
                    Arg::new("id")
                        .help("Task ID")
                        .required(true)
                        .value_name("ID")
                )
        )
        .subcommand(
            Command::new("start")
                .about("Start working on a task (starts timer)")
                .arg(
                    Arg::new("id")
                        .help("Task ID")
                        .required(true)
                        .value_name("ID")
                )
        )
}

pub async fn handle_command(matches: &ArgMatches, settings: &Settings) -> Result<()> {
    let task_manager = TaskManager::new(&settings.database_path).await?;

    match matches.subcommand() {
        Some(("add", sub_matches)) => handle_add_task(sub_matches, &task_manager).await,
        Some(("list", sub_matches)) => handle_list_tasks(sub_matches, &task_manager).await,
        Some(("show", sub_matches)) => handle_show_task(sub_matches, &task_manager).await,
        Some(("complete", sub_matches)) => handle_complete_task(sub_matches, &task_manager).await,
        Some(("start", sub_matches)) => handle_start_task(sub_matches, &task_manager).await,
        _ => unreachable!(),
    }
}

async fn handle_add_task(matches: &ArgMatches, task_manager: &TaskManager) -> Result<()> {
    let title = matches.get_one::<String>("title").unwrap();
    let description = matches.get_one::<String>("description").cloned();
    let priority = matches.get_one::<String>("priority").unwrap();
    let project_ref = matches.get_one::<String>("project");
    let due_date = matches.get_one::<String>("due");
    let tags = matches.get_one::<String>("tags");

    info!("Creating new task: {}", title);

    // Parse project reference
    let project_id = if let Some(proj_ref) = project_ref {
        Some(task_manager.resolve_project_reference(proj_ref).await?)
    } else {
        None
    };

    // Parse due date
    let parsed_due_date = if let Some(date_str) = due_date {
        Some(chrono::NaiveDate::parse_from_str(date_str, "%Y-%m-%d")
            .map_err(|e| CliError::InvalidInput(format!("Invalid date format: {}", e)))?
            .and_hms_opt(23, 59, 59)
            .unwrap())
    } else {
        None
    };

    // Parse tags
    let parsed_tags = if let Some(tags_str) = tags {
        tags_str.split(',').map(|s| s.trim().to_string()).collect()
    } else {
        Vec::new()
    };

    let task = Task {
        id: 0, // Will be set by database
        project_id,
        title: title.clone(),
        description,
        status: Status::Pending,
        priority: priority.parse()?,
        due_date: parsed_due_date,
        tags: parsed_tags,
        ..Default::default()
    };

    let created_task = task_manager.create_task(task).await?;
    
    println!("✅ Created task #{}: {}", created_task.id, created_task.title);
    Ok(())
}

async fn handle_list_tasks(matches: &ArgMatches, task_manager: &TaskManager) -> Result<()> {
    let filter = TaskFilter {
        status: matches.get_one::<String>("status").map(|s| s.parse()).transpose()?,
        priority: matches.get_one::<String>("priority").map(|s| s.parse()).transpose()?,
        project_id: if let Some(proj_ref) = matches.get_one::<String>("project") {
            Some(task_manager.resolve_project_reference(proj_ref).await?)
        } else {
            None
        },
        ..Default::default()
    };

    let tasks = task_manager.list_tasks(filter).await?;
    let format = matches.get_one::<String>("format").unwrap();

    match format.as_str() {
        "table" => {
            let headers = vec!["ID", "Title", "Status", "Priority", "Project", "Due"];
            let rows: Vec<Vec<String>> = tasks.iter().map(|task| {
                vec![
                    task.id.to_string(),
                    task.title.clone(),
                    task.status.to_string(),
                    task.priority.to_string(),
                    task.project_id.map(|id| id.to_string()).unwrap_or("-".to_string()),
                    task.due_date.map(|d| d.format("%Y-%m-%d").to_string()).unwrap_or("-".to_string()),
                ]
            }).collect();

            format_table(&headers, &rows);
        }
        "json" => {
            println!("{}", serde_json::to_string_pretty(&tasks)?);
        }
        "csv" => {
            println!("id,title,status,priority,project_id,due_date");
            for task in tasks {
                println!(
                    "{},{},{},{},{},{}",
                    task.id,
                    task.title,
                    task.status,
                    task.priority,
                    task.project_id.map(|id| id.to_string()).unwrap_or_default(),
                    task.due_date.map(|d| d.format("%Y-%m-%d").to_string()).unwrap_or_default()
                );
            }
        }
        _ => unreachable!(),
    }

    println!("\nTotal: {} tasks", tasks.len());
    Ok(())
}
```

### Time Tracking Implementation

```rust
// src/core/timer.rs
use chrono::{DateTime, Utc, Duration};
use serde::{Deserialize, Serialize};
use tokio::sync::RwLock;
use std::sync::Arc;
use crate::db::Database;
use crate::utils::error::{Result, CliError};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TimeEntry {
    pub id: i64,
    pub task_id: i64,
    pub start_time: DateTime<Utc>,
    pub end_time: Option<DateTime<Utc>>,
    pub duration_seconds: Option<i64>,
    pub description: Option<String>,
}

#[derive(Debug)]
pub struct Timer {
    db: Arc<Database>,
    active_entry: Arc<RwLock<Option<TimeEntry>>>,
}

impl Timer {
    pub async fn new(database_path: &str) -> Result<Self> {
        let db = Arc::new(Database::new(database_path).await?);
        let active_entry = Arc::new(RwLock::new(None));
        
        // Check for any running timers from previous session
        let running_entry = db.get_running_time_entry().await?;
        if let Some(entry) = running_entry {
            *active_entry.write().await = Some(entry);
        }
        
        Ok(Timer { db, active_entry })
    }

    pub async fn start(&self, task_id: i64, description: Option<String>) -> Result<TimeEntry> {
        // Stop any existing timer first
        self.stop().await?;

        let entry = TimeEntry {
            id: 0, // Will be set by database
            task_id,
            start_time: Utc::now(),
            end_time: None,
            duration_seconds: None,
            description,
        };

        let created_entry = self.db.create_time_entry(&entry).await?;
        *self.active_entry.write().await = Some(created_entry.clone());
        
        println!("⏰ Timer started for task #{}", task_id);
        Ok(created_entry)
    }

    pub async fn stop(&self) -> Result<Option<TimeEntry>> {
        let mut active = self.active_entry.write().await;
        
        if let Some(entry) = active.take() {
            let end_time = Utc::now();
            let duration = end_time.signed_duration_since(entry.start_time);
            
            let completed_entry = TimeEntry {
                end_time: Some(end_time),
                duration_seconds: Some(duration.num_seconds()),
                ..entry
            };

            let updated_entry = self.db.update_time_entry(&completed_entry).await?;
            
            // Update task's actual hours
            self.db.add_task_hours(updated_entry.task_id, duration.num_seconds() as f64 / 3600.0).await?;
            
            println!("⏹️  Timer stopped. Duration: {}", format_duration(duration));
            Ok(Some(updated_entry))
        } else {
            println!("No active timer to stop.");
            Ok(None)
        }
    }

    pub async fn status(&self) -> Result<Option<(TimeEntry, Duration)>> {
        let active = self.active_entry.read().await;
        
        if let Some(entry) = &*active {
            let elapsed = Utc::now().signed_duration_since(entry.start_time);
            Ok(Some((entry.clone(), elapsed)))
        } else {
            Ok(None)
        }
    }

    pub async fn report(&self, start_date: Option<DateTime<Utc>>, end_date: Option<DateTime<Utc>>) -> Result<Vec<TimeEntry>> {
        self.db.get_time_entries(start_date, end_date).await
    }
}

fn format_duration(duration: Duration) -> String {
    let hours = duration.num_hours();
    let minutes = duration.num_minutes() % 60;
    let seconds = duration.num_seconds() % 60;
    
    if hours > 0 {
        format!("{}h {}m {}s", hours, minutes, seconds)
    } else if minutes > 0 {
        format!("{}m {}s", minutes, seconds)
    } else {
        format!("{}s", seconds)
    }
}
```

### Configuration Management

```rust
// src/config/settings.rs
use config::{Config, ConfigError, Environment, File};
use serde::{Deserialize, Serialize};
use std::path::PathBuf;

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct Settings {
    pub database_path: String,
    pub sync: SyncSettings,
    pub ui: UiSettings,
    pub integrations: IntegrationSettings,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct SyncSettings {
    pub enabled: bool,
    pub endpoint: Option<String>,
    pub api_token: Option<String>,
    pub auto_sync_interval_minutes: u64,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct UiSettings {
    pub default_format: String,
    pub color_output: bool,
    pub page_size: usize,
    pub timezone: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct IntegrationSettings {
    pub git_enabled: bool,
    pub git_auto_create_tasks: bool,
    pub editor_command: Option<String>,
}

impl Settings {
    pub fn load() -> Result<Self, ConfigError> {
        let config_dir = Self::config_dir()?;
        let config_file = config_dir.join("config.toml");

        let s = Config::builder()
            // Start with default values
            .set_default("database_path", Self::default_database_path())?
            .set_default("sync.enabled", false)?
            .set_default("sync.auto_sync_interval_minutes", 30)?
            .set_default("ui.default_format", "table")?
            .set_default("ui.color_output", true)?
            .set_default("ui.page_size", 20)?
            .set_default("ui.timezone", "UTC")?
            .set_default("integrations.git_enabled", true)?
            .set_default("integrations.git_auto_create_tasks", false)?
            // Add config file if it exists
            .add_source(
                File::from(config_file)
                    .required(false)
            )
            // Add environment variables with PMCLI prefix
            .add_source(
                Environment::with_prefix("PMCLI")
                    .separator("__")
            )
            .build()?;

        s.try_deserialize()
    }

    pub fn save(&self) -> Result<(), Box<dyn std::error::Error>> {
        let config_dir = Self::config_dir()?;
        std::fs::create_dir_all(&config_dir)?;
        
        let config_file = config_dir.join("config.toml");
        let toml_string = toml::to_string_pretty(self)?;
        std::fs::write(config_file, toml_string)?;
        
        Ok(())
    }

    fn config_dir() -> Result<PathBuf, ConfigError> {
        dirs::config_dir()
            .ok_or_else(|| ConfigError::NotFound("Could not find config directory".into()))?
            .join("pmcli")
            .pipe(Ok)
    }

    fn default_database_path() -> String {
        dirs::data_dir()
            .unwrap_or_else(|| PathBuf::from("."))
            .join("pmcli")
            .join("pmcli.db")
            .to_string_lossy()
            .to_string()
    }
}
```

## Testing Strategy

### CLI Testing with assert_cmd

```rust
// tests/cli/task_commands.rs
use assert_cmd::Command;
use predicates::prelude::*;
use tempfile::tempdir;

#[test]
fn test_task_add_success() {
    let temp_dir = tempdir().unwrap();
    let db_path = temp_dir.path().join("test.db");

    let mut cmd = Command::cargo_bin("pmcli").unwrap();
    cmd.env("PMCLI__DATABASE_PATH", db_path)
        .args(&["task", "add", "--title", "Test Task", "--priority", "high"])
        .assert()
        .success()
        .stdout(predicate::str::contains("Created task"))
        .stdout(predicate::str::contains("Test Task"));
}

#[test]
fn test_task_list_format_json() {
    let temp_dir = tempdir().unwrap();
    let db_path = temp_dir.path().join("test.db");

    // First create a task
    Command::cargo_bin("pmcli").unwrap()
        .env("PMCLI__DATABASE_PATH", &db_path)
        .args(&["task", "add", "--title", "JSON Test Task"])
        .assert()
        .success();

    // Then list in JSON format
    let mut cmd = Command::cargo_bin("pmcli").unwrap();
    cmd.env("PMCLI__DATABASE_PATH", db_path)
        .args(&["task", "list", "--format", "json"])
        .assert()
        .success()
        .stdout(predicate::str::is_json())
        .stdout(predicate::str::contains("JSON Test Task"));
}

#[test]
fn test_invalid_priority_error() {
    let temp_dir = tempdir().unwrap();
    let db_path = temp_dir.path().join("test.db");

    let mut cmd = Command::cargo_bin("pmcli").unwrap();
    cmd.env("PMCLI__DATABASE_PATH", db_path)
        .args(&["task", "add", "--title", "Test", "--priority", "invalid"])
        .assert()
        .failure()
        .stderr(predicate::str::contains("invalid value 'invalid'"));
}
```

### Integration Testing

```rust
// tests/integration/timer_integration.rs
use pmcli::core::{TaskManager, Timer};
use tempfile::tempdir;
use tokio::time::{sleep, Duration};

#[tokio::test]
async fn test_timer_workflow() {
    let temp_dir = tempdir().unwrap();
    let db_path = temp_dir.path().join("test.db").to_str().unwrap().to_string();

    // Set up
    let task_manager = TaskManager::new(&db_path).await.unwrap();
    let timer = Timer::new(&db_path).await.unwrap();

    // Create a test task
    let task = task_manager.create_task(Task {
        title: "Timer Test Task".to_string(),
        ..Default::default()
    }).await.unwrap();

    // Start timer
    let entry = timer.start(task.id, Some("Testing timer".to_string())).await.unwrap();
    assert!(entry.end_time.is_none());
    assert!(entry.duration_seconds.is_none());

    // Check status
    let (active_entry, elapsed) = timer.status().await.unwrap().unwrap();
    assert_eq!(active_entry.task_id, task.id);
    assert!(elapsed.num_seconds() >= 0);

    // Sleep briefly to ensure measurable duration
    sleep(Duration::from_millis(100)).await;

    // Stop timer
    let completed_entry = timer.stop().await.unwrap().unwrap();
    assert!(completed_entry.end_time.is_some());
    assert!(completed_entry.duration_seconds.is_some());
    assert!(completed_entry.duration_seconds.unwrap() > 0);

    // Verify no active timer
    assert!(timer.status().await.unwrap().is_none());
}
```

## Performance Optimizations

### Binary Size Optimization

```toml
# Cargo.toml
[profile.release]
strip = true        # Remove debug symbols
lto = true         # Link-time optimization
codegen-units = 1  # Better optimization
panic = "abort"    # Smaller binary size
```

### Database Optimization

```rust
// src/db/connection.rs
use rusqlite::{Connection, OpenFlags};
use tokio_rusqlite::Connection as AsyncConnection;

pub async fn optimize_database(conn: &AsyncConnection) -> Result<(), rusqlite::Error> {
    conn.call(|conn| {
        // Enable WAL mode for better concurrency
        conn.execute("PRAGMA journal_mode = WAL", [])?;
        
        // Optimize for performance
        conn.execute("PRAGMA synchronous = NORMAL", [])?;
        conn.execute("PRAGMA cache_size = 10000", [])?;
        conn.execute("PRAGMA temp_store = MEMORY", [])?;
        
        // Auto-vacuum for smaller database size
        conn.execute("PRAGMA auto_vacuum = INCREMENTAL", [])?;
        
        Ok(())
    }).await
}
```

## Cross-Platform Build

### Build Script

```bash
#!/bin/bash
# scripts/cross-compile.sh

set -e

TARGETS=(
    "x86_64-unknown-linux-gnu"
    "x86_64-unknown-linux-musl"
    "x86_64-apple-darwin"
    "aarch64-apple-darwin"
    "x86_64-pc-windows-gnu"
)

VERSION=$(cargo metadata --format-version=1 | jq -r '.packages[] | select(.name == "pmcli") | .version')

echo "Building pmcli v$VERSION for multiple targets..."

for target in "${TARGETS[@]}"; do
    echo "Building for $target..."
    
    if command -v cross &> /dev/null; then
        cross build --release --target "$target"
    else
        cargo build --release --target "$target"
    fi
    
    # Create archive
    case "$target" in
        *windows*)
            archive_name="pmcli-v$VERSION-$target.zip"
            cd "target/$target/release"
            zip "../../../$archive_name" pmcli.exe
            cd "../../.."
            ;;
        *)
            archive_name="pmcli-v$VERSION-$target.tar.gz"
            cd "target/$target/release"
            tar -czf "../../../$archive_name" pmcli
            cd "../../.."
            ;;
    esac
    
    echo "Created $archive_name"
done

echo "All builds completed!"
```

## Installation and Usage

### Installation Methods

```bash
# From source
git clone https://github.com/nibzard/ospec-examples
cd pmcli
cargo install --path .

# From releases (future)
curl -L https://github.com/nibzard/ospec-examples/releases/latest/download/pmcli-linux.tar.gz | tar xz
sudo mv pmcli /usr/local/bin/

# Via Homebrew (macOS)
brew tap nibzard/tools
brew install pmcli

# Via Cargo
cargo install pmcli
```

### Shell Completions

```bash
# Generate completions for your shell
pmcli completions bash > ~/.bash_completion.d/pmcli
pmcli completions zsh > ~/.zfunc/_pmcli
pmcli completions fish > ~/.config/fish/completions/pmcli.fish
```

## Example Usage

### Basic Workflow

```bash
# Create a new project
pmcli project create --name "Website Redesign" --template web-app

# Add tasks to the project
pmcli task add --title "Design mockups" --priority high --project 1
pmcli task add --title "Implement frontend" --due 2024-06-15 --project 1

# Start working on a task (starts timer)
pmcli task start 1

# List current tasks
pmcli task list --status pending

# Complete a task (stops timer if running)
pmcli task complete 1

# View time report
pmcli time report --project 1
```

### Advanced Usage

```bash
# Export data
pmcli export --format csv --output tasks.csv --filter status=completed

# Git integration
pmcli config set integrations.git_auto_create_tasks true
# Now commits with format "fix: #123 description" auto-update task 123

# Sync with remote server
pmcli config set sync.endpoint https://api.yourcompany.com
pmcli config set sync.api_token $API_TOKEN
pmcli sync
```

This comprehensive CLI tool example demonstrates how OSpec can generate a full-featured, cross-platform command-line application with professional-grade features and performance.