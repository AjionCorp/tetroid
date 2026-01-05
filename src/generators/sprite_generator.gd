## Sprite Generator
##
## Procedurally generates textures for blocks, UI, and effects
class_name SpriteGenerator

static func generate_block_texture(piece_type: String, color: Color) -> ImageTexture:
	"""Generate a simple block sprite with color and shading"""
	var size := 16  # 16x16 pixels per block
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	
	# Fill with base color
	for x in range(size):
		for y in range(size):
			var pixel_color := color
			
			# Add highlight (top-left)
			if x < 2 or y < 2:
				pixel_color = pixel_color.lightened(0.3)
			
			# Add shadow (bottom-right)
			if x >= size - 2 or y >= size - 2:
				pixel_color = pixel_color.darkened(0.3)
			
			# Add border
			if x == 0 or y == 0 or x == size - 1 or y == size - 1:
				pixel_color = Color.BLACK
			
			image.set_pixel(x, y, pixel_color)
	
	return ImageTexture.create_from_image(image)

static func generate_button_texture(state: String) -> ImageTexture:
	"""Generate a simple button texture"""
	var width := 128
	var height := 32
	var image := Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	var base_color: Color
	match state:
		"normal":
			base_color = Constants.COLOR_PANEL_LIGHT
		"hover":
			base_color = Constants.COLOR_ACCENT
		"pressed":
			base_color = Constants.COLOR_ACCENT.darkened(0.2)
		_:
			base_color = Constants.COLOR_PANEL_DARK
	
	# Fill with color
	for x in range(width):
		for y in range(height):
			var pixel_color := base_color
			
			# Gradient effect
			var gradient := 1.0 - (float(y) / height) * 0.2
			pixel_color = pixel_color.lightened(gradient * 0.1)
			
			# Border
			if x == 0 or y == 0 or x == width - 1 or y == height - 1:
				pixel_color = Constants.COLOR_TEXT_SECONDARY
			
			image.set_pixel(x, y, pixel_color)
	
	return ImageTexture.create_from_image(image)

static func generate_particle_texture(particle_type: String) -> ImageTexture:
	"""Generate a particle texture"""
	var size := 32
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	
	var center := Vector2(size / 2.0, size / 2.0)
	var max_radius := size / 2.0
	
	for x in range(size):
		for y in range(size):
			var pos := Vector2(x, y)
			var dist := pos.distance_to(center)
			var alpha := 1.0 - (dist / max_radius)
			alpha = clamp(alpha, 0.0, 1.0)
			
			var color := Color.WHITE
			color.a = alpha
			
			image.set_pixel(x, y, color)
	
	return ImageTexture.create_from_image(image)

static func generate_ball_texture(ball_type: Constants.BallType) -> ImageTexture:
	"""Generate a ball sprite"""
	var size := 8
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	
	var color: Color
	match ball_type:
		Constants.BallType.NORMAL:
			color = Color.WHITE
		Constants.BallType.FIRE:
			color = Color(1.0, 0.3, 0.0)
		Constants.BallType.ICE:
			color = Color(0.0, 0.8, 1.0)
		Constants.BallType.HEAVY:
			color = Color(0.3, 0.3, 0.3)
		Constants.BallType.GHOST:
			color = Color(0.8, 0.8, 1.0, 0.5)
		_:
			color = Color.WHITE
	
	var center := Vector2(size / 2.0, size / 2.0)
	var radius := size / 2.0
	
	for x in range(size):
		for y in range(size):
			var pos := Vector2(x + 0.5, y + 0.5)
			var dist := pos.distance_to(center)
			
			if dist < radius:
				var pixel_color := color
				# Add simple shading
				var shade := 1.0 - (dist / radius) * 0.3
				pixel_color = pixel_color.lightened(shade * 0.2)
				image.set_pixel(x, y, pixel_color)
			else:
				image.set_pixel(x, y, Color.TRANSPARENT)
	
	return ImageTexture.create_from_image(image)

static func regenerate_all() -> void:
	"""Regenerate all procedural sprites (useful for development)"""
	print("Regenerating all procedural sprites...")
	AssetRegistry.generate_missing_assets()
	print("Sprites regenerated")
