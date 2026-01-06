## Ball Physics System
##
## Handles all ball movement, collision, and physics
class_name BallPhysics
extends Node

var ball: Ball
var board_manager: BoardManager
var paddles: Array = []

signal ball_hit_block(ball: Ball, block: Block)
signal ball_hit_paddle(ball: Ball, paddle: Paddle)
signal ball_missed(player_id: int)

func _ready() -> void:
	print("Ball Physics System initialized")

func set_ball(b: Ball) -> void:
	"""Set the ball to manage"""
	ball = b

func set_board_manager(bm: BoardManager) -> void:
	"""Set board manager reference"""
	board_manager = bm

func add_paddle(paddle: Paddle) -> void:
	"""Add paddle for collision checking"""
	paddles.append(paddle)

func update_physics(delta: float) -> void:
	"""Update ball physics"""
	if not ball or not ball.is_active:
		return
	
	# Move ball
	ball.position += ball.velocity * delta
	
	# Check collisions
	_check_wall_collision()
	_check_paddle_collision()
	_check_block_collision()
	_check_out_of_bounds()

func _check_wall_collision() -> void:
	"""Check collision with side walls"""
	var board_width = board_manager.board_width * board_manager.cell_size
	
	if ball.position.x < 4:
		ball.position.x = 4
		ball.velocity.x = abs(ball.velocity.x)
	elif ball.position.x > board_width - 4:
		ball.position.x = board_width - 4
		ball.velocity.x = -abs(ball.velocity.x)

func _check_paddle_collision() -> void:
	"""Check collision with paddles"""
	for paddle in paddles:
		if paddle and paddle.check_ball_collision(ball.position, 4):
			# Ball hit paddle
			var hit_pos = paddle.get_hit_position(ball.position.x)
			ball.hit_by_paddle(paddle.velocity, hit_pos)
			emit_signal("ball_hit_paddle", ball, paddle)
			print("Ball hit paddle!")

func _check_block_collision() -> void:
	"""Check collision with blocks"""
	if not board_manager:
		return
	
	var blocks = board_manager.get_blocks()
	var ball_rect = Rect2(ball.position.x - 4, ball.position.y - 4, 8, 8)
	
	for node in blocks:
		# Only check Block objects (skip particles and other nodes)
		if not node is Block:
			continue
		
		var block = node as Block
		if not is_instance_valid(block) or block.is_destroyed:
			continue
		
		# Block collision box
		var block_rect = Rect2(
			block.position.x,
			block.position.y,
			Constants.CELL_SIZE,
			Constants.CELL_SIZE
		)
		
		if ball_rect.intersects(block_rect):
			# Ball hit block!
			_handle_block_hit(block)
			break

func _handle_block_hit(block: Block) -> void:
	"""Handle ball hitting a block"""
	# Bounce ball
	var normal = _calculate_bounce_normal(ball.position, block.position)
	ball.bounce(normal)
	
	# Damage block
	block.take_damage(ball.damage)
	
	# Activate ability
	if not block.is_destroyed:
		block.activate_ability()
	
	emit_signal("ball_hit_block", ball, block)
	print("Ball hit block!")

func _calculate_bounce_normal(ball_pos: Vector2, block_pos: Vector2) -> Vector2:
	"""Calculate bounce normal from collision"""
	var diff = ball_pos - (block_pos + Vector2(Constants.CELL_SIZE / 2, Constants.CELL_SIZE / 2))
	
	# Simple normal based on which side was hit
	if abs(diff.x) > abs(diff.y):
		return Vector2(sign(diff.x), 0)
	else:
		return Vector2(0, sign(diff.y))

func _check_out_of_bounds() -> void:
	"""Check if ball went out of bounds"""
	var board_height = board_manager.board_height * board_manager.cell_size
	
	if ball.position.y < -20:
		# Went off top - Player 2 (AI) missed
		emit_signal("ball_missed", 2)
		_respawn_ball()
	elif ball.position.y > board_height + 20:
		# Went off bottom - Player 1 (human) missed
		emit_signal("ball_missed", 1)
		_respawn_ball()

func _respawn_ball() -> void:
	"""Respawn ball at center"""
	var board_width = board_manager.board_width * board_manager.cell_size
	var board_height = board_manager.board_height * board_manager.cell_size
	
	ball.position = Vector2(board_width / 2, board_height / 2)
	
	# Random angle
	var angle = randf_range(-PI/6, PI/6)
	if randf() > 0.5:
		angle += PI
	
	ball.velocity = Vector2(cos(angle), sin(angle)) * ball.speed
	
	print("Ball respawned at center")
