extends Node2D

const MAX_HAND_SIZE = 7
const OPERATOR_GUARANTEE_DRAWS = 6

var card_container: Node
var equation_area: Node
var draws_since_operator_check: int = 0

func _ready() -> void:
	randomize()
	card_container = get_node("CardContainer")
	create_deck()

func create_deck() -> void:
	var parent = get_parent()
	if parent:
		equation_area = parent.get_node_or_null("Equation Area")
	
	Global.create_deck()

func is_operator_card(card: Control) -> bool:
	var base_op_card = card.get_node_or_null("Area2D/CollisionShape2D/BaseOpCard")
	return base_op_card != null

func has_operator_in_hand() -> bool:
	for child in card_container.get_children():
		if is_operator_card(child):
			return true
	return false

func get_operator_indices_from_deck() -> Array:
	var operator_indices = []
	for i in range(Global.deck.size()):
		var card = Global.deck[i]
		if is_operator_card(card):
			operator_indices.append(i)
	return operator_indices

func draw_card() -> Control:
	var hand_card_count = card_container.get_child_count()
	
	var equation_card_count = 0
	if equation_area:
		var equation_container = equation_area.get_child(2)  
		if equation_container:
			equation_card_count = equation_container.get_child_count()
	
	if hand_card_count + equation_card_count >= MAX_HAND_SIZE:
		return null
	
	if Global.deck.size() == 0:
		Global.reshuffle_discard_into_deck()
		if Global.deck.size() == 0:
			return null
	
	var needs_operator = false
	if not has_operator_in_hand():
		draws_since_operator_check += 1
		if draws_since_operator_check >= OPERATOR_GUARANTEE_DRAWS:
			needs_operator = true
	else:
		draws_since_operator_check = 0
	
	var card: Control
	var idx: int
	
	if needs_operator:
		var operator_indices = get_operator_indices_from_deck()
		if operator_indices.size() > 0:
			var random_op_idx = randi() % operator_indices.size()
			idx = operator_indices[random_op_idx]
			card = Global.deck[idx]
			Global.deck.remove_at(idx)
			draws_since_operator_check = 0
		else:
			idx = randi() % Global.deck.size()
			card = Global.deck[idx]
			Global.deck.remove_at(idx)
	else:
		idx = randi() % Global.deck.size()
		card = Global.deck[idx]
		Global.deck.remove_at(idx)
	
	print("card : ", get_card_name(card), ",num of cards ", Global.deck.size())
	card_container.add_child(card)
	return card

func get_card_name(card: Control) -> String:
	var num_label = card.get_node_or_null("Area2D/CollisionShape2D/BaseNumCard/Label")
	if num_label:
		return "Number " + num_label.text
	
	var base_op_card = card.get_node_or_null("Area2D/CollisionShape2D/BaseOpCard")
	if base_op_card:
		if base_op_card.get_node("Plus").visible:
			return "Plus"
		elif base_op_card.get_node("Minus").visible:
			return "Minus"
		elif base_op_card.get_node("Multi").visible:
			return "Multi"
		elif base_op_card.get_node("Div").visible:
			return "Div"
	
	return "Unknown"

func _on_deck_pressed() -> void:
	var card = draw_card()
	if not card:
		return
