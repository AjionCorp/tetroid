## Block Advancement System
##
## Handles blocks moving toward enemy territory every 6 seconds
class_name BlockAdvancement
extends Node

var board_manager
var game_state

var advancement_timer: float = 0.0
const ADVANCEMENT_INTERVAL: float = 6.0  # Advance every 6 seconds

signal blocks_scored(player_id: int, damage: int)

func _ready() -> void:
	print("Block Advancement System initialized")

func set_board_manager(bm) -> void:
	"""Set board manager reference"""
	board_manager = bm

func set_game_state(gs) -> void:
	"""Set game state reference"""
	game_state = gs

func update_advancement(delta: float) -> void:
	"""Update block advancement timer"""
	if game_state.current_phase != GameState.Phase.BATTLE:
		return
	
	advancement_timer += delta
	
	if advancement_timer >= ADVANCEMENT_INTERVAL:
		advancement_timer = 0.0
		_advance_all_blocks()

func _advance_all_blocks() -> void:
	"""Move all blocks 1 space toward enemy"""
	print("=== BLOCK ADVANCEMENT ===")
	
	if not board_manager:
		return
	
	var blocks = board_manager.get_blocks()
	
	for node in blocks:
		if not node is Block:
			continue
		
		var block = node as Block
		if not is_instance_valid(block) or block.is_destroyed:
			continue
		
		# Skip phased blocks
		if block.has_meta("phased") and block.get_meta("phased"):
			continue
		
		# Advance toward enemy
		var new_y = block.grid_position.y
		
		if block.owner_id == 1:
			# Player 1 blocks move UP (toward enemy at top)
			new_y -= 1
		else:
			# Player 2 blocks move DOWN (toward enemy at bottom)
			new_y += 1
		
		# Check if reached scoring zone
		if _check_scoring_zone(block, new_y):
			continue  # Block scored, don't move it
		
		# Move block
		block.grid_position.y = new_y
		block.position = board_manager.grid_to_screen(block.grid_position)
		
		print("Block owner=" + str(block.owner_id) + " advanced to row " + str(new_y))

func _check_scoring_zone(block: Block, new_y: int) -> bool:
	"""Check if block reached scoring zone"""
	var scored = false
	
	if block.owner_id == 1:
		# Player 1 blocks scoring at top (row 0 or less)
		if new_y <= 0:
			scored = true
	else:
		# Player 2 blocks scoring at bottom (row 61 or more)
		if new_y >= 61:
			scored = true
	
	if scored:
		_score_block_group(block)
		return true
	
	return false

func _score_block_group(scoring_block: Block) -> void:
	"""Score damage for a block group (connected blocks)"""
	var connected_blocks = _find_connected_blocks(scoring_block)
	var damage = connected_blocks.size()
	
	print("Block group scored! " + str(damage) + " connected blocks")
	
	# Determine which player takes damage
	var damaged_player = 2 if scoring_block.owner_id == 1 else 1
	
	# Apply damage
	emit_signal("blocks_scored", damaged_player, damage)
	
	# Phase all connected blocks
	for block in connected_blocks:
		_phase_block(block)

func _find_connected_blocks(start_block: Block) -> Array:
	"""Find all blocks connected to this block (same owner, adjacent)"""
	var connected = [start_block]
	var to_check = [start_block]
	var checked = {}
	
	while to_check.size() > 0:
		var current = to_check.pop_back()
		var key = str(current.grid_position)
		
		if checked.has(key):
			continue
		checked[key] = true
		
		# Check 4 adjacent cells
		var adjacent_positions = [
			Vector2i(current.grid_position.x + 1, current.grid_position.y),
			Vector2i(current.grid_position.x - 1, current.grid_position.y),
			Vector2i(current.grid_position.x, current.grid_position.y + 1),
			Vector2i(current.grid_position.x, current.grid_position.y - 1)
		]
		
		for adj_pos in adjacent_positions:
			var adj_block = _find_block_at(adj_pos, current.owner_id)
			if adj_block and not checked.has(str(adj_pos)):
				connected.append(adj_block)
				to_check.append(adj_block)
	
	return connected

func _find_block_at(grid_pos: Vector2i, owner_id: int) -> Block:
	"""Find block at specific grid position with matching owner"""
	if not board_manager:
		return null
	
	var blocks = board_manager.get_blocks()
	
	for node in blocks:
		if not node is Block:
			continue
		
		var block = node as Block
		if is_instance_valid(block) and not block.is_destroyed:
			if block.grid_position == grid_pos and block.owner_id == owner_id:
				# Skip if already phased
				if block.has_meta("phased") and block.get_meta("phased"):
					continue
				return block
	
	return null

func _phase_block(block: Block) -> void:
	"""Phase a block (ghost mode - no collision but visible)"""
	block.set_meta("phased", true)
	
	# Visual feedback - semi-transparent
	block.modulate = Color(block.modulate.r, block.modulate.g, block.modulate.b, 0.3)
	
	print("Block phased (ghost mode) at " + str(block.grid_position))
