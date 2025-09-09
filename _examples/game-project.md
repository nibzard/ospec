---
layout: example
title: "2D Web Game"
description: "Interactive 2D web game with real-time multiplayer, physics, and leaderboards"
outcome_type: "game"
complexity: "advanced"
stack: "JavaScript + Phaser + Socket.io + Node.js"
tags: ["game", "phaser", "multiplayer", "websockets", "canvas"]
---

# 2D Web Game

This example demonstrates building a complete 2D web game with real-time multiplayer capabilities, physics simulation, scoring system, and persistent leaderboards.

## OSpec Document

```yaml
ospec_version: "1.0.0"
id: "space-shooter-game"
name: "Cosmic Defender - Space Shooter Game"
description: "Real-time multiplayer 2D space shooter game with physics, power-ups, and leaderboards"
outcome_type: "game"

# Game-specific configuration
game:
  title: "Cosmic Defender"
  genre: "Action/Shooter"
  platform: "Web Browser"
  target_rating: "E10+" # Everyone 10 and older
  
  # Core gameplay mechanics
  mechanics:
    - "real_time_movement"
    - "projectile_physics"
    - "collision_detection"
    - "power_up_system"
    - "scoring_system"
    - "lives_system"
    - "progressive_difficulty"
  
  # Game modes
  modes:
    - name: "single_player"
      description: "Solo campaign with progressive waves"
      max_players: 1
    - name: "multiplayer_coop"
      description: "Cooperative multiplayer up to 4 players"
      max_players: 4
    - name: "competitive"
      description: "Player vs player combat"
      max_players: 8
  
  # Visual and audio requirements
  assets:
    graphics:
      style: "pixel_art"
      resolution: "1920x1080"
      sprites: "animated"
      particles: "enabled"
      ui_theme: "sci_fi"
    
    audio:
      music: "ambient_electronic"
      sound_effects: "retro_arcade"
      spatial_audio: true
      adaptive_music: true

stack:
  frontend:
    game_engine: "Phaser.js@3.70"
    language: "JavaScript ES6+"
    bundler: "Webpack@5"
    ui_framework: "Custom Game UI"
  
  backend:
    runtime: "Node.js@18"
    framework: "Express@4"
    websockets: "Socket.io@4"
    database: "MongoDB@6"
    cache: "Redis@7"
  
  infrastructure:
    hosting: "AWS EC2"
    cdn: "CloudFront"
    load_balancer: "AWS ALB"
    monitoring: "CloudWatch"

# Game performance requirements
acceptance:
  performance:
    target_fps: 60
    min_fps: 45
    load_time_max_seconds: 5
    memory_usage_max_mb: 512
    
  gameplay:
    input_latency_max_ms: 50
    network_latency_max_ms: 100
    physics_accuracy: 99.9
    collision_detection_accuracy: 100
    
  multiplayer:
    concurrent_players_max: 1000
    rooms_max: 250  # 4 players per room
    synchronization_accuracy: 99.5
    lag_compensation_enabled: true
    
  compatibility:
    browsers: ["Chrome 90+", "Firefox 88+", "Safari 14+", "Edge 90+"]
    devices: ["Desktop", "Tablet (landscape)"]
    mobile_support: false  # Desktop/tablet focus
    
  accessibility:
    keyboard_controls: true
    gamepad_support: true
    colorblind_friendly: true
    audio_cues: true
    text_scaling: true
    
  # Content and progression
  content:
    levels_min: 20
    enemy_types_min: 8
    power_ups_min: 6
    achievements_min: 15
    unlockable_ships_min: 5

# Detailed game systems
game_systems:
  player_character:
    attributes:
      health: 100
      speed: 300  # pixels per second
      fire_rate: 5  # shots per second
      damage: 25
    
    controls:
      movement: "WASD or Arrow Keys"
      shooting: "Spacebar or Mouse Click"
      special_ability: "Shift"
      pause: "P or Escape"
    
    customization:
      ship_variants: ["Fighter", "Cruiser", "Interceptor", "Bomber"]
      color_schemes: 8
      weapon_types: ["Laser", "Plasma", "Missiles", "Energy Beam"]
  
  enemy_ai:
    behavior_patterns:
      - name: "basic_patrol"
        description: "Simple movement patterns"
      - name: "aggressive_pursuit"
        description: "Actively chase player"
      - name: "formation_flying"
        description: "Coordinated group movement"
      - name: "boss_phases"
        description: "Multi-phase boss encounters"
    
    difficulty_scaling:
      method: "progressive"
      factors: ["spawn_rate", "enemy_health", "enemy_speed", "enemy_damage"]
      scaling_curve: "exponential"
  
  physics_engine:
    gravity: 0  # Space environment
    friction: 0.95
    collision_layers: ["players", "enemies", "projectiles", "powerups", "environment"]
    physics_steps_per_second: 60
    
  power_up_system:
    types:
      - name: "health_pack"
        effect: "restore_25_health"
        duration: "instant"
        rarity: "common"
      
      - name: "rapid_fire"
        effect: "double_fire_rate"
        duration: 15  # seconds
        rarity: "uncommon"
      
      - name: "shield"
        effect: "absorb_3_hits"
        duration: 30
        rarity: "rare"
      
      - name: "multi_shot"
        effect: "shoot_5_projectiles"
        duration: 20
        rarity: "rare"
    
    spawn_mechanics:
      drop_chance: 0.15  # 15% chance on enemy death
      despawn_time: 30  # seconds if not collected

# Multiplayer architecture
multiplayer:
  networking:
    protocol: "WebSocket"
    tick_rate: 20  # updates per second
    interpolation: "client_side"
    prediction: "client_side"
    lag_compensation: "server_authoritative"
  
  synchronization:
    player_positions: "continuous"
    projectiles: "event_based"
    health_changes: "immediate"
    power_ups: "authoritative_server"
  
  anti_cheat:
    server_validation: true
    movement_bounds_checking: true
    fire_rate_limiting: true
    score_verification: true
    
  matchmaking:
    method: "skill_based"
    max_wait_time_seconds: 30
    region_preference: true
    ping_limit_ms: 150

# Progression and monetization
progression:
  experience_system:
    sources: ["enemy_kills", "level_completion", "achievements"]
    level_cap: 50
    unlocks: ["ships", "weapons", "cosmetics", "abilities"]
  
  achievements:
    categories: ["combat", "survival", "exploration", "social"]
    rewards: ["experience", "cosmetics", "titles"]
    hidden_achievements: 5
  
  leaderboards:
    types: ["high_score", "survival_time", "multiplayer_ranking"]
    reset_schedule: "weekly"
    seasons: "monthly"

# Security and data protection
security:
  user_data:
    authentication: "optional"  # Guest play allowed
    data_encryption: "AES-256"
    privacy_compliance: "GDPR"
  
  game_security:
    input_validation: "server_side"
    rate_limiting: true
    ddos_protection: true
    cheat_detection: "heuristic"

guardrails:
  content_safety:
    violence_level: "cartoon"  # No realistic violence
    language_filter: true
    user_generated_content: false
    chat_moderation: true
  
  performance_monitoring:
    fps_tracking: true
    memory_leak_detection: true
    crash_reporting: true
    user_analytics: "privacy_preserving"
  
  quality_assurance:
    automated_testing: "gameplay_scenarios"
    load_testing: "1000_concurrent_users"
    cross_browser_testing: true
    accessibility_testing: true

deployment:
  environments:
    development:
      players_max: 10
      debugging: true
      hot_reload: true
    
    staging:
      players_max: 100
      analytics: true
      load_testing: true
    
    production:
      players_max: 1000
      cdn_enabled: true
      monitoring: "full"
      backup_frequency: "daily"
  
  cdn_configuration:
    assets_cache_duration: "7 days"
    game_code_cache_duration: "1 hour"
    static_compression: "gzip + brotli"

metadata:
  development:
    team_size: 4  # 2 developers, 1 artist, 1 designer
    estimated_timeline_weeks: 16
    target_audience: "casual gamers, 13-35 years"
    similar_games: ["Asteroids", "Geometry Wars", "Space Invaders"]
  
  technical_debt:
    refactoring_budget: 20  # 20% of development time
    code_review_required: true
    documentation_coverage: 80
    test_coverage: 70
```

