# Coding Standards & Best Practices

## 🎯 Purpose

This document defines the coding standards for the Tetroid project. All agents must follow these guidelines to maintain code quality, consistency, and maintainability.

## 🗂️ Project Structure

### Directory Organization

```
Tetroid/
├── .template/                 # Template documentation (READ-ONLY)
├── src/                       # Source code
│   ├── core/                  # Core engine systems
│   │   ├── engine.gd         # Main engine loop
│   │   ├── game_state.gd     # Game state management
│   │   └── constants.gd      # Global constants
│   │
│   ├── gameplay/              # Game mechanics
│   │   ├── blocks/           # Block system
│   │   │   ├── block.gd
│   │   │   ├── block_abilities.gd
│   │   │   └── block_factory.gd
│   │   ├── ball/             # Ball physics
│   │   ├── paddle/           # Paddle system
│   │   └── rules/            # Game rules
│   │
│   ├── multiplayer/          # Networking
│   │   ├── client.gd         # Client connection
│   │   ├── server.gd         # Server logic
│   │   ├── netcode.gd        # Synchronization
│   │   └── protocol.gd       # Network protocol
│   │
│   ├── ai/                   # AI opponents
│   │   ├── ai_controller.gd  # Main AI logic
│   │   ├── behavior_tree.gd  # Decision making
│   │   └── difficulty.gd     # Difficulty scaling
│   │
│   ├── ui/                   # User interface
│   │   ├── menus/            # Menu screens
│   │   ├── hud/              # In-game HUD
│   │   └── components/       # Reusable UI components
│   │
│   ├── rendering/            # Graphics
│   │   ├── sprite_manager.gd
│   │   ├── vfx/              # Visual effects
│   │   └── animations/       # Animation system
│   │
│   ├── audio/                # Sound
│   │   ├── audio_manager.gd
│   │   ├── music_player.gd
│   │   └── sfx_pool.gd
│   │
│   └── steam/                # Platform integration
│       ├── steam_api.gd
│       ├── achievements.gd
│       └── leaderboards.gd
│
├── tests/                    # Test suites
│   ├── unit/                 # Unit tests
│   ├── integration/          # Integration tests
│   └── performance/          # Performance tests
│
├── assets/                   # Game assets
│   ├── sprites/              # Images
│   ├── audio/                # Sounds & music
│   ├── fonts/                # Typography
│   └── shaders/              # Shader files
│
├── tools/                    # Development tools
│   ├── build/                # Build scripts
│   ├── generators/           # Code generators
│   └── validators/           # Asset validators
│
└── config/                   # Configuration files
    ├── game_config.json      # Game settings
    ├── balance.json          # Balance values
    └── network_config.json   # Network settings
```

## 📝 Naming Conventions

### Files & Directories

**Rules**:
- Use `snake_case` for files: `block_manager.gd`, `game_state.py`
- Use lowercase for directories: `gameplay/`, `networking/`
- Be descriptive: `player_input_handler.gd` not `pih.gd`

**Examples**:
```
✓ Good:
  - src/gameplay/blocks/block_abilities.gd
  - src/multiplayer/network_protocol.gd
  - tests/unit/test_ball_physics.gd

✗ Bad:
  - src/GamePlay/Blocks/BlockAbilities.gd
  - src/multiplayer/netProto.gd
  - tests/unit/testBallPhys.gd
```

### Classes

**GDScript**:
```gdscript
# PascalCase for classes
class_name BlockAbility
class_name NetworkClient
class_name GameStateManager
```

**Python**:
```python
# PascalCase for classes
class BlockAbility:
class NetworkClient:
class GameStateManager:
```

### Functions & Methods

**GDScript**:
```gdscript
# snake_case for functions
func calculate_damage(base_damage: int, multiplier: float) -> int:
    return int(base_damage * multiplier)

func get_block_at_position(position: Vector2) -> Block:
    return board_state.get_block(position)

# Private functions prefixed with underscore
func _internal_update():
    pass
```

**Python**:
```python
# snake_case for functions
def calculate_damage(base_damage: int, multiplier: float) -> int:
    return int(base_damage * multiplier)

def get_block_at_position(position: Vector2) -> Block:
    return self.board_state.get_block(position)

# Private methods with underscore
def _internal_update(self):
    pass
```

### Variables

**GDScript**:
```gdscript
# snake_case for variables
var player_health: int = 100
var current_velocity: Vector2 = Vector2.ZERO
var is_game_over: bool = false

# Constants in SCREAMING_SNAKE_CASE
const MAX_PLAYERS: int = 4
const DEFAULT_HP: int = 100
const BALL_SPEED_MULTIPLIER: float = 1.5

# Private variables with underscore
var _internal_state: int = 0
```

