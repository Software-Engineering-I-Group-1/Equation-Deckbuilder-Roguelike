extends GridContainer

var player_list_with_pos = []

func _ready() -> void:
	await get_tree().process_frame
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	player_list_with_pos = sort_players_and_add_position(SilentWolf.Scores.scores)
	add_player_to_grid(player_list_with_pos)
	
func add_player_to_grid(player_list):
	var pos_vbox = VBoxContainer.new()
	var name_vbox = VBoxContainer.new()
	var score_vbox = VBoxContainer.new()
	
	for score_data in player_list_with_pos:
		var pos_label = Label.new()
		pos_label.text = str(score_data["position"])
		pos_label.show()
		pos_vbox.add_child(pos_label)
	add_child(pos_vbox)
	
	for score_data in player_list_with_pos:
		var name_label = Label.new()
		name_label.text = str(score_data["player_name"])
		if name_label.text == "Donald Trump":
			name_label.text = "Margot Robbie"
		if name_label.text == "Epstein":
			name_label.text = "Aespa Karina"
		if name_label.text == "Bill Clinton":
			name_label.text = "Taylor Swift"
		if name_label.text == "t":
			name_label.text = "Senny Lu"
		name_label.show()
		name_vbox.add_child(name_label)
	add_child(name_vbox)
	
	for score_data in player_list_with_pos:
		var score_label = Label.new()
		score_label.text = str(score_data["score"])
		score_label.show()
		score_vbox.add_child(score_label)
	add_child(score_vbox)
	
func sort_players_and_add_position(player_list):
	var position = 1
	
	for player in player_list:
		player["position"] = position
		position += 1
		
	return player_list
