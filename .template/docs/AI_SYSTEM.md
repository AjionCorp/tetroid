# AI Opponent System

## 🤖 Overview

This document details the AI system for Tetroid's computer opponents, covering decision-making algorithms, difficulty scaling, learning systems, and testing procedures.

## 🎯 AI Design Philosophy

### Core Principles
1. **Fair but Challenging**: AI should feel skillful, not cheating
2. **Predictable at Low Levels**: Beginners can learn patterns
3. **Adaptive at High Levels**: Experts face dynamic opposition
4. **Human-like Behavior**: Makes mistakes, has reaction time
5. **Deterministic Core**: Same inputs = same outputs (for testing)

### AI Goals
- **Primary**: Win the match
- **Secondary**: Provide good player experience
- **Tertiary**: Teach gameplay mechanics

## 🏗️ Architecture

### Component Structure

```
AIController
├── Perception (Observe game state)
├── Decision Making (Behavior Tree)
├── Planning (Strategic layer)
├── Execution (Action output)
└── Learning (Optional adaptive layer)
```

### Class Structure

```gdscript
class_name AIController
extends Node

# Components
var perception: AIPerception
var behavior_tree: BehaviorTree
var planner: AIPlanner
var executor: AIExecutor

# Configuration
var difficulty: Difficulty
var personality: AIPersonality

# State
var current_strategy: Strategy
var threat_level: float
var confidence: float

func _ready():
    perception = AIPerception.new()
    behavior_tree = _build_behavior_tree(difficulty)
    planner = AIPlanner.new(difficulty)
    executor = AIExecutor.new()

func _process(delta: float):
    # 1. Perceive world
    var world_state = perception.analyze_game_state(game_state)
    
    # 2. Make decisions
    var decision = behavior_tree.evaluate(world_state)
    
    # 3. Execute actions
    executor.execute_decision(decision, delta)
```

## 👁️ Perception System

### What AI Observes

```gdscript
class_name AIPerception

func analyze_game_state(game_state: GameState) -> WorldState:
    return {
        # Self state
        "own_hp": game_state.get_player_hp(ai_player_id),
        "own_score": game_state.get_player_score(ai_player_id),
        "paddle_position": game_state.get_paddle_position(ai_player_id),
        "next_pieces": game_state.get_next_pieces(ai_player_id),
        "ability_cooldowns": _get_ability_cooldowns(),
        
        # Opponent state
        "opponent_hp": game_state.get_player_hp(opponent_id),
        "opponent_score": game_state.get_player_score(opponent_id),
        "opponent_paddle_position": game_state.get_paddle_position(opponent_id),
        "opponent_blocks": game_state.get_player_blocks(opponent_id),
        
        # Ball state
        "ball_position": game_state.ball.position,
        "ball_velocity": game_state.ball.velocity,
        "ball_owner": game_state.ball.owner,
        "predicted_ball_path": _predict_ball_trajectory(),
        
        # Board state
        "own_blocks": game_state.get_player_blocks(ai_player_id),
        "enemy_territory_openings": _find_weak_spots(),
        "board_coverage": _calculate_territory_coverage(),
        
        # Threats
        "immediate_threats": _identify_threats(),
        "opponent_strategy": _guess_opponent_strategy(),
    }
```

### Ball Trajectory Prediction

```gdscript
func predict_ball_trajectory(ball: Ball, timesteps: int = 60) -> Array:
    """
    Simulate ball physics to predict future positions
    Returns array of positions for next N timesteps
    """
    var trajectory = []
    var sim_ball = ball.duplicate()
    
    for i in range(timesteps):
        # Simulate physics for one timestep
        sim_ball.position += sim_ball.velocity * FIXED_DELTA
        
        # Check collisions
        var collision = _check_collisions(sim_ball)
        if collision:
            sim_ball.velocity = _calculate_bounce(
                sim_ball.velocity,
                collision.normal
            )
            
            if collision.type == "PADDLE" or collision.type == "BLOCK":
                # Ball will change owner, stop prediction
                trajectory.append({
                    "position": sim_ball.position,
                    "velocity": sim_ball.velocity,
                    "collision": collision
                })
                break
        
        trajectory.append({
            "position": sim_ball.position,
            "velocity": sim_ball.velocity,
            "collision": null
        })
    
    return trajectory
```

