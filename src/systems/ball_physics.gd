## Ball Physics System
##
## Handles all ball movement, collision, and physics
class_name BallPhysics
extends Node

var balls: Array = []  # Multiple balls now!
var board_manager: BoardManager
var paddles: Array = []

## Collision cooldowns per ball to prevent double-hits
var paddle_collision_cooldowns: Dictionary = {}  # ball_id -> cooldown time
const PADDLE_COOLDOWN_TIME: float = 0.1  # 100ms cooldown

signal ball_hit_block(ball, block)
signal ball_hit_paddle(ball, paddle)
signal ball_missed(player_id: int)

func _ready() -> void:
	print("Ball Physics System initialized")

func set_balls(ball_array: Array) -> void:
	"""Set multiple balls to manage"""
	balls = ball_array
	for ball in balls:
		paddle_collision_cooldowns[ball] = 0.0

func set_board_manager(bm: BoardManager) -> void:
	"""Set board manager reference"""
	board_manager = bm

func add_paddle(paddle: Paddle) -> void:
	"""Add paddle for collision checking"""
	paddles.append(paddle)

func update_physics(delta: float) -> void:
	"""Update ball physics for ALL balls"""
	# Update cooldowns
	for ball in paddle_collision_cooldowns.keys():
		if paddle_collision_cooldowns[ball] > 0:
			paddle_collision_cooldowns[ball] -= delta
	
	# Update each ball
	for ball in balls:
		if not ball:
			continue
		
		# Skip physics if ball is attached to paddle
		if ball.is_attached:
			continue
		
		if not ball.is_active:
			continue
		
		# Move ball
		ball.position += ball.velocity * delta
		
		# Check collisions
		_check_wall_collision(ball)
		_check_paddle_collision(ball)
		_check_block_collision(ball)
		_check_out_of_bounds(ball)

func _check_wall_collision(ball) -> void:
	"""Check collision with side walls"""
	var board_width = board_manager.board_width * board_manager.cell_size
	
	if ball.position.x < 4:
		ball.position.x = 4
		ball.velocity.x = abs(ball.velocity.x)
	elif ball.position.x > board_width - 4:
		ball.position.x = board_width - 4
		ball.velocity.x = -abs(ball.velocity.x)

func _check_paddle_collision(ball) -> void:
	"""Check collision with paddles - can deflect ANY ball!"""
	# Skip if in cooldown for this ball
	if paddle_collision_cooldowns.get(ball, 0) > 0:
		return
	
	for paddle in paddles:
		if not paddle:
			continue
		
		# Paddle can deflect BOTH balls (yours AND enemy's)
		# This is key to strategy - defend against enemy ball!
		
		# Check collision
		var paddle_rect = Rect2(
			paddle.position.x - paddle.paddle_width / 2.0,
			paddle.position.y - 4,
			paddle.paddle_width,
			8
		)
		
		var ball_rect = Rect2(
			ball.position.x - 4,
			ball.position.y - 4,
			8,
			8
		)
		
		if paddle_rect.intersects(ball_rect):
			# Ball hit own paddle!
			var hit_pos = (ball.position.x - paddle.position.x) / (paddle.paddle_width / 2.0)
			ball.hit_by_paddle(paddle.velocity, hit_pos)
			paddle_collision_cooldowns[ball] = PADDLE_COOLDOWN_TIME
			emit_signal("ball_hit_paddle", ball, paddle)
			print("P" + str(paddle.player_id) + " deflected their ball!")
			return

func _check_block_collision(ball) -> void:
	"""Check collision with blocks - OWNERSHIP MATTERS!"""
	if not board_manager:
		return
	
	var blocks = board_manager.get_blocks()
	var ball_rect = Rect2(ball.position.x - 4, ball.position.y - 4, 8, 8)
	
	for node in blocks:
		# Only check Block objects
		if not node is Block:
			continue
		
		var block = node as Block
		if not is_instance_valid(block) or block.is_destroyed:
			continue
		
		# OWNERSHIP CHECK:
		# - Your ball PASSES THROUGH your own blocks (owner_id same)
		# - Your ball BOUNCES OFF enemy blocks (owner_id different) and damages them
		if ball.owner_id == block.owner_id:
			# Ball passes through own blocks - no collision
			continue
		
		# Ball hits ENEMY block - bounce and damage!
		var block_rect = Rect2(
			block.position.x,
			block.position.y,
			board_manager.cell_size,
			board_manager.cell_size
		)
		
		if ball_rect.intersects(block_rect):
			# Ball hit ENEMY block!
			_handle_block_hit(ball, block)
			break

