## Debug Logger
##
## Captures and displays Godot errors and logs
class_name DebugLogger
extends Node

static var log_file_path: String = "user://tetroid_debug.log"
static var enable_file_logging: bool = true
static var enable_console: bool = true

static func log_info(message: String, system: String = "GAME") -> void:
	"""Log info message"""
	var formatted = "[INFO][" + system + "] " + message
	_write_log(formatted)
	if enable_console:
		print(formatted)

static func log_warning(message: String, system: String = "GAME") -> void:
	"""Log warning message"""
	var formatted = "[WARN][" + system + "] " + message
	_write_log(formatted)
	if enable_console:
		push_warning(formatted)

static func log_error(message: String, system: String = "GAME") -> void:
	"""Log error message"""
	var formatted = "[ERROR][" + system + "] " + message
	_write_log(formatted)
	if enable_console:
		push_error(formatted)

static func log_game_event(event: String, data: Dictionary = {}) -> void:
	"""Log game event with data"""
	var formatted = "[EVENT] " + event + " | " + str(data)
	_write_log(formatted)
	if enable_console:
		print(formatted)

static func _write_log(message: String) -> void:
	"""Write to log file"""
	if not enable_file_logging:
		return
	
	var file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		var timestamp = Time.get_datetime_string_from_system()
		file.store_line(timestamp + " | " + message)
		file.close()

static func clear_log() -> void:
	"""Clear the log file"""
	var file = FileAccess.open(log_file_path, FileAccess.WRITE)
	if file:
		file.close()
	print("Debug log cleared")

static func print_log_location() -> void:
	"""Print where the log file is stored"""
	var real_path = ProjectSettings.globalize_path(log_file_path)
	print("=== DEBUG LOG LOCATION ===")
	print("Log file: " + real_path)
	print("==========================")

static func dump_game_state(game_state: GameState) -> void:
	"""Dump current game state for debugging"""
	print("=== GAME STATE DUMP ===")
	print("Phase: " + game_state.get_phase_name())
	print("P1 HP: " + str(game_state.player1_hp) + " | P2 HP: " + str(game_state.player2_hp))
	print("P1 Score: " + str(game_state.player1_score) + " | P2 Score: " + str(game_state.player2_score))
	print("P1 Blocks: " + str(game_state.player1_blocks_placed) + "/5")
	print("P2 Blocks: " + str(game_state.player2_blocks_placed) + "/5")
	if game_state.current_phase == GameState.Phase.DEPLOYMENT:
		print("Deployment Time: " + str(int(game_state.deployment_time)) + "s")
	print("======================")
