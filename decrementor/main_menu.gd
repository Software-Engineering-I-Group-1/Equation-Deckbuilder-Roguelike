extends Control

func _ready():
	$"Settings (Panel)".visible = false;
	# Gets the Buttons and attaches the _pressed functions to them (this means the functions fire on press):
	get_node("Button Box (VBoxContainer)/Play").pressed.connect(_on_play_pressed)
	get_node("Button Box (VBoxContainer)/Settings").pressed.connect(_on_settings_pressed)
	get_node("Button Box (VBoxContainer)/Quit").pressed.connect(_on_quit_pressed)
	
func _on_play_pressed():
	# Changes scene to main scene:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")
	
func _on_settings_pressed():
	$"Settings (Panel)".visible = true;
	return
	
func _on_quit_pressed():
	# Quits program:
	get_tree().quit()
