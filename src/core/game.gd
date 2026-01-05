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

## Delta accumulator for fixed timestep
var _delta_accumulator: float = 0.0

func _ready() -> void:
	print("Game instance created")

func start() -> void:
	"""Start the game"""
	print("Starting game...")
	
	# Create game world
	_create_world()
	
	# Initialize game state
	is_running = true
	game_time = 0.0
	
	print("Game started!")

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
	
	# Update game systems here
	# TODO: Add system updates when implemented

func _update_fps_display() -> void:
	"""Update FPS counter"""
	var fps_label := get_node_or_null("FPSLabel")
	if fps_label:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func stop() -> void:
	"""Stop the game"""
	is_running = false
	print("Game stopped")
