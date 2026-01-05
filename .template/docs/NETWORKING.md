# Networking & Multiplayer Implementation

## 🌐 Overview

This document details the networking architecture for Tetroid's multiplayer functionality, covering protocols, synchronization, lag compensation, and anti-cheat measures.

## 🏗️ Network Architecture

### Client-Server Model

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Client 1   │────▶│              │◀────│   Client 2   │
│  (Player 1)  │     │  Game Server │     │  (Player 2)  │
└──────────────┘     │ (Authority)  │     └──────────────┘
                     │              │
┌──────────────┐     │              │     ┌──────────────┐
│   Client 3   │────▶│              │◀────│   Client 4   │
│  (Player 3)  │     │              │     │  (Player 4)  │
└──────────────┘     └──────────────┘     └──────────────┘
```

**Why Client-Server**:
- Server has authority (anti-cheat)
- Easier to synchronize state
- Single source of truth
- Simpler than peer-to-peer for 4+ players

## 📡 Network Protocol

### Message Types

```python
class MessageType(Enum):
    # Connection
    CONNECT = 0x00
    DISCONNECT = 0x01
    PING = 0x02
    PONG = 0x03
    
    # Lobby
    CREATE_LOBBY = 0x10
    JOIN_LOBBY = 0x11
    LEAVE_LOBBY = 0x12
    LOBBY_STATE = 0x13
    PLAYER_READY = 0x14
    START_GAME = 0x15
    
    # Game State
    GAME_START = 0x20
    GAME_STATE_FULL = 0x21
    GAME_STATE_DELTA = 0x22
    GAME_EVENT = 0x23
    GAME_END = 0x24
    
    # Input
    PLAYER_INPUT = 0x30
    INPUT_ACK = 0x31
    
    # Chat
    CHAT_MESSAGE = 0x40
    EMOTE = 0x41
```

### Message Format

**Binary Protocol** (Efficient for real-time gameplay):

```
Message Structure (Little Endian):
┌────────┬──────────┬────────┬─────────┬─────────────┐
│ Header │ Protocol │ Msg ID │ Payload │  Checksum   │
│ 4 bytes│  1 byte  │ 2 bytes│ N bytes │   4 bytes   │
└────────┴──────────┴────────┴─────────┴─────────────┘

Header:
- 0xTETR (Magic number: 0x54455452)

Protocol Version:
- Current: 0x01

Message ID:
- Sequence number for ordering

Payload:
- Message type (1 byte)
- Compressed data (variable)

