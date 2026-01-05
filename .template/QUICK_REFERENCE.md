# Quick Reference - Godot 4.x Syntax

> **Keep this handy while coding!**

## 🚨 Critical: Godot 4.x vs 3.x

| Feature | ❌ Godot 3.x (DON'T USE) | ✅ Godot 4.x (USE THIS) |
|---------|-------------------------|------------------------|
| **Signals** | `emit_signal("name", args)` | `signal_name.emit(args)` |
| **Async** | `yield(obj, "signal")` | `await obj.signal` |
| **Files** | `File.new()` | `FileAccess.open()` |
| **Time** | `OS.get_ticks_msec()` | `Time.get_ticks_msec()` |
| **Viewport** | `get_viewport().size` | `get_viewport().get_visible_rect().size` |

## 📝 Signal Examples

```gdscript
# Define signals
signal player_hit(damage: int)
signal game_over()
signal block_placed(position: Vector2i, type: String)

# Emit signals
player_hit.emit(25)
game_over.emit()
block_placed.emit(Vector2i(10, 20), "I_PIECE")

# Connect signals
player_hit.connect(_on_player_hit)
game_over.connect(_on_game_over)
```

## 📂 File Access

```gdscript
# Reading files
func load_data(path: String) -> String:
    if not FileAccess.file_exists(path):
        return ""
    
    var file := FileAccess.open(path, FileAccess.READ)
    if file:
        return file.get_as_text()
    return ""

# Writing files
func save_data(path: String, content: String) -> void:
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_string(content)
```

## ⏱️ Async/Await

```gdscript
# Wait for timer
await get_tree().create_timer(1.0).timeout

# Wait for signal
await player.health_changed

# Wait for animation
await animation_player.animation_finished

# Async function
func async_load_level() -> void:
    print("Loading...")
    await get_tree().create_timer(2.0).timeout
    print("Loaded!")
```

## 🎯 Type Hints (Required)

```gdscript
# Variables
var health: int = 100
var position: Vector2 = Vector2.ZERO
var blocks: Array[Block] = []
var config: Dictionary = {}

# Functions
func calculate_damage(base: int, multiplier: float) -> int:
    return int(base * multiplier)

func get_block_at(pos: Vector2i) -> Block:
    return blocks_dict.get(pos, null)

# Class members
class_name Player
extends Node2D

var player_id: int = 0
var hp: int = 100
var is_alive: bool = true
```

## 🔍 Null Checking

```gdscript
# Check if instance is valid
if is_instance_valid(block):
    block.update()

# Safe node access
var label := get_node_or_null("Label")
if label:
    label.text = "Hello"

# Null coalescing
var value = config.get("key", default_value)
```

## 🎨 Node Creation

```gdscript
# Create and configure nodes
func create_sprite(texture: Texture2D, pos: Vector2) -> Sprite2D:
    var sprite := Sprite2D.new()
    sprite.texture = texture
    sprite.position = pos
    sprite.centered = false
    add_child(sprite)
    return sprite

# Create with parent
func create_label(parent: Node, text: String) -> Label:
    var label := Label.new()
    label.text = text
    parent.add_child(label)
    return label
```

## 🔄 Fixed Timestep

```gdscript
const FIXED_DELTA: float = 1.0 / 60.0
const MAX_PHYSICS_STEPS: int = 5

var _delta_accumulator: float = 0.0

func _process(delta: float) -> void:
    _delta_accumulator += delta
    
    var steps := 0
    while _delta_accumulator >= FIXED_DELTA and steps < MAX_PHYSICS_STEPS:
        _fixed_update(FIXED_DELTA)
        _delta_accumulator -= FIXED_DELTA
        steps += 1
    
    if steps >= MAX_PHYSICS_STEPS:
        _delta_accumulator = 0.0

func _fixed_update(delta: float) -> void:
    # Game logic here
    pass
```

## 🎵 Audio

```gdscript
# Create audio stream
var stream := AudioStreamWAV.new()
stream.format = AudioStreamWAV.FORMAT_16_BITS
stream.mix_rate = 44100
stream.stereo = false
stream.data = audio_data

# Play audio
var player := AudioStreamPlayer.new()
player.stream = stream
add_child(player)
player.play()
```

## 🖼️ Image/Texture

```gdscript
# Create image
var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)

# Set pixels
for x in range(16):
    for y in range(16):
        image.set_pixel(x, y, Color.RED)

# Create texture from image
var texture := ImageTexture.create_from_image(image)

# Apply to sprite
sprite.texture = texture
```

## 🎮 Input

```gdscript
# Check input
if Input.is_action_pressed("move_left"):
    move_left()

if Input.is_action_just_pressed("jump"):
    jump()

# Get axis input
var move_input := Input.get_axis("move_left", "move_right")

# Get vector input
var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
```

## 📊 Common Patterns

### Singleton/Autoload
```gdscript
# In autoload script
class_name GameManager
extends Node

static var instance: GameManager

func _ready() -> void:
    instance = self

# Usage
GameManager.instance.do_something()
```

### Object Pooling
```gdscript
class_name ObjectPool

var _inactive: Array[Node] = []
var _active: Array[Node] = []

func get_object() -> Node:
    var obj: Node
    if _inactive.is_empty():
        obj = _create_new()
    else:
        obj = _inactive.pop_back()
    
    _active.append(obj)
    return obj

func return_object(obj: Node) -> void:
    _active.erase(obj)
    _inactive.append(obj)
    obj.hide()
```

### State Machine
```gdscript
enum State { IDLE, MOVING, ATTACKING, DEAD }

var current_state: State = State.IDLE

func change_state(new_state: State) -> void:
    _exit_state(current_state)
    current_state = new_state
    _enter_state(current_state)

func _enter_state(state: State) -> void:
    match state:
        State.IDLE: _enter_idle()
        State.MOVING: _enter_moving()
        State.ATTACKING: _enter_attacking()
        State.DEAD: _enter_dead()
```

---

**Remember**: Always use Godot 4.x syntax. Check this reference when in doubt!

**Full Documentation**: [CODING_STANDARDS.md](docs/CODING_STANDARDS.md)  
**Last Updated**: 2026-01-05
