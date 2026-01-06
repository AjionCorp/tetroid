## Deployment Manager
##
## Handles deployment phase mechanics: pre-placed pieces that can be moved/rotated
class_name DeploymentManager
extends Node

var player_id: int = 1
var deployed_pieces: Array = []  # Array of PieceGroup (multi-block pieces)
var selected_piece = null
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

signal piece_moved(piece, new_position: Vector2i)
signal piece_rotated(piece, new_rotation: int)

func _ready() -> void:
	print("Deployment Manager initialized")

func create_starting_pieces(pid: int, board_manager) -> Array:
	"""Create pre-placed starting pieces for a player"""
	player_id = pid
	var pieces = []
	
	# Starting composition: 2x of one type, 3x of another
	var piece_types = []
	
	# Random selection
	var all_types = ["I_PIECE", "O_PIECE", "T_PIECE", "S_PIECE", "Z_PIECE", "J_PIECE", "L_PIECE"]
	var type1 = all_types[randi() % all_types.size()]
	var type2 = all_types[randi() % all_types.size()]
	while type2 == type1:
		type2 = all_types[randi() % all_types.size()]
	
	# 2 of type1, 3 of type2
	piece_types = [type1, type1, type2, type2, type2]
	
	print("Player " + str(pid) + " starting pieces: 2x " + type1 + ", 3x " + type2)
	
	# Pre-place them clustered and visible in player's territory
	var territory_y_start = 50 if pid == 1 else 10  # Bottom for P1, top for P2
	var spacing = 6  # Tighter spacing
	
	for i in range(piece_types.size()):
		var piece_type = piece_types[i]
		var start_pos = Vector2i(10 + (i * spacing), territory_y_start)
		
		# Create piece group
		var piece_group = _create_piece_group(piece_type, start_pos, pid, board_manager)
		pieces.append(piece_group)
	
	deployed_pieces = pieces
	
	# Debug: Show where all pieces are
	print("=== Deployed Pieces for Player " + str(pid) + " ===")
	for i in range(pieces.size()):
		var p = pieces[i]
		print("  Piece " + str(i+1) + ": " + p.type + " at anchor " + str(p.anchor))
		print("    Blocks at: " + str([b.grid_position for b in p.blocks if is_instance_valid(b)]))
	print("================")
	
	return pieces

func _create_piece_group(piece_type: String, grid_pos: Vector2i, owner: int, board_manager) -> Dictionary:
	"""Create a piece group (multi-block Tetris piece)"""
	var positions = BlockFactory.calculate_piece_positions(piece_type, grid_pos, 0)
	var blocks = BlockFactory.create_block_grid(piece_type, positions, owner)
	
	var piece_group = {
		"type": piece_type,
		"anchor": grid_pos,
		"rotation": 0,
		"blocks": blocks,
		"owner": owner
	}
	
	# Add blocks to board
	for block in blocks:
		board_manager.add_block(block)
	
	return piece_group

func select_piece_at(click_pos: Vector2, board_manager) -> bool:
	"""Try to select a piece at click position"""
	# Adjust for board offset
	var local_pos = click_pos - board_manager.position
	var grid_pos = Vector2i(
		int(local_pos.x / board_manager.cell_size),
		int(local_pos.y / board_manager.cell_size)
	)
	
	print("Click at screen: " + str(click_pos) + " → grid: " + str(grid_pos))
	
	# Find which piece was clicked
	for piece_group in deployed_pieces:
		for block in piece_group.blocks:
			if is_instance_valid(block):
				print("  Checking block at: " + str(block.grid_position))
				if block.grid_position == grid_pos:
					selected_piece = piece_group
					is_dragging = true
					print("✓ Selected " + piece_group.type + " piece!")
					_highlight_piece(piece_group, true)
					return true
	
	print("✗ No piece found at " + str(grid_pos))
	return false

func move_selected_piece(new_pos: Vector2, board_manager) -> void:
	"""Move the currently selected piece"""
	if not selected_piece or not is_dragging:
		return
	
	# Adjust for board offset
	var local_pos = new_pos - board_manager.position
	var new_grid_pos = Vector2i(
		int(local_pos.x / board_manager.cell_size),
		int(local_pos.y / board_manager.cell_size)
	)
	
	# Calculate new block positions
	var new_positions = BlockFactory.calculate_piece_positions(
		selected_piece.type,
		new_grid_pos,
		selected_piece.rotation
	)
	
	# Validate all positions
	var all_valid = true
	for pos in new_positions:
		if not board_manager.is_position_valid(pos):
			all_valid = false
			break
	
	if not all_valid:
		return
	
	# Update block positions
	for i in range(selected_piece.blocks.size()):
		if i < new_positions.size() and is_instance_valid(selected_piece.blocks[i]):
			var block = selected_piece.blocks[i]
			block.grid_position = new_positions[i]
			block.position = board_manager.grid_to_screen(new_positions[i])
	
	selected_piece.anchor = new_grid_pos

func rotate_selected_piece(board_manager) -> void:
	"""Rotate the selected piece 90 degrees"""
	if not selected_piece:
		print("No piece selected to rotate!")
		return
	
	var new_rotation = (selected_piece.rotation + 1) % 4
	
	print("Rotating " + selected_piece.type + " from " + str(selected_piece.rotation) + " to " + str(new_rotation))
	
	# Calculate new positions with rotation
	var new_positions = BlockFactory.calculate_piece_positions(
		selected_piece.type,
		selected_piece.anchor,
		new_rotation
	)
	
	print("New positions after rotation: " + str(new_positions))
	
	# Validate
	var all_valid = true
	for pos in new_positions:
		if not board_manager.is_position_valid(pos):
			all_valid = false
			print("Invalid position: " + str(pos))
			break
	
	if not all_valid:
		print("Cannot rotate there! Would go out of bounds or hit neutral zone")
		return
	
	# Update blocks
	for i in range(selected_piece.blocks.size()):
		if i < new_positions.size() and is_instance_valid(selected_piece.blocks[i]):
			var block = selected_piece.blocks[i]
			block.grid_position = new_positions[i]
			block.position = board_manager.grid_to_screen(new_positions[i])
			block.piece_rotation = new_rotation
	
	selected_piece.rotation = new_rotation
	print("✓ Rotated " + selected_piece.type + " to " + str(new_rotation * 90) + "°")

func deselect_piece() -> void:
	"""Deselect current piece"""
	if selected_piece:
		_highlight_piece(selected_piece, false)
		selected_piece = null
	is_dragging = false

func _highlight_piece(piece_group: Dictionary, highlight: bool) -> void:
	"""Highlight/unhighlight a piece"""
	for block in piece_group.blocks:
		if is_instance_valid(block) and block.sprite:
			if highlight:
				block.sprite.modulate = Color(2.0, 2.0, 2.0)  # Much brighter
				block.sprite.scale = Vector2(1.2, 1.2)  # Slightly larger
			else:
				block.sprite.modulate = Color.WHITE
				block.sprite.scale = Vector2(1.0, 1.0)
