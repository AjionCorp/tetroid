## Deployment AI
##
## Simple AI for placing blocks during deployment phase
class_name DeploymentAI
extends Node

var player_id: int = 2
var blocks_to_place: Array = []
var current_block_index: int = 0
var placement_delay: float = 3.0  # Seconds between placements
var time_since_last_place: float = 0.0

signal ai_place_block(piece_type: String, position: Vector2i)

func _ready() -> void:
	print("Deployment AI initialized for Player " + str(player_id))

func start_deployment(pieces: Array) -> void:
	"""Start AI deployment with given pieces"""
	blocks_to_place = pieces.duplicate()
	current_block_index = 0
	time_since_last_place = 0.0
	print("AI has " + str(blocks_to_place.size()) + " blocks to place")

func _process(delta: float) -> void:
	"""Update AI placement logic"""
	if current_block_index >= blocks_to_place.size():
		return
	
	time_since_last_place += delta
	
	if time_since_last_place >= placement_delay:
		_place_next_block()
		time_since_last_place = 0.0

func _place_next_block() -> void:
	"""AI places the next block"""
	if current_block_index >= blocks_to_place.size():
		return
	
	var piece_type = blocks_to_place[current_block_index]
	
	# Simple AI: Place randomly in own territory
	# Player 2 territory is bottom half (y: 32-61)
	var x = randi() % (Constants.BOARD_WIDTH - 4) + 2  # Leave some margin
	var y = randi() % 20 + 35  # In player 2 territory
	
	var pos = Vector2i(x, y)
	
	print("AI placing " + piece_type + " at " + str(pos))
	emit_signal("ai_place_block", piece_type, pos)
	
	current_block_index += 1
