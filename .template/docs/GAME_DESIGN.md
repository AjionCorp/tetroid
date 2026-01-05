# Tetroid - Complete Game Design Document

## 🎮 Game Overview

**Tetroid** is a competitive multiplayer game that combines strategic block placement (Tetris), ball physics (Arkanoid), and auto-battler elements (Mechabellum). Players strategically place Tetris pieces with unique abilities while managing ball deflection in a split-screen arena.

## 🎯 Core Gameplay Loop

### Victory Condition
**First player/team to reduce opponent's HP to 0 wins**

### Game Flow (Per Turn)
1. **Preview Phase** (2 seconds)
   - See your next 3 pieces
   - Observe current ball trajectory
   - Plan placement strategy

2. **Placement Phase** (8 seconds)
   - Drop and place Tetris piece
   - Choose placement: friendly territory, enemy territory, or neutral border
   - Placement location determines ability activation

3. **Action Phase** (Continuous)
   - Ball bounces between territories
   - Blocks activate abilities when hit
   - Paddle deflects ball back to opponent
   - Miss ball = take damage

4. **Resolution Phase**
   - Abilities resolve
   - Effects apply
   - Next piece queued

## 🎲 Game Board Specifications

### Board Dimensions
```
Total: 60 blocks wide × 62 blocks tall

Layout:
┌─────────────────────────────────────┐ ← Y: 0
│        Player 1 Territory            │
│         (30 blocks tall)             │
│                                      │
│   (60 blocks wide playable area)    │
│                                      │
├─────────────────────────────────────┤ ← Y: 30 (Neutral Zone)
│         NEUTRAL ZONE (2 tall)        │ ← Y: 31 (No placement allowed)
├─────────────────────────────────────┤ ← Y: 32
│                                      │
│        Player 2 Territory            │
│         (30 blocks tall)             │
│   (60 blocks wide playable area)    │
│                                      │
└─────────────────────────────────────┘ ← Y: 62
    ↑                                  ↑
   X: 0                              X: 60
```

### Territory System
- **Friendly Territory**: Own half (30 blocks)
  - Defensive abilities stronger
  - Costs less to place
  - Blocks have more HP

- **Enemy Territory**: Opponent's half
  - Offensive abilities stronger
  - Costs more to place
  - Blocks have less HP
  - Risk: can be destroyed easier

- **Neutral Zone**: Middle 2 rows
  - No block placement allowed
  - Ball passes through freely
  - Boundary marker

### Starting Positions
- Each player starts with **5 random blocks** pre-placed
- Positioned in their own territory (randomized)
- Balanced to ensure fair start
- Symmetrical placement for ranked matches

## 🧩 Block System

### Tetris Pieces (Standard 7)

```
I-Piece (Cyan)
████
Ability: Laser Line
- Fires laser across the row when hit
- Deals damage to all blocks in line

O-Piece (Yellow)
██
██
Ability: Shield Bubble
- Creates protective barrier
- Absorbs 1 ball hit without taking damage

T-Piece (Purple)
 █
███
Ability: Triple Shot
- Splits ball into 3 projectiles
- Each deals 50% damage

S-Piece (Green)
 ██
██
Ability: Healing Wave
- Heals nearby blocks when hit
- Restores paddle HP

Z-Piece (Red)
██
 ██
Ability: Speed Boost
- Increases ball speed by 50%
- Deals extra damage

J-Piece (Blue)
█
███
Ability: Bouncer
- Reflects ball at sharp angles
- Can hit same target multiple times

L-Piece (Orange)
  █
███
Ability: Spawn Blocker
- Creates temporary obstacle block
- Blocks enemy ball briefly
```

### Block Placement Rules

**Rotation**:
- 4 rotations per piece (0°, 90°, 180°, 270°)
- Super Rotation System (SRS) for wall kicks
- Hold piece allowed (1 piece in reserve)

