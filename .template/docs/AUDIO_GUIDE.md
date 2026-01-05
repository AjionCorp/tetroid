# Audio Design Guide

## 🎵 Audio Philosophy

### Design Goals
1. **Retro Feel**: 8/16-bit inspired sounds with modern quality
2. **Clear Feedback**: Every action has distinct audio cue
3. **Dynamic Music**: Adapts to gameplay intensity
4. **Non-Fatiguing**: Can play for hours without annoyance
5. **Spatial Awareness**: Audio helps locate events on screen

### Audio Strategy
- **Procedural First**: Sound effects generated programmatically for rapid prototyping
- **External Optional**: High-quality music and polished SFX supported
- **Hybrid Approach**: Mix generated and external audio as needed
- **AI-Friendly**: All audio can be generated or loaded via code

> **Note**: This guide provides specifications for external audio assets when needed. However, the project supports **procedural audio generation** as the primary approach. See [Code-Driven Development](CODE_DRIVEN_DEVELOPMENT.md) for details.

## 🔊 Technical Specifications

### Audio Format
```
Sound Effects (SFX):
  Format: WAV (16-bit, 44.1kHz)
  Compression: None (for quality)
  Runtime: Compressed to OGG Vorbis
  Max Length: 2 seconds

Music:
  Format: OGG Vorbis
  Bitrate: 160-192 kbps
  Sample Rate: 44.1kHz
  Channels: Stereo

Voice (if any):
  Format: OGG Vorbis
  Bitrate: 96-128 kbps
  Sample Rate: 44.1kHz
  Channels: Mono
```

### Performance Requirements
- **Memory**: <50MB total audio assets
- **Simultaneous Sounds**: Support 32+ concurrent
- **Latency**: <10ms input to audio
- **CPU**: <5% audio processing

## 🎮 Sound Effects (SFX)

### UI Sounds

**Button**:
```
button_click.wav
  Duration: 50-100ms
  Profile: Sharp click
  Frequency: Mid-range (1-2 kHz)
  Volume: -12 dB

button_hover.wav
  Duration: 30ms
  Profile: Soft beep
  Frequency: Higher (3-4 kHz)
  Volume: -18 dB

button_back.wav
  Duration: 80ms
  Profile: Lower tone than click
  Frequency: 500-800 Hz
  Volume: -12 dB
```

**Menu Navigation**:
```
menu_open.wav
  Duration: 200ms
  Profile: Ascending sweep
  Variation: Light whoosh

menu_close.wav
  Duration: 150ms
  Profile: Descending sweep
  Variation: Soft close

menu_error.wav
  Duration: 100ms
  Profile: Dissonant beep
  Frequency: Lower tone
  Volume: -10 dB (noticeable)
```

### Gameplay Sounds

**Block Placement**:
```
block_place.wav (7 variations - one per piece)
  Duration: 100-150ms
  Profile: Solid "thunk"
  Frequency: 200-500 Hz
  Variation: Pitch varies by piece type
  Volume: -15 dB

block_rotate.wav
  Duration: 50ms
  Profile: Quick mechanical sound
  Frequency: Mid-range
  Volume: -20 dB (subtle)

block_land.wav
  Duration: 80ms
  Profile: Impact sound
  Frequency: Bass-heavy
  Volume: -16 dB
```

**Block Hit**:
```
block_hit_light.wav
  Duration: 80ms
  Profile: Soft impact
  Frequency: 1-2 kHz
  Volume: -18 dB

block_hit_medium.wav
  Duration: 100ms
  Profile: Solid hit
  Frequency: 800 Hz - 1.5 kHz
  Volume: -15 dB

block_hit_heavy.wav
  Duration: 120ms
  Profile: Strong impact
  Frequency: 400-800 Hz
  Volume: -12 dB
```

**Block Destruction**:
```
block_destroy.wav (7 variations)
  Duration: 300-400ms
  Profile: Shattering/breaking
  Frequency: Wide range, descending
  Variation: Each piece has unique sound
  Volume: -14 dB
  Layers:
    - Initial break (high freq)
    - Pieces falling (mid freq)
    - Final settle (low freq)
```