## Key Game Systems

### 1. Core Game Engine Setup

```javascript
// game.js - Main game configuration
import Phaser from 'phaser';
import { MainMenuScene } from './scenes/MainMenuScene.js';
import { GameScene } from './scenes/GameScene.js';
import { MultiplayerScene } from './scenes/MultiplayerScene.js';
import { UIScene } from './scenes/UIScene.js';

const config = {
    type: Phaser.AUTO,
    width: 1920,
    height: 1080,
    parent: 'game-container',
    backgroundColor: '#000011',
    
    physics: {
        default: 'arcade',
        arcade: {
            gravity: { y: 0 }, // Space environment
            debug: false,
            fps: 60
        }
    },
    
    scene: [MainMenuScene, GameScene, MultiplayerScene, UIScene],
    
    scale: {
        mode: Phaser.Scale.FIT,
        autoCenter: Phaser.Scale.CENTER_BOTH,
        min: {
            width: 800,
            height: 600
        },
        max: {
            width: 1920,
            height: 1080
        }
    },
    
    input: {
        gamepad: true,
        keyboard: true,
        mouse: true
    },
    
    audio: {
        disableWebAudio: false,
        context: false
    }
};

const game = new Phaser.Game(config);
```

### 2. Player Character System

```javascript
// Player.js - Player character class
export class Player extends Phaser.Physics.Arcade.Sprite {
    constructor(scene, x, y, texture = 'player-ship') {
        super(scene, x, y, texture);
        
        // Add to scene and physics
        scene.add.existing(this);
        scene.physics.add.existing(this);
        
        // Player properties
        this.health = 100;
        this.maxHealth = 100;
        this.speed = 300;
        this.fireRate = 200; // milliseconds between shots
        this.damage = 25;
        this.lives = 3;
        this.score = 0;
        
        // Input handling
        this.keys = scene.input.keyboard.addKeys('W,S,A,D,SPACE,SHIFT');
        this.gamepad = scene.input.gamepad.pad1;
        
        // Weapons system
        this.weapons = {
            current: 'laser',
            types: {
                laser: { damage: 25, fireRate: 200, texture: 'laser' },
                plasma: { damage: 40, fireRate: 300, texture: 'plasma' },
                missiles: { damage: 80, fireRate: 800, texture: 'missile' }
            }
        };
        
        // Power-ups tracking
        this.powerUps = {
            rapidFire: { active: false, timer: 0 },
            shield: { active: false, hits: 0, timer: 0 },
            multiShot: { active: false, timer: 0 }
        };
        
        // Visual effects
        this.thruster = scene.add.particles('thruster-particle');
        this.thrusterEmitter = this.thruster.createEmitter({
            follow: this,
            followOffset: { x: 0, y: 20 },
            speed: { min: 50, max: 100 },
            lifespan: 300,
            quantity: 2,
            scale: { start: 0.3, end: 0 }
        });
        
        this.lastFired = 0;
    }
    
    update(time, delta) {
        this.handleInput(time);
        this.updatePowerUps(delta);
        this.updateVisualEffects();
    }
    
    handleInput(time) {
        const { keys, gamepad } = this;
        
        // Movement
        this.setVelocity(0, 0);
        
        // Keyboard movement
        if (keys.A.isDown || (gamepad && gamepad.left)) {
            this.setVelocityX(-this.speed);
        }
        if (keys.D.isDown || (gamepad && gamepad.right)) {
            this.setVelocityX(this.speed);
        }
        if (keys.W.isDown || (gamepad && gamepad.up)) {
            this.setVelocityY(-this.speed);
        }
        if (keys.S.isDown || (gamepad && gamepad.down)) {
            this.setVelocityY(this.speed);
        }
        
        // Shooting
        if ((keys.SPACE.isDown || (gamepad && gamepad.A)) && 
            time > this.lastFired + this.getCurrentFireRate()) {
            this.shoot(time);
        }
        
        // Special ability
        if (keys.SHIFT.isDown || (gamepad && gamepad.B)) {
            this.useSpecialAbility();
        }
    }
    
    shoot(time) {
        const weapon = this.weapons.types[this.weapons.current];
        
        if (this.powerUps.multiShot.active) {
            // Shoot 5 projectiles in a spread
            for (let i = -2; i <= 2; i++) {
                this.createProjectile(weapon, i * 10); // 10-degree spread
            }
        } else {
            this.createProjectile(weapon, 0);
        }
        
        this.lastFired = time;
        
        // Play sound effect
        this.scene.sound.play('laser-sound', { volume: 0.5 });
    }
    
    createProjectile(weapon, angleOffset = 0) {
        const projectile = this.scene.physics.add.sprite(
            this.x, 
            this.y - 30, 
            weapon.texture
        );
        
        projectile.setRotation(this.rotation + Phaser.Math.DegToRad(angleOffset));
        projectile.damage = weapon.damage;
        
        // Set velocity based on rotation
        this.scene.physics.velocityFromRotation(
            projectile.rotation, 
            600, 
            projectile.body.velocity
        );
        
        // Add to projectiles group
        this.scene.playerProjectiles.add(projectile);
        
        // Auto-destroy after 2 seconds
        this.scene.time.delayedCall(2000, () => {
            if (projectile.active) {
                projectile.destroy();
            }
        });
    }
    
    takeDamage(damage) {
        if (this.powerUps.shield.active) {
            this.powerUps.shield.hits--;
            if (this.powerUps.shield.hits <= 0) {
                this.deactivatePowerUp('shield');
            }
            return;
        }
        
        this.health -= damage;
        
        // Visual feedback
        this.scene.cameras.main.shake(100, 0.02);
        this.setTint(0xff0000);
        this.scene.time.delayedCall(100, () => this.clearTint());
        
        if (this.health <= 0) {
            this.die();
        }
        
        // Update UI
        this.scene.events.emit('player-health-changed', this.health, this.maxHealth);
    }
    
    die() {
        this.lives--;
        
        // Death animation
        this.scene.add.particles('explosion-particle')
            .createEmitter({
                x: this.x,
                y: this.y,
                speed: { min: 100, max: 200 },
                quantity: 20,
                lifespan: 500
            });
        
        this.scene.sound.play('explosion-sound');
        
        if (this.lives > 0) {
            // Respawn after delay
            this.setPosition(this.scene.cameras.main.width / 2, this.scene.cameras.main.height - 100);
            this.health = this.maxHealth;
            this.setVisible(false);
            
            this.scene.time.delayedCall(2000, () => {
                this.setVisible(true);
                this.setTint(0x00ff00); // Invincibility indicator
                this.scene.time.delayedCall(3000, () => this.clearTint());
            });
        } else {
            // Game over
            this.scene.events.emit('game-over', this.score);
            this.destroy();
        }
    }
    
    getCurrentFireRate() {
        return this.powerUps.rapidFire.active ? 
            this.fireRate / 2 : 
            this.fireRate;
    }
    
    activatePowerUp(type, duration) {
        const powerUp = this.powerUps[type];
        if (!powerUp) return;
        
        powerUp.active = true;
        powerUp.timer = duration * 1000; // Convert to milliseconds
        
        switch (type) {
            case 'shield':
                powerUp.hits = 3;
                this.setTint(0x00ffff);
                break;
            case 'rapidFire':
                this.setTint(0xffff00);
                break;
            case 'multiShot':
                this.setTint(0xff00ff);
                break;
        }
        
        this.scene.events.emit('powerup-activated', type, duration);
    }
    
    updatePowerUps(delta) {
        Object.keys(this.powerUps).forEach(type => {
            const powerUp = this.powerUps[type];
            if (powerUp.active) {
                powerUp.timer -= delta;
                if (powerUp.timer <= 0) {
                    this.deactivatePowerUp(type);
                }
            }
        });
    }
    
    deactivatePowerUp(type) {
        const powerUp = this.powerUps[type];
        powerUp.active = false;
        powerUp.timer = 0;
        
        this.clearTint();
        this.scene.events.emit('powerup-deactivated', type);
    }
}
```

