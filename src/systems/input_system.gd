## Input System
##
## Handles all player input (keyboard, controller, mouse)
## Provides clean abstraction for game code
class_name InputSystem
extends Node

## Signals for input events
signal action_pressed(action: String, player_id: int)
signal action_released(action: String, player_id: int)
signal paddle_moved(direction: float, player_id: int)

## Input state
var _player_actions: Dictionary = {}

## Deadzone for analog inputs
const DEADZONE: float = 0.2

func _ready() -> void:
	print("Input system initialized")
	_setup_player_actions()

func _setup_player_actions() -> void:
	"""Define actions for each player"""
	_player_actions = {
		1: {
			"left": "p1_left",
			"right": "p1_right",
			"rotate_left": "p1_rotate_left",
			"rotate_right": "p1_rotate_right",
			"place": "p1_place",
			"ability": "p1_ability"
		}
		# Player 2, 3, 4 can be added when multiplayer is implemented
	}

func _process(_delta: float) -> void:
	"""Check for input each frame"""
	_process_player_input(1)
	# Add more players as needed

func _process_player_input(player_id: int) -> void:
	"""Process input for a specific player"""
	if not _player_actions.has(player_id):
		return
	
	var actions = _player_actions[player_id]
	
	# Movement (analog - gets value)
	var move_input = get_move_input(player_id)
	if abs(move_input) > DEADZONE:
		paddle_moved.emit(move_input, player_id)
	
	# Actions (digital - pressed this frame)
	for action_name in ["rotate_left", "rotate_right", "place", "ability"]:
		if Input.is_action_just_pressed(actions[action_name]):
			action_pressed.emit(action_name, player_id)
		elif Input.is_action_just_released(actions[action_name]):
			action_released.emit(action_name, player_id)

func get_move_input(player_id: int) -> float:
	"""Get movement input (-1 = left, 1 = right, 0 = none)"""
	if not _player_actions.has(player_id):
		return 0.0
	
	var actions = _player_actions[player_id]
	var input = 0.0
	
	# Keyboard
	if Input.is_action_pressed(actions["left"]):
		input -= 1.0
	if Input.is_action_pressed(actions["right"]):
		input += 1.0
	
	# Controller support (if connected)
	# Godot automatically maps controller axes
	var joy_axis = Input.get_joy_axis(player_id - 1, JOY_AXIS_LEFT_X)
	if abs(joy_axis) > DEADZONE:
		input = joy_axis
	
	return clamp(input, -1.0, 1.0)

func is_action_pressed(action: String, player_id: int) -> bool:
	"""Check if an action is currently held down"""
	if not _player_actions.has(player_id):
		return false
	
	var player_action_name = _player_actions[player_id].get(action, "")
	if player_action_name.is_empty():
		return false
	
	return Input.is_action_pressed(player_action_name)

func is_action_just_pressed(action: String, player_id: int) -> bool:
	"""Check if an action was just pressed this frame"""
	if not _player_actions.has(player_id):
		return false
	
	var player_action_name = _player_actions[player_id].get(action, "")
	if player_action_name.is_empty():
		return false
	
	return Input.is_action_just_pressed(player_action_name)

func get_mouse_position() -> Vector2:
	"""Get current mouse position in the viewport"""
	return get_viewport().get_mouse_position()

func enable_input(player_id: int, enabled: bool) -> void:
	"""Enable or disable input for a player"""
	# Can be used to disable input during menus, pause, etc.
	# For now, just a placeholder
	pass
