extends Node

const CARD_NUM_SCENE = preload("res://Scenes/card_front_num.tscn")
const CARD_BINOP_SCENE = preload("res://Scenes/card_front_binop.tscn")

var playerName : String
var player_list = []
var deck = []
var discardPile = []
var deck_initialized: bool = false
var score = 0
var damage_multiplier = 10

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
	if not deck_initialized:
		deck.clear()
		discardPile.clear()
		
		# Create the base deck - one of each card (14 total)
		for num in range(0, 10):
			var card = CARD_NUM_SCENE.instantiate()
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
		
		deck_initialized = true

func set_operator_visible(card: Control, operator_name: String) -> void:
	var base_op_card = card.get_node("Area2D/CollisionShape2D/BaseOpCard")
	
	base_op_card.get_node("Plus").visible = false
	base_op_card.get_node("Minus").visible = false
	base_op_card.get_node("Multi").visible = false
	base_op_card.get_node("Div").visible = false
	
	if base_op_card.has_node(operator_name):
		base_op_card.get_node(operator_name).visible = true

func reshuffle_discard_into_deck() -> void:
	var valid_cards = []
	for card in discardPile:
		if is_instance_valid(card):
			valid_cards.append(card)
	
	discardPile.clear()
	
	for card in valid_cards:
		deck.append(card)
		print("back to deck :  ", get_card_name(card))

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