### 3. Enemy AI System

```javascript
// Enemy.js - Enemy AI system
export class Enemy extends Phaser.Physics.Arcade.Sprite {
    constructor(scene, x, y, type = 'basic') {
        super(scene, x, y, `enemy-${type}`);
        
        scene.add.existing(this);
        scene.physics.add.existing(this);
        
        this.type = type;
        this.setupEnemyType(type);
        
        this.target = null;
        this.behavior = 'patrol';
        this.lastShot = 0;
        this.waypoints = [];
        this.currentWaypoint = 0;
        
        // AI state machine
        this.state = 'spawning';
        this.stateTimer = 0;
        
        this.setupBehavior();
    }
    
    setupEnemyType(type) {
        const types = {
            basic: {
                health: 50,
                speed: 150,
                damage: 15,
                fireRate: 1000,
                points: 100,
                behavior: 'patrol'
            },
            aggressive: {
                health: 75,
                speed: 200,
                damage: 20,
                fireRate: 800,
                points: 150,
                behavior: 'chase'
            },
            heavy: {
                health: 150,
                speed: 100,
                damage: 30,
                fireRate: 1500,
                points: 300,
                behavior: 'formation'
            },
            boss: {
                health: 500,
                speed: 80,
                damage: 50,
                fireRate: 500,
                points: 1000,
                behavior: 'boss_pattern'
            }
        };
        
        const config = types[type] || types.basic;
        Object.assign(this, config);
        this.maxHealth = this.health;
    }
    
    update(time, delta) {
        this.updateAI(time, delta);
        this.updateState(delta);
        this.updateVisuals();
    }
    
    updateAI(time, delta) {
        switch (this.behavior) {
            case 'patrol':
                this.patrolBehavior();
                break;
            case 'chase':
                this.chaseBehavior();
                break;
            case 'formation':
                this.formationBehavior();
                break;
            case 'boss_pattern':
                this.bossBehavior(time);
                break;
        }
        
        // Shooting AI
        if (time > this.lastShot + this.fireRate && this.canShoot()) {
            this.shoot(time);
        }
    }
    
    patrolBehavior() {
        // Simple back-and-forth movement
        if (this.waypoints.length === 0) {
            this.waypoints = [
                { x: this.x - 100, y: this.y },
                { x: this.x + 100, y: this.y }
            ];
        }
        
        this.moveToWaypoint();
    }
    
    chaseBehavior() {
        if (!this.target) {
            this.target = this.scene.player;
        }
        
        if (this.target && this.target.active) {
            // Move towards player
            this.scene.physics.moveToObject(this, this.target, this.speed);
            
            // Face the target
            this.rotation = Phaser.Math.Angle.Between(
                this.x, this.y, 
                this.target.x, this.target.y
            ) + Math.PI / 2;
        }
    }
    
    formationBehavior() {
        // Maintain formation with other enemies
        const formation = this.scene.enemyFormations.get(this.formationId);
        if (formation) {
            const targetPos = formation.getPositionFor(this);
            this.scene.physics.moveTo(this, targetPos.x, targetPos.y, this.speed);
        }
    }
    
    bossBehavior(time) {
        // Multi-phase boss behavior
        const phase = Math.floor(this.health / this.maxHealth * 3) + 1;
        
        switch (phase) {
            case 1: // High health - slow, predictable
                this.patrolBehavior();
                break;
            case 2: // Medium health - more aggressive
                this.chaseBehavior();
                this.fireRate = 300; // Faster shooting
                break;
            case 3: // Low health - erratic movement
                this.erraticMovement();
                this.fireRate = 200; // Very fast shooting
                break;
        }
    }
    
    shoot(time) {
        let targetAngle = 0;
        
        if (this.target && this.target.active) {
            targetAngle = Phaser.Math.Angle.Between(
                this.x, this.y,
                this.target.x, this.target.y
            );
        }
        
        const projectile = this.scene.physics.add.sprite(
            this.x, 
            this.y + 20, 
            'enemy-projectile'
        );
        
        projectile.setRotation(targetAngle + Math.PI / 2);
        projectile.damage = this.damage;
        
        this.scene.physics.velocityFromRotation(
            targetAngle, 
            300, 
            projectile.body.velocity
        );
        
        this.scene.enemyProjectiles.add(projectile);
        
        // Auto-destroy after 3 seconds
        this.scene.time.delayedCall(3000, () => {
            if (projectile.active) {
                projectile.destroy();
            }
        });
        
        this.lastShot = time;
        this.scene.sound.play('enemy-shoot', { volume: 0.3 });
    }
    
    takeDamage(damage) {
        this.health -= damage;
        
        // Visual feedback
        this.setTint(0xff0000);
        this.scene.time.delayedCall(50, () => this.clearTint());
        
        // Health bar update
        if (this.healthBar) {
            this.healthBar.setScale(this.health / this.maxHealth, 1);
        }
        
        if (this.health <= 0) {
            this.die();
        }
    }
    
    die() {
        // Death effects
        this.scene.add.particles('enemy-explosion')
            .createEmitter({
                x: this.x,
                y: this.y,
                speed: { min: 50, max: 150 },
                quantity: 15,
                lifespan: 300
            });
        
        this.scene.sound.play('enemy-death');
        
        // Award points
        this.scene.events.emit('enemy-killed', this.points);
        
        // Chance to drop power-up
        if (Math.random() < 0.15) { // 15% chance
            this.scene.spawnPowerUp(this.x, this.y);
        }
        
        this.destroy();
    }
}
```

