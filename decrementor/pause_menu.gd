extends Control

func _ready():
	$"Settings (Panel)".visible = false;
	# Gets the Buttons and attaches the _pressed functions to them (this means the functions fire on press):
	get_node("Button Box (VBoxContainer)/Resume").pressed.connect(_on_resume_pressed)
	get_node("Button Box (VBoxContainer)/Settings").pressed.connect(_on_settings_pressed)
	get_node("Settings (Panel)/Back").pressed.connect(_on_back_pressed)
	get_node("Button Box (VBoxContainer)/Quit").pressed.connect(_on_quit_pressed)
	
func _input(event): 
	if event.is_action_pressed("ui_pause"): toggle_pause_menu()
	
func toggle_pause_menu(): 
	visible = not visible
	
func _on_resume_pressed():
	visible = false
	get_tree().paused = false
	
func _on_settings_pressed():
	$"Settings (Panel)".visible = true;
	
func _on_back_pressed():
	$"Settings (Panel)".visible = false;
	
func _on_quit_pressed():
	# Quits program:
	get_tree().quit()
