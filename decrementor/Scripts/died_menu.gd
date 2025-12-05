extends Node2D

var score = GameState.player_score

@onready var score_label: Label = $Score/Label2

func _physics_process(delta: float) -> void:
	change_text()
	
func change_text():
	score_label.text = "Score: " + str(score)
	Global.score = score