### 4. Multiplayer Networking

```javascript
// MultiplayerManager.js - Real-time multiplayer system
import io from 'socket.io-client';

export class MultiplayerManager {
    constructor(scene) {
        this.scene = scene;
        this.socket = null;
        this.players = new Map();
        this.interpolationBuffer = [];
        this.serverTick = 0;
        this.clientTick = 0;
        this.ping = 0;
        
        this.predictionEnabled = true;
        this.interpolationEnabled = true;
    }
    
    connect(serverUrl) {
        this.socket = io(serverUrl, {
            transports: ['websocket']
        });
        
        this.setupEventHandlers();
    }
    
    setupEventHandlers() {
        this.socket.on('connect', () => {
            console.log('Connected to game server');
            this.scene.events.emit('multiplayer-connected');
        });
        
        this.socket.on('player-joined', (data) => {
            this.createRemotePlayer(data);
        });
        
        this.socket.on('player-left', (playerId) => {
            this.removeRemotePlayer(playerId);
        });
        
        this.socket.on('game-state', (state) => {
            this.handleServerUpdate(state);
        });
        
        this.socket.on('player-input', (data) => {
            this.handleRemoteInput(data);
        });
        
        this.socket.on('projectile-fired', (data) => {
            this.handleRemoteProjectile(data);
        });
        
        this.socket.on('player-hit', (data) => {
            this.handlePlayerHit(data);
        });
        
        this.socket.on('ping-response', (timestamp) => {
            this.ping = Date.now() - timestamp;
        });
        
        // Regular ping to measure latency
        setInterval(() => {
            this.socket.emit('ping', Date.now());
        }, 1000);
    }
    
    sendPlayerInput(input) {
        if (!this.socket || !this.socket.connected) return;
        
        const inputData = {
            tick: this.clientTick++,
            timestamp: Date.now(),
            playerId: this.socket.id,
            input: input,
            position: { x: this.scene.player.x, y: this.scene.player.y },
            rotation: this.scene.player.rotation
        };
        
        this.socket.emit('player-input', inputData);
        
        // Client-side prediction
        if (this.predictionEnabled) {
            this.applyInput(this.scene.player, input);
        }
    }
    
    handleServerUpdate(state) {
        this.serverTick = state.tick;
        
        // Add to interpolation buffer
        if (this.interpolationEnabled) {
            this.interpolationBuffer.push({
                timestamp: Date.now(),
                state: state
            });
            
            // Keep only last 200ms of states
            this.interpolationBuffer = this.interpolationBuffer.filter(
                entry => Date.now() - entry.timestamp < 200
            );
        }
        
        // Update remote players
        Object.entries(state.players).forEach(([playerId, playerState]) => {
            if (playerId !== this.socket.id) {
                this.updateRemotePlayer(playerId, playerState);
            } else {
                // Server reconciliation for local player
                this.reconcileLocalPlayer(playerState);
            }
        });
        
        // Update game objects
        this.updateGameObjects(state.gameObjects);
    }
    
    updateRemotePlayer(playerId, playerState) {
        let player = this.players.get(playerId);
        
        if (!player) {
            player = this.createRemotePlayer({ id: playerId, ...playerState });
            this.players.set(playerId, player);
        }
        
        if (this.interpolationEnabled) {
            // Smooth interpolation to server position
            this.scene.tweens.add({
                targets: player,
                x: playerState.x,
                y: playerState.y,
                rotation: playerState.rotation,
                duration: 50, // 50ms interpolation
                ease: 'Linear'
            });
        } else {
            // Direct update
            player.setPosition(playerState.x, playerState.y);
            player.setRotation(playerState.rotation);
        }
        
        // Update visual state
        player.health = playerState.health;
        player.setTint(playerState.tint);
    }
    
    reconcileLocalPlayer(serverState) {
        const player = this.scene.player;
        
        // Check if server position differs significantly from client
        const positionError = Phaser.Math.Distance.Between(
            player.x, player.y,
            serverState.x, serverState.y
        );
        
        if (positionError > 50) { // 50 pixel threshold
            console.log('Server reconciliation triggered');
            
            // Snap to server position
            player.setPosition(serverState.x, serverState.y);
            
            // Re-apply any inputs that happened after server timestamp
            // (This would require storing input history)
        }
        
        // Always trust server for health/game state
        player.health = serverState.health;
        player.score = serverState.score;
    }
    
    createRemotePlayer(data) {
        const sprite = this.scene.add.sprite(data.x, data.y, 'player-ship');
        sprite.playerId = data.id;
        sprite.health = data.health || 100;
        
        // Add name tag
        const nameText = this.scene.add.text(
            sprite.x, sprite.y - 30,
            data.name || `Player ${data.id.slice(-4)}`,
            {
                fontSize: '14px',
                fill: '#ffffff',
                stroke: '#000000',
                strokeThickness: 2
            }
        );
        
        sprite.nameTag = nameText;
        
        return sprite;
    }
    
    removeRemotePlayer(playerId) {
        const player = this.players.get(playerId);
        if (player) {
            if (player.nameTag) player.nameTag.destroy();
            player.destroy();
            this.players.delete(playerId);
        }
    }
    
    sendProjectileFired(projectileData) {
        if (!this.socket) return;
        
        this.socket.emit('projectile-fired', {
            playerId: this.socket.id,
            timestamp: Date.now(),
            ...projectileData
        });
    }
    
    handleRemoteProjectile(data) {
        // Create projectile from remote player
        const projectile = this.scene.physics.add.sprite(
            data.x, data.y, data.texture
        );
        
        projectile.setRotation(data.rotation);
        projectile.damage = data.damage;
        projectile.ownerId = data.playerId;
        
        this.scene.physics.velocityFromRotation(
            data.rotation, data.velocity, projectile.body.velocity
        );
        
        this.scene.allProjectiles.add(projectile);
    }
    
    sendPlayerHit(targetId, damage) {
        if (!this.socket) return;
        
        this.socket.emit('player-hit', {
            shooterId: this.socket.id,
            targetId: targetId,
            damage: damage,
            timestamp: Date.now()
        });
    }
    
    handlePlayerHit(data) {
        // Apply damage to local player if we're the target
        if (data.targetId === this.socket.id) {
            this.scene.player.takeDamage(data.damage);
        }
        
        // Visual effects for all players
        const targetPlayer = this.players.get(data.targetId) || 
                           (data.targetId === this.socket.id ? this.scene.player : null);
        
        if (targetPlayer) {
            // Hit effect
            targetPlayer.setTint(0xff0000);
            this.scene.time.delayedCall(100, () => targetPlayer.clearTint());
        }
    }
    
    disconnect() {
        if (this.socket) {
            this.socket.disconnect();
            this.socket = null;
        }
        
        // Clean up remote players
        this.players.forEach(player => {
            if (player.nameTag) player.nameTag.destroy();
            player.destroy();
        });
        this.players.clear();
    }
}
```

