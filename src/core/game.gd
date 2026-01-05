## Main Game Class
##
## Manages the complete game state and coordinates all systems
class_name Game
extends Node2D

## Current game mode
var game_mode: Constants.GameMode = Constants.GameMode.ONE_VS_ONE

## Game state
var is_running: bool = false
var game_time: float = 0.0

## Systems
var input_system

## Entities
var blocks: Array = []

## Delta accumulator for fixed timestep
var _delta_accumulator: float = 0.0

func _ready() -> void:
	print("Game instance created")

func start() -> void:
	"""Start the game"""
	print("Starting game...")
	
	# Initialize input system
	input_system = InputSystem.new()
	add_child(input_system)
	_connect_input_signals()
	
	# Create game world
	_create_world()
	
	# Create test blocks
	_create_test_blocks()
	
	# Initialize game state
	is_running = true
	game_time = 0.0
	
	print("Game started!")

func _connect_input_signals() -> void:
	"""Connect input system signals"""
	input_system.action_pressed.connect(_on_action_pressed)
	input_system.paddle_moved.connect(_on_paddle_moved)

func _on_action_pressed(action: String, player_id: int) -> void:
	"""Handle action input"""
	print("Action pressed: " + action + " (Player " + str(player_id) + ")")
	
	match action:
		"place":
			_test_place_block()
		"rotate_left":
			print("Rotate left")
		"rotate_right":
			print("Rotate right")
		"ability":
			_test_activate_abilities()

func _on_paddle_moved(direction: float, player_id: int) -> void:
	"""Handle paddle movement"""
	# Will be used for paddle control
	pass

func _create_world() -> void:
	"""Create the game world programmatically"""
	print("Creating game world...")
	
	# Create background
	var bg := ColorRect.new()
	bg.color = Constants.COLOR_BG_DARK
	bg.size = Vector2(
		Constants.BOARD_WIDTH * Constants.CELL_SIZE,
		Constants.BOARD_HEIGHT * Constants.CELL_SIZE
	)
	bg.z_index = -100
	add_child(bg)
	
	# Create board grid visualization
	_create_board_grid()
	
	# Add test label
	var label := Label.new()
	label.text = "TETROID - Code-Driven Development\nGame World Created Successfully!"
	label.position = Vector2(100, 100)
	label.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	add_child(label)
	
	# Add FPS counter
	var fps_label := Label.new()
	fps_label.name = "FPSLabel"
	fps_label.position = Vector2(10, 10)
	fps_label.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	add_child(fps_label)
	
	print("Game world created")

func _create_board_grid() -> void:
	"""Create visual grid for the board"""
	var grid := Node2D.new()
	grid.name = "BoardGrid"
	add_child(grid)
	
	# Draw grid lines
	for x in range(Constants.BOARD_WIDTH + 1):
		var line := Line2D.new()
		line.add_point(Vector2(x * Constants.CELL_SIZE, 0))
		line.add_point(Vector2(x * Constants.CELL_SIZE, Constants.BOARD_HEIGHT * Constants.CELL_SIZE))
		line.default_color = Color(Constants.COLOR_PANEL_DARK, 0.3)
		line.width = 1
		grid.add_child(line)
	
	for y in range(Constants.BOARD_HEIGHT + 1):
		var line := Line2D.new()
		line.add_point(Vector2(0, y * Constants.CELL_SIZE))
		line.add_point(Vector2(Constants.BOARD_WIDTH * Constants.CELL_SIZE, y * Constants.CELL_SIZE))
		line.default_color = Color(Constants.COLOR_PANEL_DARK, 0.3)
		line.width = 1
		grid.add_child(line)
	
	# Highlight neutral zone
	var neutral_zone := ColorRect.new()
	neutral_zone.color = Color(Constants.COLOR_ACCENT, 0.2)
	neutral_zone.position = Vector2(0, Constants.NEUTRAL_START_Y * Constants.CELL_SIZE)
	neutral_zone.size = Vector2(
		Constants.BOARD_WIDTH * Constants.CELL_SIZE,
		2 * Constants.CELL_SIZE
	)
	grid.add_child(neutral_zone)

func _process(delta: float) -> void:
	"""Main game loop (60 FPS)"""
	if not is_running:
		return
	
	# Update FPS display
	_update_fps_display()
	
	# Fixed timestep update
	_delta_accumulator += delta
	
	while _delta_accumulator >= Constants.FIXED_DELTA:
		_fixed_update(Constants.FIXED_DELTA)
		_delta_accumulator -= Constants.FIXED_DELTA

func _fixed_update(delta: float) -> void:
	"""Fixed timestep update for game logic"""
	game_time += delta
	
	# Update all blocks
	for block in blocks:
		if is_instance_valid(block):
			block._process(delta)

func _create_test_blocks() -> void:
	"""Create some test blocks to visualize the system"""
	print("Creating test blocks...")
	
	# Create a few blocks of different types
	var test_positions = [
		{"type": "I_PIECE", "pos": Vector2i(5, 5)},
		{"type": "O_PIECE", "pos": Vector2i(10, 8)},
		{"type": "T_PIECE", "pos": Vector2i(15, 12)},
		{"type": "S_PIECE", "pos": Vector2i(20, 15)},
		{"type": "Z_PIECE", "pos": Vector2i(25, 20)},
		{"type": "J_PIECE", "pos": Vector2i(30, 25)},
		{"type": "L_PIECE", "pos": Vector2i(35, 28)},
	]
	
	for test in test_positions:
		var block := BlockFactory.create_block(test.type, test.pos, 1)
		if block:
			add_child(block)
			blocks.append(block)
			print("  Created " + test.type + " at " + str(test.pos))
	
	print("Test blocks created: " + str(blocks.size()))

func _test_place_block() -> void:
	"""Test placing a new block (Space key)"""
	var random_x := randi() % Constants.BOARD_WIDTH
	var random_y := randi() % 20 + 5  # Top half
	var random_type := BlockData.get_all_piece_types()[randi() % 7]
	
	var block := BlockFactory.create_block(random_type, Vector2i(random_x, random_y), 1)
	if block:
		add_child(block)
		blocks.append(block)
		print("Placed " + random_type + " at (" + str(random_x) + ", " + str(random_y) + ")")

func _test_activate_abilities() -> void:
	"""Test activating abilities on all blocks (F key)"""
	var activated := 0
	for block in blocks:
		if is_instance_valid(block) and block.activate_ability():
			activated += 1
	
	if activated > 0:
		print("Activated " + str(activated) + " abilities")

func _update_fps_display() -> void:
	"""Update FPS counter"""
	var fps_label := get_node_or_null("FPSLabel")
	if fps_label:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func stop() -> void:
	"""Stop the game"""
	is_running = false
	print("Game stopped")