### Threat Assessment

```gdscript
func identify_threats() -> Array:
    """
    Identify immediate dangers requiring response
    """
    var threats = []
    
    # 1. Ball about to miss paddle
    if _is_ball_coming_toward_me():
        var time_to_impact = _calculate_time_to_paddle()
        var paddle_distance = _distance_paddle_to_intercept()
        
        if time_to_impact < 1.0:  # Less than 1 second
            threats.append({
                "type": "BALL_MISS",
                "severity": _calculate_miss_severity(time_to_impact, paddle_distance),
                "time_to_impact": time_to_impact,
                "intercept_position": _calculate_intercept_position()
            })
    
    # 2. Low HP
    if own_hp < 30:
        threats.append({
            "type": "LOW_HP",
            "severity": 1.0 - (own_hp / 100.0),
            "recommended_action": "DEFENSIVE"
        })
    
    # 3. Opponent aggressive placement
    var recent_enemy_placements = _get_recent_placements(opponent_id, 3)
    if _all_in_my_territory(recent_enemy_placements):
        threats.append({
            "type": "AGGRESSIVE_OPPONENT",
            "severity": 0.7,
            "recommended_action": "COUNTER_ATTACK"
        })
    
    # Sort by severity
    threats.sort_custom(func(a, b): return a.severity > b.severity)
    
    return threats
```

## 🌳 Behavior Tree

### Tree Structure

```
Root: Selector
├── [High Priority] Handle Immediate Threats
│   ├── Sequence: Ball Approaching
│   │   ├── Condition: Ball coming to my side?
│   │   ├── Action: Move paddle to intercept
│   │   └── Action: Prepare paddle ability
│   │
│   └── Sequence: Critical HP
│       ├── Condition: HP < 20?
│       └── Action: Place defensive blocks
│
├── [Medium Priority] Strategic Actions
│   ├── Sequence: Good Attack Opportunity
│   │   ├── Condition: Have offensive piece?
│   │   ├── Condition: Enemy territory weak?
│   │   └── Action: Place in enemy territory
│   │
│   ├── Sequence: Ability Ready
│   │   ├── Condition: Ability off cooldown?
│   │   ├── Condition: Good timing?
│   │   └── Action: Activate ability
│   │
│   └── Sequence: Build Defense
│       ├── Condition: Own territory sparse?
│       └── Action: Place in own territory
│
└── [Low Priority] Default Actions
    ├── Action: Position paddle center
    └── Action: Wait for next piece
```

### Behavior Tree Implementation

```gdscript
func _build_behavior_tree(difficulty: Difficulty) -> BehaviorTree:
    var root = SelectorNode.new("Root")
    
    # High Priority: Immediate Threats
    var threat_handler = SequenceNode.new("Threat Handler")
    threat_handler.add_child(ConditionNode.new("Ball Approaching?", _is_ball_approaching))
    threat_handler.add_child(ActionNode.new("Intercept Ball", _intercept_ball))
    root.add_child(threat_handler)
    
    # Medium Priority: Strategic Actions
    var strategy_selector = SelectorNode.new("Strategy")
    
    # Offensive sequence
    var offensive = SequenceNode.new("Offensive Play")
    offensive.add_child(ConditionNode.new("Have offensive piece?", _has_offensive_piece))
    offensive.add_child(ConditionNode.new("Enemy weak?", _is_enemy_weak))
    offensive.add_child(ActionNode.new("Attack", _place_offensive_block))
    strategy_selector.add_child(offensive)
    
    # Defensive sequence
    var defensive = SequenceNode.new("Defensive Play")
    defensive.add_child(ConditionNode.new("Need defense?", _needs_defense))
    defensive.add_child(ActionNode.new("Defend", _place_defensive_block))
    strategy_selector.add_child(defensive)
    
    root.add_child(strategy_selector)
    
    # Low Priority: Default
    var default = ActionNode.new("Default", _default_action)
    root.add_child(default)
    
    return BehaviorTree.new(root, difficulty)
```

## 🎲 Difficulty System

### Difficulty Levels