**Python**:
```python
# snake_case for variables
player_health: int = 100
current_velocity: Vector2 = Vector2(0, 0)
is_game_over: bool = False

# Constants in SCREAMING_SNAKE_CASE
MAX_PLAYERS: int = 4
DEFAULT_HP: int = 100
BALL_SPEED_MULTIPLIER: float = 1.5

# Private variables with underscore
_internal_state: int = 0
```

### Enums

**GDScript**:
```gdscript
enum PieceType {
    I_PIECE,
    O_PIECE,
    T_PIECE,
    S_PIECE,
    Z_PIECE,
    J_PIECE,
    L_PIECE
}

enum GameMode {
    ONE_VS_ONE,
    TWO_VS_TWO,
    FREE_FOR_ALL
}
```

**Python**:
```python
from enum import Enum, auto

class PieceType(Enum):
    I_PIECE = auto()
    O_PIECE = auto()
    T_PIECE = auto()
    S_PIECE = auto()
    Z_PIECE = auto()
    J_PIECE = auto()
    L_PIECE = auto()

class GameMode(Enum):
    ONE_VS_ONE = auto()
    TWO_VS_TWO = auto()
    FREE_FOR_ALL = auto()
```

## 💬 Code Comments

### When to Comment

**DO comment**:
- Complex algorithms
- Non-obvious behavior
- Workarounds for bugs
- Performance-critical sections
- Public API functions
- Game design decisions

**DON'T comment**:
- Obvious code
- What code does (code should be self-documenting)
- Outdated information

### Comment Styles

**Function documentation (GDScript)**:
```gdscript
## Calculates the damage dealt by a ball hit.
##
## Takes into account ball speed, type, and any active modifiers.
## Damage is capped at MAX_DAMAGE constant.
##
## @param ball: The ball entity that hit
## @param target: The block being hit
## @return: Final damage amount to apply
func calculate_ball_damage(ball: Ball, target: Block) -> int:
    var base_damage = ball.damage
    var speed_bonus = ball.velocity.length() * SPEED_DAMAGE_MULTIPLIER
    var type_modifier = _get_type_modifier(ball.type, target.type)
    
    var total_damage = (base_damage + speed_bonus) * type_modifier
    return min(total_damage, MAX_DAMAGE)
```

**Inline comments**:
```gdscript
# Good: Explains WHY
# Use binary search here because block list is sorted by X position
var index = _binary_search_blocks(position.x)

# Bad: Explains WHAT (obvious)
# Set index to result of binary search
var index = _binary_search_blocks(position.x)
```

**TODO comments**:
```gdscript
# TODO(gameplay-agent): Implement special ball types
# TODO(network-agent): Add lag compensation for paddle
# FIXME(audio-agent): Audio occasionally cuts out on Linux
# HACK: Temporary workaround until physics engine is fixed
# NOTE: This must run before network sync
```

## 🏗️ Code Organization

### Function Length

**Target**: 20-50 lines per function
**Maximum**: 100 lines (refactor if longer)

```gdscript
# Good: Small, focused function
func apply_damage_to_block(block: Block, damage: int) -> void:
    block.current_hp -= damage
    _trigger_hit_effect(block)
    
    if block.current_hp <= 0:
        _destroy_block(block)

# Bad: Too long, does too much
func update_game_state(delta: float) -> void:
    # 200 lines of mixed concerns
    # Should be split into multiple functions
```

### Class Size

**Target**: 200-400 lines per class
**Maximum**: 600 lines (split if larger)

**When to split**:
- Class has multiple responsibilities
- Hard to name the class
- Many private helper functions
- Team members confused by it

### Single Responsibility Principle

Each class/function should do ONE thing:

```gdscript
# Good: Each class has single responsibility
class_name BlockPlacementValidator
    func can_place_block(block: Block, position: Vector2) -> bool

class_name BlockRenderer
    func render_block(block: Block) -> void

class_name BlockAbilityManager
    func activate_ability(block: Block) -> void

# Bad: God class doing everything
class_name BlockManager
    func can_place_block()
    func render_block()
    func activate_ability()
    func check_collision()
    func play_sound()
    func update_network()
    # ... 50 more functions
```

## 🎯 Error Handling

### Always Handle Errors

**GDScript**:
```gdscript
# Good: Proper error handling
func get_player_by_id(player_id: int) -> Player:
    if player_id < 0 or player_id >= players.size():
        push_error("Invalid player_id: %d" % player_id)
        return null
    
    var player = players[player_id]
    if not is_instance_valid(player):
        push_error("Player %d is no longer valid" % player_id)
        return null
    
    return player

# Bad: No error checking
func get_player_by_id(player_id: int) -> Player:
    return players[player_id]  # Crashes if invalid
```

