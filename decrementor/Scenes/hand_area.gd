extends Node2D

const CARD_NUM_SCENE = preload("res://Scenes/card_front_num.tscn")
const CARD_BINOP_SCENE = preload("res://Scenes/card_front_binop.tscn")

const MAX_HAND_SIZE = 7

var card_container: Node

func _ready() -> void:
	randomize()
	card_container = get_node("CardContainer")
	create_deck()

func create_deck() -> void:
	Global.deck.clear()
	
	for num in range(1, 9):
		var card = CARD_NUM_SCENE.instantiate()
		var label = card.get_node("Area2D/CollisionShape2D/BaseNumCard/Label")
		label.text = str(num)
		Global.deck.append(card)

	var plus_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(plus_card, "Plus")
	Global.deck.append(plus_card)

	var minus_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(minus_card, "Minus")
	Global.deck.append(minus_card)

	var multi_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(multi_card, "Multi")
	Global.deck.append(multi_card)

	var div_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(div_card, "Div")
	Global.deck.append(div_card)

func set_operator_visible(card: Control, operator_name: String) -> void:
	var base_op_card = card.get_node("Area2D/CollisionShape2D/BaseOpCard")
	
	base_op_card.get_node("Plus").visible = false
	base_op_card.get_node("Minus").visible = false
	base_op_card.get_node("Multi").visible = false
	base_op_card.get_node("Div").visible = false
	
	if base_op_card.has_node(operator_name):
		base_op_card.get_node(operator_name).visible = true

func draw_card() -> Control:
	if card_container.get_child_count() >= MAX_HAND_SIZE:
		return null
	if Global.deck.size() == 0:
		resuffleDiscardPileIntoDeck()
	
	var idx = randi() % Global.deck.size()
	var card = Global.deck[idx]
	Global.deck.remove_at(idx)
	card_container.add_child(card)
	return card

func resuffleDiscardPileIntoDeck():
	print("refulling discard into deck")
	for card in Global.discardPile:
		Global.deck.append(card)


func _on_deck_pressed() -> void:
	var card = draw_card()
	if not card:
		return
