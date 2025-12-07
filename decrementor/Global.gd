extends Node
const CARD_NUM_SCENE = preload("res://Scenes/card_front_num.tscn")
const CARD_BINOP_SCENE = preload("res://Scenes/card_front_binop.tscn")
var playerName : String
var player_list = []
var deck = []
var discardPile = []
var permanent_cards = []
var deck_initialized: bool = false
var score = 0
var damage_multiplier = 1

func _ready() -> void:
	SilentWolf.configure({
		"api_key": "iSKt2PVArP28Ut7pnS5d41kUcV1vu7pFOe85IpOc",
		"game_id" : "decrementor",
		"log_level" : 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://Scenes/MainMenu.tscn"
	})

func _physics_process(delta: float) -> void:
	leaderboard()

func leaderboard():
	for score in Global.score:
		Global.player_list.append(Global.playerName)

func create_deck() -> void:
	deck.clear()
	discardPile.clear()
	
	for num in range(0, 10):
		var card = CARD_NUM_SCENE.instantiate()
		card.already_initialized = true
		var label = card.get_node("Area2D/CollisionShape2D/BaseNumCard/Label")
		label.text = str(num)
		deck.append(card)
	
	var plus_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(plus_card, "Plus")
	deck.append(plus_card)
	
	var minus_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(minus_card, "Minus")
	deck.append(minus_card)
	
	var multi_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(multi_card, "Multi")
	deck.append(multi_card)
	
	var div_card = CARD_BINOP_SCENE.instantiate()
	set_operator_visible(div_card, "Div")
	deck.append(div_card)
	
	for card in permanent_cards:
		if is_instance_valid(card) and not card.is_queued_for_deletion():
			deck.append(card)
	
	deck_initialized = true
	
	var deck_contents = []
	for card in deck:
		deck_contents.append(get_card_name(card))
	#print("Deck created with ", deck.size(), " cards (including ", permanent_cards.size(), " permanent cards): ", deck_contents)

func set_operator_visible(card: Control, operator_name: String) -> void:
	card.already_initialized = true
	
	var base_op_card = card.get_node("Area2D/CollisionShape2D/BaseOpCard")
	
	base_op_card.get_node("Plus").visible = false
	base_op_card.get_node("Minus").visible = false
	base_op_card.get_node("Multi").visible = false
	base_op_card.get_node("Div").visible = false
	
	if base_op_card.has_node(operator_name):
		base_op_card.get_node(operator_name).visible = true
		
	if operator_name == "Plus":
		card.value = '+'
	elif operator_name == "Minus":
		card.value = '-'
	elif operator_name == "Multi":
		card.value = 'x'
	elif operator_name == "Div":
		card.value = '/'

func reshuffle_discard_into_deck() -> void:
	var valid_cards = []
	for card in discardPile:
		if is_instance_valid(card) and not card.is_queued_for_deletion():
			if card.get_parent():
				card.get_parent().remove_child(card)
			valid_cards.append(card)
		else:
			print("Skipping invalid card during reshuffle")
	
	discardPile.clear()
	
	if valid_cards.size() == 0:
		print("No valid cards to reshuffle, creating new deck")
		create_deck()
		return
	
	for card in valid_cards:
		deck.append(card)
		print("Card returned to deck: ", get_card_name(card))

func discard_card(card: Control) -> void:
	if is_instance_valid(card) and not card.is_queued_for_deletion():
		if card.get_parent():
			card.get_parent().remove_child(card)
		discardPile.append(card)
		print("Card discarded: ", get_card_name(card))
	else:
		print("Attempted to discard invalid card")

func return_hand_to_deck(hand_container: Node) -> void:
	if not hand_container:
		return
	
	var cards_to_return = []
	for card in hand_container.get_children():
		if is_instance_valid(card) and not card.is_queued_for_deletion():
			cards_to_return.append(card)
	
	for card in cards_to_return:
		hand_container.remove_child(card)
		deck.append(card)
		#print("Card returned to deck: ", get_card_name(card))

func return_equation_to_deck(equation_container: Node) -> void:
	if not equation_container:
		return
	
	var cards_to_return = []
	for card in equation_container.get_children():
		if is_instance_valid(card) and not card.is_queued_for_deletion():
			cards_to_return.append(card)
	
	for card in cards_to_return:
		equation_container.remove_child(card)
		deck.append(card)
		print("Card returned to deck: ", get_card_name(card))

func reset_round(hand_container: Node = null, equation_container: Node = null) -> void:
	if hand_container:
		return_hand_to_deck(hand_container)
	if equation_container:
		return_equation_to_deck(equation_container)
	
	print("Round reset complete. Deck size: ", deck.size())

func add_permanent_card(card: Control) -> void:
	if is_instance_valid(card) and not card.is_queued_for_deletion():
		var parent = card.get_parent()
		if parent:
			parent.remove_child(card)
		
		card.hide()
		permanent_cards.append(card)
		deck.append(card)
		
		var permanent_contents = []
		for perm_card in permanent_cards:
			permanent_contents.append(get_card_name(perm_card))
		
		var deck_contents = []
		for deck_card in deck:
			deck_contents.append(get_card_name(deck_card))
		
		print("Permanent card added: ", get_card_name(card))
		print("Total permanent cards (", permanent_cards.size(), "): ", permanent_contents)

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
