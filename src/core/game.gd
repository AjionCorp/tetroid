## Main Game Class
##
## Manages the complete game state and coordinates all systems
class_name Game
extends Node2D

## Game systems
var game_state: GameState
var input_system
var deployment_ai: DeploymentAI
var game_hud: GameHUD

## Entities
var blocks: Array = []
var ball
var player1_paddle
var player2_paddle

## Player pieces to place
var player1_pieces: Array = []
var player2_pieces: Array = []
var player1_current_piece_index: int = 0

## Deployment placement preview
var placement_preview

## Delta accumulator for fixed timestep
var _delta_accumulator: float = 0.0

func _ready() -> void:
	print("Game instance created")

func start() -> void:
	"""Start the game"""
	print("Starting game match...")
	
	# Create game state manager
	game_state = GameState.new()
	add_child(game_state)
	_connect_game_state_signals()
	
	# Initialize input system
	input_system = InputSystem.new()
	add_child(input_system)
	_connect_input_signals()
	
	# Create game world
	_create_world()
	
	# Create HUD
	game_hud = GameHUD.new()
	add_child(game_hud)
	
	# Create players
	_create_players()
	
	# Start deployment phase
	_start_deployment_phase()
	
	print("Game started!")

func _connect_game_state_signals() -> void:
	"""Connect to game state signals"""
	game_state.phase_changed.connect(_on_phase_changed)
	game_state.deployment_time_changed.connect(_on_deployment_time_changed)
	game_state.hp_changed.connect(_on_hp_changed)
	game_state.score_changed.connect(_on_score_changed)
	game_state.match_ended.connect(_on_match_ended)

func _connect_input_signals() -> void:
	"""Connect input system signals"""
	input_system.action_pressed.connect(_on_action_pressed)
	input_system.paddle_moved.connect(_on_paddle_moved)

func _create_world() -> void:
	"""Create the game world programmatically"""
	print("Creating game world...")
	
	# Create background
	var bg = ColorRect.new()
	bg.color = Constants.COLOR_BG_DARK
	bg.size = Vector2(
		Constants.BOARD_WIDTH * Constants.CELL_SIZE,
		Constants.BOARD_HEIGHT * Constants.CELL_SIZE
	)
	bg.z_index = -100
	add_child(bg)
	
	# Create board grid visualization
	_create_board_grid()
	
	print("Game world created")

func _create_board_grid() -> void:
	"""Create visual grid for the board"""
	var grid = Node2D.new()
	grid.name = "BoardGrid"
	add_child(grid)
	
	# Draw grid lines (subtle)
	for x in range(Constants.BOARD_WIDTH + 1):
		if x % 5 == 0:  # Only every 5th line
			var line = Line2D.new()
			line.add_point(Vector2(x * Constants.CELL_SIZE, 0))
			line.add_point(Vector2(x * Constants.CELL_SIZE, Constants.BOARD_HEIGHT * Constants.CELL_SIZE))
			line.default_color = Color(Constants.COLOR_PANEL_DARK, 0.3)
			line.width = 1
			grid.add_child(line)
	
	for y in range(Constants.BOARD_HEIGHT + 1):
		if y % 5 == 0:  # Only every 5th line
			var line = Line2D.new()
			line.add_point(Vector2(0, y * Constants.CELL_SIZE))
			line.add_point(Vector2(Constants.BOARD_WIDTH * Constants.CELL_SIZE, y * Constants.CELL_SIZE))
			line.default_color = Color(Constants.COLOR_PANEL_DARK, 0.3)
			line.width = 1
			grid.add_child(line)
	
	# Highlight neutral zone
	var neutral_zone = ColorRect.new()
	neutral_zone.color = Color(Constants.COLOR_ACCENT, 0.3)
	neutral_zone.position = Vector2(0, Constants.NEUTRAL_START_Y * Constants.CELL_SIZE)
	neutral_zone.size = Vector2(
		Constants.BOARD_WIDTH * Constants.CELL_SIZE,
		2 * Constants.CELL_SIZE
	)
	grid.add_child(neutral_zone)

func _create_players() -> void:
	"""Create player paddles"""
	# Player 1 paddle (top)
	player1_paddle = Paddle.new()
	player1_paddle.initialize(1, 5 * Constants.CELL_SIZE)
	add_child(player1_paddle)
	
	# Player 2 paddle (bottom)
	player2_paddle = Paddle.new()
	player2_paddle.initialize(2, 57 * Constants.CELL_SIZE)
	add_child(player2_paddle)
	
	print("Players created")

func _start_deployment_phase() -> void:
	"""Start the deployment phase"""
	print("=== DEPLOYMENT PHASE ===")
	
	# Generate random pieces for each player
	player1_pieces = _generate_random_pieces(5)
	player2_pieces = _generate_random_pieces(5)
	
	print("Player 1 pieces: " + str(player1_pieces))
	print("Player 2 pieces: " + str(player2_pieces))
	
	# Start game state
	game_state.start_deployment()
	
	# Initialize AI
	deployment_ai = DeploymentAI.new()
	deployment_ai.player_id = 2
	deployment_ai.ai_place_block.connect(_on_ai_place_block)
	add_child(deployment_ai)
	deployment_ai.start_deployment(player2_pieces)
	
	# Show instructions
	print("Place your 5 blocks! Use mouse to click where to place.")
	print("Current piece: " + player1_pieces[0])

