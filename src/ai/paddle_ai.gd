## Paddle AI
##
## Advanced AI for paddle control with dual-ball awareness
class_name PaddleAI
extends Node

var paddle: Paddle
var own_ball: Ball      # AI's ball to launch
var enemy_ball: Ball    # Enemy's ball to defend against

var reaction_speed: float = 5.0

func _ready() -> void:
	print("Advanced Paddle AI initialized")

func set_paddle(p: Paddle) -> void:
	"""Set the paddle to control"""
	paddle = p

func set_ball(b: Ball) -> void:
	"""Set AI's own ball"""
	own_ball = b

func set_enemy_ball(b: Ball) -> void:
	"""Set enemy's ball to defend against"""
	enemy_ball = b

func update_ai(delta: float) -> void:
	"""Update AI with strategic decision making"""
	if not paddle:
		return
	
	# ONLY control AI paddle
	if paddle.player_id != 2:
		return
	
	# Priority 1: Launch own ball if attached
	if own_ball and own_ball.is_attached and own_ball.attached_paddle == paddle:
		await get_tree().create_timer(0.5).timeout
		if own_ball.is_attached:
			# Aim at strategic target (center or random)
			var angle = randf_range(-2.0 * PI / 3.0, -PI / 3.0) + PI  # Downward spread
			own_ball.launch_from_paddle(angle)
			print("AI launched ball strategically!")
		return
	
	# Priority 2: Defend against ENEMY ball if it's coming toward AI
	if enemy_ball and not enemy_ball.is_attached:
		# Check if enemy ball is coming toward AI (moving up, velocity.y < 0)
		if enemy_ball.velocity.y < 0:  # Ball moving toward AI
			# Predict where ball will be
			var predicted_x = _predict_ball_intercept(enemy_ball)
			if predicted_x > 0:
				_move_toward_target(predicted_x)
				return
	
	# Priority 3: Track own ball for secondary defense
	if own_ball and not own_ball.is_attached:
		var target_x = own_ball.position.x
		_move_toward_target(target_x)
		return
	
	# Default: Stay centered
	var board_center = 960.0  # Approximate center
	_move_toward_target(board_center)

func _predict_ball_intercept(ball: Ball) -> float:
	"""Predict where ball will hit paddle Y position"""
	if abs(ball.velocity.y) < 0.1:
		return -1.0  # Ball not moving vertically
	
	# Simple linear prediction
	var time_to_paddle = (paddle.position.y - ball.position.y) / ball.velocity.y
	
	if time_to_paddle < 0:
		return -1.0  # Ball moving away
	
	var predicted_x = ball.position.x + (ball.velocity.x * time_to_paddle)
	return predicted_x

func _move_toward_target(target_x: float) -> void:
	"""Move paddle toward target position"""
	var distance = target_x - paddle.position.x
	
	# Move with proportional speed
	if abs(distance) > 15:
		var move_direction = sign(distance)
		paddle.velocity = move_direction * paddle.paddle_speed
	else:
		paddle.velocity = 0

func set_difficulty(difficulty: float) -> void:
	"""Set AI difficulty (0.0 - 1.0)"""
	reaction_speed = lerp(2.0, 10.0, difficulty)
