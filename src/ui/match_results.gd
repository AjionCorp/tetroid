## Match Results Screen
##
## Shows match outcome and stats
class_name MatchResults
extends CanvasLayer

signal leave_pressed()

var result_type: String = "VICTORY"
var player_hp: int = 0
var enemy_hp: int = 0
var player_score: int = 0
var enemy_score: int = 0

func _ready() -> void:
	layer = 1000  # Very high layer
	print("MatchResults _ready() - Layer: " + str(layer))
	_create_results_ui()

func set_results(is_victory: bool, p1_hp: int, p2_hp: int, p1_score: int, p2_score: int) -> void:
	"""Set match results data"""
	result_type = "VICTORY" if is_victory else "DEFEAT"
	player_hp = p1_hp
	enemy_hp = p2_hp
	player_score = p1_score
	enemy_score = p2_score
	
	print("Setting results: " + result_type)
	call_deferred("_update_display")

func _create_results_ui() -> void:
	"""Create results screen UI"""
	print("Creating results UI (as CanvasLayer)...")
	
	# Full screen control
	var root = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)
	
	# Black overlay
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.9)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(overlay)
	
	# Center box
	var center_box = VBoxContainer.new()
	center_box.anchor_left = 0.5
	center_box.anchor_top = 0.5
	center_box.anchor_right = 0.5
	center_box.anchor_bottom = 0.5
	center_box.offset_left = -400
	center_box.offset_top = -300
	center_box.offset_right = 400
	center_box.offset_bottom = 300
	center_box.add_theme_constant_override("separation", 40)
	root.add_child(center_box)
	
	# VICTORY/DEFEAT text
	var result_label = Label.new()
	result_label.name = "ResultLabel"
	result_label.text = result_type
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.add_theme_color_override("font_color", Color.WHITE)
	result_label.add_theme_font_size_override("font_size", 96)
	center_box.add_child(result_label)
	
	# Stats
	var stats_label = Label.new()
	stats_label.name = "StatsLabel"
	stats_label.text = "YOUR HP: 100 | ENEMY HP: 0"
	stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats_label.add_theme_color_override("font_color", Color.CYAN)
	stats_label.add_theme_font_size_override("font_size", 32)
	center_box.add_child(stats_label)
	
	# LEAVE button
	var leave_btn = Button.new()
	leave_btn.text = "LEAVE"
	leave_btn.custom_minimum_size = Vector2(300, 80)
	leave_btn.add_theme_color_override("font_color", Color.WHITE)
	leave_btn.add_theme_font_size_override("font_size", 32)
	leave_btn.pressed.connect(_on_leave_pressed)
	center_box.add_child(leave_btn)
	
	print("Results UI created!")

func _update_display() -> void:
	"""Update display with current data"""
	var result_label = find_child("ResultLabel")
	if result_label:
		result_label.text = result_type
		if result_type == "VICTORY":
			result_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			result_label.add_theme_color_override("font_color", Color.RED)
		print("Updated result label to: " + result_type)
	
	var stats_label = find_child("StatsLabel")
	if stats_label:
		stats_label.text = "YOUR HP: " + str(player_hp) + " | ENEMY HP: " + str(enemy_hp) + "\nYOUR SCORE: " + str(player_score) + " | ENEMY SCORE: " + str(enemy_score)
		print("Updated stats: P1=" + str(player_hp) + "HP, P2=" + str(enemy_hp) + "HP")

func _on_leave_pressed() -> void:
	"""Leave button pressed"""
	print("LEAVE button clicked!")
	leave_pressed.emit()
