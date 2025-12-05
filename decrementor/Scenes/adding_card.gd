extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Skip").pressed.connect(_on_skip_pressed)
	pass # Replace with function body.
	
func _on_skip_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