**Python**:
```python
# Good: Use exceptions properly
def get_player_by_id(player_id: int) -> Player:
    if player_id < 0 or player_id >= len(self.players):
        raise ValueError(f"Invalid player_id: {player_id}")
    
    player = self.players[player_id]
    if not player:
        raise RuntimeError(f"Player {player_id} is None")
    
    return player

# Bad: Silently fail
def get_player_by_id(player_id: int) -> Player:
    try:
        return self.players[player_id]
    except:
        pass  # Never do this!
```

### Error Messages

```gdscript
# Good: Descriptive error messages
push_error("Failed to place block at (%d, %d): Position occupied by block ID %d" % [x, y, existing_block.id])

# Bad: Vague error messages
push_error("Error")
push_error("Can't place")
```

## ⚡ Performance Best Practices

### Object Pooling

```gdscript
# Good: Reuse objects
class_name BallPool

var _inactive_balls: Array = []
var _active_balls: Array = []

func get_ball() -> Ball:
    var ball: Ball
    if _inactive_balls.is_empty():
        ball = _create_new_ball()
    else:
        ball = _inactive_balls.pop_back()
    
    ball.reset()
    _active_balls.append(ball)
    return ball

func return_ball(ball: Ball) -> void:
    _active_balls.erase(ball)
    _inactive_balls.append(ball)
    ball.hide()

# Bad: Create new objects every frame
func spawn_ball() -> Ball:
    return Ball.new()  # Memory allocation every call
```

### Avoid in Loops

```gdscript
# Good: Cache outside loop
func update_all_blocks(delta: float) -> void:
    var player_position = player.global_position  # Cache once
    
    for block in blocks:
        var distance = block.global_position.distance_to(player_position)
        if distance < INTERACTION_RANGE:
            block.update(delta)

# Bad: Recalculate every iteration
func update_all_blocks(delta: float) -> void:
    for block in blocks:
        # This calls player.global_position 100+ times!
        var distance = block.global_position.distance_to(player.global_position)
        if distance < INTERACTION_RANGE:
            block.update(delta)
```

### Early Returns

```gdscript
# Good: Exit early
func process_input(event: InputEvent) -> void:
    if not is_game_active:
        return
    
    if not event is InputEventKey:
        return
    
    if event.is_action_pressed("move_left"):
        move_paddle_left()
    elif event.is_action_pressed("move_right"):
        move_paddle_right()

# Bad: Nested conditions
func process_input(event: InputEvent) -> void:
    if is_game_active:
        if event is InputEventKey:
            if event.is_action_pressed("move_left"):
                move_paddle_left()
            elif event.is_action_pressed("move_right"):
                move_paddle_right()
```

## 🧪 Testing Standards

### Test Coverage

**Minimum coverage**:
- Core gameplay: 90%
- Networking: 85%
- UI: 70%
- Utilities: 95%

### Test Naming

```gdscript
# Good: Descriptive test names
func test_ball_bounces_off_paddle_correctly():
func test_block_ability_activates_on_hit():
func test_network_sync_handles_packet_loss():

# Bad: Vague test names
func test1():
func test_blocks():
func test_stuff():
```

### Test Structure (AAA Pattern)

```gdscript
func test_block_takes_damage_from_ball():
    # Arrange
    var block = Block.new()
    block.hp = 50
    var ball = Ball.new()
    ball.damage = 10
    
    # Act
    block.take_damage(ball.damage)
    
    # Assert
    assert_eq(block.hp, 40, "Block should have 40 HP after taking 10 damage")
```

### Mock External Dependencies

```gdscript
func test_network_message_sent():
    # Use mock instead of real network
    var mock_network = MockNetworkClient.new()
    var game_client = GameClient.new(mock_network)
    
    game_client.send_input(Input.MOVE_LEFT)
    
    assert_true(mock_network.was_called("send_message"))
    assert_eq(mock_network.last_message.type, MessageType.INPUT)
```

## 🔒 Security Practices

### Never Trust Client Input

```gdscript
# Server-side validation (authoritative)
func process_client_input(player_id: int, input: Dictionary) -> void:
    # Validate player exists
    if not _is_valid_player(player_id):
        push_warning("Invalid player_id: %d" % player_id)
        return
    
    # Validate input type
    if not input.has("type") or not input.type is int:
        push_warning("Malformed input from player %d" % player_id)
        return
    
    # Validate input is possible
    if not _is_input_physically_possible(player_id, input):
        push_warning("Impossible input from player %d, potential cheat" % player_id)
        _flag_player_for_review(player_id)
        return
    
    # Process validated input
    _apply_input(player_id, input)
```

### Sanitize User Content

