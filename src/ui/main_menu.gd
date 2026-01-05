## Main Menu
##
## Main lobby/menu screen inspired by Mechabellum
## Shows game modes, tournaments, player info
class_name MainMenu
extends Control

signal mode_selected(mode: String)
signal tournament_selected(tournament_id: String)

var player_name: String = "Player"
var player_elo: int = 1000

func _ready() -> void:
	# Fill entire screen
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	_create_menu_ui()

func set_player_info(username: String, elo: int = 1000) -> void:
	"""Set player information from Steam"""
	player_name = username
	player_elo = elo
	_update_player_display()

func _create_menu_ui() -> void:
	"""Create main menu UI programmatically"""
	# Background
	var bg = ColorRect.new()
	bg.color = Constants.COLOR_BG_DARK
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.z_index = -1
	add_child(bg)
	
	# Top navigation bar
	_create_top_nav()
	
	# Left panel - Player info & quick actions
	_create_left_panel()
	
	# Center panel - Main content/featured
	_create_center_panel()
	
	# Right panel - Tournaments & events
	_create_right_panel()
	
	# Bottom panel - Quick match buttons
	_create_bottom_panel()

func _create_top_nav() -> void:
	"""Create top navigation bar"""
	var nav = HBoxContainer.new()
	nav.offset_left = 20
	nav.offset_top = 10
	nav.offset_right = -20
	nav.offset_bottom = 60
	nav.anchor_right = 1.0
	nav.add_theme_constant_override("separation", 20)
	add_child(nav)
	
	# Game logo
	var logo = Label.new()
	logo.text = "◆ TETROID ◆"
	logo.add_theme_color_override("font_color", Constants.COLOR_ACCENT)
	logo.add_theme_font_size_override("font_size", 32)
	nav.add_child(logo)
	
	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(50, 0)
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav.add_child(spacer)
	
	# Navigation buttons
	var nav_buttons = ["MULTIPLAYER", "SOLO", "TOURNAMENT", "RANKED", "CUSTOM", "COLLECTION"]
	for btn_text in nav_buttons:
		var btn = _create_nav_button(btn_text)
		nav.add_child(btn)

func _create_left_panel() -> void:
	"""Create left panel with player info"""
	var panel = PanelContainer.new()
	panel.offset_left = 20
	panel.offset_top = 80
	panel.offset_right = 320
	panel.offset_bottom = 600
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Constants.COLOR_PANEL_DARK
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Constants.COLOR_ACCENT
	panel.add_theme_stylebox_override("panel", style)
	
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	panel.add_child(vbox)
	
	# Player profile section
	var profile_label = Label.new()
	profile_label.text = "PLAYER PROFILE"
	profile_label.add_theme_color_override("font_color", Constants.COLOR_ACCENT)
	profile_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(profile_label)
	
	# Player name
	var name_label = Label.new()
	name_label.name = "PlayerName"
	name_label.text = player_name
	name_label.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	name_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(name_label)
	
	# Player ELO
	var elo_label = Label.new()
	elo_label.name = "PlayerELO"
	elo_label.text = "ELO: " + str(player_elo)
	elo_label.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(elo_label)
	
	# Stats
	vbox.add_child(_create_separator())
	var stats_label = Label.new()
	stats_label.text = "STATISTICS"
	stats_label.add_theme_color_override("font_color", Constants.COLOR_ACCENT)
	vbox.add_child(stats_label)
	
	var stats = Label.new()
	stats.text = "Matches Played: 0\nWins: 0\nWin Rate: 0%"
	stats.add_theme_color_override("font_color", Constants.COLOR_TEXT_SECONDARY)
	vbox.add_child(stats)
	
	# Quick actions
	vbox.add_child(_create_separator())
	
	var quick_match_btn = _create_action_button("QUICK MATCH")
	quick_match_btn.pressed.connect(_on_quick_match_pressed)
	vbox.add_child(quick_match_btn)
	
	var practice_btn = _create_action_button("PRACTICE vs AI")
	practice_btn.pressed.connect(_on_practice_pressed)
	vbox.add_child(practice_btn)

