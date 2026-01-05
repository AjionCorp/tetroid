# Tetroid - Multi-Agent Game Development Template

> **🚨 AI AGENTS: READ THIS FIRST → [AGENT_START_HERE.md](AGENT_START_HERE.md)**

## 🎮 Game Overview

**Tetroid** is a competitive multiplayer game combining elements of Tetris, Arkanoid, and Mechabellum. Players strategically place Tetris blocks with unique abilities while managing ball physics in a split-screen arena.

### Core Concept
- **Genre**: Competitive Strategy + Action
- **Players**: 1v1, 2v2, 4-player FFA
- **Platform**: Steam (PC)
- **Art Style**: Retro Pixel Graphics
- **Engine**: Godot 4.x (recommended) or Unity with ECS

## 🎯 Quick Start for AI Agents

### Before You Start
1. Read `/docs/ARCHITECTURE.md` for system design
2. Check `/docs/CURRENT_STATE.md` for project status
3. Review `/docs/AGENT_GUIDELINES.md` for collaboration rules
4. See `/docs/GAME_DESIGN.md` for complete game mechanics

### Making Changes
1. Update `/docs/CURRENT_STATE.md` with what you're working on
2. Follow coding standards in `/docs/CODING_STANDARDS.md`
3. Run tests before committing
4. Update documentation as you build
5. Log decisions in `/docs/DECISIONS.md`

## 📁 Repository Structure

```
Tetroid/
├── .template/              # This template - DO NOT MODIFY
│   ├── docs/              # All documentation
│   ├── plans/             # Development plans & roadmaps
│   └── assets/            # Design assets & references
├── src/                   # Source code
│   ├── core/              # Core game engine
│   ├── gameplay/          # Game mechanics
│   ├── multiplayer/       # Networking
│   ├── ai/                # AI opponents
│   ├── ui/                # User interface
│   └── steam/             # Steam integration
├── tests/                 # All tests
├── assets/                # Game assets
│   ├── sprites/           # Pixel art
│   ├── audio/             # Sound effects & music
│   └── vfx/               # Visual effects
└── tools/                 # Development tools
```

## 🚀 Technology Stack

### Development Philosophy
- **100% Code-Driven** - No visual editors, all code
- **AI-Friendly** - Maximum automation, minimal manual work
- **Procedural Generation** - Assets generated programmatically
- **Data-Driven** - Configuration via JSON, not hardcoded

### Core Engine
- **Primary**: Godot 4.5 (GDScript)
  - Code-first development
  - Native networking
  - Excellent 2D support
  - Built-in physics
  - Text-based scene files (git-friendly)
  - Easy Steam integration via plugins
  
- **Alternative**: Raylib (Pure C)
  - 100% code, no editor
  - Ultimate control
  - Lightweight

### Networking
- **Steam Networking API** (primary matchmaking)
- **Custom Server** (tournaments, ranked)
- **WebSocket** fallback
- **Netcode Pattern**: Client-Server with rollback for critical gameplay

### Backend
- **Language**: Rust or Go (high performance)
- **Database**: PostgreSQL (player data, rankings)
- **Cache**: Redis (matchmaking, sessions)
- **Message Queue**: RabbitMQ (tournament system)

### DevOps
- **CI/CD**: GitHub Actions
- **Testing**: Unit, Integration, Load tests
- **Monitoring**: Prometheus + Grafana
- **Deployment**: Docker + Kubernetes

## 🎲 Game Mechanics Summary

### Board Layout
- **Width**: 60 blocks
- **Height**: 62 blocks total
  - Player 1: Top 30 blocks
  - Neutral Zone: Middle 2 blocks (no placement)
  - Player 2: Bottom 30 blocks

### Core Gameplay Loop
1. Players start with 5 blocks placed
2. Tetris pieces drop (can see next 3-5 pieces)
3. Place pieces in your territory or enemy territory
4. Placement location affects block abilities
5. Ball bounces between territories hitting blocks
6. Blocks activate abilities when hit
7. Paddle deflects ball (can gain abilities)
8. Missed balls reduce HP
9. First to 0 HP loses

### Block Abilities
- Offensive: Damage, speed up ball, spawn obstacles
- Defensive: Shield, slow ball, heal HP
- Utility: Block transformation, chain reactions
- Special: Territory control, board manipulation

## 🏗️ Development Phases

### Phase 1: Foundation (Weeks 1-3)
- Core engine setup
- Basic block placement
- Ball physics
- Single-player prototype

### Phase 2: Core Mechanics (Weeks 4-6)
- Block ability system
- HP system
- Paddle mechanics
- Game rules implementation

### Phase 3: Multiplayer (Weeks 7-10)
- Networking layer
- Room system
- Matchmaking
- Lag compensation

### Phase 4: AI & Content (Weeks 11-13)
- AI opponent system
- Block balancing
- More abilities
- Visual/audio polish

### Phase 5: Steam & Testing (Weeks 14-16)
- Steam integration
- Tournament system
- Beta testing
- Performance optimization

### Phase 6: Launch (Week 17+)
- Final polish
- Marketing materials
- Steam page setup
- Launch!

## 📊 Performance Targets

- **FPS**: 60 (locked)
- **Network Latency**: <50ms optimal, <100ms acceptable
- **Tick Rate**: 60 Hz (client), 30 Hz (server)
- **Max Players per Server**: 4 active + spectators
- **Load Time**: <3 seconds to game

## 🔐 Security Considerations

- Server-authoritative gameplay
- Anti-cheat validation
- Input sanitization
- Rate limiting
- Encrypted communications

## 📝 Documentation Index

1. `/docs/ARCHITECTURE.md` - System architecture
2. `/docs/GAME_DESIGN.md` - Complete game design document
3. `/docs/API.md` - API specifications
4. `/docs/NETWORKING.md` - Multiplayer implementation
5. `/docs/AI_SYSTEM.md` - AI opponent design
6. `/docs/STEAM_INTEGRATION.md` - Steam features
7. `/docs/AGENT_GUIDELINES.md` - Multi-agent workflow
8. `/docs/CODING_STANDARDS.md` - Code style guide
9. `/docs/TESTING.md` - Testing strategy
10. `/docs/DEPLOYMENT.md` - Deployment guide

## 🤝 Contributing (For AI Agents)

### Agent Roles
- **Architect**: System design, performance optimization
- **Gameplay**: Core mechanics, balancing
- **Network**: Multiplayer, Steam integration
- **AI**: Bot opponents, difficulty scaling
- **UI/UX**: Interface, menus, feedback
- **Audio**: Sound effects, music
- **Graphics**: Sprites, VFX, animations
- **QA**: Testing, bug fixing

### Workflow
1. Check `/docs/CURRENT_STATE.md` for active tasks
2. Claim a task by updating the document
3. Implement following standards
4. Write tests
5. Update documentation
6. Self-review code
7. Mark task complete

## 🐛 Known Issues & Improvements

See `/docs/ISSUES.md` for current bugs and enhancement requests.

## 📈 Metrics & Analytics

Track in `/docs/METRICS.md`:
- Player retention
- Match duration
- Block usage statistics
- Win rates
- Network performance

## 🎨 Asset Creation Guidelines

See `/docs/ART_GUIDE.md` for:
- Pixel art standards (16x16 base unit)
- Color palette
- Animation guidelines
- Effect specifications

## 🎵 Audio Guidelines

See `/docs/AUDIO_GUIDE.md` for:
- Sound effect specifications
- Music style
- Mixing guidelines
- Implementation

---

**Last Updated**: 2026-01-05
**Template Version**: 1.0.0
**Status**: Initial Setup
