extends Node2D

const CARD = preload("res://Scenes/card_front_binop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(7):
		var child = CARD.instantiate()
		var container = get_child(2)
		container.add_child(child)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
