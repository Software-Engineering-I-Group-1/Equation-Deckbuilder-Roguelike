extends Node2D

const CARD_START_X = 100
const CARD_SPACING = 100
const CARD_CENTER_Y = 340

func _ready() -> void:
	pass

func update_card_positions() -> void:
	var container = get_child(2)
	var cards = container.get_children()
	
	for i in range(cards.size()):
		cards[i].position = Vector2(CARD_START_X + i * CARD_SPACING, CARD_CENTER_Y)
