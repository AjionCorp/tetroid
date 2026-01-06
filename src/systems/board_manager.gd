## Board Manager
##
## Manages the game board, grid, and visual elements
class_name BoardManager
extends Node2D

var board_width: int = 60
var board_height: int = 62  # 30 + 2 + 30
var cell_size: int = 16

var blocks_container: Node2D
var effects_container: Node2D
var screen_size: Vector2

func _ready() -> void:
	create_board()

func create_board() -> void:
	"""Create the visual game board (full screen)"""
	screen_size = get_viewport().get_visible_rect().size
	
	# Calculate cell size to fill screen
	var cells_width = float(board_width)
	var cells_height = float(board_height)
	
	# Use smaller dimension to maintain aspect ratio
	var cell_width = screen_size.x / cells_width
	var cell_height = screen_size.y / cells_height
	cell_size = int(min(cell_width, cell_height))
	
	# Calculate actual board size
	var board_pixel_width = board_width * cell_size
	var board_pixel_height = board_height * cell_size
	
	# Center the board
	var offset_x = (screen_size.x - board_pixel_width) / 2
	var offset_y = (screen_size.y - board_pixel_height) / 2
	position = Vector2(offset_x, offset_y)
	
	print("Board size: " + str(board_width) + "x" + str(board_height) + " cells")
	print("Cell size: " + str(cell_size) + "px")
	print("Board position: " + str(position))
	
	# Dark background
	var bg = ColorRect.new()
	bg.color = Color(0.02, 0.02, 0.05)
	bg.size = Vector2(board_pixel_width, board_pixel_height)
	bg.z_index = -100
	add_child(bg)
	
	# Draw grid
	_draw_grid()
	
	# Container for blocks (only Block objects)
	blocks_container = Node2D.new()
	blocks_container.name = "Blocks"
	add_child(blocks_container)
	
	# Container for visual effects (particles, etc)
	effects_container = Node2D.new()
	effects_container.name = "Effects"
	effects_container.z_index = 50
	add_child(effects_container)
	
	# Draw neutral zone
	_draw_neutral_zone()
	
	# Draw territory borders
	_draw_territory_borders()

func _draw_grid() -> void:
	"""Draw subtle grid lines for EVERY square"""
	var grid = Node2D.new()
	grid.name = "Grid"
	grid.z_index = -50
	add_child(grid)
	
	# Vertical lines (EVERY cell)
	for x in range(board_width + 1):
		var line = Line2D.new()
		line.add_point(Vector2(x * cell_size, 0))
		line.add_point(Vector2(x * cell_size, board_height * cell_size))
		
		# Thicker line every 10 cells
		if x % 10 == 0:
			line.default_color = Color(0.15, 0.15, 0.2, 0.5)
			line.width = 1
		else:
			line.default_color = Color(0.08, 0.08, 0.12, 0.3)
			line.width = 1
		
		grid.add_child(line)
	
	# Horizontal lines (EVERY cell)
	for y in range(board_height + 1):
		var line = Line2D.new()
		line.add_point(Vector2(0, y * cell_size))
		line.add_point(Vector2(board_width * cell_size, y * cell_size))
		
		# Thicker line every 10 cells
		if y % 10 == 0:
			line.default_color = Color(0.15, 0.15, 0.2, 0.5)
			line.width = 1
		else:
			line.default_color = Color(0.08, 0.08, 0.12, 0.3)
			line.width = 1
		
		grid.add_child(line)

func _draw_neutral_zone() -> void:
	"""Draw the 2-block neutral zone in middle"""
	var neutral_start_y = 30 * cell_size
	
	# Neutral zone background (2 blocks tall)
	var neutral_bg = ColorRect.new()
	neutral_bg.color = Color(0.2, 0.1, 0.3, 0.4)
	neutral_bg.position = Vector2(0, neutral_start_y)
	neutral_bg.size = Vector2(board_width * cell_size, 2 * cell_size)
	neutral_bg.z_index = -40
	add_child(neutral_bg)
	
	# Top line of neutral zone
	var line_top = Line2D.new()
	line_top.add_point(Vector2(0, neutral_start_y))
	line_top.add_point(Vector2(board_width * cell_size, neutral_start_y))
	line_top.default_color = Color.MAGENTA
	line_top.width = 3
	line_top.z_index = 10
	add_child(line_top)
	
	# Bottom line of neutral zone
	var line_bottom = Line2D.new()
	line_bottom.add_point(Vector2(0, neutral_start_y + 2 * cell_size))
	line_bottom.add_point(Vector2(board_width * cell_size, neutral_start_y + 2 * cell_size))
	line_bottom.default_color = Color.MAGENTA
	line_bottom.width = 3
	line_bottom.z_index = 10
	add_child(line_bottom)

func _draw_territory_borders() -> void:
	"""Draw borders around the play area"""
	var border = Line2D.new()
	border.default_color = Color(0.5, 0.2, 0.2, 0.8)
	border.width = 3
	border.z_index = 20
	
	# Draw border rectangle
	var w = board_width * cell_size
	var h = board_height * cell_size
	border.add_point(Vector2(0, 0))
	border.add_point(Vector2(w, 0))
	border.add_point(Vector2(w, h))
	border.add_point(Vector2(0, h))
	border.add_point(Vector2(0, 0))
	
	add_child(border)

func add_block(block: Block) -> void:
	"""Add a block to the board"""
	if blocks_container:
		blocks_container.add_child(block)

func get_blocks() -> Array:
	"""Get all blocks on the board"""
	if blocks_container:
		return blocks_container.get_children()
	return []

func is_position_valid(grid_pos: Vector2i) -> bool:
	"""Check if a position is valid for placement"""
	# Check bounds
	if grid_pos.x < 0 or grid_pos.x >= board_width:
		return false
	if grid_pos.y < 0 or grid_pos.y >= board_height:
		return false
	
	# Check neutral zone (rows 30-31, 2 blocks in middle)
	if grid_pos.y == 30 or grid_pos.y == 31:
		return false
	
	return true

func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	"""Convert screen position to grid position"""
	# Adjust for board offset (board may be centered)
	var local_pos = screen_pos - position
	return Vector2i(
		int(local_pos.x / cell_size),
		int(local_pos.y / cell_size)
	)

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	"""Convert grid position to screen position"""
	return Vector2(
		grid_pos.x * cell_size,
		grid_pos.y * cell_size
	)
