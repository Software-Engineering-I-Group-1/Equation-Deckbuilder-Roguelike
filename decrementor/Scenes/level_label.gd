extends Label

func _ready() -> void:
	text = "Level: " + str(GameState.current_level)
