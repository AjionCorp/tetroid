## Main Game Class
##
## Orchestrates all game systems in a modular way
class_name Game
extends CanvasLayer

## Core systems
var game_state: GameState
var board_manager: BoardManager
var ball_physics: BallPhysics
var input_system: InputSystem
var deployment_ai: DeploymentAI

## UI
var game_hud: GameHUD

## Entities
var ball: Ball
var player_paddle: Paddle  # Bottom paddle (human)
var ai_paddle: Paddle      # Top paddle (AI)

## Player data
var player_pieces: Array = []
var ai_pieces: Array = []
var current_piece_index: int = 0

func _ready() -> void:
	print("Game initialized")

func start() -> void:
	"""Start a new game match"""
	print("=== Starting New Match ===")
	
	# Initialize systems in order
	_initialize_game_state()
	_initialize_board()
	_initialize_input()
	_initialize_hud()
	_initialize_players()
	
	# Start deployment phase
	_start_deployment()
	
	print("=== Match Started ===")

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
	add_child(board_manager)
	print("✓ Board created (60x62)")

func _initialize_input() -> void:
	"""Initialize input system"""
	input_system = InputSystem.new()
	add_child(input_system)
	
	input_system.paddle_moved.connect(_on_paddle_moved)
	print("✓ Input system ready")

func _initialize_hud() -> void:
	"""Initialize game HUD"""
	game_hud = GameHUD.new()
	add_child(game_hud)
	print("✓ HUD initialized")

func _initialize_players() -> void:
	"""Initialize player paddles"""
	# Human player paddle (BOTTOM)
	player_paddle = Paddle.new()
	player_paddle.initialize(1, 57 * board_manager.cell_size)
	board_manager.add_child(player_paddle)
	
	# AI paddle (TOP)
	ai_paddle = Paddle.new()
	ai_paddle.initialize(2, 5 * board_manager.cell_size)
	board_manager.add_child(ai_paddle)
	
	print("✓ Paddles created (Human=bottom, AI=top)")

func _start_deployment() -> void:
	"""Start deployment phase"""
	# Generate random pieces
	player_pieces = _generate_random_pieces(5)
	ai_pieces = _generate_random_pieces(5)
	current_piece_index = 0
	
	print("Your pieces: " + str(player_pieces))
	print("Click anywhere to place piece: " + player_pieces[0])
	
	# Start game state
	game_state.start_deployment()
	
	# Initialize AI deployment
	deployment_ai = DeploymentAI.new()
	deployment_ai.player_id = 2
	deployment_ai.ai_place_block.connect(_on_ai_place_block)
	add_child(deployment_ai)
	deployment_ai.start_deployment(ai_pieces)

func _generate_random_pieces(count: int) -> Array:
	"""Generate random Tetris pieces"""
	var pieces = []
	var all_types = ["I_PIECE", "O_PIECE", "T_PIECE", "S_PIECE", "Z_PIECE", "J_PIECE", "L_PIECE"]
	
	for i in range(count):
		pieces.append(all_types[randi() % all_types.size()])
	
	return pieces

func _input(event: InputEvent) -> void:
	"""Handle mouse clicks for block placement"""
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if game_state.current_phase == GameState.Phase.DEPLOYMENT:
				_handle_click_placement(event.position)

func _handle_click_placement(click_pos: Vector2) -> void:
	"""Handle clicking to place block"""
	if not game_state.can_place_block(1):
		print("No more blocks to place!")
		return
	
	# Convert to grid position
	var grid_pos = board_manager.screen_to_grid(click_pos)
	
	# Validate position
	if not board_manager.is_position_valid(grid_pos):
		print("Invalid position! (Out of bounds or neutral zone)")
		return
	
	# Place block
	var piece_type = player_pieces[current_piece_index]
	var block = BlockFactory.create_block(piece_type, grid_pos, 1)
	
	if block:
		board_manager.add_block(block)
		
		game_state.register_block_placed(1)
		current_piece_index += 1
		
		game_hud.update_blocks_remaining(1, current_piece_index, 5)
		
		if current_piece_index < player_pieces.size():
			print("Placed " + piece_type + "! Next: " + player_pieces[current_piece_index])
		else:
			print("All your blocks placed!")

func _on_ai_place_block(piece_type: String, grid_pos: Vector2i) -> void:
	"""AI places a block"""
	if not game_state.can_place_block(2):
		return
	
	var block = BlockFactory.create_block(piece_type, grid_pos, 2)
	if block:
		board_manager.add_block(block)
		game_state.register_block_placed(2)
		game_hud.update_blocks_remaining(2, game_state.player2_blocks_placed, 5)

func _on_phase_changed(new_phase: GameState.Phase) -> void:
	"""Phase changed"""
	game_hud.update_phase(game_state.get_phase_name())
	
	if new_phase == GameState.Phase.BATTLE:
		_start_battle()

func _start_battle() -> void:
	"""Start battle phase with ball"""
	print("=== BATTLE PHASE ===")
	
	# Create ball
	var board_width = board_manager.board_width * board_manager.cell_size
	var board_height = board_manager.board_height * board_manager.cell_size
	
	ball = Ball.new()
	ball.initialize(
		Vector2(board_width / 2, board_height / 2),
		Vector2(0, 400)  # Start going DOWN toward player
	)
	board_manager.add_child(ball)
	
	# Initialize ball physics system
	ball_physics = BallPhysics.new()
	ball_physics.set_ball(ball)
	ball_physics.set_board_manager(board_manager)
	ball_physics.add_paddle(player_paddle)
	ball_physics.add_paddle(ai_paddle)
	ball_physics.ball_missed.connect(_on_ball_missed)
	add_child(ball_physics)
	
	print("Ball spawned - FIGHT!")

func _process(delta: float) -> void:
	"""Update game systems"""
	if game_state and game_state.current_phase == GameState.Phase.BATTLE:
		if ball_physics:
			ball_physics.update_physics(delta)

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
