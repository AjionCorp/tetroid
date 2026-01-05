# Tetroid - Quick Start Guide

## 🚀 Running the Project

### Prerequisites
1. **Install Godot 4.2+**
   - Download from: https://godotengine.org/download
   - Choose "Godot Engine - .NET" or standard version

### Open Project
```bash
# Option 1: From Godot Project Manager
1. Open Godot
2. Click "Import"
3. Navigate to this directory
4. Select "project.godot"
5. Click "Import & Edit"

# Option 2: From command line
godot --path . --editor
```

### Run the Game
```bash
# In Godot Editor
Press F5 or click "Run Project" button

# From command line
godot --path . res://main.tscn
```

## ✅ What You'll See

When you run the project, you should see:
- **Background**: Dark game board (60×62 grid)
- **Grid Lines**: Visual grid showing all cells
- **Neutral Zone**: Highlighted 2-row zone in the middle
- **Text**: "TETROID - Code-Driven Development"
- **FPS Counter**: Top-left showing 60 FPS

## 🎯 What's Implemented

### Core Systems ✅
- **Main Entry Point** (`src/main.gd`)
- **60 FPS Game Loop** with fixed timestep
- **Constants System** - All game values
- **Configuration Loader** - JSON-based settings
- **Block Data System** - 7 Tetris pieces defined
- **Asset Registry** - Hybrid procedural/external assets

### Procedural Generation ✅
- **Sprite Generator** - Creates block textures on the fly
- **Audio Generator** - Synthesizes sound effects
- **Grid Rendering** - Programmatic visual board

### Project Structure ✅
```
src/
├── main.gd                     # Bootstrap entry point
├── core/
│   ├── constants.gd           # All constants
│   ├── config.gd              # Configuration loader
│   ├── game.gd                # Main game class
│   └── asset_registry.gd      # Asset management
├── data/
│   ├── blocks.json            # Block definitions
│   ├── config.json            # Game settings
│   └── block_data.gd          # Data loader
└── generators/
    ├── sprite_generator.gd    # Procedural sprites
    └── audio_generator.gd     # Procedural audio
```

## 🔧 Development

### Code-Driven Philosophy
Everything is created in code - no visual editors used except for initial project setup.

See **[.template/docs/CODE_DRIVEN_DEVELOPMENT.md](/.template/docs/CODE_DRIVEN_DEVELOPMENT.md)** for complete guide.

### Making Changes

**1. Modify Block Colors:**
```gdscript
# Edit src/data/blocks.json
{
  "I_PIECE": {
    "color": "#FF0000"  // Change to red
  }
}
```

**2. Change Board Size:**
```gdscript
# Edit src/core/constants.gd
const BOARD_WIDTH: int = 80  // Make wider
const BOARD_HEIGHT: int = 80  // Make taller
```

**3. Add New Features:**
```gdscript
# All features added through code
# See documentation for patterns
```

## 🎮 Controls (Configured)

### Player 1
- **Left**: A / Left Arrow
- **Right**: D / Right Arrow
- **Rotate Left**: Q
- **Rotate Right**: E
- **Place Block**: Space / Enter
- **Use Ability**: F

*Note: Input system not yet connected to gameplay*

## 📚 Documentation

### Essential Reading
- **[Getting Started](/.template/docs/GETTING_STARTED.md)** - Development guide
- **[Code-Driven Dev](/.template/docs/CODE_DRIVEN_DEVELOPMENT.md)** - Our approach
- **[Architecture](/.template/docs/ARCHITECTURE.md)** - System design
- **[Game Design](/.template/docs/GAME_DESIGN.md)** - Complete mechanics

### Complete Index
See **[Documentation Index](/.template/docs/INDEX.md)** for all docs.

## 🐛 Troubleshooting

### "Can't find class_name"
**Solution**: Godot needs to parse scripts first
```bash
# In Godot Editor:
Project → Reload Current Project
```

### "Errors in scripts"
**Solution**: Check if all files were created
```bash
# Verify core files exist:
ls src/core/
ls src/generators/
ls src/data/
```

### "Black screen"
**Solution**: Check console for errors
```bash
# Look for error messages in Output panel
# Most likely a missing file or typo
```

## ✨ Next Steps

### Immediate Tasks
1. ✅ Project runs and shows grid
2. ⏳ Implement input system
3. ⏳ Create block entities
4. ⏳ Add ball physics
5. ⏳ Implement paddle

### Follow the Roadmap
See **[Development Roadmap](/.template/plans/DEVELOPMENT_ROADMAP.md)** for complete timeline.

## 🤝 Contributing

For AI agents: Follow **[Agent Guidelines](/.template/docs/AGENT_GUIDELINES.md)**

## 📞 Help

- Check **[FAQ](/.template/docs/FAQ.md)**
- Review documentation in `.template/docs/`
- Check git log for recent changes

---

**Status**: Foundation Complete ✅  
**Next Milestone**: Core Mechanics (Blocks + Ball)  
**Version**: 0.1.0-dev
