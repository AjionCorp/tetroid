# Tetroid - Modular Architecture Summary

## 🏗️ System Overview

The game is built using a **modular, code-driven architecture** where each system has a single responsibility.

## 📦 Core Systems

### **1. Game (Orchestrator)**
**File**: `src/core/game.gd`
**Role**: Coordinates all systems, manages game flow
**Responsibilities**:
- Initialize all systems in correct order
- Handle phase transitions
- Route events between systems
- Manage overall game lifecycle

**Does NOT**: Handle physics, rendering details, or game logic directly

### **2. GameState (State Manager)**
**File**: `src/core/game_state.gd`
**Role**: Manages game phases, HP, scores, timers
**Responsibilities**:
- Track current phase (Deployment/Battle/Ended)
- Manage deployment timer (90 seconds)
- Track player HP and scores
- Determine win/loss conditions
- Emit state change signals

**Does NOT**: Render anything or handle input

### **3. BoardManager (Board System)**
**File**: `src/systems/board_manager.gd`
**Role**: Manages the game board and grid
**Responsibilities**:
- Create and manage 60x62 grid
- Handle block container
- Convert screen ↔ grid coordinates
- Validate placement positions
- Draw neutral line
- Manage board visuals

**Does NOT**: Handle game logic or player actions

### **4. BallPhysics (Physics System)**
**File**: `src/systems/ball_physics.gd`
**Role**: Handles all ball physics and collisions
**Responsibilities**:
- Move ball each frame
- Detect wall collisions
- Detect paddle collisions
- Detect block collisions
- Calculate bounce angles
- Handle ball respawn
- Emit collision events

**Does NOT**: Modify game state directly (uses signals)

### **5. InputSystem (Input Handler)**
**File**: `src/systems/input_system.gd`
**Role**: Handles all player input
**Responsibilities**:
- Process keyboard input
- Process controller input
- Process mouse input (future)
- Emit input events as signals
- Support multiple players

**Does NOT**: Move entities directly (emits signals)

### **6. DeploymentAI (AI System)**
**File**: `src/ai/deployment_ai.gd`
**Role**: AI block placement during deployment
**Responsibilities**:
- Place AI blocks automatically
- Timing between placements
- Position selection
- Emit placement events

**Does NOT**: Create blocks directly (emits signals)

### **7. GameHUD (UI Display)**
**File**: `src/ui/game_hud.gd`
**Role**: Display game information
**Responsibilities**:
- Show player stats (HP, score, blocks)
- Show phase and timer
- Update displays when notified
- Provide visual feedback

**Does NOT**: Handle game logic or input

## 🎮 Entities (Passive)

### **Block**
**File**: `src/entities/block.gd`
- Data container for block properties
- Visual representation
- Self-contained behavior (damage, abilities)
- Emits events when state changes

### **Ball**
**File**: `src/entities/ball.gd`
- Data container for ball properties
- Visual representation (sprite, trail)
- Movement handled by BallPhysics system

### **Paddle**
**File**: `src/entities/paddle.gd`
- Data container for paddle properties
- Visual representation
- Movement methods (called by systems)
- Collision checking

## 📊 Data Flow

```
User Input
    ↓
InputSystem (emits signals)
    ↓
Game (routes to systems)
    ↓
BoardManager / BallPhysics / GameState
    ↓
Entities (Block, Ball, Paddle)
    ↓
Entities (emit state change signals)
    ↓
Game (listens to signals)
    ↓
GameHUD (updates display)
```

## 🔄 Phase Flow

### **Deployment Phase**
```
Game.start()
    → GameState.start_deployment()
    → DeploymentAI.start_deployment()
    → Player clicks
        → Game._handle_click_placement()
        → BlockFactory.create_block()
        → BoardManager.add_block()
        → GameState.register_block_placed()
        → GameHUD.update_blocks_remaining()
```

### **Battle Phase**
```
Timer expires / All blocks placed
    → GameState._end_deployment_phase()
    → Game._on_phase_changed()
    → Game._start_battle()
        → Create Ball
        → Create BallPhysics
        → Ball moves
            → BallPhysics.update_physics()
            → Check collisions
            → Emit events
            → GameState updates
            → GameHUD updates
```

## 🎯 Why This Architecture?

### **Benefits**
✅ **Single Responsibility**: Each system does ONE thing well
✅ **Testable**: Can test systems independently
✅ **Maintainable**: Easy to find and fix bugs
✅ **Extensible**: Add new systems without breaking existing
✅ **AI-Friendly**: Clear structure for AI agents to understand
✅ **Debuggable**: Can disable/enable systems individually

### **Principles Followed**
1. **Separation of Concerns**: Logic, rendering, and data separated
2. **Event-Driven**: Systems communicate via signals
3. **Dependency Injection**: Systems receive references, not hard-coded
4. **Code-Driven**: Everything created programmatically
5. **Data-Driven**: Configuration in JSON files

## 📝 Adding New Features

### **Example: Add New Ball Type**
```
1. Add to data/balls.json
2. Update BallPhysics collision logic
3. Update Ball visual generator
Done! No changes to Game.gd needed.
```

### **Example: Add New System**
```
1. Create src/systems/new_system.gd
2. Add to Game._initialize_xxx()
3. Connect signals
4. System operates independently
```

## 🗂️ File Organization

```
src/
├── core/               # Core orchestrators
│   ├── game.gd        # Main orchestrator
│   ├── game_state.gd  # State management
│   ├── constants.gd   # Global constants
│   ├── config.gd      # Configuration
│   ├── steam_manager.gd
│   └── asset_registry.gd
│
├── systems/           # Game systems (logic)
│   ├── board_manager.gd    # Board/grid
│   ├── ball_physics.gd     # Ball physics
│   └── input_system.gd     # Input handling
│
├── entities/          # Game entities (data + visuals)
│   ├── block.gd       # Block entity
│   ├── ball.gd        # Ball entity
│   └── paddle.gd      # Paddle entity
│
├── factories/         # Entity creation
│   └── block_factory.gd
│
├── generators/        # Procedural generation
│   ├── sprite_generator.gd
│   └── audio_generator.gd
│
├── ai/               # AI systems
│   └── deployment_ai.gd
│
├── ui/               # User interface
│   ├── loading_screen.gd
│   ├── main_menu.gd
│   └── game_hud.gd
│
└── data/             # Configuration data
    ├── blocks.json
    ├── config.json
    └── block_data.gd
```

## 🎯 Current State

**Working Systems**: 12  
**Lines of Code**: ~4,000+  
**Architecture**: Fully modular ✅  
**Phase 1**: COMPLETE (Weeks 1-3) ✅  

---

**Last Updated**: 2026-01-05
**Status**: Modular Architecture Complete
