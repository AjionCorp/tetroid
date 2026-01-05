## Board Manager
##
## Manages the game board, grid, and visual elements
class_name BoardManager
extends Node2D

var board_width: int = 60
var board_height: int = 62
var cell_size: int = 16

var board_visual: Node2D
var blocks_container: Node2D

func _ready() -> void:
	create_board()

func create_board() -> void:
	"""Create the visual game board"""
	# Background
	var bg = ColorRect.new()
	bg.color = Color(0.05, 0.05, 0.08)
	bg.size = Vector2(board_width * cell_size, board_height * cell_size)
	bg.z_index = -100
	add_child(bg)
	
	# Container for blocks
	blocks_container = Node2D.new()
	blocks_container.name = "Blocks"
	add_child(blocks_container)
	
	# Draw neutral line
	_draw_neutral_line()

func _draw_neutral_line() -> void:
	"""Draw the neutral zone line in the middle"""
	var line = Line2D.new()
	var middle_y = (board_height / 2) * cell_size
	
	line.add_point(Vector2(0, middle_y))
	line.add_point(Vector2(board_width * cell_size, middle_y))
	line.default_color = Color.MAGENTA
	line.width = 2
	line.z_index = 10
	add_child(line)

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
	
	# Check neutral zone (middle line)
	var middle_y = board_height / 2
	if grid_pos.y == middle_y or grid_pos.y == middle_y - 1:
		return false
	
	return true

func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	"""Convert screen position to grid position"""
	return Vector2i(
		int(screen_pos.x / cell_size),
		int(screen_pos.y / cell_size)
	)

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	"""Convert grid position to screen position"""
	return Vector2(
		grid_pos.x * cell_size,
		grid_pos.y * cell_size
	)
