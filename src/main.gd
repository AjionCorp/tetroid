## Main Entry Point for Tetroid
##
## This is the ONLY scene file in the project.
## Everything else is created programmatically from code.
##
## @tutorial: See .template/docs/CODE_DRIVEN_DEVELOPMENT.md
extends Node

## Current screen
var current_screen
var main_menu

func _ready() -> void:
	print("=== Tetroid Starting ===")
	print("Code-Driven Development Mode")
	print("Engine: Godot " + Engine.get_version_info().string)
	
	# Clear previous debug log
	DebugLogger.clear_log()
	DebugLogger.print_log_location()
	
	# Initialize core systems
	_initialize_systems()
	
	# Show loading screen first
	_show_loading_screen()

func _initialize_systems() -> void:
	"""Initialize all core systems before game starts"""
	print("Initializing core systems...")
	
	# Load constants
	Constants.initialize()
	
	# Load configuration data
	Config.load_config()
	
	# Load block data
	BlockData.load_data()
	
	# Initialize asset registry (procedural + external)
	AssetRegistry.initialize()
	
	print("Core systems initialized")

func _show_loading_screen() -> void:
	"""Show loading screen with Steam authentication"""
	print("Showing loading screen...")
	
	var loading = LoadingScreen.new()
	loading.loading_complete.connect(_on_loading_complete)
	add_child(loading)
	current_screen = loading

func _on_loading_complete() -> void:
	"""Called when loading is complete"""
	print("Loading complete, showing main menu...")
	
	# Remove loading screen
	if current_screen:
		current_screen.queue_free()
	
	# Show main menu
	_show_main_menu()

func _show_main_menu() -> void:
	"""Show main menu/lobby"""
	main_menu = MainMenu.new()
	
	# Get player info from Steam
	var steam_manager = get_node_or_null("/root/SteamManager")
	if steam_manager:
		main_menu.set_player_info(steam_manager.get_player_name(), 1000)
	
	main_menu.mode_selected.connect(_on_mode_selected)
	add_child(main_menu)
	current_screen = main_menu
	
	print("Main menu displayed")

func _on_mode_selected(mode: String) -> void:
	"""Handle game mode selection"""
	print("Starting game mode: " + mode)
	# MainMenu handles transition to game

func _process(_delta: float) -> void:
	# Individual systems handle their own updates
	pass
