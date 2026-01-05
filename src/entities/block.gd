## Block Entity
##
## Represents a single Tetris piece block in the game world
## Has HP, abilities, and visual representation
class_name Block
extends Node2D

## Block properties
var block_id: int = 0
var piece_type: String = ""
var owner_id: int = 0
var grid_position: Vector2i = Vector2i.ZERO
var piece_rotation: int = 0  # Renamed from 'rotation' to avoid Node2D conflict

## Stats
var hp: int = 3
var max_hp: int = 3

## Ability
var ability_name: String = ""
var ability_cooldown: float = 0.0
var ability_cooldown_max: float = 5.0

## Territory
enum Territory { FRIENDLY, ENEMY, NEUTRAL }
var territory: Territory = Territory.FRIENDLY

## Visual
var sprite: Sprite2D
var color: Color = Color.WHITE

## State
var is_destroyed: bool = false

signal block_hit(damage: int)
signal block_destroyed()
signal ability_activated()

func _ready() -> void:
	# Sprite is added by factory
	pass

func initialize(config: Dictionary, grid_pos: Vector2i, owner: int) -> void:
	"""Initialize block with configuration"""
	piece_type = config.get("name", "Unknown")
	hp = config.get("hp", 3)
	max_hp = hp
	color = Color(config.get("color", "#FFFFFF"))
	ability_name = config.get("ability", "")
	ability_cooldown_max = config.get("ability_cooldown", 5.0)
	
	grid_position = grid_pos
	owner_id = owner
	
	# Set visual position
	position = Vector2(
		grid_pos.x * Constants.CELL_SIZE,
		grid_pos.y * Constants.CELL_SIZE
	)
	
	# Determine territory
	_determine_territory()

func _determine_territory() -> void:
	"""Determine if block is in friendly, enemy, or neutral territory"""
	if Constants.is_in_neutral_zone(grid_position.y):
		territory = Territory.NEUTRAL
	elif owner_id == 1:
		# Player 1 (human) owns BOTTOM territory
		if Constants.is_in_player2_territory(grid_position.y):
			territory = Territory.FRIENDLY
		else:
			territory = Territory.ENEMY
	else:
		# Player 2 (AI) owns TOP territory
		if Constants.is_in_player1_territory(grid_position.y):
			territory = Territory.FRIENDLY
		else:
			territory = Territory.ENEMY

func _process(delta: float) -> void:
	"""Update block state"""
	# Update cooldown
	if ability_cooldown > 0:
		ability_cooldown -= delta
		ability_cooldown = max(0.0, ability_cooldown)

func take_damage(amount: int) -> void:
	"""Apply damage to block"""
	if is_destroyed:
		return
	
	hp -= amount
	block_hit.emit(amount)
	
	# Visual feedback
	_flash_damage()
	
	if hp <= 0:
		destroy()

func _flash_damage() -> void:
	"""Visual feedback when hit"""
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(sprite, "modulate", color, 0.1)

func destroy() -> void:
	"""Destroy the block"""
	if is_destroyed:
		return
	
	is_destroyed = true
	block_destroyed.emit()
	
	# Play destruction animation
	_play_destruction_animation()

func _play_destruction_animation() -> void:
	"""Animate block destruction"""
	var tween := create_tween()
	tween.set_parallel(true)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	
	# Scale down
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.3)
	
	# Rotate
	tween.tween_property(self, "rotation_degrees", 180, 0.3)
	
	# Create particles
	_create_destruction_particles()
	
	# Remove after animation
	tween.tween_callback(queue_free)

func _create_destruction_particles() -> void:
	"""Create particle effect on destruction"""
	var particles := CPUParticles2D.new()
	particles.position = position
	particles.emitting = true
	particles.one_shot = true
	particles.amount = 20
	particles.lifetime = 0.5
	particles.explosiveness = 1.0
	
	# Set color
	particles.color = color
	
	# Physics
	particles.direction = Vector2(0, -1)
	particles.spread = 180
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 150
	particles.gravity = Vector2(0, 300)
	
	# Add to parent
	get_parent().add_child(particles)
	
	# Auto-remove after lifetime
	await get_tree().create_timer(particles.lifetime).timeout
	particles.queue_free()

func activate_ability() -> bool:
	"""Activate block's ability"""
	if ability_cooldown > 0:
		return false
	
	if is_destroyed:
		return false
	
	# Reset cooldown
	ability_cooldown = ability_cooldown_max
	
	ability_activated.emit()
	
	# Visual feedback
	_play_ability_effect()
	
	return true

func _play_ability_effect() -> void:
	"""Visual effect when ability activates"""
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.1)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)

func get_territory_modifier() -> float:
	"""Get stat modifier based on territory"""
	match territory:
		Territory.FRIENDLY:
			return 1.2  # 20% bonus in friendly territory
		Territory.ENEMY:
			return 0.8  # 20% penalty in enemy territory
		_:
			return 1.0

func heal(amount: int) -> void:
	"""Heal the block"""
	if is_destroyed:
		return
	
	hp = min(hp + amount, max_hp)
	
	# Visual feedback
	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "modulate", Color.GREEN, 0.1)
		tween.tween_property(sprite, "modulate", color, 0.1)
