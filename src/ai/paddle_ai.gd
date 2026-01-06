## Paddle AI
##
## Simple AI to control the paddle during battle phase
class_name PaddleAI
extends Node

var paddle: Paddle
var ball: Ball
var reaction_speed: float = 5.0  # How fast AI reacts (higher = faster)

func _ready() -> void:
	print("Paddle AI initialized")

func set_paddle(p: Paddle) -> void:
	"""Set the paddle to control"""
	paddle = p

func set_ball(b: Ball) -> void:
	"""Set the ball to track"""
	ball = b

func update_ai(delta: float) -> void:
	"""Update AI paddle control - ONLY controls AI paddle"""
	if not paddle or not ball:
		return
	
	# ONLY control if this is the AI paddle (player_id == 2)
	if paddle.player_id != 2:
		print("WARNING: PaddleAI trying to control non-AI paddle!")
		return
	
	# If ball is attached, launch it after a short delay
	if ball.is_attached and ball.attached_paddle == paddle:
		await get_tree().create_timer(0.5).timeout
		if ball.is_attached:  # Still attached after delay
			# Launch at random angle toward player
			var angle = randf_range(-2.0 * PI / 3.0, -PI / 3.0) + PI  # Downward
			ball.launch_from_paddle(angle)
			print("AI launched ball!")
		return
	
	# Simple AI: Move paddle toward ball's X position
	var target_x = ball.position.x
	
	# Calculate distance
	var distance = target_x - paddle.position.x
	
	# Move toward target (with some imperfection)
	if abs(distance) > 10:  # Dead zone
		var move_speed = sign(distance) * paddle.paddle_speed
		paddle.velocity = move_speed
	else:
		paddle.velocity = 0

func set_difficulty(difficulty: float) -> void:
	"""Set AI difficulty (0.0 - 1.0)"""
	reaction_speed = lerp(2.0, 10.0, difficulty)