func _handle_block_hit(ball, block: Block) -> void:
	"""Handle ball hitting an ENEMY block"""
	# Bounce ball
	var normal = _calculate_bounce_normal(ball.position, block.position)
	ball.bounce(normal)
	
	# Damage block
	block.take_damage(ball.damage)
	
	# Activate ability
	if not block.is_destroyed:
		block.activate_ability()
	
	emit_signal("ball_hit_block", ball, block)
	print("P" + str(ball.owner_id) + "'s ball hit P" + str(block.owner_id) + "'s block!")

func _calculate_bounce_normal(ball_pos: Vector2, block_pos: Vector2) -> Vector2:
	"""Calculate bounce normal from collision"""
	var diff = ball_pos - (block_pos + Vector2(Constants.CELL_SIZE / 2.0, Constants.CELL_SIZE / 2.0))
	
	# Simple normal based on which side was hit
	if abs(diff.x) > abs(diff.y):
		return Vector2(sign(diff.x), 0)
	else:
		return Vector2(0, sign(diff.y))

func _check_out_of_bounds(ball) -> void:
	"""Check if ball went behind paddle - attach it for re-launch"""
	var board_height = board_manager.board_height * board_manager.cell_size
	
	if ball.position.y < -20:
		# Ball went off TOP
		if ball.owner_id == 1:
			# YOUR ball scored against AI!
			print("Your CYAN ball scored! AI takes damage!")
			emit_signal("ball_missed", 2)  # AI takes damage
			# Attach to your paddle for relaunch
			_attach_ball_to_owner_paddle(ball)
		else:
			# AI's ball went backwards - attach to AI paddle
			print("AI's RED ball went backwards - attaching to AI paddle")
			_attach_ball_to_owner_paddle(ball)
		
	elif ball.position.y > board_height + 20:
		# Ball went off BOTTOM
		if ball.owner_id == 2:
			# ENEMY ball scored against you!
			print("Enemy RED ball scored! You take damage!")
			emit_signal("ball_missed", 1)  # You take damage
			# Attach to AI paddle for relaunch
			_attach_ball_to_owner_paddle(ball)
		else:
			# YOUR ball went backwards - attach to your paddle
			print("Your CYAN ball went backwards - attaching to paddle")
			_attach_ball_to_owner_paddle(ball)

func _attach_ball_to_owner_paddle(ball) -> void:
	"""Attach ball to its owner's paddle"""
	for paddle in paddles:
		if paddle and paddle.player_id == ball.owner_id:
			ball.attach_to_paddle(paddle)
			break

func _respawn_ball(ball) -> void:
	"""Respawn ball in owner's territory"""
	var board_width = board_manager.board_width * board_manager.cell_size
	var board_height = board_manager.board_height * board_manager.cell_size
	
	# Respawn in owner's area
	if ball.owner_id == 1:
		# Player 1 - bottom area
		ball.position = Vector2(board_width / 2.0, board_height * 0.75)
		# Send toward enemy (up)
		var angle = randf_range(-PI/4, PI/4) - PI/2  # Upward
		ball.velocity = Vector2(cos(angle), sin(angle)) * ball.speed
	else:
		# Player 2 - top area  
		ball.position = Vector2(board_width / 2.0, board_height * 0.25)
		# Send toward enemy (down)
		var angle = randf_range(-PI/4, PI/4) + PI/2  # Downward
		ball.velocity = Vector2(cos(angle), sin(angle)) * ball.speed
	
	print("P" + str(ball.owner_id) + "'s ball respawned")