**Placement Cost** (Resource System):
- Each player has Energy meter (100 max)
- Regenerates 10 per turn
- Friendly territory: 20 energy
- Enemy territory: 40 energy
- Special pieces: +10 energy

**Placement Restrictions**:
- Must not overlap existing blocks
- Must be supported (touching bottom or another block)
- Cannot place in neutral zone
- Cannot place beyond board boundaries

### Block Properties

```python
class Block:
    # Core Properties
    position: Vector2
    piece_type: PieceType  # I, O, T, S, Z, J, L
    rotation: int  # 0-3
    owner: PlayerId
    territory: Territory  # FRIENDLY, ENEMY
    
    # Combat Properties
    hp: int  # 1-5 depending on piece and territory
    max_hp: int
    armor: int  # Damage reduction
    
    # Ability Properties
    ability: Ability
    ability_cooldown: float  # seconds
    ability_charges: int
    
    # Status Effects
    active_effects: List[Effect]
    buffs: List[Buff]
    debuffs: List[Debuff]
    
    # Visual
    color: Color
    glow: bool
    particles: ParticleEffect
```

### Ability System

**Ability Triggers**:
1. **On Hit**: Ball collides with block
2. **On Destroy**: Block HP reaches 0
3. **On Place**: When first placed
4. **Passive**: Constant effect
5. **Activated**: Player triggers manually

**Ability Categories**:
- **Offensive**: Damage, ball manipulation, debuffs
- **Defensive**: Healing, shields, armor
- **Utility**: Vision, energy, special effects
- **Territory Control**: Area denial, crowd control

**Cooldown System**:
- Global cooldown: 0.5 seconds
- Individual ability cooldowns: 3-10 seconds
- Cooldown reduction from items/effects

## ⚽ Ball Physics System

### Ball Properties

```python
class Ball:
    # Physics
    position: Vector2
    velocity: Vector2
    speed: float  # 200-800 pixels/second
    mass: float  # Affects bounce angles
    
    # Combat
    damage: int  # 5-50 depending on speed/type
    pierce: bool  # Goes through blocks
    
    # Type & Effects
    ball_type: BallType
    effects: List[BallEffect]
    trail: ParticleEffect
    
    # State
    owner: PlayerId  # Who last hit it
    hits_this_bounce: int
    lifetime: float  # Some balls expire
```

### Ball Types

**Normal Ball** (White)
- Damage: 10
- Speed: 400 px/s
- Standard physics

**Fire Ball** (Red)
- Damage: 20
- Speed: 500 px/s
- Burns blocks (DoT)

**Ice Ball** (Blue)
- Damage: 10
- Speed: 300 px/s
- Slows paddle and ball speed

**Multi Ball** (Rainbow)
- Spawns 2-3 balls
- Each deals half damage
- Chaos strategy

**Heavy Ball** (Gray)
- Damage: 30
- Speed: 350 px/s
- Penetrates shields

**Ghost Ball** (Transparent)
- Damage: 15
- Speed: 450 px/s
- Passes through blocks (no collision)
- Only paddle can hit

### Ball Physics Rules

**Bounce Mechanics**:
```
Reflection angle = Incident angle + Paddle velocity influence
Max angle change: ±30° from pure reflection
Spin affects trajectory slightly
```

**Collision Detection**:
- Ball vs Block: AABB collision
- Ball vs Paddle: Precise collision with angle influence
- Ball vs Wall: Perfect reflection
- Ball vs Ball: Elastic collision

**Speed Modifications**:
- Paddle hit: ±50 px/s depending on timing
- Block abilities: -100 to +300 px/s
- Maximum speed: 1000 px/s
- Minimum speed: 150 px/s

**Missed Ball Consequences**:
```
Normal ball: -10 HP
Fire ball: -20 HP + burn (5 HP/sec for 3 sec)
Ice ball: -10 HP + slow paddle
Heavy ball: -30 HP
Ghost ball: -15 HP (hard to see)
Multi ball: -10 HP per ball
```

## 🏓 Paddle System

