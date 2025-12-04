extends Node

enum CombatState {
	PlayerTurn,
	EnemyTurn,
	Busy,
	End
}

const EQUATION_AREA_CARD_CONTAINER_INDEX = 2

const ENEMY_DAMAGE = 5
const MESSAGE_DISPLAY_TIME = 1.5
const ATTACK_DELAY = 0.5
const ENEMY_TURN_DELAY = 0.8

var state = CombatState.PlayerTurn

@onready var player = $User 
@onready var enemy = $Enemy 

@onready var attack_button = $Attack_Button
@onready var turn_label = $Label
@onready var hp_bar = $Player_HP/ProgressBar
@onready var enemy_hp_bar = $Enemy/ProgressBar

var hand_area: Node
var equation_area: Node

func _on_attack_button_pressed() -> void:
	if state == CombatState.PlayerTurn:
		player_choose_attack()



func _ready() -> void:
	attack_button.pressed.connect(_on_attack_button_pressed)
	
	var root = get_parent().get_parent()
	hand_area = root.get_node("Hand Area")
	equation_area = root.get_node("Equation Area")
	
	start_player_turn()

func start_player_turn() -> void:
	state = CombatState.PlayerTurn
	turn_label.text = "Your turn"

func evaluate_equation() -> Variant:
	var container = equation_area.get_child(EQUATION_AREA_CARD_CONTAINER_INDEX)
	var cards = container.get_children()
	
	if cards.is_empty():
		return null
	
	var result = extract_card_value(cards[0])
	if result == null:
		return null
	
	var i = 1
	while i < cards.size():
		if i + 1 >= cards.size():
			return null
		
		var operator = cards[i]
		var operand = cards[i + 1]
		
		var op_value = get_operator_type(operator)
		var operand_value = extract_card_value(operand)
		
		if op_value == null or operand_value == null:
			return null
		
		result = apply_operator(result, op_value, operand_value)
		if result == null:
			return null
		
		i += 2
	
	if i != cards.size():
		return null
	
	return max(result, 0)

func extract_card_value(card: Node) -> Variant:
	var label = card.get_node_or_null("Area2D/CollisionShape2D/BaseNumCard/Label")
	if label:
		var text = label.text.strip_edges()
		if text.is_valid_int():
			return int(text)
	return null

func get_operator_type(card: Node) -> Variant:
	var base_op = card.get_node_or_null("Area2D/CollisionShape2D/BaseOpCard")
	if not base_op:
		return null
	
	if base_op.get_node_or_null("Plus").visible:
		return "+"
	elif base_op.get_node_or_null("Minus").visible:
		return "-"
	elif base_op.get_node_or_null("Multi").visible:
		return "*"
	elif base_op.get_node_or_null("Div").visible:
		return "/"
	
	return null

func apply_operator(a: int, op: String, b: int) -> Variant:
	match op:
		"+":
			return a + b
		"-":
			return a - b
		"*":
			return a * b
		"/":
			if b == 0:
				return null
			return a / b
	return null

func clear_equation_area() -> void:
	var container = equation_area.get_child(EQUATION_AREA_CARD_CONTAINER_INDEX)
	for card in container.get_children():
		if card.get_parent() == container:
			card.queue_free()

func player_choose_attack() -> void:
	if state != CombatState.PlayerTurn: 
		return
	state = CombatState.Busy
	
	var result = evaluate_equation()
	
	if result == null:
		turn_label.text = "I messed up!"
		await get_tree().create_timer(MESSAGE_DISPLAY_TIME).timeout
		clear_equation_area()
		transition(CombatState.PlayerTurn)
	else:
		enemy_hp_bar.value -= result
		await get_tree().create_timer(ATTACK_DELAY).timeout
		clear_equation_area()
		transition(CombatState.PlayerTurn)

func start_enemy_turn() -> void:
	state = CombatState.EnemyTurn
	turn_label.text = "Enemy turn"

	await get_tree().create_timer(ENEMY_TURN_DELAY).timeout
	hp_bar.value -= ENEMY_DAMAGE

	transition(CombatState.EnemyTurn)

func transition(prev_state: int) -> void:
	match prev_state:
		CombatState.PlayerTurn:
			if !enemy_alive(): 
				end_battle(true)
			else: 
				start_enemy_turn()
		CombatState.EnemyTurn:
			if !player_alive(): 
				end_battle(false)
			else: 
				start_player_turn()
		_:
			pass

func enemy_alive() -> bool:
	return true

func player_alive() -> bool:
	return true

func end_battle(victory: bool) -> void:
	return
