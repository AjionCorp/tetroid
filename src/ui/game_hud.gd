## Game HUD
##
## In-game UI showing player stats, timer, resources
class_name GameHUD
extends Control

## References
var timer_label: Label
var phase_label: Label

## Player 1 UI (top right)
var p1_hp_label: Label
var p1_score_label: Label
var p1_blocks_label: Label

## Player 2 UI (bottom right)
var p2_hp_label: Label
var p2_score_label: Label
var p2_blocks_label: Label

func _ready() -> void:
	# Fill screen
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE  # Don't block game input
	
	_create_hud()

func _create_hud() -> void:
	"""Create HUD elements programmatically"""
	# Top right - Player 1 stats
	_create_player1_panel()
	
	# Bottom right - Player 2 stats
	_create_player2_panel()
	
	# Center top - Timer and phase
	_create_center_display()

func _create_player1_panel() -> void:
	"""Create Player 1 stats panel (top right)"""
	var panel = _create_stat_panel(Vector2(20, 20), "PLAYER 1", Color.CYAN)
	
	var vbox = panel.get_child(0) as VBoxContainer
	
	# HP
	p1_hp_label = Label.new()
	p1_hp_label.text = "HP: 100"
	p1_hp_label.add_theme_color_override("font_color", Color.GREEN)
	p1_hp_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(p1_hp_label)
	
	# Score
	p1_score_label = Label.new()
	p1_score_label.text = "SCORE: 0"
	p1_score_label.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	vbox.add_child(p1_score_label)
	
	# Blocks remaining
	p1_blocks_label = Label.new()
	p1_blocks_label.text = "BLOCKS: 5/5"
	p1_blocks_label.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(p1_blocks_label)
	
	add_child(panel)

func _create_player2_panel() -> void:
	"""Create Player 2 stats panel (bottom right)"""
	var panel = _create_stat_panel(Vector2(20, -220), "PLAYER 2", Color.ORANGE)
	panel.anchor_top = 1.0
	panel.anchor_bottom = 1.0
	
	var vbox = panel.get_child(0) as VBoxContainer
	
	# HP
	p2_hp_label = Label.new()
	p2_hp_label.text = "HP: 100"
	p2_hp_label.add_theme_color_override("font_color", Color.GREEN)
	p2_hp_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(p2_hp_label)
	
	# Score
	p2_score_label = Label.new()
	p2_score_label.text = "SCORE: 0"
	p2_score_label.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	vbox.add_child(p2_score_label)
	
	# Blocks remaining
	p2_blocks_label = Label.new()
	p2_blocks_label.text = "BLOCKS: 5/5"
	p2_blocks_label.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(p2_blocks_label)
	
	add_child(panel)

func _create_stat_panel(pos: Vector2, title: String, color: Color) -> PanelContainer:
	"""Create a stat panel"""
	var panel = PanelContainer.new()
	panel.position = pos
	panel.custom_minimum_size = Vector2(200, 180)
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Color(Constants.COLOR_PANEL_DARK, 0.9)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = color
	panel.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)
	
	# Title
	var title_label = Label.new()
	title_label.text = title
	title_label.add_theme_color_override("font_color", color)
	title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(title_label)
	
	return panel

func _create_center_display() -> void:
	"""Create center timer/phase display"""
	var center = VBoxContainer.new()
	center.anchor_left = 0.5
	center.anchor_right = 0.5
	center.offset_left = -150
	center.offset_right = 150
	center.offset_top = 20
	center.offset_bottom = 120
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(center)
	
	# Phase label
	phase_label = Label.new()
	phase_label.text = "DEPLOYMENT PHASE"
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	phase_label.add_theme_color_override("font_color", Color.YELLOW)
	phase_label.add_theme_font_size_override("font_size", 24)
	center.add_child(phase_label)
	
	# Timer
	timer_label = Label.new()
	timer_label.text = "90"
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.add_theme_color_override("font_color", Color.GREEN)
	timer_label.add_theme_font_size_override("font_size", 48)
	center.add_child(timer_label)
	
	# Instructions
	var instructions = Label.new()
	instructions.text = "Place your 5 blocks strategically!"
	instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instructions.add_theme_color_override("font_color", Constants.COLOR_TEXT_SECONDARY)
	instructions.add_theme_font_size_override("font_size", 16)
	center.add_child(instructions)

func update_timer(time: float) -> void:
	"""Update deployment timer"""
	if timer_label:
		timer_label.text = str(int(ceil(time)))
		
		# Change color based on urgency
		if time < 10:
			timer_label.add_theme_color_override("font_color", Color.RED)
		elif time < 30:
			timer_label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			timer_label.add_theme_color_override("font_color", Color.GREEN)

func update_phase(phase_name: String) -> void:
	"""Update phase display"""
	if phase_label:
		phase_label.text = phase_name + " PHASE"
		
		if phase_name == "BATTLE":
			phase_label.add_theme_color_override("font_color", Color.RED)
			if timer_label:
				timer_label.hide()  # Hide timer in battle

func update_player_hp(player_id: int, hp: int) -> void:
	"""Update player HP display"""
	var label = p1_hp_label if player_id == 1 else p2_hp_label
	if label:
		label.text = "HP: " + str(hp)
		
		# Color based on HP
		if hp < 30:
			label.add_theme_color_override("font_color", Color.RED)
		elif hp < 60:
			label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			label.add_theme_color_override("font_color", Color.GREEN)

func update_player_score(player_id: int, score: int) -> void:
	"""Update player score display"""
	var label = p1_score_label if player_id == 1 else p2_score_label
	if label:
		label.text = "SCORE: " + str(score)

func update_blocks_remaining(player_id: int, placed: int, total: int) -> void:
	"""Update blocks remaining display"""
	var label = p1_blocks_label if player_id == 1 else p2_blocks_label
	if label:
		label.text = "BLOCKS: " + str(placed) + "/" + str(total)
