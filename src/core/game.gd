## Main Game Class
##
## Orchestrates all game systems in a modular way
class_name Game
extends Node2D

## Core systems
var game_state
var board_manager
var ball_physics
var input_system
var deployment_ai
var paddle_ai
var deployment_manager  # Handles piece movement/rotation

## UI
var game_hud

## Entities
var player_ball  # Player's ball (goes through enemy blocks)
var ai_ball      # AI's ball (goes through player blocks)
var player_paddle  # Bottom paddle (human)
var ai_paddle      # Top paddle (AI)


func _ready() -> void:
	print("Game initialized")

func start() -> void:
	"""Start a new game match"""
	DebugLogger.log_info("=== Starting New Match ===", "GAME")
	
	# Initialize systems in order
	_initialize_game_state()
	_initialize_board()
	_initialize_input()
	_initialize_hud()
	_initialize_players()
	
	# Start deployment phase
	_start_deployment()
	
	DebugLogger.log_info("=== Match Started ===", "GAME")
	DebugLogger.log_info("Click on board to place Tetris pieces!", "GAME")

func _initialize_game_state() -> void:
	"""Initialize game state manager"""
	game_state = GameState.new()
	add_child(game_state)
	
	# Connect signals
	game_state.phase_changed.connect(_on_phase_changed)
	game_state.deployment_time_changed.connect(_on_deployment_timer_update)
	game_state.hp_changed.connect(_on_hp_changed)
	game_state.score_changed.connect(_on_score_changed)
	game_state.match_ended.connect(_on_match_ended)
	
	print("✓ Game state initialized")

func _initialize_board() -> void:
	"""Initialize board manager"""
	board_manager = BoardManager.new()
	board_manager.name = "BoardManager"
	add_child(board_manager)
	print("✓ Board created (60x62, full screen)")

func _initialize_input() -> void:
	"""Initialize input system"""
	input_system = InputSystem.new()
	add_child(input_system)
	
	input_system.paddle_moved.connect(_on_paddle_moved)
	print("✓ Input system ready")

func _initialize_hud() -> void:
	"""Initialize game HUD as overlay"""
	var hud_layer = CanvasLayer.new()
	hud_layer.name = "HUDLayer"
	hud_layer.layer = 100  # On top
	add_child(hud_layer)
	
	game_hud = GameHUD.new()
	hud_layer.add_child(game_hud)
	print("✓ HUD initialized (overlay)")

func _initialize_players() -> void:
	"""Initialize player paddles"""
	var board_width_px = board_manager.board_width * board_manager.cell_size
	var board_height_px = board_manager.board_height * board_manager.cell_size
	
	# Human player paddle (AT VERY BOTTOM - Arkanoid style)
	player_paddle = Paddle.new()
	player_paddle.initialize(1, board_height_px - 10, board_width_px)  # 10px from bottom edge
	board_manager.add_child(player_paddle)
	
	# AI paddle (AT VERY TOP - Arkanoid style)
	ai_paddle = Paddle.new()
	ai_paddle.initialize(2, 10, board_width_px)  # 10px from top edge
	board_manager.add_child(ai_paddle)
	
	DebugLogger.log_info("Paddles created at edges (Player=bottom, AI=top)", "GAME")

func _start_deployment() -> void:
	"""Start deployment phase with pre-placed pieces"""
	print("=== DEPLOYMENT PHASE ===")
	print("Pieces are PRE-PLACED. Click to select, drag to move, R to rotate!")
	
	# Create deployment manager
	deployment_manager = DeploymentManager.new()
	deployment_manager.player_id = 1
	add_child(deployment_manager)
	
	# Pre-place player pieces (2 of one type, 3 of another)
	var player_piece_groups = deployment_manager.create_starting_pieces(1, board_manager)
	print("Player has " + str(player_piece_groups.size()) + " pieces pre-placed")
	
	# Pre-place AI pieces (hidden in their territory)
	var ai_deployment = DeploymentManager.new()
	ai_deployment.player_id = 2
	add_child(ai_deployment)
	var ai_piece_groups = ai_deployment.create_starting_pieces(2, board_manager)
	print("AI has " + str(ai_piece_groups.size()) + " pieces pre-placed")
	
	# Start game state
	game_state.start_deployment()
	
	# Mark all pieces as "placed" since they're pre-placed
	game_state.player1_blocks_placed = 5
	game_state.player2_blocks_placed = 5
	game_hud.update_blocks_remaining(1, 5, 5)
	game_hud.update_blocks_remaining(2, 5, 5)

