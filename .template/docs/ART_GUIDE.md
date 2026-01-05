# Art & Visual Design Guide

## 🎨 Visual Style

### Art Direction
- **Style**: Retro Pixel Art with Modern Polish
- **Era Inspiration**: Late 80s / Early 90s arcade games
- **Mood**: Energetic, competitive, vibrant
- **Polish Level**: Clean pixels with smooth animations and modern effects

### Asset Strategy
- **Procedural First**: Most assets generated programmatically for rapid iteration
- **External Optional**: High-quality external assets supported for polish
- **Hybrid Approach**: Mix procedural and external as needed
- **AI-Friendly**: All assets can be generated or loaded via code

> **Note**: This guide provides specifications for external assets when needed. However, the project supports **procedural generation** as the primary approach. See [Code-Driven Development](CODE_DRIVEN_DEVELOPMENT.md) for details.

## 📐 Technical Specifications

### Base Unit
- **Pixel Base**: 16×16 pixels per grid cell
- **Grid Size**: 60×62 cells
- **Screen Resolution**: 
  - Minimum: 1280×720 (720p)
  - Target: 1920×1080 (1080p)
  - Support: Up to 4K (3840×2160)

### Scaling
- **Pixel Perfect**: Maintain integer scaling when possible
- **Fallback**: High-quality filtering for non-integer scales
- **UI**: Vector-based for clean scaling

## 🎨 Color Palette

### Primary Colors (Tetris Pieces)
```
Cyan (I-Piece):    #00FFFF
Yellow (O-Piece):  #FFFF00
Purple (T-Piece):  #AA00FF
Green (S-Piece):   #00FF00
Red (Z-Piece):     #FF0000
Blue (J-Piece):    #0000FF
Orange (L-Piece):  #FF8800
```

### UI Colors
```
Background Dark:    #0A0A0F
Background Medium:  #1A1A2E
Panel Dark:         #16213E
Panel Light:        #0F3460
Accent Primary:     #533483
Accent Secondary:   #E94560
Text Primary:       #EAEAEA
Text Secondary:     #9D9D9D
Success Green:      #00FF88
Warning Yellow:     #FFAA00
Error Red:          #FF4444
```

### Effect Colors
```
Fire:       #FF4500 → #FFAA00 → #FFFF00
Ice:        #00CED1 → #87CEEB → #FFFFFF
Poison:     #32CD32 → #228B22
Electric:   #FFD700 → #FFFFFF → #4169E1
Shield:     #87CEEB → #00CED1 (50% opacity)
Explosion:  #FF4500 → #FFAA00 → #666666
```

## 🧩 Block Sprites

### Standard Block (16×16)
```
File: block_base.png
Layers:
1. Base color fill
2. Highlight (top-left, 1-2px)
3. Shadow (bottom-right, 1-2px)
4. Border (optional, 1px)
```

### Block States
Each block piece needs:
- `idle.png` - Default state
- `hover.png` - Preview/highlight (optional)
- `placed.png` - Just placed animation frame
- `hit_1.png`, `hit_2.png`, `hit_3.png` - Damage states
- `destroyed.png` - Destruction animation frames (4-6 frames)
- `ability_ready.png` - Ability charged indicator
- `ability_active.png` - During ability use

### Animation Specifications
**Block Placement**:
```
Duration: 300ms
Frames: 6
Animation: 
  Frame 1-2: Scale from 150% to 110%
  Frame 3-4: Scale from 110% to 95%
  Frame 5-6: Scale from 95% to 100%
  Add: Rotation wobble ±5 degrees
```

**Block Destruction**:
```
Duration: 400ms
Frames: 8
Animation:
  Frame 1-3: Break into 4 pieces
  Frame 4-6: Pieces spread outward
  Frame 7-8: Fade out (alpha 100% → 0%)
  Particles: 8-12 small fragments
```

## ⚽ Ball Sprites

### Ball Types (8×8 base)
```
Normal Ball:    ball_normal.png (white)
Fire Ball:      ball_fire.png (red-orange gradient)
Ice Ball:       ball_ice.png (light blue)
Heavy Ball:     ball_heavy.png (dark gray)
Ghost Ball:     ball_ghost.png (translucent)
Multi Ball:     ball_multi.png (rainbow)
```