```gdscript
enum DifficultyLevel {
    EASY,
    NORMAL,
    HARD,
    EXPERT
}

class Difficulty:
    var level: DifficultyLevel
    
    # Reaction time (seconds)
    var reaction_time: float
    
    # Error rate (0.0 = perfect, 1.0 = always wrong)
    var error_rate: float
    
    # Prediction accuracy
    var prediction_accuracy: float
    
    # Strategic thinking depth
    var planning_depth: int
    
    # Ability usage frequency
    var ability_usage_rate: float
    
    # Risk tolerance (0.0 = cautious, 1.0 = aggressive)
    var aggression: float
    
    static func create(level: DifficultyLevel) -> Difficulty:
        var diff = Difficulty.new()
        diff.level = level
        
        match level:
            DifficultyLevel.EASY:
                diff.reaction_time = 0.3
                diff.error_rate = 0.3
                diff.prediction_accuracy = 0.5
                diff.planning_depth = 1
                diff.ability_usage_rate = 0.2
                diff.aggression = 0.3
            
            DifficultyLevel.NORMAL:
                diff.reaction_time = 0.15
                diff.error_rate = 0.15
                diff.prediction_accuracy = 0.7
                diff.planning_depth = 2
                diff.ability_usage_rate = 0.5
                diff.aggression = 0.5
            
            DifficultyLevel.HARD:
                diff.reaction_time = 0.08
                diff.error_rate = 0.05
                diff.prediction_accuracy = 0.9
                diff.planning_depth = 3
                diff.ability_usage_rate = 0.8
                diff.aggression = 0.7
            
            DifficultyLevel.EXPERT:
                diff.reaction_time = 0.03
                diff.error_rate = 0.01
                diff.prediction_accuracy = 0.98
                diff.planning_depth = 5
                diff.ability_usage_rate = 0.95
                diff.aggression = 0.8
        
        return diff
```

### Simulating Human Behavior

```gdscript
class AIExecutor:
    var difficulty: Difficulty
    var reaction_delay_remaining: float = 0.0
    var pending_action = null
    
    func execute_decision(decision, delta: float):
        # Add reaction delay on new decisions
        if decision != pending_action:
            pending_action = decision
            reaction_delay_remaining = difficulty.reaction_time
            return
        
        # Count down reaction time
        if reaction_delay_remaining > 0:
            reaction_delay_remaining -= delta
            return
        
        # Execute with error chance
        if randf() < difficulty.error_rate:
            # Make a mistake
            decision = _introduce_error(decision)
        
        # Actually execute the action
        _perform_action(decision)
    
    func _introduce_error(decision):
        """Make the AI do something slightly wrong"""
        match decision.type:
            "MOVE_PADDLE":
                # Move paddle to slightly wrong position
                var error = randf_range(-50, 50)
                decision.target_x += error
            
            "PLACE_BLOCK":
                # Place in suboptimal position
                decision.position.x += randi() % 3 - 1
            
            "ACTIVATE_ABILITY":
                # Use ability at wrong time
                if randf() < 0.5:
                    decision = null  # Don't use ability
        
        return decision
```

## 🧠 Strategic Planning

### Evaluation Function

```gdscript
func evaluate_block_placement(piece: Piece, position: Vector2, rotation: int) -> float:
    """
    Evaluate how good a block placement is
    Returns score (higher = better)
    """
    var score = 0.0
    
    # Factor 1: Territory control (20%)
    if _is_in_enemy_territory(position):
        score += 20.0 * difficulty.aggression
    else:
        score += 15.0 * (1.0 - difficulty.aggression)
    
    # Factor 2: Coverage (15%)
    var coverage_improvement = _calculate_coverage_improvement(piece, position, rotation)
    score += coverage_improvement * 15.0
    
    # Factor 3: Ability synergy (25%)
    var synergy = _calculate_ability_synergy(piece, position)
    score += synergy * 25.0
    
    # Factor 4: Defensive value (20%)
    var defensive_value = _calculate_defensive_value(piece, position)
    score += defensive_value * 20.0
    
    # Factor 5: Risk vs Reward (20%)
    var risk = _calculate_placement_risk(position)
    var reward = _calculate_placement_reward(position)
    score += (reward - risk * 0.5) * 20.0
    
    # Apply prediction accuracy (AI might misjudge)
    if randf() > difficulty.prediction_accuracy:
        score *= randf_range(0.5, 1.5)  # Random adjustment
    
    return score
```

### Block Placement Decision

