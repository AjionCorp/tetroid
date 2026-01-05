# Tetroid - System Architecture

## 🏛️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Steam Client                          │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │  Steam API  │  │ Achievements │  │  Friend System   │   │
│  └─────────────┘  └──────────────┘  └──────────────────┘   │
└───────────────────────┬─────────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                    Tetroid Client                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Game Engine Layer (Godot)               │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │   │
│  │  │ Renderer │  │  Physics  │  │  Input Manager  │  │   │
│  │  └──────────┘  └──────────┘  └──────────────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                 Game Logic Layer                      │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │   │
│  │  │GameState │  │  Blocks  │  │   Ball Physics   │  │   │
│  │  ├──────────┤  ├──────────┤  ├──────────────────┤  │   │
│  │  │Abilities │  │  Paddle  │  │   HP System      │  │   │
│  │  └──────────┘  └──────────┘  └──────────────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Networking Layer                         │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │   │
│  │  │ Netcode  │  │  Rollback │ │  Steam Sockets  │  │   │
│  │  ├──────────┤  ├──────────┤  ├──────────────────┤  │   │
│  │  │ Snapshot │  │  Predict  │  │   Matchmaking   │  │   │
│  │  └──────────┘  └──────────┘  └──────────────────┘  │   │
│  └──────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────────┘
                        │ WebSocket/Steam Networking
┌───────────────────────▼─────────────────────────────────────┐
│                   Game Server (Authoritative)                │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Server Game Engine                       │   │
│  │  ┌──────────────┐  ┌────────────┐  ┌────────────┐   │   │
│  │  │ Game Master  │  │ Validation │  │ Anti-Cheat │   │   │
│  │  ├──────────────┤  ├────────────┤  ├────────────┤   │   │
│  │  │   Tick Loop  │  │  Reconcile │  │  Security  │   │   │
│  │  └──────────────┘  └────────────┘  └────────────┘   │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Room Management                          │   │
│  │  ┌──────────────┐  ┌────────────┐  ┌────────────┐   │   │
│  │  │   Lobbies    │  │   Active   │  │Tournament  │   │   │
│  │  │              │  │   Matches  │  │  Manager   │   │   │
│  │  └──────────────┘  └────────────┘  └────────────┘   │   │
│  └──────────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────────┘
                        │ HTTP/gRPC/WebSocket
┌───────────────────────▼─────────────────────────────────────┐
│                    Backend Services                          │
│  ┌────────────┐  ┌────────────┐  ┌─────────────────────┐   │
│  │  Auth      │  │  Matchmaker│  │  Tournament Service │   │
│  │  Service   │  │  Service   │  │                     │   │
│  └────────────┘  └────────────┘  └─────────────────────┘   │
│  ┌────────────┐  ┌────────────┐  ┌─────────────────────┐   │
│  │  Ranking   │  │  Stats     │  │  Leaderboard Service│   │
│  │  Service   │  │  Service   │  │                     │   │
│  └────────────┘  └────────────┘  └─────────────────────┘   │
└───────────────────────┬─────────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────────┐
│                    Data Layer                                │
│  ┌────────────┐  ┌────────────┐  ┌─────────────────────┐   │
│  │ PostgreSQL │  │   Redis    │  │    RabbitMQ         │   │
│  │(Persistent)│  │  (Cache)   │  │  (Message Queue)    │   │
│  └────────────┘  └────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🎮 Core Game Architecture

### Game State Management

```
GameState (Server-Authoritative)
├── MatchState
│   ├── player_states: List[PlayerState]
│   ├── ball_state: BallState
│   ├── board_state: BoardState
│   ├── tick: u64
│   └── game_rules: GameRules
│
├── PlayerState
│   ├── player_id: UUID
│   ├── hp: i32
│   ├── score: i32
│   ├── paddle_position: Vector2
│   ├── placed_blocks: List[Block]
│   ├── next_pieces: Queue[TetrisPiece]
│   └── abilities_active: List[ActiveAbility]
│
├── BoardState
│   ├── grid: Array[60][62]
│   ├── neutral_zone: (y: 30-31)
│   └── territory_states: Map[PlayerId, TerritoryState]
│
└── BallState
    ├── position: Vector2
    ├── velocity: Vector2
    ├── type: BallType
    ├── damage: i32
    └── effects: List[BallEffect]
```

### Component-Based Entity System