func _generate_random_pieces(count: int) -> Array:
	"""Generate random Tetris pieces"""
	var pieces = []
	var all_types = BlockData.get_all_piece_types()
	
	for i in range(count):
		var random_type = all_types[randi() % all_types.size()]
		pieces.append(random_type)
	
	return pieces

func _process(delta: float) -> void:
	"""Main game loop"""
	# Fixed timestep for physics
	_delta_accumulator += delta
	
	while _delta_accumulator >= Constants.FIXED_DELTA:
		_fixed_update(Constants.FIXED_DELTA)
		_delta_accumulator -= Constants.FIXED_DELTA

func _fixed_update(delta: float) -> void:
	"""Fixed timestep update"""
	# Update all blocks
	for block in blocks:
		if is_instance_valid(block):
			block._process(delta)

func _input(event: InputEvent) -> void:
	"""Handle input events"""
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if game_state.current_phase == GameState.Phase.DEPLOYMENT:
				_handle_deployment_click(event.position)

func _handle_deployment_click(click_pos: Vector2) -> void:
	"""Handle clicking to place block during deployment"""
	if not game_state.can_place_block(1):
		print("No more blocks to place!")
		return
	
	# Convert screen position to grid position
	var grid_x = int(click_pos.x / Constants.CELL_SIZE)
	var grid_y = int(click_pos.y / Constants.CELL_SIZE)
	var grid_pos = Vector2i(grid_x, grid_y)
	
	# Check if in player 1 territory
	if not Constants.is_in_player1_territory(grid_y):
		print("Can only place in your own territory during deployment!")
		return
	
	# Get current piece
	var piece_type = player1_pieces[player1_current_piece_index]
	
	# Create block
	var block = BlockFactory.create_block(piece_type, grid_pos, 1)
	if block:
		add_child(block)
		blocks.append(block)
		
		game_state.register_block_placed(1)
		player1_current_piece_index += 1
		
		# Update HUD
		game_hud.update_blocks_remaining(1, player1_current_piece_index, 5)
		
		if player1_current_piece_index < player1_pieces.size():
			print("Next piece: " + player1_pieces[player1_current_piece_index])
		else:
			print("All blocks placed! Waiting for opponent...")

func _on_ai_place_block(piece_type: String, grid_pos: Vector2i) -> void:
	"""AI places a block"""
	if not game_state.can_place_block(2):
		return
	
	var block = BlockFactory.create_block(piece_type, grid_pos, 2)
	if block:
		add_child(block)
		blocks.append(block)
		
		game_state.register_block_placed(2)
		
		# Update HUD
		game_hud.update_blocks_remaining(2, game_state.player2_blocks_placed, 5)

func _on_phase_changed(new_phase: GameState.Phase) -> void:
	"""Handle phase change"""
	print("Phase changed to: " + game_state.get_phase_name())
	game_hud.update_phase(game_state.get_phase_name())
	
	if new_phase == GameState.Phase.BATTLE:
		_start_battle_phase()

func _start_battle_phase() -> void:
	"""Start the battle phase with ball"""
	print("=== BATTLE PHASE ===")
	
	# Create ball
	var board_width = Constants.BOARD_WIDTH * Constants.CELL_SIZE
	var board_height = Constants.BOARD_HEIGHT * Constants.CELL_SIZE
	
	ball = Ball.new()
	ball.initialize(
		Vector2(board_width / 2, board_height / 2),
		Vector2(0, -400)  # Start moving toward player 1
	)
	ball.ball_missed.connect(_on_ball_missed)
	add_child(ball)
	
	print("Ball spawned - FIGHT!")

func _on_deployment_time_changed(time: float) -> void:
	"""Update deployment timer in HUD"""
	game_hud.update_timer(time)

func _on_hp_changed(player_id: int, new_hp: int) -> void:
	"""Update HP in HUD"""
	game_hud.update_player_hp(player_id, new_hp)

func _on_score_changed(player_id: int, new_score: int) -> void:
	"""Update score in HUD"""
	game_hud.update_player_score(player_id, new_score)

func _on_ball_missed(player_id: int) -> void:
	"""Ball was missed by a player"""
	print("Player " + str(player_id) + " missed the ball!")
	
	# Apply damage
	game_state.damage_player(player_id, 10)

func _on_match_ended(result: GameState.MatchResult) -> void:
	"""Match ended"""
	print("=== MATCH ENDED ===")
	
	match result:
		GameState.MatchResult.PLAYER1_WIN:
			print("PLAYER 1 WINS!")
		GameState.MatchResult.PLAYER2_WIN:
			print("PLAYER 2 WINS!")
		GameState.MatchResult.DRAW:
			print("DRAW!")

func _on_action_pressed(action: String, player_id: int) -> void:
	"""Handle action input"""
	# Only used in battle phase
	pass

func _on_paddle_moved(direction: float, player_id: int) -> void:
	"""Handle paddle movement"""
	if game_state.current_phase == GameState.Phase.BATTLE:
		if player_id == 1 and player1_paddle:
			player1_paddle.move_with_input(direction)
		elif player_id == 2 and player2_paddle:
			player2_paddle.move_with_input(direction)

func stop() -> void:
	"""Stop the game"""
	print("Game stopped")