Checksum:
- CRC32 for validation
```

### Example Messages

**PLAYER_INPUT**:
```python
{
    "type": MessageType.PLAYER_INPUT,
    "tick": 1234,                    # Client tick number
    "player_id": "uuid-123",
    "actions": [
        {
            "type": "MOVE_PADDLE",
            "x": 450.5,              # Paddle X position
            "timestamp": 1234567890
        },
        {
            "type": "PLACE_BLOCK",
            "piece": "I_PIECE",
            "position": {"x": 10, "y": 5},
            "rotation": 0,
            "timestamp": 1234567900
        }
    ]
}
```

**GAME_STATE_FULL** (Initial sync):
```python
{
    "type": MessageType.GAME_STATE_FULL,
    "tick": 1234,
    "timestamp": 1234567890,
    "players": [
        {
            "id": "uuid-123",
            "hp": 100,
            "score": 250,
            "paddle_x": 450.5,
            "next_pieces": ["I_PIECE", "T_PIECE", "O_PIECE"]
        },
        # ... more players
    ],
    "blocks": [
        {
            "id": 1,
            "type": "I_PIECE",
            "owner": "uuid-123",
            "position": {"x": 10, "y": 5},
            "rotation": 0,
            "hp": 3,
            "ability_cooldown": 0.5
        },
        # ... more blocks
    ],
    "balls": [
        {
            "id": 1,
            "position": {"x": 300.0, "y": 400.0},
            "velocity": {"x": 200.0, "y": -350.0},
            "type": "NORMAL",
            "owner": "uuid-123"
        }
    ],
    "game_time": 125.5,
    "game_mode": "1v1"
}
```

**GAME_STATE_DELTA** (Updates only changes):
```python
{
    "type": MessageType.GAME_STATE_DELTA,
    "tick": 1235,
    "base_tick": 1234,               # Previous state
    "changes": [
        {
            "entity": "ball",
            "id": 1,
            "position": {"x": 305.0, "y": 390.0}
        },
        {
            "entity": "player",
            "id": "uuid-123",
            "hp": 95,                # Took damage
            "score": 260             # Gained points
        },
        {
            "entity": "block",
            "id": 1,
            "hp": 2,                 # Block hit
            "ability_cooldown": 5.0  # Ability activated
        }
    ],
    "events": [
        {
            "type": "BLOCK_HIT",
            "block_id": 1,
            "ball_id": 1,
            "damage": 10
        }
    ]
}
```

## ⏱️ Tick System

### Server Tick Rate

**Target**: 30 Hz (33.33ms per tick)
- Balance between accuracy and bandwidth
- Sufficient for Tetroid's gameplay speed
- Industry standard for competitive games

```python
class GameServer:
    TICK_RATE = 30  # Hz
    TICK_DURATION = 1.0 / TICK_RATE  # ~33ms
    
    def game_loop(self):
        last_tick_time = time.time()
        tick_number = 0
        
        while self.running:
            current_time = time.time()
            delta_time = current_time - last_tick_time
            
            if delta_time >= self.TICK_DURATION:
                # Fixed timestep update
                self.update_game_state(self.TICK_DURATION)
                self.broadcast_state(tick_number)
                
                tick_number += 1
                last_tick_time = current_time
                
                # Handle tick overflow
                if tick_number > 0xFFFF:
                    tick_number = 0
            else:
                # Sleep to avoid busy-waiting
                sleep_time = self.TICK_DURATION - delta_time
                time.sleep(max(0, sleep_time * 0.9))  # Sleep 90% to avoid oversleep
```

### Client Tick Rate

**Target**: 60 Hz (16.67ms per tick)
- Smooth local prediction
- Matches display refresh rate
- Interpolates between server updates

## 🔄 State Synchronization

### Client-Side Prediction

```python
class GameClient:
    def __init__(self):
        self.server_state = None
        self.predicted_state = None
        self.input_buffer = []
        self.last_acked_tick = 0
    
    def process_input(self, input_action):
        tick = self.current_tick
        
        # 1. Send to server immediately
        self.send_input_to_server(tick, input_action)
        
        # 2. Apply locally (prediction)
        self.predicted_state.apply_input(tick, input_action)
        
        # 3. Store for reconciliation
        self.input_buffer.append({
            "tick": tick,
            "input": input_action
        })
    
    def on_server_state_received(self, server_state):
        # 4. Compare prediction with server
        prediction_error = self.check_prediction_error(
            self.predicted_state,
            server_state
        )
        
        if prediction_error > TOLERANCE:
            # 5. Rollback and replay
            self.rollback_and_resimulate(server_state)
        else:
            # Prediction was correct
            self.server_state = server_state
            self.clean_old_inputs(server_state.tick)
    
    def rollback_and_resimulate(self, server_state):
        # Reset to authoritative state
        self.predicted_state = server_state.clone()
        
        # Replay all inputs after this state
        for buffered_input in self.input_buffer:
            if buffered_input["tick"] > server_state.tick:
                self.predicted_state.apply_input(
                    buffered_input["tick"],
                    buffered_input["input"]
                )
