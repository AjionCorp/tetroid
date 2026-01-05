## Main Entry Point for Tetroid
##
## This is the ONLY scene file in the project.
## Everything else is created programmatically from code.
##
## @tutorial: See .template/docs/CODE_DRIVEN_DEVELOPMENT.md
extends Node

## Game instance
var game: Game

func _ready() -> void:
	print("=== Tetroid Starting ===")
	print("Code-Driven Development Mode")
	print("Engine: Godot " + Engine.get_version_info().string)
	
	# Initialize core systems
	_initialize_systems()
	
	# Create game instance
	game = Game.new()
	add_child(game)
	
	# Start game
	game.start()
	
	print("=== Tetroid Ready ===")

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

func _process(delta: float) -> void:
	# Main game loop runs at 60 FPS
	# Individual systems handle their own updates
	pass