func _create_center_panel() -> void:
	"""Create center featured content panel"""
	var panel = PanelContainer.new()
	panel.offset_left = 340
	panel.offset_top = 80
	panel.offset_right = -340
	panel.offset_bottom = 600
	panel.anchor_right = 1.0
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Constants.COLOR_PANEL_DARK
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Constants.COLOR_ACCENT
	panel.add_theme_stylebox_override("panel", style)
	
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	# Featured title
	var title = Label.new()
	title.text = "FEATURED: COMPETITIVE SEASON 1"
	title.add_theme_color_override("font_color", Color.YELLOW)
	title.add_theme_font_size_override("font_size", 24)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Featured image/content placeholder
	var featured_content = ColorRect.new()
	featured_content.color = Color(0.1, 0.1, 0.2)
	featured_content.custom_minimum_size = Vector2(0, 300)
	vbox.add_child(featured_content)
	
	# Featured text on content
	var featured_text = Label.new()
	featured_text.text = "WELCOME TO TETROID\n\nStrategic Block Placement meets Fast-Paced Action\n\nPlace Tetris pieces with unique abilities\nDeflect the ball with precision\nReduce opponent's HP to zero\n\nReady to compete?"
	featured_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	featured_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	featured_text.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	featured_text.add_theme_font_size_override("font_size", 18)
	featured_content.add_child(featured_text)
	
	# Mode selection buttons
	var mode_container = HBoxContainer.new()
	mode_container.alignment = BoxContainer.ALIGNMENT_CENTER
	mode_container.add_theme_constant_override("separation", 20)
	vbox.add_child(mode_container)
	
	var modes = [
		{"name": "1v1 RANKED", "desc": "Competitive"},
		{"name": "2v2 TEAM", "desc": "Cooperative"},
		{"name": "4P FFA", "desc": "Free-for-All"}
	]
	
	for mode in modes:
		var mode_btn = _create_mode_button(mode.name, mode.desc)
		mode_container.add_child(mode_btn)

func _create_right_panel() -> void:
	"""Create right panel with tournaments"""
	var panel = PanelContainer.new()
	panel.offset_left = -320
	panel.offset_top = 80
	panel.offset_right = -20
	panel.offset_bottom = 600
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Constants.COLOR_PANEL_DARK
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Constants.COLOR_ACCENT
	panel.add_theme_stylebox_override("panel", style)
	
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)
	
	# Tournament header
	var header = Label.new()
	header.text = "TOURNAMENTS"
	header.add_theme_color_override("font_color", Constants.COLOR_ACCENT)
	header.add_theme_font_size_override("font_size", 18)
	vbox.add_child(header)
	
	# Tournament list
	var tournaments = [
		{"name": "Weekend Cup", "time": "In 2 hours", "prize": "Cosmetic Pack"},
		{"name": "Season Qualifier", "time": "Tomorrow", "prize": "Rank Points"},
		{"name": "Community Event", "time": "Active Now", "prize": "XP Boost"}
	]
	
	for tournament in tournaments:
		var t_entry = _create_tournament_entry(tournament.name, tournament.time, tournament.prize)
		vbox.add_child(t_entry)

func _create_bottom_panel() -> void:
	"""Create bottom panel with quick actions"""
	var panel = Panel.new()
	panel.offset_left = 20
	panel.offset_top = -80
	panel.offset_right = -20
	panel.offset_bottom = -20
	panel.anchor_top = 1.0
	panel.anchor_right = 1.0
	panel.anchor_bottom = 1.0
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Constants.COLOR_PANEL_LIGHT
	panel.add_theme_stylebox_override("panel", style)
	
	add_child(panel)
	
	var hbox = HBoxContainer.new()
	hbox.offset_left = 10
	hbox.offset_top = 10
	hbox.offset_right = -10
	hbox.offset_bottom = -10
	hbox.anchor_right = 1.0
	hbox.anchor_bottom = 1.0
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 30)
	panel.add_child(hbox)
	
	# Status text
	var status = Label.new()
	status.text = "● ONLINE | " + str(randi() % 500 + 100) + " Players Active"
	status.add_theme_color_override("font_color", Color.GREEN)
	hbox.add_child(status)
	
	# Spacer
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(spacer)
	
	# Quick buttons
	var practice_game = _create_quick_button("▶ PRACTICE GAME")
	practice_game.pressed.connect(_on_practice_pressed)
	hbox.add_child(practice_game)

