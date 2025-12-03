extends GridContainer

var player_list_with_pos = []

func _ready() -> void:
	columns = 3
	add_theme_constant_override("h_separation", 125)
	add_theme_constant_override("v_separation", 15)
	
	await get_tree().process_frame
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	player_list_with_pos = sort_players_and_add_position(SilentWolf.Scores.scores)
	add_player_to_grid(player_list_with_pos)
	
func add_player_to_grid(player_list):
	for score_data in player_list_with_pos:
		var pos_label = Label.new()
		pos_label.text = str(score_data["position"])
		add_child(pos_label)
		
		var name_label = Label.new()
		name_label.text = str(score_data["player_name"])
		add_child(name_label)
		
		var score_label = Label.new()
		score_label.text = str(score_data["score"])

		add_child(score_label)
	
func sort_players_and_add_position(player_list):
	player_list.sort_custom(func(a, b): return a["score"] > b["score"])
	
	var position = 1
	for player in player_list:
		player["position"] = position
		position += 1
		
	return player_list