```gdscript
# Good: Sanitize chat messages
func process_chat_message(player_id: int, message: String) -> void:
    # Length check
    if message.length() > MAX_CHAT_LENGTH:
        message = message.substr(0, MAX_CHAT_LENGTH)
    
    # Remove control characters
    message = message.strip_edges()
    
    # Filter profanity
    message = _filter_profanity(message)
    
    # Check for spam
    if _is_spam(player_id, message):
        return
    
    _broadcast_chat(player_id, message)
```

### Secrets Management

```gdscript
# Good: Use environment variables
const STEAM_API_KEY = OS.get_environment("STEAM_API_KEY")

# Bad: Hardcoded secrets
const STEAM_API_KEY = "ABCD1234567890"  # NEVER DO THIS
```

## 📊 Logging Standards

### Log Levels

```gdscript
# Use appropriate log levels
print_debug("Ball position: %v" % ball.position)  # Development only
print("Game started with %d players" % player_count)  # Info
push_warning("Player %d lagging (ping: %dms)" % [id, ping])  # Warning
push_error("Failed to load asset: %s" % path)  # Error
```

### Structured Logging

```gdscript
# Good: Structured, parseable logs
func log_match_event(event_type: String, data: Dictionary) -> void:
    var log_entry = {
        "timestamp": Time.get_unix_time_from_system(),
        "event": event_type,
        "match_id": current_match_id,
        "data": data
    }
    print(JSON.stringify(log_entry))

# Usage
log_match_event("block_placed", {
    "player_id": 1,
    "piece_type": "I_PIECE",
    "position": {"x": 10, "y": 20}
})
```

## 🎨 Code Formatting

### Indentation

- **Use tabs** (Godot default) or **4 spaces** (Python)
- Be consistent within each file
- Never mix tabs and spaces

### Line Length

- **Maximum**: 100 characters
- **Ideal**: 80 characters
- Break long lines:

```gdscript
# Good: Broken at logical points
var result = calculate_complicated_value(
    first_parameter,
    second_parameter,
    third_parameter
)

# Bad: Too long
var result = calculate_complicated_value(first_parameter, second_parameter, third_parameter, fourth_parameter)
```

### Spacing

```gdscript
# Good: Proper spacing
func calculate_score(base: int, multiplier: float) -> int:
    var bonus = 10
    var result = (base + bonus) * multiplier
    return int(result)

# Bad: Inconsistent spacing
func calculate_score(base:int,multiplier:float)->int:
    var bonus=10
    var result=(base+bonus)*multiplier
    return int(result)
```

### Blank Lines

```gdscript
# Two blank lines between top-level definitions
class_name BlockManager


const MAX_BLOCKS = 1000


func initialize() -> void:
    pass


# One blank line between functions in a class
class Example:
    func first_function() -> void:
        pass
    
    func second_function() -> void:
        pass
```

## 🔄 Version Control

### Commit Messages

**Format**:
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Examples**:
```
feat(gameplay): Add I-piece laser ability

Implemented the laser ability for I-piece blocks.
When hit by a ball, fires a laser across the entire row,
damaging all blocks in the line.

Closes #42

---

fix(network): Handle packet loss in state sync

Added retry logic and timeout handling for dropped packets.
Prevents clients from getting stuck waiting for state updates.

Fixes #108

---

docs(api): Update block ability documentation

Added examples for each block type's ability.
Clarified cooldown mechanics.
```

### Branching Strategy

```
main (production)
├── develop (development)
│   ├── feature/block-abilities
│   ├── feature/multiplayer-rooms
│   ├── bugfix/paddle-collision
│   └── hotfix/critical-crash
```

**Branch naming**:
- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Critical fixes
- `refactor/description` - Code refactoring
- `test/description` - Test additions

## 📦 Dependencies

### Adding Dependencies

**Before adding a new dependency**:
1. Is it necessary?
2. Is it maintained?
3. What's the license?
4. Does it conflict with existing dependencies?
5. What's the file size?

**Document in**:
```
/docs/DEPENDENCIES.md

## Dependency Name

**Purpose**: What it does
**Version**: 1.2.3
**License**: MIT
**Justification**: Why we need it
**Alternatives Considered**: Other options we evaluated
```

## 🎯 Code Review Checklist

Before marking code as complete:

- [ ] Follows naming conventions
- [ ] Functions are small and focused
- [ ] Comments explain complex logic
- [ ] Error handling present
- [ ] No hardcoded values
- [ ] Performance considered
- [ ] Security validated
- [ ] Tests written
- [ ] Documentation updated
- [ ] No compiler warnings
- [ ] Linter passes
- [ ] Formatted correctly

---

**Last Updated**: 2026-01-05
**Status**: Complete Standards Document
**Version**: 1.0.0
