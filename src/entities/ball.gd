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
var is_attached: bool = false
var attached_paddle = null
var attach_offset: float = 0.0  # Offset from paddle center

signal ball_hit_block(block)
signal ball_hit_paddle(paddle, player_id: int)
signal ball_missed(player_id: int)
signal ball_attached_to_paddle(ball, paddle)

func _ready() -> void:
	# Visuals created after initialize() is called
	pass

func initialize(start_position: Vector2, start_velocity: Vector2) -> void:
	"""Initialize ball"""
	position = start_position
	velocity = start_velocity
	speed = velocity.length()
	
	# Create visuals now (after owner_id is set)
	_create_visuals()

func _create_visuals() -> void:
	"""Create ball visuals"""
	# Determine color based on ownership
	var ball_color: Color
	if owner_id == 1:
		ball_color = Color.CYAN  # Player's ball = BLUE/CYAN (friendly)
	else:
		ball_color = Color.RED   # Enemy's ball = RED (enemy)
	
	# Sprite
	sprite = Sprite2D.new()
	sprite.texture = SpriteGenerator.generate_ball_texture(ball_type)
	sprite.modulate = ball_color
	add_child(sprite)
	
	# Trail effect (matches ball color)
	trail = Line2D.new()
	trail.width = 3
	trail.default_color = Color(ball_color.r, ball_color.g, ball_color.b, 0.6)
	trail.z_index = -1
	add_child(trail)

func _process(_delta: float) -> void:
	"""Update ball visuals and attachment"""
	# If attached to paddle, follow it
	if is_attached and attached_paddle:
		position.x = attached_paddle.position.x + attach_offset
		position.y = attached_paddle.position.y - 20  # Above paddle
		velocity = Vector2.ZERO  # No velocity while attached
	
	# Update trail
	_update_trail()

func attach_to_paddle(paddle) -> void:
	"""Attach ball to paddle (waiting for launch)"""
	is_attached = true
	attached_paddle = paddle
	attach_offset = 0.0  # Center of paddle
	is_active = false  # Stop physics
	print("Ball attached to P" + str(paddle.player_id) + " paddle - Click to launch!")
	emit_signal("ball_attached_to_paddle", self, paddle)

func launch_from_paddle(aim_angle: float) -> void:
	"""Launch ball from paddle with given angle"""
	if not is_attached:
		return
	
	is_attached = false
	attached_paddle = null
	is_active = true
	
	# Launch with specified angle
	velocity = Vector2(cos(aim_angle), sin(aim_angle)) * speed
	
	print("Ball launched at angle: " + str(rad_to_deg(aim_angle)) + "°")

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

func hit_by_paddle(paddle_velocity: float, hit_position: float, paddle_player_id: int) -> void:
	"""Ball hit by paddle"""
	# Reflect in the correct direction based on which paddle
	if paddle_player_id == 1:
		# Bottom paddle - send ball UPWARD
		velocity.y = -abs(velocity.y)
	else:
		# Top paddle - send ball DOWNWARD
		velocity.y = abs(velocity.y)
	
	# Add paddle movement influence
	velocity.x += paddle_velocity * 0.3
	
	# Vary angle based on hit position (center vs edges)
	velocity.x += hit_position * 150  # More influence from edges
	
	# Normalize and maintain speed
	velocity = velocity.normalized() * speed
	
	# Small speed boost on each hit
	speed = min(speed + 20, Constants.BALL_SPEED_MAX)
	velocity = velocity.normalized() * speed

func set_speed(new_speed: float) -> void:
	"""Change ball speed"""
	speed = clamp(new_speed, Constants.BALL_SPEED_MIN, Constants.BALL_SPEED_MAX)
	velocity = velocity.normalized() * speed