```
Entity Component System (ECS)
│
├── Components
│   ├── Transform (position, rotation, scale)
│   ├── Sprite (texture, animation)
│   ├── Physics (velocity, mass, collision)
│   ├── Health (current, max, regeneration)
│   ├── Block (type, ability, cooldown)
│   ├── Ball (damage, speed_multiplier)
│   ├── Paddle (width, special_ability)
│   ├── NetworkSync (owner, tick, prediction)
│   └── AudioSource (sound, volume, 3d_position)
│
├── Systems (Update Order)
│   ├── 1. InputSystem (process player input)
│   ├── 2. AISystem (AI decision making)
│   ├── 3. AbilitySystem (process abilities)
│   ├── 4. PhysicsSystem (move entities, collisions)
│   ├── 5. BlockSystem (block behavior)
│   ├── 6. BallSystem (ball mechanics)
│   ├── 7. PaddleSystem (paddle movement)
│   ├── 8. HealthSystem (HP changes, death)
│   ├── 9. ScoreSystem (scoring logic)
│   ├── 10. RenderSystem (draw to screen)
│   ├── 11. AudioSystem (play sounds)
│   ├── 12. NetworkSystem (sync state)
│   └── 13. UISystem (update UI)
│
└── Resources (Shared Global State)
    ├── GameTime
    ├── InputState
    ├── AssetManager
    ├── NetworkConnection
    └── GameSettings
```

## 🌐 Networking Architecture

### Client-Server Model with Rollback

```
Client Side:
┌─────────────────────────────────────────┐
│  1. Capture Input (tick N)              │
│  2. Send to Server immediately          │
│  3. Predict local state (tick N+1)      │
│  4. Continue simulating (tick N+2, N+3) │
│  5. Receive server state (tick N)       │
│  6. Compare with prediction             │
│  7. If mismatch: rollback & resimulate  │
│  8. Render current state                │
└─────────────────────────────────────────┘

Server Side:
┌─────────────────────────────────────────┐
│  1. Receive inputs from all clients     │
│  2. Validate inputs (anti-cheat)        │
│  3. Simulate tick N                     │
│  4. Apply game rules                    │
│  5. Broadcast state to all clients      │
│  6. Store snapshot for reconciliation   │
└─────────────────────────────────────────┘
```

### Network Protocol

```
Message Types:
├── Client → Server
│   ├── INPUT { tick, player_id, action, data }
│   ├── READY { player_id }
│   ├── PAUSE_REQUEST { player_id }
│   └── CHAT { player_id, message }
│
├── Server → Client
│   ├── GAME_STATE { tick, full_state }
│   ├── DELTA_STATE { tick, changes }
│   ├── EVENT { type, data }
│   ├── MATCH_START { settings }
│   └── MATCH_END { results }
│
└── Bidirectional
    ├── PING { timestamp }
    ├── PONG { timestamp }
    └── DISCONNECT { player_id, reason }
```

### Lag Compensation Strategies

1. **Client-Side Prediction**: Immediate visual feedback
2. **Server Reconciliation**: Authority on game state
3. **Input Buffer**: Handle variable latency
4. **Interpolation**: Smooth remote player movements
5. **Extrapolation**: Predict future positions
6. **Snapshot System**: Store past states for rewind

## 🤖 AI System Architecture

```
AI Opponent System
├── Difficulty Levels
│   ├── Easy (reaction: 300ms, error: 30%)
│   ├── Normal (reaction: 150ms, error: 15%)
│   ├── Hard (reaction: 80ms, error: 5%)
│   └── Expert (reaction: 30ms, error: 1%)
│
├── Decision Making (Behavior Tree)
│   ├── Strategic Layer
│   │   ├── Analyze board state
│   │   ├── Evaluate threats
│   │   ├── Choose placement strategy
│   │   └── Select ability timing
│   │
│   ├── Tactical Layer
│   │   ├── Paddle positioning
│   │   ├── Ball prediction
│   │   ├── Piece placement
│   │   └── Defense priority
│   │
│   └── Execution Layer
│       ├── Input generation
│       ├── Timing simulation
│       └── Error injection (difficulty)
│
├── Learning System (Optional)
│   ├── Collect match data
│   ├── Analyze winning strategies
│   ├── Update behavior weights
│   └── Adapt to player style
│
└── Testing AI
    ├── Self-play training
    ├── Balance validation
    └── Difficulty calibration
```

## 💾 Data Architecture

### Database Schema (PostgreSQL)

```sql
-- Players
CREATE TABLE players (
    id UUID PRIMARY KEY,
    steam_id BIGINT UNIQUE NOT NULL,
    username VARCHAR(32) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP,
    total_matches INTEGER DEFAULT 0,
    total_wins INTEGER DEFAULT 0,
    ranking_elo INTEGER DEFAULT 1000
);

-- Matches
CREATE TABLE matches (
    id UUID PRIMARY KEY,
    game_mode VARCHAR(16) NOT NULL, -- '1v1', '2v2', 'ffa'
    is_ranked BOOLEAN DEFAULT FALSE,
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP,
    winner_id UUID REFERENCES players(id),
    match_data JSONB -- Full replay data
);

-- Match Participants
CREATE TABLE match_participants (
    match_id UUID REFERENCES matches(id),
    player_id UUID REFERENCES players(id),
    team INTEGER,
    final_score INTEGER,
    blocks_placed INTEGER,
    abilities_used INTEGER,
    elo_change INTEGER,
    PRIMARY KEY (match_id, player_id)
);

-- Rankings
CREATE TABLE rankings (
    season_id INTEGER,
    player_id UUID REFERENCES players(id),
    game_mode VARCHAR(16),
    elo INTEGER DEFAULT 1000,
    wins INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    peak_elo INTEGER,
    PRIMARY KEY (season_id, player_id, game_mode)
);

-- Tournaments
CREATE TABLE tournaments (
    id UUID PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    format VARCHAR(32), -- 'single_elim', 'double_elim', 'round_robin'
    start_time TIMESTAMP,
    status VARCHAR(16), -- 'registration', 'in_progress', 'completed'
    prize_pool INTEGER,
    max_participants INTEGER
);

-- Statistics
CREATE TABLE player_statistics (
    player_id UUID REFERENCES players(id),
    stat_date DATE,
    matches_played INTEGER DEFAULT 0,
    favorite_block VARCHAR(32),
    average_blocks_per_match FLOAT,
    win_rate FLOAT,
    PRIMARY KEY (player_id, stat_date)
);
```

