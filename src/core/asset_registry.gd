## Asset Registry
##
## Manages both procedural and external assets
## Tries to load external first, falls back to procedural generation
class_name AssetRegistry

static var sprites: Dictionary = {}
static var sounds: Dictionary = {}
static var fonts: Dictionary = {}

static func initialize() -> void:
	"""Initialize asset registry"""
	print("Initializing asset registry...")
	
	# Try to load external assets first
	load_external_assets()
	
	# Generate any missing assets procedurally
	generate_missing_assets()
	
	print("Asset registry initialized: " + str(sprites.size()) + " sprites, " + str(sounds.size()) + " sounds")

static func load_external_assets() -> void:
	"""Try to load external assets if they exist"""
	# Fonts (recommended external)
	_load_font("regular", "res://assets/fonts/regular.ttf")
	_load_font("bold", "res://assets/fonts/bold.ttf")
	
	# UI sprites (optional external)
	_load_sprite("ui_button_normal", "res://assets/sprites/ui/button_normal.png")
	_load_sprite("ui_button_hover", "res://assets/sprites/ui/button_hover.png")
	
	# Particle textures (optional external)
	_load_sprite("particle_spark", "res://assets/sprites/particles/spark.png")
	
	# Music (recommended external)
	_load_audio("music_menu", "res://assets/audio/music/menu_theme.ogg")
	_load_audio("music_gameplay", "res://assets/audio/music/gameplay_theme.ogg")

static func generate_missing_assets() -> void:
	"""Generate any assets that weren't loaded externally"""
	# Always generate block sprites (need easy modification)
	for piece_type in BlockData.get_all_piece_types():
		var config := BlockData.get_config(piece_type)
		sprites[piece_type] = SpriteGenerator.generate_block_texture(
			piece_type,
			Color(config.color)
		)
	
	# Generate missing UI elements
	if not sprites.has("ui_button_normal"):
		sprites["ui_button_normal"] = SpriteGenerator.generate_button_texture("normal")
	
	# Generate missing particles
	if not sprites.has("particle_spark"):
		sprites["particle_spark"] = SpriteGenerator.generate_particle_texture("spark")
	
	# Generate placeholder audio
	if not sounds.has("sfx_block_hit"):
		sounds["sfx_block_hit"] = AudioGenerator.generate_simple_tone(1200.0, 0.1)

static func _load_sprite(key: String, path: String) -> void:
	"""Try to load external sprite"""
	if FileAccess.file_exists(path):
		var texture := load(path) as Texture2D
		if texture:
			sprites[key] = texture
			print("  Loaded external sprite: " + key)
	else:
		print("  External sprite not found (will generate): " + key)

static func _load_audio(key: String, path: String) -> void:
	"""Try to load external audio"""
	if FileAccess.file_exists(path):
		var stream := load(path) as AudioStream
		if stream:
			sounds[key] = stream
			print("  Loaded external audio: " + key)

static func _load_font(key: String, path: String) -> void:
	"""Try to load external font"""
	if FileAccess.file_exists(path):
		var font := load(path) as Font
		if font:
			fonts[key] = font
			print("  Loaded external font: " + key)

static func get_sprite(key: String) -> Texture2D:
	"""Get sprite (external or generated)"""
	return sprites.get(key)

static func get_sound(key: String) -> AudioStream:
	"""Get audio (external or generated)"""
	return sounds.get(key)

static func get_font(key: String) -> Font:
	"""Get font (external or fallback)"""
	return fonts.get(key, ThemeDB.fallback_font)