```

### Server Reconciliation

```python
class GameServer:
    def process_client_input(self, player_id, tick, input_action):
        player = self.get_player(player_id)
        
        # Validate tick is reasonable
        if tick < player.last_processed_tick:
            # Too old, ignore
            return
        
        if tick > player.last_processed_tick + MAX_TICK_AHEAD:
            # Too far ahead, suspicious
            self.flag_potential_cheat(player_id)
            return
        
        # Validate input is physically possible
        if not self.is_input_valid(player, input_action):
            # Impossible input
            self.flag_potential_cheat(player_id)
            return
        
        # Apply input to game state
        self.game_state.apply_input(player_id, input_action)
        
        # Send acknowledgment
        self.send_input_ack(player_id, tick)
        
        # Update last processed
        player.last_processed_tick = tick
```

## 🕐 Lag Compensation

### Techniques Used

#### 1. Client-Side Prediction
- Immediate visual feedback
- Hide network latency
- Rollback on mismatch

#### 2. Server-Side Rewinding
```python
class GameServer:
    def __init__(self):
        self.state_history = []  # Store last 1 second of states
        self.MAX_HISTORY = 30    # 1 second at 30 Hz
    
    def store_state_snapshot(self, tick):
        snapshot = self.game_state.clone()
        self.state_history.append({
            "tick": tick,
            "timestamp": time.time(),
            "state": snapshot
        })
        
        # Limit history size
        if len(self.state_history) > self.MAX_HISTORY:
            self.state_history.pop(0)
    
    def validate_hit_with_lag_compensation(self, player_id, ball_hit):
        player = self.get_player(player_id)
        latency = player.average_latency
        
        # Rewind to when player actually saw the game state
        past_tick = self.current_tick - int(latency * self.TICK_RATE / 1000)
        past_state = self.get_state_at_tick(past_tick)
        
        # Validate hit using past state
        if past_state.is_ball_hit_valid(ball_hit):
            # Apply hit to current state
            self.game_state.apply_ball_hit(ball_hit)
            return True
        
        return False
```

#### 3. Interpolation (Smoothing)
```python
class GameClient:
    INTERPOLATION_DELAY = 100  # ms (3 server ticks)
    
    def render_remote_entities(self):
        # Render entities slightly in the past for smoothness
        render_time = self.current_time - self.INTERPOLATION_DELAY
        
        for entity in self.remote_entities:
            # Find two states to interpolate between
            state_before = self.find_state_before(entity, render_time)
            state_after = self.find_state_after(entity, render_time)
            
            if state_before and state_after:
                # Linear interpolation
                t = (render_time - state_before.time) / \
                    (state_after.time - state_before.time)
                
                interpolated_position = lerp(
                    state_before.position,
                    state_after.position,
                    t
                )
                
                entity.visual_position = interpolated_position
```

#### 4. Input Buffering
```python
class InputBuffer:
    def __init__(self, buffer_size=3):
        self.buffer = []
        self.buffer_size = buffer_size
    
    def add_input(self, input_action, timestamp):
        self.buffer.append({
            "input": input_action,
            "timestamp": timestamp
        })
        
        # Maintain buffer size
        if len(self.buffer) > self.buffer_size:
            self.buffer.pop(0)
    
    def get_input_for_tick(self, tick):
        # Return input if available, or last known input
        if self.buffer:
            # Use most recent input
            return self.buffer[-1]["input"]
        return None  # No input