### Ball Effects
**Trail Effect**:
- Length: 3-5 ball diameters
- Opacity: 100% → 0% gradient
- Width: Ball width → 50%
- Particles: Speed-based (faster = more particles)

**Impact Effect**:
```
Duration: 150ms
Frames: 4
Elements:
  - Flash (1 frame, white)
  - Shockwave ring (expands from impact point)
  - Particles (4-8, radiating from impact)
```

## 🏓 Paddle Sprite

### Paddle Design
```
File: paddle.png
Dimensions: 60×8 pixels (base)
States:
  - idle.png
  - hit.png (impact frame)
  - ability_ready.png (glow)
  - ability_active.png (special appearance)
```

### Paddle Abilities Visual
- **Quick Dash**: Motion blur trail
- **Wide Guard**: Paddle extends with energy field
- **Power Shot**: Charged aura, pulsing
- **Multi-Hit**: Paddle splits visually
- **Magnetic Pull**: Magnetic field lines
- **Shield Wall**: Barrier appears behind paddle

## 🎮 UI Elements

### Buttons
```
File naming: button_[state].png
Dimensions: Variable (9-slice compatible)
States:
  - normal.png
  - hover.png
  - pressed.png
  - disabled.png

9-Slice borders: 4px corners
```

### Panels
```
File: panel_[type].png
Types:
  - menu (solid background)
  - game_hud (semi-transparent)
  - popup (modal overlay)

All panels support 9-slice scaling
```

### HUD Elements
```
HP Bar:
  - Background: hp_bar_bg.png
  - Fill: hp_bar_fill.png (green → yellow → red)
  - Border: hp_bar_border.png

Score Display:
  - Panel: score_panel.png
  - Numbers: numbers_sprite_sheet.png (0-9)

Next Piece Preview:
  - Frame: preview_frame.png
  - Shows next 3 pieces in queue
```

### Icons
```
Size: 32×32 or 64×64
Files:
  - icon_settings.png
  - icon_audio.png
  - icon_profile.png
  - icon_friends.png
  - icon_achievements.png
  - [ability_name]_icon.png (one per ability)
```

## ✨ Visual Effects (VFX)

### Particle Systems

**Block Hit Particles**:
```
Count: 8-12
Life: 0.3-0.5s
Speed: 100-200 px/s
Size: 2×2px
Color: Block color
Behavior: Radial spread from impact
Gravity: Slight downward pull
```

**Ability Activation**:
```
Count: 20-30
Life: 0.5-1.0s
Speed: 50-150 px/s
Size: 3×3px
Color: Ability-specific
Behavior: Burst outward, fade
Glow: Yes
```

**Ball Trail**:
```
Count: Continuous
Life: 0.2s per particle
Speed: Follows ball
Size: 4×4px shrinking to 1×1px
Color: Ball type color
Opacity: 100% → 0%
```

### Screen Effects

**Camera Shake**:
```
Trigger: Heavy hits, abilities
Intensity: 2-5 pixels
Duration: 0.1-0.2s
Frequency: 30 Hz
```

**Flash Effects**:
```
Ability Activation: 0.05s white flash
Critical Hit: 0.1s yellow flash
Block Destroy: 0.05s block color flash
HP Low: Pulsing red vignette
```

**Slow Motion**:
```
Trigger: Clutch moments (ball barely saved)
Slowdown: 0.5× speed
Duration: 0.3s
Ease: Smooth in/out
```

## 🎬 Animations

### Timing Guidelines
- **Instant Feedback**: <50ms (button press)
- **Quick Actions**: 100-200ms (block placement)
- **Standard Actions**: 200-400ms (ability activation)
- **Dramatic Events**: 500-1000ms (victory/defeat)

### Animation Principles
1. **Anticipation**: Wind up before action
2. **Follow Through**: Complete the motion
3. **Squash & Stretch**: Exaggerate for emphasis
4. **Easing**: Never linear, always ease in/out
5. **Overlap**: Multiple animations cascade

### Key Animations

**Menu Transitions**:
```
Type: Fade + Slide
Duration: 300ms
Ease: Cubic ease out
Direction: Right to left (entering)
           Left to right (exiting)
```

