extends Control

func _ready():
	$"Settings (Panel)".visible = false;
	# Gets the Buttons and attaches the _pressed functions to them (this means the functions fire on press):
	get_node("Button Box (VBoxContainer)/Play").pressed.connect(_on_play_pressed)
	get_node("Button Box (VBoxContainer)/Settings").pressed.connect(_on_settings_pressed)
	get_node("Settings (Panel)/Back").pressed.connect(_on_back_pressed)
	get_node("Button Box (VBoxContainer)/LeaderBoards").pressed.connect(_on_leaderboard_pressed)

	
func _on_play_pressed():
	Global.deck_initialized = false
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")
	
func _on_settings_pressed():
	$"Settings (Panel)".visible = true;
	
func _on_back_pressed():
	$"Settings (Panel)".visible = false;
	
func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://Scenes/leaderboard_panel.tscn")