```

## 🔐 Anti-Cheat Measures

### Server-Side Validation

```python
class ServerValidator:
    def validate_paddle_movement(self, player, new_position):
        old_position = player.paddle.position
        delta_time = 1.0 / self.TICK_RATE
        max_distance = player.paddle.speed * delta_time * 1.1  # 10% tolerance
        
        actual_distance = abs(new_position - old_position)
        
        if actual_distance > max_distance:
            # Impossible movement speed
            return False, "Movement too fast"
        
        if new_position < 0 or new_position > BOARD_WIDTH:
            # Out of bounds
            return False, "Out of bounds"
        
        return True, None
    
    def validate_block_placement(self, player, block_placement):
        # Check placement is in valid area
        if not self.is_position_valid(block_placement.position):
            return False, "Invalid position"
        
        # Check no overlap with existing blocks
        if self.has_overlap(block_placement):
            return False, "Overlaps existing block"
        
        # Check player has this piece in queue
        if block_placement.piece not in player.piece_queue:
            return False, "Piece not in queue"
        
        # Check placement timing (not too fast)
        time_since_last = time.time() - player.last_placement_time
        if time_since_last < MIN_PLACEMENT_INTERVAL:
            return False, "Placement too fast"
        
        return True, None
    
    def validate_ability_activation(self, player, ability):
        block = self.game_state.get_block(ability.block_id)
        
        # Check block belongs to player
        if block.owner != player.id:
            return False, "Not player's block"
        
        # Check ability is off cooldown
        if block.ability_cooldown > 0:
            return False, "Ability on cooldown"
        
        # Check block still exists
        if not block.is_alive():
            return False, "Block destroyed"
        
        return True, None
```

### Anomaly Detection

```python
class AntiCheatMonitor:
    def __init__(self):
        self.player_stats = {}
        self.suspicious_actions = []
    
    def track_player_action(self, player_id, action_type, success):
        if player_id not in self.player_stats:
            self.player_stats[player_id] = {
                "paddle_hits": [],
                "placement_accuracy": [],
                "reaction_times": []
            }
        
        stats = self.player_stats[player_id]
        
        if action_type == "paddle_hit":
            stats["paddle_hits"].append({
                "success": success,
                "timestamp": time.time()
            })
            
            # Check for impossible accuracy
            recent_hits = stats["paddle_hits"][-20:]  # Last 20 attempts
            if len(recent_hits) >= 20:
                accuracy = sum(1 for h in recent_hits if h["success"]) / 20
                
                if accuracy > 0.98:  # >98% is suspicious
                    self.flag_suspicious(
                        player_id,
                        "Impossible paddle accuracy",
                        {"accuracy": accuracy}
                    )
    
    def flag_suspicious(self, player_id, reason, data):
        self.suspicious_actions.append({
            "player_id": player_id,
            "timestamp": time.time(),
            "reason": reason,
            "data": data
        })
        
        # Auto-action on repeated flags
        player_flags = [
            a for a in self.suspicious_actions 
            if a["player_id"] == player_id
        ]
        
        if len(player_flags) >= 5:
            self.kick_player(player_id, "Multiple cheat flags")
```

### Encryption & Security

```python
# All network traffic encrypted with TLS
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

class SecureConnection:
    def __init__(self):
        self.aes_key = get_random_bytes(32)  # 256-bit key
        self.cipher = AES.new(self.aes_key, AES.MODE_GCM)
    
    def encrypt_message(self, plaintext):
        nonce = get_random_bytes(12)
        ciphertext, tag = self.cipher.encrypt_and_digest(plaintext)
        return nonce + tag + ciphertext
    
    def decrypt_message(self, encrypted):
        nonce = encrypted[:12]
        tag = encrypted[12:28]
        ciphertext = encrypted[28:]
        
        cipher = AES.new(self.aes_key, AES.MODE_GCM, nonce=nonce)
        plaintext = cipher.decrypt_and_verify(ciphertext, tag)
        return plaintext
```

## 📊 Bandwidth Optimization

### Delta Compression

```python
class StateCompressor:
    def create_delta(self, previous_state, current_state):
        delta = {
            "tick": current_state.tick,
            "base_tick": previous_state.tick,
            "changes": []
        }
        
        # Only send changed values
        for entity_id, entity in current_state.entities.items():
            if entity_id not in previous_state.entities:
                # New entity
                delta["changes"].append({
                    "type": "new",
                    "entity": entity.serialize()
                })
            else:
                # Check for changes
                old_entity = previous_state.entities[entity_id]
                changes = self.diff_entities(old_entity, entity)
                
                if changes:
                    delta["changes"].append({
                        "type": "update",
                        "entity_id": entity_id,
                        "fields": changes
                    })
        
        # Check for removed entities
        for entity_id in previous_state.entities:
            if entity_id not in current_state.entities:
                delta["changes"].append({
                    "type": "remove",
                    "entity_id": entity_id
                })
        
        return delta
    
    def diff_entities(self, old, new):
        changes = {}
        
        # Position (quantize to reduce precision)
        if self.position_changed(old.position, new.position):
            changes["position"] = {
                "x": int(new.position.x * 10) / 10,  # 1 decimal place
                "y": int(new.position.y * 10) / 10
            }
        
        # Other fields
        if old.hp != new.hp:
            changes["hp"] = new.hp
        
        if old.score != new.score:
            changes["score"] = new.score
        
        return changes if changes else None
