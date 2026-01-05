## Block Data Loader
##
## Loads and provides access to block configuration data
class_name BlockData

static var data: Dictionary = {}

static func load_data() -> void:
	"""Load block data from blocks.json"""
	var data_path := "res://src/data/blocks.json"
	
	if not FileAccess.file_exists(data_path):
		print("ERROR: blocks.json not found!")
		return
	
	var file := FileAccess.open(data_path, FileAccess.READ)
	if file:
		var json_string := file.get_as_text()
		var json := JSON.new()
		var parse_result := json.parse(json_string)
		
		if parse_result == OK:
			data = json.data
			print("Block data loaded: " + str(data.keys().size()) + " piece types")
		else:
			print("Error parsing blocks.json: " + json.get_error_message())
	else:
		print("Could not open blocks.json")

static func get_config(piece_type: String) -> Dictionary:
	"""Get configuration for a piece type"""
	if data.has(piece_type):
		return data[piece_type]
	else:
		print("WARNING: No config found for piece type: " + piece_type)
		return {}

static func get_all_piece_types() -> Array:
	"""Get all available piece types"""
	return data.keys()