**Ball Physics**:
```
ball_paddle_hit.wav
  Duration: 60ms
  Profile: "Pong" sound
  Frequency: Pitch varies with speed
    - Slow: 800 Hz
    - Normal: 1200 Hz
    - Fast: 1800 Hz
  Volume: -16 dB
  Variation: 3 variations to avoid repetition

ball_block_hit.wav
  Duration: 50ms
  Profile: "Bop" sound
  Frequency: 1-1.5 kHz
  Volume: -18 dB
  Variation: 5 variations

ball_wall_bounce.wav
  Duration: 40ms
  Profile: "Boing"
  Frequency: Mid-high
  Volume: -20 dB

ball_miss.wav
  Duration: 200ms
  Profile: Whoosh + alarm
  Frequency: Descending sweep
  Volume: -10 dB (important feedback)
```

**Abilities**:
```
Each ability needs:
  - [ability]_activate.wav (trigger sound)
  - [ability]_loop.wav (if sustained)
  - [ability]_end.wav (completion)

I-Piece Laser:
  laser_charge.wav (100ms windup)
  laser_fire.wav (300ms, sustained beam)
  laser_impact.wav (per hit)

O-Piece Shield:
  shield_activate.wav (200ms)
  shield_loop.wav (looping hum)
  shield_absorb.wav (when hit)
  shield_break.wav (if destroyed)

T-Piece Triple Shot:
  triple_shot_activate.wav (150ms)
  triple_shot_split.wav (ball splits)

[... similar for each ability]
```

**HP & Score**:
```
hp_damage.wav
  Duration: 100ms
  Profile: Painful hit sound
  Frequency: Low thump
  Volume: Scales with damage

hp_heal.wav
  Duration: 150ms
  Profile: Positive chime
  Frequency: Ascending notes
  Volume: -16 dB

score_gain.wav
  Duration: 80ms
  Profile: Reward sound
  Frequency: Pleasant high tone
  Volume: -18 dB

score_combo.wav (for chains)
  Duration: 120ms
  Profile: Increasingly excited
  Frequency: Rises with combo count
  Volume: -16 dB
```

### Match Events

**Game State**:
```
match_start.wav
  Duration: 1.5s
  Profile: Epic horn/fanfare
  Frequency: Full spectrum
  Volume: -10 dB

match_countdown.wav (3, 2, 1, GO)
  Duration: 4× 500ms
  Profile: Beep, beep, beep, BOOP
  Volume: -12 dB

match_win.wav
  Duration: 2s
  Profile: Triumphant fanfare
  Frequency: Major key progression
  Volume: -8 dB

match_lose.wav
  Duration: 1.5s
  Profile: Disappointed music
  Frequency: Minor key, descending
  Volume: -10 dB

match_draw.wav
  Duration: 1s
  Profile: Neutral tone
  Volume: -12 dB
```

## 🎼 Music

### Track List

**Main Menu Theme**:
```
File: menu_theme.ogg
Duration: 2:30 (loops)
Tempo: 110 BPM
Genre: Synthwave
Mood: Energetic, inviting
Instruments:
  - Synth lead
  - Bass synth
  - Electronic drums
  - Pad/atmosphere
Volume: -16 dB
```

**Gameplay Theme** (Dynamic Layers):
```
Base Track: gameplay_theme_base.ogg
  - Drums and bass
  - Always playing
  - 140 BPM
  
Layer 1: gameplay_theme_rhythm.ogg
  - Rhythmic elements
  - Adds at 30% intensity
  
Layer 2: gameplay_theme_melody.ogg
  - Main melody
  - Adds at 50% intensity
  
Layer 3: gameplay_theme_intense.ogg
  - Additional instrumentation
  - Adds at 80% intensity
  - Adds urgency

Intensity based on:
  - HP levels (low HP = higher intensity)
  - Time remaining
  - Score difference
  - Recent action density
```

