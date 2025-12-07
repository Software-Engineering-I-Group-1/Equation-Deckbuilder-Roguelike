extends Button


func _on_pressed_leaderboard():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
func _on_pressed_defeat():
	GameState.player_health = 100
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
