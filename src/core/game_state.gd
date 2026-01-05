## Game State Manager
##
## Manages the complete game state and match flow
class_name GameState
extends Node

enum Phase {
	DEPLOYMENT,  # Players placing initial blocks
	BATTLE,      # Active gameplay with ball
	ENDED        # Match finished
}

enum MatchResult {
	ONGOING,
	PLAYER1_WIN,
	PLAYER2_WIN,
	DRAW
}

signal phase_changed(new_phase: Phase)
signal deployment_time_changed(time_remaining: float)
signal hp_changed(player_id: int, new_hp: int)
signal score_changed(player_id: int, new_score: int)
signal match_ended(result: MatchResult)

## Current phase
var current_phase: Phase = Phase.DEPLOYMENT

## Deployment phase
var deployment_time: float = 90.0
var deployment_blocks_to_place: int = 5

## Player states
var player1_hp: int = 100
var player2_hp: int = 100
var player1_score: int = 0
var player2_score: int = 0
var player1_blocks_placed: int = 0
var player2_blocks_placed: int = 0

## Match time
var match_time: float = 0.0

func _ready() -> void:
	print("GameState initialized")

func _process(delta: float) -> void:
	match current_phase:
		Phase.DEPLOYMENT:
			_update_deployment(delta)
		Phase.BATTLE:
			_update_battle(delta)

func _update_deployment(delta: float) -> void:
	"""Update deployment phase"""
	deployment_time -= delta
	emit_signal("deployment_time_changed", deployment_time)
	
	if deployment_time <= 0:
		_end_deployment_phase()

func _update_battle(delta: float) -> void:
	"""Update battle phase"""
	match_time += delta
	
	# Check win conditions
	if player1_hp <= 0 or player2_hp <= 0:
		_end_match()

func start_deployment() -> void:
	"""Start deployment phase"""
	current_phase = Phase.DEPLOYMENT
	deployment_time = 90.0
	player1_blocks_placed = 0
	player2_blocks_placed = 0
	emit_signal("phase_changed", Phase.DEPLOYMENT)
	print("Deployment phase started - 90 seconds to place blocks")

func _end_deployment_phase() -> void:
	"""End deployment phase and start battle"""
	current_phase = Phase.BATTLE
	match_time = 0.0
	emit_signal("phase_changed", Phase.BATTLE)
	print("Battle phase started!")

func can_place_block(player_id: int) -> bool:
	"""Check if player can place another block"""
	if current_phase != Phase.DEPLOYMENT:
		return false
	
	if player_id == 1:
		return player1_blocks_placed < deployment_blocks_to_place
	else:
		return player2_blocks_placed < deployment_blocks_to_place

func register_block_placed(player_id: int) -> void:
	"""Register that a block was placed"""
	if player_id == 1:
		player1_blocks_placed += 1
		print("Player 1 blocks placed: " + str(player1_blocks_placed) + "/" + str(deployment_blocks_to_place))
	else:
		player2_blocks_placed += 1
		print("Player 2 blocks placed: " + str(player2_blocks_placed) + "/" + str(deployment_blocks_to_place))
	
	# Auto-start battle if both players placed all blocks
	if player1_blocks_placed >= deployment_blocks_to_place and player2_blocks_placed >= deployment_blocks_to_place:
		print("All blocks placed, starting battle in 3 seconds...")
		await get_tree().create_timer(3.0).timeout
		_end_deployment_phase()

func damage_player(player_id: int, amount: int) -> void:
	"""Apply damage to a player"""
	if player_id == 1:
		player1_hp = max(0, player1_hp - amount)
		emit_signal("hp_changed", 1, player1_hp)
		print("Player 1 HP: " + str(player1_hp))
	else:
		player2_hp = max(0, player2_hp - amount)
		emit_signal("hp_changed", 2, player2_hp)
		print("Player 2 HP: " + str(player2_hp))
	
	# Check for game over
	if player1_hp <= 0 or player2_hp <= 0:
		_end_match()

func add_score(player_id: int, points: int) -> void:
	"""Add score to a player"""
	if player_id == 1:
		player1_score += points
		emit_signal("score_changed", 1, player1_score)
	else:
		player2_score += points
		emit_signal("score_changed", 2, player2_score)

func _end_match() -> void:
	"""End the match and determine winner"""
	current_phase = Phase.ENDED
	
	var result: MatchResult
	if player1_hp > player2_hp:
		result = MatchResult.PLAYER1_WIN
	elif player2_hp > player1_hp:
		result = MatchResult.PLAYER2_WIN
	else:
		result = MatchResult.DRAW
	
	emit_signal("match_ended", result)
	print("Match ended: " + str(result))

func get_phase_name() -> String:
	"""Get current phase as string"""
	match current_phase:
		Phase.DEPLOYMENT:
			return "DEPLOYMENT"
		Phase.BATTLE:
			return "BATTLE"
		Phase.ENDED:
			return "ENDED"
		_:
			return "UNKNOWN"
