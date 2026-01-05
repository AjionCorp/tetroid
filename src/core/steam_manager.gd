## Steam Manager
##
## Handles Steam API integration and authentication
class_name SteamManager
extends Node

signal steam_initialized(success: bool)
signal auth_completed(steam_id: int, username: String)
signal auth_failed(error: String)

var is_initialized: bool = false
var steam_id: int = 0
var steam_username: String = "Player"
var is_steam_running: bool = false

func _ready() -> void:
	print("Steam Manager initializing...")

func initialize() -> bool:
	"""Initialize Steam API"""
	# Check if Steam module is available (requires GodotSteam plugin)
	# For now, we'll simulate it for development
	
	if Engine.has_singleton("Steam"):
		print("Steam API found, initializing...")
		return _initialize_real_steam()
	else:
		print("Steam API not found, using mock mode")
		return _initialize_mock_steam()

func _initialize_real_steam() -> bool:
	"""Initialize real Steam API (requires GodotSteam plugin)"""
	var Steam = Engine.get_singleton("Steam")
	
	if not Steam.isSteamRunning():
		push_error("Steam is not running!")
		emit_signal("auth_failed", "Steam not running")
		return false
	
	var init_result = Steam.steamInit()
	if init_result.status != 1:
		push_error("Failed to initialize Steam: " + str(init_result))
		emit_signal("auth_failed", "Steam init failed")
		return false
	
	is_steam_running = true
	is_initialized = true
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	
	print("Steam initialized successfully")
	print("Steam ID: " + str(steam_id))
	print("Username: " + steam_username)
	
	emit_signal("steam_initialized", true)
	emit_signal("auth_completed", steam_id, steam_username)
	
	return true

func _initialize_mock_steam() -> bool:
	"""Mock Steam for development without Steam"""
	is_steam_running = false
	is_initialized = true
	steam_id = 76561198000000000 + randi() % 99999999
	steam_username = "DevPlayer_" + str(randi() % 1000)
	
	print("Mock Steam initialized")
	print("Mock Steam ID: " + str(steam_id))
	print("Mock Username: " + steam_username)
	
	# Simulate async initialization
	await get_tree().create_timer(0.5).timeout
	
	emit_signal("steam_initialized", true)
	emit_signal("auth_completed", steam_id, steam_username)
	
	return true

func get_player_name() -> String:
	"""Get current player name"""
	return steam_username

func get_steam_id() -> int:
	"""Get current Steam ID"""
	return steam_id

func is_authenticated() -> bool:
	"""Check if player is authenticated"""
	return is_initialized and steam_id > 0