```

### Quantization

```python
# Reduce precision for network transmission
def quantize_position(position: Vector2, precision=0.1) -> tuple:
    """
    Reduce position precision to save bandwidth
    0.1 precision = 1 decimal place
    """
    x = int(position.x / precision) * precision
    y = int(position.y / precision) * precision
    return (x, y)

def quantize_angle(angle: float) -> int:
    """
    Convert angle (0-360) to byte (0-255)
    Precision: ~1.4 degrees
    """
    return int((angle % 360) / 360 * 255)

def dequantize_angle(quantized: int) -> float:
    """
    Convert byte back to angle
    """
    return (quantized / 255) * 360
```

## 🎮 Matchmaking

### ELO-Based Matching

```python
class Matchmaker:
    def __init__(self):
        self.queues = {
            "1v1_ranked": [],
            "1v1_casual": [],
            "2v2_ranked": [],
            # etc.
        }
    
    def add_to_queue(self, player, game_mode):
        queue = self.queues[game_mode]
        queue.append({
            "player": player,
            "join_time": time.time(),
            "elo": player.elo if "ranked" in game_mode else None
        })
    
    def find_match(self, game_mode):
        queue = self.queues[game_mode]
        
        if "ranked" in game_mode:
            return self.find_ranked_match(queue)
        else:
            return self.find_casual_match(queue)
    
    def find_ranked_match(self, queue):
        if len(queue) < 2:
            return None
        
        # Sort by ELO
        queue.sort(key=lambda x: x["elo"])
        
        # Try to match similar ELO players
        for i in range(len(queue) - 1):
            player1 = queue[i]
            
            for j in range(i + 1, len(queue)):
                player2 = queue[j]
                
                # Calculate wait time
                wait_time = time.time() - player1["join_time"]
                
                # ELO range expands with wait time
                max_elo_diff = 100 + (wait_time / 30) * 50  # +50 per 30 sec
                
                elo_diff = abs(player1["elo"] - player2["elo"])
                
                if elo_diff <= max_elo_diff:
                    # Found match!
                    queue.remove(player1)
                    queue.remove(player2)
                    return [player1["player"], player2["player"]]
        
        return None
```

## 📈 Network Monitoring

```python
class NetworkMonitor:
    def __init__(self):
        self.metrics = {
            "latency": [],
            "packet_loss": [],
            "bandwidth_in": [],
            "bandwidth_out": []
        }
    
    def measure_latency(self, player_id):
        # Send PING
        ping_time = time.time()
        self.send_ping(player_id, ping_time)
        
        # Wait for PONG (handled in callback)
        pass
    
    def on_pong_received(self, player_id, ping_time):
        latency = (time.time() - ping_time) * 1000  # ms
        
        player = self.get_player(player_id)
        player.latency_samples.append(latency)
        
        # Keep last 10 samples
        if len(player.latency_samples) > 10:
            player.latency_samples.pop(0)
        
        # Calculate average
        player.average_latency = sum(player.latency_samples) / len(player.latency_samples)
        
        # Detect high latency
        if player.average_latency > 200:
            self.warn_high_latency(player_id)
```

---

**Last Updated**: 2026-01-05
**Status**: Complete Specification
**Version**: 1.0.0
