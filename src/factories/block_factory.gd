## Block Factory
##
## Creates block entities programmatically
## Handles sprite generation and configuration
class_name BlockFactory

static var _next_block_id: int = 1

static func create_block(piece_type: String, grid_pos: Vector2i, owner_id: int):
	"""Create a block entity"""
	var config := BlockData.get_config(piece_type)
	if config.is_empty():
		push_error("Cannot create block: invalid piece type " + piece_type)
		return null
	
	# Create block instance
	var block := Block.new()
	block.block_id = _next_block_id
	_next_block_id += 1
	
	# Add sprite
	var sprite := _create_sprite(piece_type, Color(config.color))
	block.sprite = sprite
	block.add_child(sprite)
	
	# Initialize with config
	block.initialize(config, grid_pos, owner_id)
	
	# Add collision shape (for ball physics)
	var collision := _create_collision()
	block.add_child(collision)
	
	return block

static func create_test_block(grid_pos: Vector2i):
	"""Create a test block for development"""
	return create_block("I_PIECE", grid_pos, 1)

static func _create_sprite(piece_type: String, color: Color) -> Sprite2D:
	"""Create sprite for block"""
	var sprite := Sprite2D.new()
	
	# Get or generate texture
	var texture := AssetRegistry.get_sprite(piece_type)
	if not texture:
		# Generate if not found
		texture = SpriteGenerator.generate_block_texture(piece_type, color)
	
	sprite.texture = texture
	sprite.centered = false  # Align to grid
	
	return sprite

static func _create_collision() -> Area2D:
	"""Create collision area for block"""
	var area := Area2D.new()
	area.name = "CollisionArea"
	
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(Constants.CELL_SIZE, Constants.CELL_SIZE)
	shape.shape = rect
	shape.position = Vector2(Constants.CELL_SIZE / 2, Constants.CELL_SIZE / 2)
	
	area.add_child(shape)
	
	return area

static func create_block_grid(piece_type: String, grid_positions: Array, owner_id: int) -> Array:
	"""Create multiple blocks forming a Tetris piece"""
	var blocks: Array = []
	
	for grid_pos in grid_positions:
		var block := create_block(piece_type, grid_pos, owner_id)
		if block:
			blocks.append(block)
	
	return blocks

static func get_tetris_piece_shape(piece_type: String) -> Array:
	"""Get the shape configuration for a Tetris piece"""
	var config := BlockData.get_config(piece_type)
	if config.has("shape"):
		return config.shape
	return []

static func calculate_piece_positions(piece_type: String, center_pos: Vector2i, rotation: int = 0) -> Array:
	"""Calculate grid positions for all blocks in a piece"""
	var shape := get_tetris_piece_shape(piece_type)
	if shape.is_empty():
		return []
	
	var positions: Array = []
	
	# Parse shape array
	for y in range(shape.size()):
		var row = shape[y]
		for x in range(row.size()):
			if row[x] == 1:
				var pos := Vector2i(
					center_pos.x + x,
					center_pos.y + y
				)
				positions.append(pos)
	
	# Apply rotation if needed
	if rotation != 0:
		positions = _rotate_positions(positions, center_pos, rotation)
	
	return positions

static func _rotate_positions(positions: Array, center: Vector2i, rotation: int) -> Array:
	"""Rotate positions around center (90 degree increments)"""
	var rotated: Array = []
	
	for pos in positions:
		var relative := pos - center
		var new_relative := relative
		
		# Apply rotation (0, 90, 180, 270)
		match rotation % 4:
			1:  # 90 degrees
				new_relative = Vector2i(-relative.y, relative.x)
			2:  # 180 degrees
				new_relative = Vector2i(-relative.x, -relative.y)
			3:  # 270 degrees
				new_relative = Vector2i(relative.y, -relative.x)
		
		rotated.append(center + new_relative)
	
	return rotated