### 5. Game Server (Node.js)

```javascript
// server.js - Multiplayer game server
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const GameRoom = require('./GameRoom');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

const gameRooms = new Map();
const waitingPlayers = [];

io.on('connection', (socket) => {
    console.log(`Player ${socket.id} connected`);
    
    socket.on('join-game', (data) => {
        const room = findOrCreateRoom(data.gameMode, data.maxPlayers);
        room.addPlayer(socket, data);
    });
    
    socket.on('player-input', (data) => {
        const room = gameRooms.get(socket.roomId);
        if (room) {
            room.handlePlayerInput(socket.id, data);
        }
    });
    
    socket.on('projectile-fired', (data) => {
        const room = gameRooms.get(socket.roomId);
        if (room) {
            room.handleProjectileFired(socket.id, data);
        }
    });
    
    socket.on('player-hit', (data) => {
        const room = gameRooms.get(socket.roomId);
        if (room) {
            room.handlePlayerHit(data);
        }
    });
    
    socket.on('ping', (timestamp) => {
        socket.emit('ping-response', timestamp);
    });
    
    socket.on('disconnect', () => {
        console.log(`Player ${socket.id} disconnected`);
        const room = gameRooms.get(socket.roomId);
        if (room) {
            room.removePlayer(socket.id);
            
            // Remove empty rooms
            if (room.players.size === 0) {
                gameRooms.delete(socket.roomId);
            }
        }
    });
});

function findOrCreateRoom(gameMode, maxPlayers) {
    // Find existing room with space
    for (let room of gameRooms.values()) {
        if (room.gameMode === gameMode && 
            room.players.size < maxPlayers && 
            room.state === 'waiting') {
            return room;
        }
    }
    
    // Create new room
    const roomId = generateRoomId();
    const room = new GameRoom(roomId, gameMode, maxPlayers, io);
    gameRooms.set(roomId, room);
    
    return room;
}

function generateRoomId() {
    return Math.random().toString(36).substring(2, 8).toUpperCase();
}

const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
    console.log(`Game server running on port ${PORT}`);
});
```