**Victory Theme**:
```
File: victory_theme.ogg
Duration: 5s (one-shot)
Tempo: 130 BPM
Genre: Triumphant orchestral/electronic hybrid
Mood: Celebratory
Volume: -10 dB
```

**Defeat Theme**:
```
File: defeat_theme.ogg
Duration: 3s (one-shot)
Tempo: 90 BPM
Genre: Somber electronic
Mood: Disappointed but respectful
Volume: -12 dB
```

**Tutorial Theme**:
```
File: tutorial_theme.ogg
Duration: 2:00 (loops)
Tempo: 100 BPM
Genre: Calm electronic
Mood: Educational, relaxed
Volume: -18 dB (background)
```

### Music Implementation

```gdscript
class_name MusicManager

var current_track: AudioStreamPlayer
var intensity_layers: Array = []
var current_intensity: float = 0.0

func play_gameplay_music():
    # Load all layers
    var base = preload("res://assets/audio/music/gameplay_theme_base.ogg")
    var rhythm = preload("res://assets/audio/music/gameplay_theme_rhythm.ogg")
    var melody = preload("res://assets/audio/music/gameplay_theme_melody.ogg")
    var intense = preload("res://assets/audio/music/gameplay_theme_intense.ogg")
    
    # Create audio players
    intensity_layers = [
        create_layer(base, 1.0),    # Always on
        create_layer(rhythm, 0.0),  # Start muted
        create_layer(melody, 0.0),  # Start muted
        create_layer(intense, 0.0)  # Start muted
    ]
    
    # Start all layers in sync
    for layer in intensity_layers:
        layer.play()

func update_music_intensity(game_state: GameState):
    # Calculate intensity (0.0 - 1.0)
    var hp_factor = 1.0 - (game_state.player_hp / 100.0)
    var time_factor = calculate_time_pressure()
    var action_factor = calculate_action_density()
    
    var target_intensity = (hp_factor + time_factor + action_factor) / 3.0
    
    # Smooth transition
    current_intensity = lerp(current_intensity, target_intensity, 0.05)
    
    # Adjust layer volumes
    intensity_layers[1].volume_db = _intensity_to_db(current_intensity, 0.3)
    intensity_layers[2].volume_db = _intensity_to_db(current_intensity, 0.5)
    intensity_layers[3].volume_db = _intensity_to_db(current_intensity, 0.8)

func _intensity_to_db(intensity: float, threshold: float) -> float:
    if intensity < threshold:
        return -80.0  # Muted
    else:
        var amount = (intensity - threshold) / (1.0 - threshold)
        return lerp(-80.0, 0.0, amount)
```

## 🎚️ Audio Mixing

### Volume Levels (dB)

```
Master: 0 dB (user controlled)

├── Music: -16 dB
│   ├── Menu: -16 dB
│   ├── Gameplay: -18 dB (to avoid fatigue)
│   └── Stingers: -10 dB (victory/defeat)
│
├── SFX: -12 dB
│   ├── UI: -12 dB
│   ├── Gameplay: -15 dB
│   ├── Impacts: -14 dB
│   └── Abilities: -13 dB
│
└── Voice (if any): -10 dB
    ├── Announcer: -10 dB
    └── Emotes: -14 dB
```

### Ducking

When important sounds play:
```
Ball Miss: Duck music -6 dB for 1 second
Ability Activation: Duck music -3 dB for 0.5 seconds
Victory/Defeat: Fade out music, play stinger
```

## 🎨 Audio Categories

### Priority System

```
Priority Levels (higher = more important):
1. Critical (will never be cut)
   - Ball miss
   - Match start/end
   - Error sounds

2. High (rarely cut)
   - Ability activations
   - Block destruction
   - Paddle hits

3. Medium (can be cut if many playing)
   - Block placement
   - Ball bounces
   - Score notifications

4. Low (cut freely)
   - Menu navigation
   - Ambient sounds
   - Subtle feedback
```

### Audio Pooling