```gdscript
func decide_block_placement(piece: Piece) -> Dictionary:
    """
    Decide where to place the current piece
    Returns: {position, rotation, confidence}
    """
    var best_placement = null
    var best_score = -INF
    
    # Try different positions and rotations
    var search_positions = _get_search_positions(difficulty.planning_depth)
    
    for pos in search_positions:
        for rotation in range(4):  # 0, 90, 180, 270 degrees
            # Check if placement is valid
            if not _is_valid_placement(piece, pos, rotation):
                continue
            
            # Evaluate this placement
            var score = evaluate_block_placement(piece, pos, rotation)
            
            # Check if this is better
            if score > best_score:
                best_score = score
                best_placement = {
                    "position": pos,
                    "rotation": rotation,
                    "score": score
                }
    
    # Calculate confidence
    var confidence = clamp(best_score / 100.0, 0.0, 1.0)
    best_placement["confidence"] = confidence
    
    return best_placement
```

### Paddle Positioning

```gdscript
func calculate_paddle_target_position() -> float:
    """
    Decide where paddle should be positioned
    """
    # Predict where ball will hit paddle line
    var ball_trajectory = predict_ball_trajectory(game_state.ball)
    
    var intercept_position = null
    for point in ball_trajectory:
        if point.position.y >= PADDLE_Y_POSITION:
            intercept_position = point.position.x
            break
    
    if intercept_position:
        # Add some error based on difficulty
        var error = randf_range(-20, 20) * difficulty.error_rate
        return intercept_position + error
    else:
        # Ball not coming to us, position for defense
        return BOARD_WIDTH / 2  # Center
```

## 🎭 AI Personalities (Optional)

### Personality Types

```gdscript
enum AIPersonality {
    AGGRESSIVE,      # High risk, high reward plays
    DEFENSIVE,       # Conservative, defensive strategy
    BALANCED,        # Mix of both
    UNPREDICTABLE,   # Random strategy changes
    MIMETIC          # Copies player's strategy
}

class AIPersonalityTraits:
    var personality: AIPersonality
    var aggression: float        # 0.0 = defensive, 1.0 = aggressive
    var risk_tolerance: float    # Willingness to make risky plays
    var ability_preference: float # Prefers using abilities often
    var territory_preference: float # Prefers own (0.0) vs enemy (1.0) territory
    
    static func create(personality: AIPersonality) -> AIPersonalityTraits:
        var traits = AIPersonalityTraits.new()
        traits.personality = personality
        
        match personality:
            AIPersonality.AGGRESSIVE:
                traits.aggression = 0.9
                traits.risk_tolerance = 0.8
                traits.ability_preference = 0.9
                traits.territory_preference = 0.8
            
            AIPersonality.DEFENSIVE:
                traits.aggression = 0.2
                traits.risk_tolerance = 0.3
                traits.ability_preference = 0.4
                traits.territory_preference = 0.2
            
            AIPersonality.BALANCED:
                traits.aggression = 0.5
                traits.risk_tolerance = 0.5
                traits.ability_preference = 0.6
                traits.territory_preference = 0.5
            
            AIPersonality.UNPREDICTABLE:
                # Randomize each match
                traits.aggression = randf()
                traits.risk_tolerance = randf()
                traits.ability_preference = randf()
                traits.territory_preference = randf()
            
            AIPersonality.MIMETIC:
                # Set dynamically based on player behavior
                traits.aggression = 0.5  # Start balanced
                traits.risk_tolerance = 0.5
                traits.ability_preference = 0.5
                traits.territory_preference = 0.5
        
        return traits
```

## 📚 Learning System (Advanced)

### Match Data Collection

```gdscript
class AILearningSystem:
    var training_database: Dictionary = {}
    
    func record_match_state(state: GameState, decision, outcome):
        """
        Record game state, AI decision, and outcome for learning
        """
        var record = {
            "timestamp": Time.get_unix_time_from_system(),
            "state": _serialize_state(state),
            "decision": decision,
            "outcome": outcome,  # "win", "loss", or intermediate score
            "difficulty": ai_controller.difficulty.level
        }
        
        # Store in database
        if not training_database.has(ai_controller.difficulty.level):
            training_database[ai_controller.difficulty.level] = []
        
        training_database[ai_controller.difficulty.level].append(record)
    
    func analyze_and_improve():
        """
        Analyze past matches to improve decision-making
        """
        for level in training_database:
            var matches = training_database[level]
            
            # Find patterns in winning vs losing matches
            var winning_patterns = _extract_patterns(
                matches.filter(func(m): return m.outcome == "win")
            )
            var losing_patterns = _extract_patterns(
                matches.filter(func(m): return m.outcome == "loss")
            )
            
            # Adjust behavior weights
            _update_behavior_weights(winning_patterns, losing_patterns)
```

