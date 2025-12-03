extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_card_positions():
	var displacement = 0
	var skip = 2
	for card in get_children():
		if skip > 0:
			skip -= 1
			continue
		card.position = Vector2(100 + displacement*100,340)
		displacement += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_card_positions()
	pass
