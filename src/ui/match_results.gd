## Match Results Screen
##
## Shows match outcome and stats
class_name MatchResults
extends Control

signal leave_pressed()

var result_type: String = "VICTORY"  # or "DEFEAT"
var player_hp: int = 0
var enemy_hp: int = 0
var player_score: int = 0
var enemy_score: int = 0

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_create_results_ui()

func set_results(is_victory: bool, p1_hp: int, p2_hp: int, p1_score: int, p2_score: int) -> void:
	"""Set match results data"""
	result_type = "VICTORY" if is_victory else "DEFEAT"
	player_hp = p1_hp
	enemy_hp = p2_hp
	player_score = p1_score
	enemy_score = p2_score
	
	_update_display()

func _create_results_ui() -> void:
	"""Create results screen UI"""
	# Dark overlay
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.8)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	# Center container (properly centered)
	var center = VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.grow_horizontal = Control.GROW_DIRECTION_BOTH
	center.grow_vertical = Control.GROW_DIRECTION_BOTH
	center.position = Vector2(-300, -300)  # Offset from center
	center.custom_minimum_size = Vector2(600, 600)
	center.add_theme_constant_override("separation", 30)
	add_child(center)
	
	# Result text (VICTORY or DEFEAT)
	var result_label = Label.new()
	result_label.name = "ResultLabel"
	result_label.text = result_type
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.add_theme_font_size_override("font_size", 72)
	center.add_child(result_label)
	
	# Divider
	var separator = HSeparator.new()
	separator.add_theme_color_override("separator", Color.WHITE)
	center.add_child(separator)
	
	# Stats panel
	var stats_panel = PanelContainer.new()
	var stats_style = StyleBoxFlat.new()
	stats_style.bg_color = Color(0.1, 0.1, 0.15, 0.9)
	stats_style.border_width_left = 2
	stats_style.border_width_top = 2
	stats_style.border_width_right = 2
	stats_style.border_width_bottom = 2
	stats_style.border_color = Color(0.5, 0.5, 0.5)
	stats_panel.add_theme_stylebox_override("panel", stats_style)
	center.add_child(stats_panel)
	
	var stats_vbox = VBoxContainer.new()
	stats_vbox.add_theme_constant_override("separation", 15)
	stats_panel.add_child(stats_vbox)
	
	# Title
	var stats_title = Label.new()
	stats_title.text = "MATCH SUMMARY"
	stats_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats_title.add_theme_color_override("font_color", Color.YELLOW)
	stats_title.add_theme_font_size_override("font_size", 24)
	stats_vbox.add_child(stats_title)
	
	# Player stats
	var player_stats = Label.new()
	player_stats.name = "PlayerStats"
	player_stats.text = "YOUR HP: 100\nYOUR SCORE: 0"
	player_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	player_stats.add_theme_color_override("font_color", Color.CYAN)
	player_stats.add_theme_font_size_override("font_size", 20)
	stats_vbox.add_child(player_stats)
	
	# VS
	var vs_label = Label.new()
	vs_label.text = "VS"
	vs_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vs_label.add_theme_color_override("font_color", Color.WHITE)
	vs_label.add_theme_font_size_override("font_size", 18)
	stats_vbox.add_child(vs_label)
	
	# Enemy stats
	var enemy_stats = Label.new()
	enemy_stats.name = "EnemyStats"
	enemy_stats.text = "ENEMY HP: 100\nENEMY SCORE: 0"
	enemy_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	enemy_stats.add_theme_color_override("font_color", Color.RED)
	enemy_stats.add_theme_font_size_override("font_size", 20)
	stats_vbox.add_child(enemy_stats)
	
	# Leave button
	var button_container = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(button_container)
	
	var leave_button = Button.new()
	leave_button.text = "LEAVE"
	leave_button.custom_minimum_size = Vector2(200, 60)
	
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = Color(0.5, 0.2, 0.2)
	btn_style.corner_radius_top_left = 5
	btn_style.corner_radius_top_right = 5
	btn_style.corner_radius_bottom_left = 5
	btn_style.corner_radius_bottom_right = 5
	
	leave_button.add_theme_stylebox_override("normal", btn_style)
	leave_button.add_theme_color_override("font_color", Color.WHITE)
	leave_button.add_theme_font_size_override("font_size", 24)
	leave_button.pressed.connect(_on_leave_pressed)
	button_container.add_child(leave_button)

func _update_display() -> void:
	"""Update the display with current data"""
	# Update result text
	var result_label = find_child("ResultLabel")
	if result_label:
		result_label.text = result_type
		if result_type == "VICTORY":
			result_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			result_label.add_theme_color_override("font_color", Color.RED)
	
	# Update stats
	var player_stats = find_child("PlayerStats")
	if player_stats:
		player_stats.text = "YOUR HP: " + str(player_hp) + "\nYOUR SCORE: " + str(player_score)
	
	var enemy_stats = find_child("EnemyStats")
	if enemy_stats:
		enemy_stats.text = "ENEMY HP: " + str(enemy_hp) + "\nENEMY SCORE: " + str(enemy_score)

func _on_leave_pressed() -> void:
	"""Leave button pressed"""
	leave_pressed.emit()