```gdscript
class_name AudioPool

const MAX_INSTANCES = 32
var audio_players: Array = []
var next_player: int = 0

func play_sound(sound: AudioStream, volume: float = 1.0, pitch: float = 1.0):
    # Get next available player
    var player = audio_players[next_player]
    next_player = (next_player + 1) % MAX_INSTANCES
    
    # Stop current sound if playing
    if player.playing:
        player.stop()
    
    # Set properties
    player.stream = sound
    player.volume_db = linear_to_db(volume)
    player.pitch_scale = pitch
    
    # Play
    player.play()
```

## 🎧 Spatial Audio (Optional)

For enhanced experience:
```
Ball Position: Slight stereo panning based on X position
  - Left side: Pan left
  - Right side: Pan right
  - Center: No pan

Block Destruction: Panned to block position

Abilities: Panned to activation point
```

## ♿ Accessibility

### Audio Settings
```
Options to provide:
- Master volume
- Music volume
- SFX volume
- Voice volume (if applicable)
- Mute all
- Visual sound indicators (for hearing impaired)
- Mono audio option
- High contrast audio mode (more distinct sounds)
```

### Visual Indicators

For hearing-impaired players:
```
- Ball hit: Flash at impact point
- Block destroyed: Visual shake
- HP loss: Screen flash
- Ability activated: Icon pulse
- Critical events: Subtitle/notification
```

## 🛠️ Audio Tools

### Recommended Software

**SFX Creation**:
- **BFXR** / **ChipTone** - Retro sound generator
- **Audacity** - Free audio editing
- **FL Studio** - Professional DAW
- **Reaper** - Affordable DAW

**Music Creation**:
- **FL Studio** - Electronic music
- **Ableton Live** - Loop-based composition
- **FamiTracker** - Authentic chiptune
- **Renoise** - Tracker-style composition

**Middleware** (Optional):
- **FMOD** - Advanced audio engine
- **Wwise** - Professional game audio

## 📏 Export Guidelines

### Normalization
```
SFX: Normalize to -3 dB peak
Music: Normalize to -0.5 dB peak
Use RMS normalization for consistency
Apply subtle limiting to prevent clipping
```

### File Naming
```
[category]_[object]_[action]_[variation].wav

Examples:
  sfx_block_place_i.wav
  sfx_ball_hit_paddle_01.wav
  music_gameplay_theme_base.ogg
  ui_button_click.wav
```

## 🎼 Audio Implementation Checklist

### Core Systems
- [ ] Audio manager singleton
- [ ] Audio pooling (32+ simultaneous sounds)
- [ ] Volume controls (Master, Music, SFX)
- [ ] Audio categories/buses
- [ ] Ducking system

### Sound Effects
- [ ] All UI sounds
- [ ] Block placement (7 pieces)
- [ ] Block hits (light/medium/heavy)
- [ ] Block destruction (7 pieces)
- [ ] Ball physics (paddle, block, wall, miss)
- [ ] All ability sounds
- [ ] HP and score sounds
- [ ] Match events (start, end, countdown)

### Music
- [ ] Main menu theme
- [ ] Gameplay theme (dynamic layers)
- [ ] Victory stinger
- [ ] Defeat stinger
- [ ] Tutorial theme (optional)

### Polish
- [ ] Pitch variation on repeated sounds
- [ ] Spatial audio (stereo panning)
- [ ] Music intensity system
- [ ] Audio ducking implementation
- [ ] Accessibility options

## 🎵 Placeholder Audio

For development:
```
Use simple beeps/tones:
- Button: 1 kHz beep, 50ms
- Block hit: 800 Hz blip, 80ms
- Ball hit: 1200 Hz boop, 60ms
- Music: Simple loop or silence

Tools:
- Online tone generator
- BFXR with default settings
- Royalty-free placeholder music
```

Replace with polished audio once mechanics are solid.

---

**Last Updated**: 2026-01-05
**Status**: Complete Audio Guide
**Version**: 1.0.0