## Project Structure

```
space-shooter-game/
├── client/
│   ├── src/
│   │   ├── scenes/
│   │   │   ├── MainMenuScene.js
│   │   │   ├── GameScene.js
│   │   │   ├── MultiplayerScene.js
│   │   │   └── UIScene.js
│   │   ├── entities/
│   │   │   ├── Player.js
│   │   │   ├── Enemy.js
│   │   │   └── PowerUp.js
│   │   ├── systems/
│   │   │   ├── MultiplayerManager.js
│   │   │   ├── AudioManager.js
│   │   │   └── InputManager.js
│   │   ├── assets/
│   │   │   ├── sprites/
│   │   │   ├── audio/
│   │   │   └── particles/
│   │   └── index.js
│   ├── public/
│   │   └── index.html
│   └── webpack.config.js
├── server/
│   ├── GameRoom.js
│   ├── GameState.js
│   ├── CollisionSystem.js
│   └── server.js
├── shared/
│   ├── GameConstants.js
│   └── GameMath.js
└── package.json
```

## Benefits

### For Players
- **Smooth gameplay** with high frame rates and responsive controls
- **Multiplayer fun** with real-time cooperative and competitive modes
- **Progressive challenge** with adaptive difficulty scaling
- **Persistent progress** with achievements and leaderboards