### Paddle Properties

```python
class Paddle:
    position: Vector2  # X position (Y is fixed)
    width: int  # 60-120 pixels
    speed: float  # 400 px/s
    
    # Special
    ability: PaddleAbility  # Optional special move
    ability_cooldown: float
    
    # Visual
    color: Color
    glow_intensity: float
    particles: ParticleEffect
```

### Paddle Abilities (Earned during match)

**Quick Dash**
- Cooldown: 5 seconds
- Teleport 100 pixels instantly
- Dodge impossible shots

**Wide Guard**
- Cooldown: 8 seconds
- Duration: 2 seconds
- Paddle width +100%

**Power Shot**
- Cooldown: 10 seconds
- Next hit doubles ball speed and damage
- Visual charge-up effect

**Multi-Hit**
- Cooldown: 12 seconds
- Next ball splits into 3 on paddle contact

**Magnetic Pull**
- Cooldown: 15 seconds
- Duration: 3 seconds
- Slightly attracts ball toward paddle

**Shield Wall**
- Cooldown: 20 seconds
- Duration: 2 seconds
- Blocks behind paddle prevent HP loss

### Paddle Controls

**Keyboard**:
- A/D or ←/→: Move paddle
- Spacebar: Activate paddle ability
- Q/E: Rotate next piece
- W/S: Move piece left/right before drop
- Enter: Fast drop / Place piece

**Controller**:
- Left Stick: Move paddle
- Right Stick: Position piece
- A Button: Place piece / Activate ability
- Bumpers: Rotate piece
- Triggers: Fine control

**Mouse** (Optional):
- Mouse X: Paddle position
- Left Click: Place piece / Ability
- Right Click: Hold piece
- Scroll: Rotate piece

## 💖 HP & Damage System

### HP Pools

**Game Mode HP Values**:
```
1v1:
- Starting HP: 100
- Victory condition: Reduce opponent to 0

2v2:
- Starting HP: 150 per player
- Shared team HP: 300 total
- Team eliminated when total reaches 0

4-Player FFA:
- Starting HP: 80 per player
- Last player standing wins
- Can form temporary alliances
```

### Damage Sources

**Direct Damage**:
- Missed ball: -10 to -30 HP
- Block ability: -5 to -20 HP
- DoT effects: -3 to -10 HP/sec

**Indirect Damage**:
- Territory loss: Blocks destroyed in your area
- Ability combos: Chained effects
- Environmental: Special board hazards (advanced)

### Healing Sources

**Limited Healing**:
- Healing blocks: +10 HP (cooldown)
- Paddle ability: +15 HP (rare)
- Perfect defense streak: +5 HP per 5 deflections
- Max HP: Cannot exceed starting HP

## 🏆 Game Modes

### 1v1 Standard
- Most common mode
- Pure skill-based
- Ranked available
- 5-10 minute matches

### 2v2 Team Battle
- Coordinated strategy
- Shared board (larger)
- Team abilities combo
- 8-15 minute matches

### 4-Player FFA
- Chaos mode
- Every player for themselves
- Dynamic alliances possible
- 10-20 minute matches
- Special board layout (4 territories)

### Ranked Modes
- Separate ELO per mode
- Seasonal rankings
- Rewards per tier
- Decay system (inactive)

### Non-Ranked
- Casual play
- Experimental modes
- Custom rules
- Practice vs AI

### Tournament Mode
- Single/Double elimination
- Swiss system
- Round robin
- Best of 3/5

### Custom Lobbies
- Host can adjust:
  - Starting HP
  - Ball speed
  - Block abilities on/off
  - Territory size
  - Special rules

## 🤖 AI Opponent System

### Difficulty Levels

**Easy** (Beginner-friendly)
- Reaction time: 300ms
- Miss rate: 30%
- Basic piece placement
- Rarely uses abilities
- Predictable patterns

**Normal** (Casual play)
- Reaction time: 150ms
- Miss rate: 15%
- Strategic placement
- Uses abilities occasionally
- Adapts slowly