### Cache Strategy (Redis)

```
Key Patterns:
├── session:{session_id} → SessionData (TTL: 24h)
├── player:{player_id}:profile → PlayerProfile (TTL: 1h)
├── lobby:{lobby_id} → LobbyState (TTL: until game starts)
├── match:{match_id}:state → LiveMatchState (TTL: match duration)
├── leaderboard:{mode}:{season} → SortedSet (updated real-time)
├── matchmaking:queue:{mode} → Queue of player IDs
└── stats:{player_id}:live → Real-time match stats
```

## 🔐 Security Architecture

### Anti-Cheat System

```
Validation Layers:
├── Client-Side (Detection Only)
│   ├── Memory integrity checks
│   ├── Process monitoring
│   └── Input pattern analysis
│
├── Server-Side (Authoritative)
│   ├── Input validation
│   │   ├── Rate limiting
│   │   ├── Physics validation
│   │   ├── Timing validation
│   │   └── State validation
│   │
│   ├── Behavior Analysis
│   │   ├── Impossible actions
│   │   ├── Statistical anomalies
│   │   └── Pattern recognition
│   │
│   └── Reputation System
│       ├── Report aggregation
│       ├── Automatic flagging
│       └── Manual review queue
│
└── Steam Integration
    ├── VAC (Valve Anti-Cheat)
    ├── Game bans
    └── Account reputation
```

### Data Security

- **Encryption**: TLS 1.3 for all network traffic
- **Authentication**: Steam OAuth + JWT tokens
- **Authorization**: Role-based access control
- **Input Sanitization**: All client inputs validated
- **Rate Limiting**: Prevent DoS attacks
- **Secure Storage**: Encrypted sensitive data

## 📊 Performance Architecture

### Optimization Strategies

```
Client Performance:
├── Rendering
│   ├── Sprite batching
│   ├── Object pooling
│   ├── Culling (off-screen objects)
│   └── Level-of-detail (for effects)
│
├── Physics
│   ├── Spatial hashing for collisions
│   ├── Fixed timestep
│   └── Simplified collision shapes
│
├── Memory
│   ├── Asset streaming
│   ├── Texture atlases
│   └── Audio compression
│
└── Network
    ├── Delta compression
    ├── Prediction to hide latency
    └── Adaptive quality

Server Performance:
├── Horizontal Scaling
│   ├── Load balancer
│   ├── Multiple game servers
│   └── Region-based distribution
│
├── Resource Management
│   ├── Connection pooling
│   ├── Worker thread pool
│   └── Memory-mapped files for replays
│
└── Optimization
    ├── ECS for efficient updates
    ├── Deterministic simulation
    └── Profiling and metrics
```

### Monitoring & Telemetry

```
Metrics to Track:
├── Client Metrics
│   ├── FPS
│   ├── Frame time
│   ├── Network latency
│   ├── Packet loss
│   └── Memory usage
│
├── Server Metrics
│   ├── Tick rate
│   ├── Player count
│   ├── CPU/Memory usage
│   ├── Network bandwidth
│   └── Match duration
│
└── Business Metrics
    ├── DAU/MAU
    ├── Retention rates
    ├── Match completion rate
    ├── Average session length
    └── Concurrent players
```

## 🛠️ Build & Deployment

### CI/CD Pipeline

```
Commit → GitHub
    ↓
Automated Tests
    ├── Unit Tests
    ├── Integration Tests
    └── Performance Tests
    ↓
Build Artifacts
    ├── Windows Build
    ├── Linux Build
    └── Mac Build (optional)
    ↓
Staging Deployment
    ├── Internal Testing
    ├── QA Validation
    └── Performance Check
    ↓
Production Deployment
    ├── Canary Release (10%)
    ├── Monitor Metrics
    └── Full Rollout
    ↓
Steam Upload
    ├── Patch Notes
    ├── Version Update
    └── CDN Distribution
```

---

**Last Updated**: 2026-01-05
**Status**: Template Complete