## 🧪 AI Testing

### Test Scenarios

```gdscript
class AITester:
    func run_all_tests():
        test_paddle_accuracy()
        test_block_placement()
        test_difficulty_scaling()
        test_ability_usage()
        test_win_rate()
    
    func test_paddle_accuracy():
        """Test how often AI successfully hits the ball"""
        var test_count = 100
        var hits = 0
        
        for i in range(test_count):
            var test_game = _create_test_game()
            # ... simulate game
            if ai_hit_ball:
                hits += 1
        
        var accuracy = float(hits) / test_count
        
        # Check against expected accuracy for difficulty
        assert_in_range(accuracy, expected_min, expected_max)
    
    func test_difficulty_scaling():
        """Ensure higher difficulties actually perform better"""
        var results = {}
        
        for difficulty in [EASY, NORMAL, HARD, EXPERT]:
            # Run 50 matches per difficulty
            var win_rate = _run_test_matches(difficulty, 50)
            results[difficulty] = win_rate
        
        # Assert difficulties scale properly
        assert(results[EASY] < results[NORMAL])
        assert(results[NORMAL] < results[HARD])
        assert(results[HARD] < results[EXPERT])
    
    func test_win_rate():
        """Test AI win rate against target difficulty"""
        var matches = 100
        var wins = 0
        
        for i in range(matches):
            var result = _simulate_ai_vs_player_match()
            if result == "AI_WIN":
                wins += 1
        
        var win_rate = float(wins) / matches
        
        # Target win rates by difficulty:
        # Easy: 20-30%
        # Normal: 40-50%
        # Hard: 60-70%
        # Expert: 75-85%
        
        match difficulty:
            EASY:
                assert_in_range(win_rate, 0.20, 0.30)
            NORMAL:
                assert_in_range(win_rate, 0.40, 0.50)
            HARD:
                assert_in_range(win_rate, 0.60, 0.70)
            EXPERT:
                assert_in_range(win_rate, 0.75, 0.85)
```

### Performance Profiling

```gdscript
func profile_ai_performance():
    """Measure AI decision-making performance"""
    var iterations = 1000
    var total_time = 0.0
    
    for i in range(iterations):
        var start_time = Time.get_ticks_usec()
        
        # Run one AI decision cycle
        ai_controller.make_decision()
        
        var end_time = Time.get_ticks_usec()
        total_time += (end_time - start_time) / 1000000.0  # Convert to seconds
    
    var average_time = total_time / iterations
    
    print("AI Decision Time: %.3f ms" % (average_time * 1000))
    
    # Assert performance target: <5ms per decision
    assert(average_time < 0.005, "AI too slow!")
```

## 📊 AI Debugging & Visualization

### Debug Visualization

```gdscript
func draw_ai_debug_info():
    """Draw AI's decision-making visualization"""
    if not DEBUG_MODE:
        return
    
    # Draw predicted ball trajectory
    var trajectory = ai_perception.predict_ball_trajectory(game_state.ball)
    for i in range(trajectory.size() - 1):
        draw_line(
            trajectory[i].position,
            trajectory[i + 1].position,
            Color.YELLOW,
            2.0
        )
    
    # Draw target paddle position
    var target_pos = ai_controller.paddle_target_position
    draw_circle(Vector2(target_pos, PADDLE_Y), 10, Color.GREEN)
    
    # Draw threat indicators
    for threat in ai_perception.current_threats:
        var threat_pos = threat.get("position", Vector2.ZERO)
        draw_circle(threat_pos, 20, Color.RED)
        draw_text(threat_pos, threat.type)
    
    # Draw current strategy
    draw_text(Vector2(10, 10), "Strategy: " + str(ai_controller.current_strategy))
    draw_text(Vector2(10, 30), "Confidence: %.2f" % ai_controller.confidence)
```

---

**Last Updated**: 2026-01-05
**Status**: Complete Specification
**Version**: 1.0.0