**Hard** (Challenge)
- Reaction time: 80ms
- Miss rate: 5%
- Optimized placement
- Good ability timing
- Counters player strategy

**Expert** (Near-perfect)
- Reaction time: 30ms
- Miss rate: 1%
- Perfect piece placement
- Frame-perfect abilities
- Reads player patterns
- Combo chains

### AI Behavior

**Decision Tree**:
```
Every Tick:
1. Evaluate Threats
   - Ball trajectory
   - HP differential
   - Board state

2. Choose Strategy
   - Aggressive: Place in enemy territory
   - Defensive: Fortify own territory
   - Balanced: Mixed approach

3. Piece Placement
   - Calculate best position
   - Consider ability synergy
   - Maximize value

4. Ability Timing
   - Check cooldowns
   - Predict ball hits
   - Combo with pieces

5. Paddle Control
   - Path to intercept ball
   - Adjust for ball curve
   - Prepare ability use
```

**Learning System** (Optional Advanced Feature):
```
After Each Match:
- Record player strategies
- Update behavior weights
- Adapt difficulty dynamically
- Store patterns in database

Results:
- AI becomes more challenging over time
- Personalized difficulty
- Unpredictable behavior
```

## 🎨 Visual Design

### Art Style
- **Pixel Art**: 16×16 base unit
- **Retro Aesthetic**: 80s/90s arcade feel
- **Modern Polish**: Smooth animations, particles
- **High Contrast**: Clear visual hierarchy

### Color Palette

**Primary Colors** (Blocks):
```
Cyan:    #00FFFF (I-piece)
Yellow:  #FFFF00 (O-piece)
Purple:  #FF00FF (T-piece)
Green:   #00FF00 (S-piece)
Red:     #FF0000 (Z-piece)
Blue:    #0000FF (J-piece)
Orange:  #FF8800 (L-piece)
```

**UI Colors**:
```
Background:    #1A1A2E
Panel:         #16213E
Accent:        #0F3460
Highlight:     #533483
Text Primary:  #EAEAEA
Text Secondary:#9D9D9D
```

**Effect Colors**:
```
Fire:     #FF4500
Ice:      #00CED1
Poison:   #32CD32
Electric: #FFD700
Shield:   #87CEEB
```

### Animations

**Block Placement**:
- Drop animation: 0.3 seconds
- Land effect: Particle burst
- Place sound: Satisfying "thunk"

**Ball Movement**:
- Smooth interpolation
- Trail effect based on speed
- Impact flash on collision

**Abilities**:
- Windup: 0.1 seconds
- Effect: 0.3-1.0 seconds
- Cooldown visual feedback

**UI Transitions**:
- Fade: 0.2 seconds
- Slide: 0.3 seconds
- Scale: 0.15 seconds

### Visual Effects (VFX)

**Particles**:
- Block destruction: Colored fragments
- Ability activation: Glow + particles
- Ball trail: Motion blur + particles
- Paddle hit: Impact flash

**Screen Effects**:
- Camera shake on big hits
- Slow-motion on clutch moments
- Flash on critical events
- Vignette on low HP

## 🎵 Audio Design

### Sound Effects (SFX)

**Block Sounds**:
- Place: "Thunk" (varied by piece)
- Hit: "Impact" (varied by material)
- Destroy: "Shatter" (satisfying crunch)
- Ability: Unique per ability type

**Ball Sounds**:
- Paddle hit: "Pong" (pitch varies with speed)
- Block hit: "Bop"
- Wall bounce: "Boing"
- Miss: "Whoosh" + "Alarm"

**UI Sounds**:
- Button click: Crisp beep
- Menu navigate: Soft click
- Confirm: Positive chime
- Cancel: Negative beep
- Match start: Epic horn

**Ambient**:
- Crowd noise (varies with action)
- Electrical hum (low level)
- Territory pulse (subtle)

### Music

