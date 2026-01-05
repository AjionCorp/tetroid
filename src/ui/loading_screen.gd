## Loading Screen
##
## Initial loading screen with Steam authentication
class_name LoadingScreen
extends Control

signal loading_complete()

var progress: float = 0.0
var status_label: Label
var progress_bar: ProgressBar
var logo_label: Label

func _ready() -> void:
	# Fill entire screen
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	_create_ui()
	
	# Start loading process
	_start_loading()

func _create_ui() -> void:
	"""Create loading screen UI programmatically"""
	# Background
	var bg = ColorRect.new()
	bg.color = Constants.COLOR_BG_DARK
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	add_child(bg)
	
	# Center container
	var center = VBoxContainer.new()
	center.anchor_left = 0.5
	center.anchor_top = 0.5
	center.anchor_right = 0.5
	center.anchor_bottom = 0.5
	center.offset_left = -200
	center.offset_top = -100
	center.offset_right = 200
	center.offset_bottom = 100
	center.add_theme_constant_override("separation", 20)
	add_child(center)
	
	# Logo/Title
	logo_label = Label.new()
	logo_label.text = "TETROID"
	logo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	logo_label.add_theme_color_override("font_color", Constants.COLOR_ACCENT)
	logo_label.add_theme_font_size_override("font_size", 48)
	center.add_child(logo_label)
	
	# Status text
	status_label = Label.new()
	status_label.text = "Initializing..."
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_color_override("font_color", Constants.COLOR_TEXT_PRIMARY)
	center.add_child(status_label)
	
	# Progress bar
	progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(400, 30)
	progress_bar.value = 0
	progress_bar.max_value = 100
	center.add_child(progress_bar)
	
	# Version label
	var version = Label.new()
	version.text = "Version 0.1.0-dev | Code-Driven Development"
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	version.add_theme_color_override("font_color", Constants.COLOR_TEXT_SECONDARY)
	version.add_theme_font_size_override("font_size", 12)
	center.add_child(version)

func _start_loading() -> void:
	"""Start the loading process"""
	await get_tree().create_timer(0.1).timeout
	
	# Step 1: Initialize core systems
	update_status("Loading core systems...", 10)
	await get_tree().create_timer(0.3).timeout
	
	# Step 2: Load assets
	update_status("Loading assets...", 30)
	await get_tree().create_timer(0.3).timeout
	
	# Step 3: Initialize Steam
	update_status("Connecting to Steam...", 50)
	await _initialize_steam()
	
	update_status("Authentication complete!", 75)
	
	await get_tree().create_timer(0.3).timeout
	
	# Step 4: Complete
	update_status("Loading complete!", 100)
	await get_tree().create_timer(0.5).timeout
	
	emit_signal("loading_complete")

func _initialize_steam() -> void:
	"""Initialize Steam and wait for authentication"""
	var steam_manager = SteamManager.new()
	steam_manager.name = "SteamManager"
	get_tree().root.add_child(steam_manager)
	
	steam_manager.initialize()
	
	# Wait for auth to complete
	await steam_manager.auth_completed
	
	if steam_manager.is_authenticated():
		update_status("Logged in as: " + steam_manager.get_player_name(), 70)

func update_status(text: String, percent: float) -> void:
	"""Update loading status"""
	if status_label:
		status_label.text = text
	if progress_bar:
		progress_bar.value = percent
	
	print("Loading: " + text + " (" + str(percent) + "%)")
