# Code-Driven Development Guide

## 🎯 Philosophy

**Code-First Development with Asset Flexibility**

This project uses a **code-driven approach** to leverage AI agent capabilities and minimize manual work, while maintaining the flexibility to use external assets when they provide better results.

## 🚫 What We Don't Use

- ❌ Visual scene editors (drag-and-drop for game objects)
- ❌ Node tree builders for gameplay
- ❌ Visual scripting/blueprints
- ❌ UI designers for layout (code-based instead)
- ❌ Manual asset placement in scenes

## ✅ What We Do Use

### Code (Primary)
- ✅ Pure code (GDScript/C#)
- ✅ Programmatic scene composition
- ✅ Data-driven configuration (JSON/YAML)
- ✅ Automated build scripts
- ✅ Version-controlled text files

### Assets (Flexible Approach)
- ✅ **Procedural generation** (PRIMARY) - For rapid iteration and AI generation
- ✅ **External assets** (OPTIONAL) - When quality/complexity demands it
- ✅ **Hybrid approach** - Procedural base + external polish

## 📊 Asset Strategy: Procedural-First with External Option

### When to Use Procedural Generation

**Best For:**
- ✅ Rapid prototyping and iteration
- ✅ Placeholder assets during development
- ✅ Simple geometric shapes (blocks, UI elements)
- ✅ Variations and randomization
- ✅ Debug visualizations
- ✅ AI-generated content
- ✅ Dynamic effects that change at runtime

**Example:** Block sprites, simple particles, UI backgrounds

### When to Use External Assets

**Best For:**
- ✅ Complex artwork that's hard to generate
- ✅ Professional polish and final graphics
- ✅ Character art, detailed UI elements
- ✅ High-quality audio (music, voice)
- ✅ Particle textures (smoke, fire, magic effects)
- ✅ Fonts and typography
- ✅ Branding and logo assets

**Example:** UI icons, particle textures, menu backgrounds, music tracks

### Hybrid Approach (Recommended)

```
Development Phase:
- Procedural sprites → Fast iteration
- Simple generated audio → Test gameplay
- Code-based particles → Prototype effects

Polish Phase:
- Keep procedural for blocks (easy to modify)
- Add external UI sprites (professional look)
- Replace key audio with high-quality files
- Add particle textures for premium effects
```

## 🏗️ Code-First Architecture

### Project Structure (All Code)

```
src/
├── main.gd                 # Entry point, bootstraps everything
├── core/
│   ├── game.gd            # Main game class, creates world
│   ├── world.gd           # World container
│   └── constants.gd       # All constants
├── entities/
│   ├── entity.gd          # Base entity class
│   ├── block.gd           # Block entity
│   ├── ball.gd            # Ball entity
│   └── paddle.gd          # Paddle entity
├── systems/
│   ├── physics_system.gd  # Physics updates
│   ├── render_system.gd   # Drawing
│   ├── input_system.gd    # Input handling
│   └── audio_system.gd    # Audio management
├── factories/
│   ├── block_factory.gd   # Creates blocks programmatically
│   ├── ball_factory.gd    # Creates balls
│   └── effect_factory.gd  # Creates VFX
├── generators/
│   ├── sprite_gen.gd      # Procedural sprite generation
│   ├── audio_gen.gd       # Procedural audio
│   └── particle_gen.gd    # Procedural particles
└── data/
    ├── blocks.json        # Block definitions
    ├── abilities.json     # Ability data
    └── config.json        # Game configuration
```

### No Scene Files (Except Root)

```
project.godot              # Godot project file
main.tscn                  # ONLY scene file (minimal, just entry)
└── Script: main.gd        # Bootstraps entire game
```

**main.tscn** (minimal):
```
[gd_scene format=3]
[ext_resource type="Script" path="res://src/main.gd"]

[node name="Main" type="Node"]
script = ExtResource("1")
```

## 💻 Code Patterns

### Pattern 1: Factory Pattern for Everything

```gdscript
# block_factory.gd
class_name BlockFactory

static func create_block(piece_type: String, position: Vector2, owner_id: int) -> Block:
    var block = Block.new()
    
    # Configure from data
    var config = BlockData.get_config(piece_type)
    block.piece_type = piece_type
    block.position = position
    block.owner_id = owner_id
    block.hp = config.hp
    block.color = config.color
    
    # Create sprite programmatically
    var sprite = create_sprite(piece_type, config.color)
    block.add_child(sprite)
    
    # Create collision programmatically
    var collision = create_collision(config.shape)
    block.add_child(collision)
    
    # Setup ability
    var ability = AbilityFactory.create_ability(config.ability)
    block.add_child(ability)
    
    return block

static func create_sprite(piece_type: String, color: Color) -> Sprite2D:
    var sprite = Sprite2D.new()
    
    # Generate texture procedurally
    var texture = SpriteGenerator.generate_block_texture(piece_type, color)
    sprite.texture = texture
    
    return sprite
```

### Pattern 2: Data-Driven Configuration

```json
// data/blocks.json
{
  "I_PIECE": {
    "name": "I-Piece",
    "hp": 3,
    "color": "#00FFFF",
    "shape": [[1,1,1,1]],
    "ability": "laser_line",
    "ability_cooldown": 5.0
  },
  "O_PIECE": {
    "name": "O-Piece",
    "hp": 4,
    "color": "#FFFF00",
    "shape": [[1,1],[1,1]],
    "ability": "shield_bubble",
    "ability_cooldown": 8.0
  }
}
```

```gdscript
# Load and use
class_name BlockData

static var data: Dictionary = {}

static func load_data():
    var file = FileAccess.open("res://data/blocks.json", FileAccess.READ)
    var json = JSON.parse_string(file.get_as_text())
    data = json

static func get_config(piece_type: String) -> Dictionary:
    return data[piece_type]
```

### Pattern 3: Procedural Asset Generation

```gdscript
# sprite_gen.gd
class_name SpriteGenerator

static func generate_block_texture(piece_type: String, color: Color) -> ImageTexture:
    var size = 16  # 16x16 pixels
    var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
    
    # Fill with base color
    for x in range(size):
        for y in range(size):
            var pixel_color = color
            
            # Add highlight (top-left)
            if x < 2 or y < 2:
                pixel_color = pixel_color.lightened(0.3)
            
            # Add shadow (bottom-right)
            if x >= size - 2 or y >= size - 2:
                pixel_color = pixel_color.darkened(0.3)
            
            # Add border
            if x == 0 or y == 0 or x == size - 1 or y == size - 1:
                pixel_color = Color.BLACK
            
            image.set_pixel(x, y, pixel_color)
    
    return ImageTexture.create_from_image(image)
```

### Pattern 4: Programmatic Scene Composition

```gdscript
# world.gd
class_name World extends Node2D

func _ready():
    create_board()
    create_ui()
    create_players()

func create_board():
    # Create board programmatically
    for x in range(Constants.BOARD_WIDTH):
        for y in range(Constants.BOARD_HEIGHT):
            var cell = create_cell(x, y)
            add_child(cell)

func create_cell(x: int, y: int) -> Node2D:
    var cell = Node2D.new()
    cell.position = Vector2(x * Constants.CELL_SIZE, y * Constants.CELL_SIZE)
    
    # Add visual
    var sprite = Sprite2D.new()
    sprite.texture = SpriteGenerator.generate_cell_texture()
    cell.add_child(sprite)
    
    return cell
```

### Pattern 5: Code-Generated UI

```gdscript
# ui_factory.gd
class_name UIFactory

static func create_hud() -> Control:
    var hud = Control.new()
    hud.name = "HUD"
    
    # Create HP bar
    var hp_bar = create_hp_bar(Vector2(10, 10))
    hud.add_child(hp_bar)
    
    # Create score display
    var score = create_score_display(Vector2(10, 50))
    hud.add_child(score)
    
    # Create next pieces preview
    var preview = create_piece_preview(Vector2(900, 10))
    hud.add_child(preview)
    
    return hud

static func create_hp_bar(pos: Vector2) -> Control:
    var container = Control.new()
    container.position = pos
    
    # Background
    var bg = ColorRect.new()
    bg.color = Color(0.2, 0.2, 0.2)
    bg.size = Vector2(200, 30)
    container.add_child(bg)
    
    # Fill (animated)
    var fill = ColorRect.new()
    fill.color = Color.GREEN
    fill.size = Vector2(200, 30)
    fill.name = "Fill"
    container.add_child(fill)
    
    # Label
    var label = Label.new()
    label.text = "HP: 100"
    label.position = Vector2(5, 5)
    container.add_child(label)
    
    return container
```

### Pattern 6: Automated Animation

```gdscript
# animation_builder.gd
class_name AnimationBuilder

static func create_block_placement_animation(block: Node2D) -> Tween:
    var tween = block.create_tween()
    
    # Scale animation
    tween.tween_property(block, "scale", Vector2(1.5, 1.5), 0.1)
    tween.tween_property(block, "scale", Vector2(0.95, 0.95), 0.1)
    tween.tween_property(block, "scale", Vector2(1.0, 1.0), 0.1)
    
    # Rotation wobble
    tween.parallel().tween_property(block, "rotation_degrees", 5, 0.15)
    tween.tween_property(block, "rotation_degrees", -5, 0.1)
    tween.tween_property(block, "rotation_degrees", 0, 0.05)
    
    return tween

static func create_destruction_animation(block: Node2D) -> void:
    # Create particle effect programmatically
    var particles = create_destruction_particles(block.position, block.modulate)
    block.get_parent().add_child(particles)
    
    # Fade out and remove
    var tween = block.create_tween()
    tween.tween_property(block, "modulate:a", 0.0, 0.3)
    tween.tween_callback(block.queue_free)

static func create_destruction_particles(pos: Vector2, color: Color) -> CPUParticles2D:
    var particles = CPUParticles2D.new()
    particles.position = pos
    particles.emitting = true
    particles.one_shot = true
    particles.amount = 20
    particles.lifetime = 0.5
    particles.color = color
    particles.initial_velocity_min = 50
    particles.initial_velocity_max = 150
    particles.gravity = Vector2(0, 300)
    return particles
```

### Pattern 7: Procedural Audio

```gdscript
# audio_gen.gd
class_name AudioGenerator

static func generate_block_hit_sound(block_type: String) -> AudioStreamWAV:
    var stream = AudioStreamWAV.new()
    
    # Generate waveform based on block type
    var frequency = get_frequency_for_block(block_type)
    var duration = 0.1  # 100ms
    var sample_rate = 44100
    var samples = int(duration * sample_rate)
    
    var data = PackedByteArray()
    for i in range(samples):
        var t = float(i) / sample_rate
        var value = sin(t * frequency * TAU) * 0.3  # Simple sine wave
        
        # Apply envelope (attack-decay)
        var envelope = 1.0 - (float(i) / samples)
        value *= envelope
        
        # Convert to byte
        var byte_value = int(clamp(value * 127, -128, 127))
        data.append(byte_value)
    
    stream.data = data
    stream.format = AudioStreamWAV.FORMAT_8_BITS
    stream.mix_rate = sample_rate
    
    return stream

static func get_frequency_for_block(block_type: String) -> float:
    match block_type:
        "I_PIECE": return 440.0  # A4
        "O_PIECE": return 523.25  # C5
        "T_PIECE": return 587.33  # D5
        "S_PIECE": return 659.25  # E5
        "Z_PIECE": return 698.46  # F5
        "J_PIECE": return 783.99  # G5
        "L_PIECE": return 880.0  # A5
        _: return 440.0
```

## 🤖 AI-Friendly Patterns

### Template Generation

```gdscript
# entity_template.gd
# AI can copy and modify this template

class_name EntityTemplate extends Node2D

var entity_id: int
var entity_type: String
var hp: int
var max_hp: int

func _ready():
    setup()

func setup():
    # Override in derived classes
    pass

func update(delta: float):
    # Override in derived classes
    pass

func take_damage(amount: int):
    hp -= amount
    if hp <= 0:
        die()

func die():
    queue_free()
```

### Code Generation Helper

```gdscript
# code_gen.gd
class_name CodeGen

static func generate_block_class(block_type: String, config: Dictionary) -> String:
    var template = """
class_name Block_{type} extends Block

func _init():
    piece_type = "{type}"
    hp = {hp}
    max_hp = {max_hp}
    color = Color("{color}")
    ability = "{ability}"
    ability_cooldown = {cooldown}

func setup():
    super.setup()
    # Custom setup for {type}
    pass
"""
    
    return template.format({
        "type": block_type,
        "hp": config.hp,
        "max_hp": config.hp,
        "color": config.color,
        "ability": config.ability,
        "cooldown": config.ability_cooldown
    })
```

## 📦 Asset Management (Hybrid Approach)

### Asset Registry (Supports Both)

```gdscript
# asset_registry.gd
class_name AssetRegistry

static var sprites: Dictionary = {}
static var sounds: Dictionary = {}
static var particles: Dictionary = {}
static var fonts: Dictionary = {}

static func initialize():
    # Try to load external assets first, fall back to procedural
    load_external_assets()
    generate_missing_assets()

static func load_external_assets():
    """Load external assets if they exist"""
    # Sprites
    _load_sprite("ui_button_normal", "res://assets/sprites/ui/button_normal.png")
    _load_sprite("ui_button_hover", "res://assets/sprites/ui/button_hover.png")
    _load_sprite("particle_spark", "res://assets/sprites/particles/spark.png")
    _load_sprite("particle_smoke", "res://assets/sprites/particles/smoke.png")
    
    # Audio
    _load_audio("music_menu", "res://assets/audio/music/menu_theme.ogg")
    _load_audio("music_gameplay", "res://assets/audio/music/gameplay_theme.ogg")
    _load_audio("sfx_menu_click", "res://assets/audio/sfx/menu_click.wav")
    
    # Fonts
    _load_font("regular", "res://assets/fonts/regular.ttf")
    _load_font("bold", "res://assets/fonts/bold.ttf")

static func generate_missing_assets():
    """Generate any assets that weren't loaded externally"""
    # Generate block sprites (keep procedural for easy modification)
    for piece in ["I_PIECE", "O_PIECE", "T_PIECE", "S_PIECE", "Z_PIECE", "J_PIECE", "L_PIECE"]:
        if not sprites.has(piece):
            var config = BlockData.get_config(piece)
            sprites[piece] = SpriteGenerator.generate_block_texture(piece, Color(config.color))
    
    # Generate missing UI elements
    if not sprites.has("ui_button_normal"):
        sprites["ui_button_normal"] = SpriteGenerator.generate_button_texture("normal")
    
    # Generate missing particles
    if not particles.has("particle_spark"):
        particles["particle_spark"] = SpriteGenerator.generate_particle_texture("spark")
    
    # Generate missing audio
    if not sounds.has("sfx_block_hit"):
        sounds["sfx_block_hit"] = AudioGenerator.generate_hit_sound(1200.0)

static func _load_sprite(key: String, path: String):
    """Try to load external sprite, silently skip if missing"""
    if FileAccess.file_exists(path):
        sprites[key] = load(path)
        print("Loaded external sprite: " + key)
    else:
        print("External sprite not found (will generate): " + key)

static func _load_audio(key: String, path: String):
    """Try to load external audio, silently skip if missing"""
    if FileAccess.file_exists(path):
        sounds[key] = load(path)
        print("Loaded external audio: " + key)

static func _load_font(key: String, path: String):
    """Try to load external font, silently skip if missing"""
    if FileAccess.file_exists(path):
        fonts[key] = load(path)
        print("Loaded external font: " + key)

static func get_sprite(key: String) -> Texture2D:
    """Get sprite (external or generated)"""
    return sprites.get(key)

static func get_sound(key: String) -> AudioStream:
    """Get audio (external or generated)"""
    return sounds.get(key)

static func get_font(key: String) -> Font:
    """Get font (external or fallback)"""
    return fonts.get(key, ThemeDB.fallback_font)
```

### Directory Structure for External Assets

```
assets/                    # Optional external assets
├── sprites/
│   ├── blocks/           # Optional custom block sprites
│   │   ├── i_piece.png
│   │   └── o_piece.png
│   ├── ui/               # UI elements (recommended external)
│   │   ├── button_normal.png
│   │   ├── button_hover.png
│   │   ├── button_pressed.png
│   │   ├── panel.png
│   │   └── icons/
│   │       ├── settings.png
│   │       ├── profile.png
│   │       └── achievements.png
│   └── particles/        # Particle textures (optional)
│       ├── spark.png
│       ├── smoke.png
│       └── glow.png
│
├── audio/
│   ├── music/           # Music tracks (recommended external)
│   │   ├── menu_theme.ogg
│   │   ├── gameplay_theme.ogg
│   │   └── victory_theme.ogg
│   ├── sfx/             # Sound effects (optional)
│   │   ├── block_place.wav
│   │   ├── ball_hit.wav
│   │   └── ability_activate.wav
│   └── voice/           # Voice lines (if any)
│       └── announcer/
│
└── fonts/               # Typography (recommended external)
    ├── regular.ttf
    ├── bold.ttf
    └── mono.ttf
```

### Asset Guidelines

**Always Procedural:**
- Block sprites (need easy color/shape changes)
- Debug visualizations
- Placeholder content
- Dynamic effects

**Usually External:**
- Fonts (professional typography)
- Music tracks (quality matters)
- UI icons (consistency and polish)
- Particle textures (complexity)

**Either Works:**
- Sound effects (procedural for prototyping, external for polish)
- UI backgrounds (procedural for simple, external for detailed)
- Ball sprites (procedural is fine, external for variety)

## 🔧 Build Automation

### Build Script (build.gd)

```gdscript
# build.gd - Run with: godot --script build.gd
extends SceneTree

func _init():
    print("Starting automated build...")
    
    # Generate all code-based assets
    generate_assets()
    
    # Run tests
    run_tests()
    
    # Export builds
    export_builds()
    
    print("Build complete!")
    quit()

func generate_assets():
    print("Generating assets...")
    AssetRegistry.initialize()
    # Save generated assets to disk if needed
    save_generated_assets()

func run_tests():
    print("Running tests...")
    # Run automated tests
    pass

func export_builds():
    print("Exporting builds...")
    # Use Godot export templates
    OS.execute("godot", ["--export", "Windows", "builds/tetroid_windows.exe"])
    OS.execute("godot", ["--export", "Linux", "builds/tetroid_linux.x86_64"])
```

### Continuous Generation

```gdscript
# regenerate.gd - Run during development
extends EditorScript

func _run():
    print("Regenerating all procedural assets...")
    
    # Regenerate sprites
    SpriteGenerator.regenerate_all()
    
    # Regenerate sounds
    AudioGenerator.regenerate_all()
    
    # Update data files
    DataGenerator.regenerate_configs()
    
    print("Regeneration complete!")
```

## 📊 Configuration Over Code

### Game Config (data/config.json)

```json
{
  "game": {
    "board_width": 60,
    "board_height": 62,
    "cell_size": 16,
    "target_fps": 60
  },
  "gameplay": {
    "starting_hp": 100,
    "ball_speed": 400,
    "paddle_speed": 400
  },
  "network": {
    "tick_rate": 30,
    "max_players": 4,
    "default_port": 7777
  },
  "ai": {
    "difficulties": {
      "easy": {
        "reaction_time": 0.3,
        "error_rate": 0.3
      },
      "normal": {
        "reaction_time": 0.15,
        "error_rate": 0.15
      }
    }
  }
}
```

### Load Config

```gdscript
class_name Config

static var data: Dictionary

static func load():
    var file = FileAccess.open("res://data/config.json", FileAccess.READ)
    data = JSON.parse_string(file.get_as_text())

static func get(path: String):
    # Support dot notation: "game.board_width"
    var parts = path.split(".")
    var current = data
    for part in parts:
        current = current[part]
    return current
```

## 🎯 Benefits for AI Development

### 1. Grepable
Everything is searchable text:
```bash
grep -r "class_name Block" src/
grep -r "piece_type" src/
```

### 2. Diff-able
```bash
git diff src/entities/block.gd
# See exactly what changed
```

### 3. Testable
```gdscript
func test_block_creation():
    var block = BlockFactory.create_block("I_PIECE", Vector2(10, 10), 1)
    assert(block != null)
    assert(block.piece_type == "I_PIECE")
    assert(block.position == Vector2(10, 10))
```

### 4. Replicable
```bash
# Same code = same results
git clone repo
cd tetroid
godot --headless --script build.gd
# Identical build every time
```

### 5. Automatable
```python
# AI can generate code files
def generate_ability(name, effect, cooldown):
    template = open("templates/ability.gd").read()
    code = template.format(
        name=name,
        effect=effect,
        cooldown=cooldown
    )
    with open(f"src/abilities/{name}.gd", "w") as f:
        f.write(code)
```

## 📝 Documentation as Code

```gdscript
## Block Entity
##
## Represents a single Tetris piece block in the game world.
## Blocks have HP, abilities, and can be destroyed.
##
## @tutorial: See docs/GAME_DESIGN.md#block-system
class_name Block extends Entity

## Tetris piece type (I, O, T, S, Z, J, L)
var piece_type: String

## Current hit points
var hp: int

## Maximum hit points
var max_hp: int

## Block color
var color: Color

## Ability system
var ability: Ability

## Ability cooldown remaining
var ability_cooldown: float = 0.0
```

## 🎨 Adding External Assets (When Needed)

### Workflow for External Assets

#### 1. Create the Asset
```bash
# Use your preferred tools
- Aseprite / Photoshop for sprites
- GIMP for pixel art
- Audacity / FL Studio for audio
- FontForge for fonts
```

#### 2. Place in Assets Directory
```bash
assets/
└── sprites/
    └── ui/
        └── custom_button.png  # Your new asset
```

#### 3. Register in AssetRegistry
```gdscript
# asset_registry.gd
static func load_external_assets():
    _load_sprite("ui_custom_button", "res://assets/sprites/ui/custom_button.png")
```

#### 4. Use in Code
```gdscript
# ui_factory.gd
static func create_custom_button() -> TextureButton:
    var button = TextureButton.new()
    button.texture_normal = AssetRegistry.get_sprite("ui_custom_button")
    return button
```

### External Asset Specifications

**Sprites:**
```
Format: PNG (with transparency)
Size: Power of 2 recommended (16x16, 32x32, 64x64)
Color: RGB or RGBA
DPI: 72 (standard)
Naming: snake_case (button_normal.png, icon_settings.png)
```

**Audio:**
```
Music:
  Format: OGG Vorbis
  Bitrate: 160-192 kbps
  Sample Rate: 44.1 kHz
  Channels: Stereo
  Looping: Set loop points in metadata

Sound Effects:
  Format: WAV (for quality) or OGG (for size)
  Sample Rate: 44.1 kHz
  Channels: Mono (for SFX) or Stereo (for ambient)
  Length: <2 seconds for most SFX
```

**Fonts:**
```
Format: TTF or OTF
License: Verify commercial use allowed
Include: Regular, Bold (minimum)
Fallback: Always have procedural text rendering
```

**Particle Textures:**
```
Format: PNG with alpha
Size: Usually 32x32 to 128x128
Content: White shape on transparent background
Usage: GPU particles will color/blend it
```

### Example: Adding a Custom UI Icon

```gdscript
# 1. Create icon (32x32 PNG)
# assets/sprites/ui/icons/star.png

# 2. Register it
# asset_registry.gd
static func load_external_assets():
    _load_sprite("icon_star", "res://assets/sprites/ui/icons/star.png")

# 3. Use it
# achievement_ui.gd
func create_achievement_icon() -> TextureRect:
    var icon = TextureRect.new()
    icon.texture = AssetRegistry.get_sprite("icon_star")
    icon.custom_minimum_size = Vector2(32, 32)
    return icon
```

### Example: Adding Custom Music

```gdscript
# 1. Create music track (OGG Vorbis)
# assets/audio/music/boss_theme.ogg

# 2. Register it
# asset_registry.gd
static func load_external_assets():
    _load_audio("music_boss", "res://assets/audio/music/boss_theme.ogg")

# 3. Use it
# music_manager.gd
func play_boss_music():
    var stream = AssetRegistry.get_sound("music_boss")
    music_player.stream = stream
    music_player.play()
```

### Example: Adding Particle Texture

```gdscript
# 1. Create particle texture (64x64 PNG, white shape on transparent)
# assets/sprites/particles/magic_spark.png

# 2. Register it
# asset_registry.gd
static func load_external_assets():
    _load_sprite("particle_magic", "res://assets/sprites/particles/magic_spark.png")

# 3. Use it
# effect_factory.gd
static func create_magic_effect(position: Vector2) -> GPUParticles2D:
    var particles = GPUParticles2D.new()
    particles.position = position
    particles.amount = 50
    particles.lifetime = 1.0
    
    # Use external particle texture
    var material = ParticleProcessMaterial.new()
    particles.process_material = material
    particles.texture = AssetRegistry.get_sprite("particle_magic")
    
    return particles
```

## 🔄 Procedural to External Migration

### Gradual Polish Workflow

```gdscript
# Phase 1: All Procedural (Rapid Development)
sprites["ui_button"] = SpriteGenerator.generate_button_texture()

# Phase 2: Test External Asset
_load_sprite("ui_button_test", "res://assets/sprites/ui/button_test.png")

# Phase 3: Switch to External (If Better)
# Just add to load_external_assets(), procedural becomes fallback

# Phase 4: Keep What Works
# Some things stay procedural (blocks), others use external (UI)
```

### Best of Both Worlds

```gdscript
class_name UIFactory

static func create_button(style: String) -> TextureButton:
    var button = TextureButton.new()
    
    # Try external first
    var texture_key = "ui_button_" + style
    if AssetRegistry.sprites.has(texture_key):
        # Use external asset
        button.texture_normal = AssetRegistry.get_sprite(texture_key)
    else:
        # Fall back to procedural
        button.texture_normal = SpriteGenerator.generate_button_texture(style)
    
    return button
```

## 🚀 Getting Started Checklist

- [ ] Install Godot 4.5
- [ ] Create project with minimal main.tscn
- [ ] Set up src/ directory structure
- [ ] Set up assets/ directory structure (optional initially)
- [ ] Create base classes (Entity, System, Factory)
- [ ] Implement data loading (JSON configs)
- [ ] Create sprite generator (procedural)
- [ ] Create audio generator (procedural)
- [ ] Build factory patterns
- [ ] Test programmatic scene creation
- [ ] Set up build automation
- [ ] Add external asset loading (as needed)
- [ ] Test hybrid workflow (procedural + external)

## 🎓 Learning Resources

- [Godot Scripting Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/)
- [Procedural Generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html)
- [Factory Pattern](https://refactoring.guru/design-patterns/factory-method)

---

**Last Updated**: 2026-01-05
**Status**: Complete Code-Driven Guide
**Version**: 1.0.0