**Victory/Defeat**:
```
Victory:
  - Duration: 2s
  - Screen brightens
  - Confetti particles
  - "VICTORY" text scales in
  - Music flourish

Defeat:
  - Duration: 1.5s
  - Screen desaturates
  - Slow motion
  - "DEFEAT" text fades in
  - Somber sound
```

## 🖼️ Asset Organization

### Directory Structure
```
assets/
├── sprites/
│   ├── blocks/
│   │   ├── i_piece/
│   │   │   ├── idle.png
│   │   │   ├── hit_1.png
│   │   │   └── destroyed_001.png ... 008.png
│   │   ├── o_piece/
│   │   └── ... (all pieces)
│   ├── ball/
│   │   ├── normal.png
│   │   ├── fire.png
│   │   └── ... (all types)
│   ├── paddle/
│   │   ├── idle.png
│   │   └── ... (all states)
│   └── ui/
│       ├── buttons/
│       ├── panels/
│       ├── icons/
│       └── hud/
├── effects/
│   ├── particles/
│   │   ├── block_fragments.png
│   │   ├── spark.png
│   │   └── glow.png
│   └── textures/
│       ├── gradient.png
│       └── noise.png
└── backgrounds/
    ├── menu_bg.png
    ├── game_bg.png
    └── victory_bg.png
```

## 🎨 Art Creation Guidelines

### Pixel Art Rules
1. **Consistent Resolution**: All assets same pixel ratio
2. **Limited Palette**: Stick to defined colors
3. **Anti-Aliasing**: Manual anti-aliasing only
4. **Dithering**: Use for gradients and shadows
5. **Outlines**: 1px dark outline for clarity

### Dos and Don'ts

**Do**:
✅ Use consistent light source (top-left)
✅ Apply subtle gradients with dithering
✅ Add highlights and shadows for depth
✅ Keep pixels clean and aligned
✅ Test at target resolution

**Don't**:
❌ Use automatic anti-aliasing
❌ Mix different pixel densities
❌ Over-detail small sprites
❌ Use too many colors
❌ Rotate sprites (except 90° increments)

## 🛠️ Tools Recommended

### Pixel Art Software
- **Aseprite** (Recommended) - Best for animation
- **Pyxel Edit** - Good for tilesets
- **GIMP** - Free alternative
- **Photoshop** - With pixel-perfect settings

### Animation Tools
- **Aseprite** - Pixel animation
- **Spine** - Skeletal animation (if needed)
- **After Effects** - VFX mockups

### Utilities
- **TexturePacker** - Sprite sheet creation
- **Tiled** - Level/board layout
- **Color Oracle** - Colorblind testing

## 📏 Export Settings

### PNG Export
```
Format: PNG-8 (indexed color) or PNG-24 (if alpha needed)
Compression: Maximum
Transparency: Yes (where needed)
Metadata: Remove all
```

### Sprite Sheets
```
Format: PNG-24
Padding: 2px between sprites
Max Size: 2048×2048
Naming: [object]_[animation]_sheet.png
Include: JSON metadata file
```

## ♿ Accessibility

### Color Blindness
- Test with Color Oracle or similar
- Provide colorblind mode option
- Use patterns in addition to colors
- High contrast mode available

### Visual Clarity
- Minimum 2px spacing between important elements
- Clear visual hierarchy
- Sufficient contrast ratios (WCAG AAA)
- Scalable UI elements

## 🎨 Placeholder Art

For development, create simple placeholders:
```
Blocks: Solid colored squares with piece letter
Ball: White circle
Paddle: White rectangle
Background: Solid dark color
UI: Gray rectangles with text labels
```

Replace with polished art once mechanics are solid.

## 📊 Performance Considerations

### Optimization
- Use sprite atlases/texture atlases
- Limit unique textures to <100
- Keep individual textures power of 2 when possible
- Use texture compression (platform-dependent)
- Minimize overdraw
- Batch similar sprites

### Memory Budget
- Total VRAM: <256MB
- Individual texture: <2048×2048
- Sprite atlas: Use efficiently
- Unload unused assets

---

**Last Updated**: 2026-01-05
**Status**: Complete Art Guide
**Version**: 1.0.0