### For Developers
- **Modular architecture** makes adding features easier
- **Real-time networking** handles latency and synchronization
- **Scalable server** supports many concurrent rooms
- **Rich tooling** for debugging and performance monitoring

## Advanced Features

### Achievement System

```javascript
// AchievementSystem.js
export class AchievementSystem {
    constructor(scene) {
        this.scene = scene;
        this.achievements = new Map();
        this.loadAchievements();
    }
    
    loadAchievements() {
        const achievements = [
            {
                id: 'first_kill',
                name: 'First Blood',
                description: 'Destroy your first enemy',
                condition: (stats) => stats.enemiesKilled >= 1,
                reward: { type: 'experience', amount: 100 }
            },
            {
                id: 'survivor',
                name: 'Survivor',
                description: 'Survive for 5 minutes without dying',
                condition: (stats) => stats.survivalTime >= 300000,
                reward: { type: 'ship_unlock', ship: 'interceptor' }
            },
            // ... more achievements
        ];
        
        achievements.forEach(achievement => {
            this.achievements.set(achievement.id, {
                ...achievement,
                unlocked: this.isUnlocked(achievement.id),
                progress: 0
            });
        });
    }
    
    checkAchievements(stats) {
        this.achievements.forEach((achievement, id) => {
            if (!achievement.unlocked && achievement.condition(stats)) {
                this.unlockAchievement(id);
            }
        });
    }
    
    unlockAchievement(id) {
        const achievement = this.achievements.get(id);
        if (achievement) {
            achievement.unlocked = true;
            this.scene.events.emit('achievement-unlocked', achievement);
            this.saveProgress();
        }
    }
}
```

## Related Examples

- [API Service →](/examples/api-service/) - Game backend APIs
- [Mobile App →](/examples/mobile-app/) - Mobile game development
- [Real-time Chat →](/cookbook/patterns/) - WebSocket patterns

## Next Steps

1. **Mobile version** - Adapt for touch controls and mobile performance
2. **Tournament system** - Organized competitive events
3. **Level editor** - User-generated content tools
4. **3D graphics** - Upgrade to 3D using Three.js or Babylon.js
5. **VR support** - Virtual reality game modes