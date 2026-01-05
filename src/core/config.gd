## Configuration Manager
##
## Loads and manages configuration from JSON files
class_name Config

static var data: Dictionary = {}

static func load_config() -> void:
	"""Load configuration from data/config.json"""
	var config_path := "res://src/data/config.json"
	
	if not FileAccess.file_exists(config_path):
		print("Config file not found, using defaults")
		_load_defaults()
		return
	
	var file := FileAccess.open(config_path, FileAccess.READ)
	if file:
		var json_string := file.get_as_text()
		var json := JSON.new()
		var parse_result := json.parse(json_string)
		
		if parse_result == OK:
			data = json.data
			print("Configuration loaded from " + config_path)
		else:
			print("Error parsing config: " + json.get_error_message())
			_load_defaults()
	else:
		print("Could not open config file")
		_load_defaults()

static func _load_defaults() -> void:
	"""Load default configuration values"""
	data = {
		"game": {
			"board_width": 60,
			"board_height": 62,
			"cell_size": 16,
			"target_fps": 60
		},
		"gameplay": {
			"starting_hp": 100,
			"ball_speed": 400,
			"paddle_speed": 400
		},
		"network": {
			"tick_rate": 30,
			"max_players": 4,
			"default_port": 7777
		}
	}
	print("Using default configuration")

static func get_value(path: String, default = null):
	"""Get configuration value using dot notation (e.g., 'game.board_width')"""
	var parts := path.split(".")
	var current = data
	
	for part in parts:
		if current is Dictionary and current.has(part):
			current = current[part]
		else:
			return default
	
	return current
