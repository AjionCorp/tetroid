## Ball Entity
##
## Bouncing ball that hits blocks and paddle
class_name Ball
extends Node2D

## Ball properties
var ball_id: int = 0
var ball_type: Constants.BallType = Constants.BallType.NORMAL
var velocity: Vector2 = Vector2(0, -400)  # Start moving up
var speed: float = 400.0
var damage: int = 10
var owner_id: int = 0  # Who last hit it

## Visual
var sprite: Sprite2D
var trail: Line2D

## State
var is_active: bool = true

signal ball_hit_block(block)
signal ball_hit_paddle(paddle, player_id: int)
signal ball_missed(player_id: int)

func _ready() -> void:
	# Create visual
	_create_visuals()

func initialize(start_position: Vector2, start_velocity: Vector2) -> void:
	"""Initialize ball"""
	position = start_position
	velocity = start_velocity
	speed = velocity.length()

func _create_visuals() -> void:
	"""Create ball visuals"""
	# Sprite
	sprite = Sprite2D.new()
	sprite.texture = SpriteGenerator.generate_ball_texture(ball_type)
	add_child(sprite)
	
	# Trail effect
	trail = Line2D.new()
	trail.width = 3
	trail.default_color = Color(1, 1, 1, 0.5)
	trail.z_index = -1
	add_child(trail)

func _process(_delta: float) -> void:
	"""Update ball visuals"""
	# Physics handled by BallPhysics system
	_update_trail()

func _update_trail() -> void:
	"""Update trail effect"""
	if trail:
		trail.add_point(Vector2.ZERO)  # Relative to ball
		
		# Limit trail length
		if trail.get_point_count() > 10:
			trail.remove_point(0)

func bounce(normal: Vector2) -> void:
	"""Bounce ball off surface"""
	velocity = velocity.bounce(normal)
	
	# Normalize and maintain speed
	velocity = velocity.normalized() * speed

func hit_by_paddle(paddle_velocity: float, hit_position: float) -> void:
	"""Ball hit by paddle"""
	# Reflect upward/downward
	velocity.y = -velocity.y
	
	# Add paddle influence
	velocity.x += paddle_velocity * 0.3
	
	# Vary angle based on hit position (center vs edges)
	var paddle_width = 60.0  # TODO: Get from paddle
	var hit_offset = hit_position / (paddle_width / 2)  # -1 to 1
	velocity.x += hit_offset * 100
	
	# Normalize and maintain speed
	velocity = velocity.normalized() * speed
	
	# Small speed boost
	speed = min(speed + 20, Constants.BALL_SPEED_MAX)
	velocity = velocity.normalized() * speed

func set_speed(new_speed: float) -> void:
	"""Change ball speed"""
	speed = clamp(new_speed, Constants.BALL_SPEED_MIN, Constants.BALL_SPEED_MAX)
	velocity = velocity.normalized() * speed