func _create_nav_button(text: String) -> Button:
	"""Create navigation button"""
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(120, 40)
	
	# Style
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color.TRANSPARENT
	normal_style.border_width_bottom = 2
	normal_style.border_color = Color.TRANSPARENT
	
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(Constants.COLOR_ACCENT, 0.3)
	hover_style.border_width_bottom = 2
	hover_style.border_color = Constants.COLOR_ACCENT
	
	btn.add_theme_stylebox_override("normal", normal_style)
	btn.add_theme_stylebox_override("hover", hover_style)
	btn.add_theme_stylebox_override("pressed", hover_style)
	btn.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	
	return btn

func _create_mode_button(mode_name: String, description: String) -> Button:
	"""Create game mode selection button"""
	var btn = Button.new()
	btn.text = mode_name + "\n" + description
	btn.custom_minimum_size = Vector2(180, 100)
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Constants.COLOR_PANEL_LIGHT
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = Constants.COLOR_ACCENT
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	
	var hover_style = style.duplicate()
	hover_style.bg_color = Constants.COLOR_ACCENT
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", hover_style)
	btn.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	
	btn.pressed.connect(_on_mode_button_pressed.bind(mode_name))
	
	return btn

func _create_action_button(text: String) -> Button:
	"""Create action button"""
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(250, 50)
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Constants.COLOR_ACCENT
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", 16)
	
	return btn

func _create_quick_button(text: String) -> Button:
	"""Create quick action button"""
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(200, 45)
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.5, 0.2)
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", 14)
	
	return btn

func _create_tournament_entry(name: String, time: String, prize: String) -> PanelContainer:
	"""Create tournament entry"""
	var panel = PanelContainer.new()
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Constants.COLOR_PANEL_LIGHT
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	panel.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = name
	title.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(title)
	
	var time_label = Label.new()
	time_label.text = "⏰ " + time
	time_label.add_theme_color_override("font_color", Constants.COLOR_TEXT_SECONDARY)
	time_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(time_label)
	
	var prize_label = Label.new()
	prize_label.text = "🏆 " + prize
	prize_label.add_theme_color_override("font_color", Color.ORANGE)
	prize_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(prize_label)
	
	return panel

func _create_separator() -> HSeparator:
	"""Create visual separator"""
	var sep = HSeparator.new()
	sep.add_theme_color_override("separator", Constants.COLOR_ACCENT)
	return sep

func _update_player_display() -> void:
	"""Update player information display"""
	var name_label = find_child("PlayerName")
	if name_label:
		name_label.text = player_name
	
	var elo_label = find_child("PlayerELO")
	if elo_label:
		elo_label.text = "ELO: " + str(player_elo)

func _on_mode_button_pressed(mode: String) -> void:
	"""Handle mode button pressed"""
	print("Mode selected: " + mode)
	emit_signal("mode_selected", mode)
	
	# For now, start the game
	_start_game_test()

func _on_quick_match_pressed() -> void:
	"""Handle quick match button"""
	print("Quick Match pressed")
	_start_game_test()

func _on_practice_pressed() -> void:
	"""Handle practice button"""
	print("Practice mode pressed")
	_start_game_test()

func _start_game_test() -> void:
	"""Transition to game (temporary)"""
	# Fade out menu
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	# Switch to game scene
	queue_free()
	
	# Create game
	var game = Game.new()
	get_tree().root.add_child(game)
	game.start()
