## Paddle Entity
##
## Player-controlled paddle for deflecting ball
class_name Paddle
extends Node2D

## Paddle properties
var player_id: int = 1
var paddle_width: float = 60.0
var paddle_speed: float = 400.0
var velocity: float = 0.0

## Visual
var sprite: ColorRect

## Position bounds
var min_x: float = 0
var max_x: float = 1000

signal ball_deflected()

func _ready() -> void:
	_create_visuals()

func initialize(pid: int, y_position: float, board_width_px: float = 960.0) -> void:
	"""Initialize paddle"""
	player_id = pid
	position.y = y_position
	
	# Set bounds based on actual board size
	min_x = paddle_width / 2
	max_x = board_width_px - (paddle_width / 2)
	
	# Start at center
	position.x = board_width_px / 2

func _create_visuals() -> void:
	"""Create paddle visuals"""
	sprite = ColorRect.new()
	sprite.size = Vector2(paddle_width, 8)
	sprite.position = Vector2(-paddle_width / 2, -4)  # Center it
	
	# Color based on player (P1=bottom=cyan, P2=top=red)
	if player_id == 1:
		sprite.color = Color.CYAN  # Player at bottom
	else:
		sprite.color = Color.RED  # AI at top
	
	add_child(sprite)

func _physics_process(delta: float) -> void:
	"""Update paddle physics"""
	if abs(velocity) > 0.01:
		position.x += velocity * delta
		
		# Clamp to bounds
		position.x = clamp(position.x, min_x, max_x)

func set_target_x(target_x: float) -> void:
	"""Set target X position (for AI or mouse control)"""
	var diff = target_x - position.x
	velocity = clamp(diff * 5.0, -paddle_speed, paddle_speed)

func move_with_input(input_direction: float) -> void:
	"""Move paddle with keyboard/controller input"""
	velocity = input_direction * paddle_speed

func check_ball_collision(ball_position: Vector2, ball_radius: float) -> bool:
	"""Check if ball collides with paddle"""
	# Simple AABB collision
	var paddle_rect = Rect2(
		position.x - paddle_width / 2,
		position.y - 4,
		paddle_width,
		8
	)
	
	var ball_rect = Rect2(
		ball_position.x - ball_radius,
		ball_position.y - ball_radius,
		ball_radius * 2,
		ball_radius * 2
	)
	
	return paddle_rect.intersects(ball_rect)

func get_hit_position(ball_x: float) -> float:
	"""Get where on paddle the ball hit (-1 to 1, center = 0)"""
	var relative_pos = ball_x - position.x
	return relative_pos / (paddle_width / 2)