**Main Menu**:
- Genre: Synthwave
- Tempo: 110 BPM
- Mood: Energetic, inviting

**Gameplay**:
- Genre: Electronic/Chiptune
- Tempo: 130-140 BPM
- Mood: Intense, focused
- Dynamic: Adapts to game state

**Victory**:
- Genre: Triumphant fanfare
- Duration: 5 seconds
- Mood: Celebratory

**Defeat**:
- Genre: Minor key deflation
- Duration: 3 seconds
- Mood: Disappointed but respectful

### Audio Implementation

```python
class AudioManager:
    # Categories (for mixing)
    sfx_volume: float  # 0.0-1.0
    music_volume: float
    voice_volume: float
    
    # Spatial Audio (optional)
    enable_3d: bool
    listener_position: Vector2
    
    # Dynamic Music
    current_intensity: float  # 0.0-1.0
    layers: List[AudioStream]  # Add layers based on intensity
    
    # Audio Pooling
    sfx_pool: ObjectPool[AudioSource]
    max_concurrent: int = 32
```

## 📊 Progression System

### Player Levels
- Earn XP from matches
- Level up for cosmetic rewards
- No gameplay advantages (fair competitive)

### Unlockables

**Cosmetics**:
- Block skins (visual only)
- Paddle designs
- Ball trails
- Victory animations
- Emotes

**Titles**:
- Earned through achievements
- Display next to username
- Prestige indicator

### Achievements

**Gameplay**:
- "First Blood": Win first match
- "Perfectionist": Win without taking damage
- "Combo Master": Chain 5 abilities
- "Survivor": Win with <10 HP remaining
- "Untouchable": 20 paddle hits in a row

**Skill**:
- "Sharp Shooter": 95%+ paddle accuracy
- "Strategist": Place 50 blocks in enemy territory
- "Defender": Protect 10 blocks for entire match
- "Speedster": Win in under 3 minutes

**Social**:
- "Team Player": Win 10 team matches
- "Tournament Victor": Win a tournament
- "Mentor": Play 5 matches with new players

## 🌐 Multiplayer Features

### Matchmaking

**Ranked**:
- ELO-based matching
- ±100 ELO range initially
- Expands after 30 seconds
- Region preference
- Max wait: 2 minutes

**Casual**:
- Loose skill matching
- Prioritize connection quality
- Faster queue times
- Cross-region allowed

### Room System

**Lobby Creation**:
- Public or Private
- Password protection
- Custom rules
- Spectator slots (up to 8)

**In-Lobby Features**:
- Text chat
- Ready system
- Host controls
- Practice mode while waiting

### Tournament System

**Formats**:
- Single Elimination
- Double Elimination
- Swiss System
- Round Robin

**Features**:
- Automatic bracket generation
- Check-in system
- Auto-advance on no-show
- Replay saving
- Prize distribution (cosmetic)

### Social Features

**Friends System**:
- Steam friends integration
- In-game friend list
- Invite to match
- Recent players

**Communication**:
- Text chat (filtered for toxicity)
- Quick chat (preset messages)
- Emotes (cosmetic expressions)
- Post-match stats sharing

## 🎯 Balance Philosophy

### Core Principles
1. **Skill First**: Player skill determines outcome
2. **Clear Counterplay**: Every strategy has a counter
3. **Variety Viable**: Multiple strategies competitive
4. **Predictable**: Consistent mechanics
5. **Reward Risk**: High-risk plays = high reward

### Balancing Tools

**Data-Driven**:
- Track win rates per piece type
- Monitor ability usage
- Analyze placement heatmaps
- Review match duration

**Regular Updates**:
- Monthly balance patches
- Seasonal major updates
- Community feedback
- Pro player input

### Testing Protocol
1. Internal playtesting
2. Closed beta
3. Public test realm
4. Gradual rollout
5. Monitor & adjust

---

**Last Updated**: 2026-01-05
**Status**: Complete Design Document
**Version**: 1.0.0