func _input(event: InputEvent) -> void:
	"""Handle input for deployment phase"""
	if game_state.current_phase != GameState.Phase.DEPLOYMENT:
		return
	
	if not deployment_manager:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Mouse down - select piece
				deployment_manager.select_piece_at(event.position, board_manager)
			else:
				# Mouse up - deselect
				deployment_manager.deselect_piece()
	
	elif event is InputEventMouseMotion:
		# Dragging - move selected piece
		if deployment_manager.is_dragging:
			deployment_manager.move_selected_piece(event.position, board_manager)
	
	elif event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_Q:
				# Q key - rotate LEFT (counter-clockwise)
				deployment_manager.rotate_selected_piece(board_manager, -1)
			elif event.keycode == KEY_E:
				# E key - rotate RIGHT (clockwise)
				deployment_manager.rotate_selected_piece(board_manager, 1)


func _on_phase_changed(new_phase: GameState.Phase) -> void:
	"""Phase changed"""
	game_hud.update_phase(game_state.get_phase_name())
	
	if new_phase == GameState.Phase.BATTLE:
		_start_battle()

func _start_battle() -> void:
	"""Start battle phase with TWO balls (one per player)"""
	print("=== BATTLE PHASE ===")
	
	var board_width = board_manager.board_width * board_manager.cell_size
	var board_height = board_manager.board_height * board_manager.cell_size
	
	# Create PLAYER'S ball (starts near player, attacks AI)
	player_ball = Ball.new()
	player_ball.owner_id = 1
	player_ball.initialize(
		Vector2(board_width / 2.0, board_height * 0.75),  # Bottom area
		Vector2(randf_range(-100, 100), -400)  # Going UP toward AI
	)
	board_manager.add_child(player_ball)
	
	# Create AI'S ball (starts near AI, attacks player)
	ai_ball = Ball.new()
	ai_ball.owner_id = 2
	ai_ball.initialize(
		Vector2(board_width / 2.0, board_height * 0.25),  # Top area
		Vector2(randf_range(-100, 100), 400)  # Going DOWN toward player
	)
	board_manager.add_child(ai_ball)
	
	# Initialize ball physics system
	ball_physics = BallPhysics.new()
	ball_physics.set_balls([player_ball, ai_ball])  # Pass both balls
	ball_physics.set_board_manager(board_manager)
	ball_physics.add_paddle(player_paddle)
	ball_physics.add_paddle(ai_paddle)
	ball_physics.ball_missed.connect(_on_ball_missed)
	add_child(ball_physics)
	
	# Initialize AI paddle controller (tracks AI's own ball)
	paddle_ai = PaddleAI.new()
	paddle_ai.set_paddle(ai_paddle)
	paddle_ai.set_ball(ai_ball)  # AI tracks its own ball
	add_child(paddle_ai)
	
	DebugLogger.log_info("TWO balls spawned - Each player has their own ball!", "GAME")

func _process(delta: float) -> void:
	"""Update game systems"""
	if game_state and game_state.current_phase == GameState.Phase.BATTLE:
		if ball_physics:
			ball_physics.update_physics(delta)
		if paddle_ai:
			paddle_ai.update_ai(delta)

func _on_deployment_timer_update(time: float) -> void:
	"""Update deployment timer"""
	game_hud.update_timer(time)

func _on_hp_changed(player_id: int, new_hp: int) -> void:
	"""HP changed"""
	game_hud.update_player_hp(player_id, new_hp)

func _on_score_changed(player_id: int, new_score: int) -> void:
	"""Score changed"""
	game_hud.update_player_score(player_id, new_score)

func _on_ball_missed(player_id: int) -> void:
	"""Ball missed by player"""
	print("Player " + str(player_id) + " missed!")
	game_state.damage_player(player_id, 10)

func _on_match_ended(result: GameState.MatchResult) -> void:
	"""Match ended"""
	print("=== MATCH ENDED ===")
	match result:
		GameState.MatchResult.PLAYER1_WIN:
			print("YOU WIN!")
		GameState.MatchResult.PLAYER2_WIN:
			print("AI WINS!")

func _on_paddle_moved(direction: float, player_id: int) -> void:
	"""Handle paddle movement"""
	if game_state.current_phase == GameState.Phase.BATTLE:
		if player_id == 1 and player_paddle:
			player_paddle.move_with_input(direction)
