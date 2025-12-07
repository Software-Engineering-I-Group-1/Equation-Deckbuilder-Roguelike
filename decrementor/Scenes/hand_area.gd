extends Node2D
const MAX_HAND_SIZE = 7
const OPERATOR_GUARANTEE_DRAWS = 6
var card_container: Node
var equation_area: Node

func _ready() -> void:
	randomize()
	card_container = get_node("CardContainer")
	create_deck()

func create_deck() -> void:
	var parent = get_parent()
	if parent:
		equation_area = parent.get_node_or_null("Equation Area")
	
	Global.create_deck()

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
	
	var card: Control
	var idx: int
	idx = randi() % Global.deck.size()
	card = Global.deck[idx]
	
	if not is_instance_valid(card):
		push_error("Card at index " + str(idx) + " is invalid or freed")
		Global.deck.remove_at(idx)
		return draw_card()
	
	Global.deck.remove_at(idx)
	
	if card.get_parent():
		card.get_parent().remove_child(card)
	
	var card_name_before = get_card_name(card)
	
	card.show()
	card_container.add_child(card)
	var card_name_after = get_card_name(card)
	#print("AFTER adding to scene: ", card_name_after, " | Remaining in deck: ", Global.deck.size())
	
	return card

func get_card_name(card: Control) -> String:
	if not is_instance_valid(card):
		return "Invalid"
		
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
