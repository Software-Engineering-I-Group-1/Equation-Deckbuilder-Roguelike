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
@onready var score = $Player_Score/Score
@onready var requirement = $Enemy/Requirement

var current_req_list = []

var hand_area: Node
var equation_area: Node

func _on_attack_button_pressed() -> void:
	if state == CombatState.PlayerTurn:
		player_choose_attack()



func _ready() -> void:
	randomize()
	attack_button.pressed.connect(_on_attack_button_pressed)
	
	var root = get_parent().get_parent()
	hand_area = root.get_node("Hand Area")
	equation_area = root.get_node("Equation Area")
	
	hp_bar.value = GameState.player_health
	score.text = str(GameState.player_score).pad_zeros(8)
	var unique_numbers_list = [0,1,2,3,4]
	# for i in range(0, GameState.current_level):
	requirement.text = ""
	var difficulty = (GameState.current_level / 5) + 1
	print("difficulty")
	print(difficulty)
	for i in range(difficulty):
		var random_requirement = randi() % unique_numbers_list.size()
		match unique_numbers_list[random_requirement]:
			0: 
				# Even num
				requirement.text += "Is Even\n"
				var lambda = func(x) : return even_num(x)
				current_req_list.append(lambda)
				unique_numbers_list.erase(random_requirement)
			1: 
				# Odd num
				requirement.text += "Is Odd\n"
				var lambda = func(x) : return odd_num(x)
				current_req_list.append(lambda)
				unique_numbers_list.erase(random_requirement)
			2: 
				# Greater than
				requirement.text += "Greater than 10\n"
				var lambda = func(x) : return greater_than(x, 10)
				current_req_list.append(lambda)
				unique_numbers_list.erase(random_requirement)
			3: 
				# Less than
				requirement.text += "Less than 5\n"
				var lambda = func(x) : return less_than(x, 5)
				current_req_list.append(lambda)
				unique_numbers_list.erase(random_requirement)
			4: 
				# Greater than
				requirement.text += "Greater than 15\n"
				var lambda = func(x) : return greater_than(x, 10)
				current_req_list.append(lambda)
				unique_numbers_list.erase(random_requirement)
				


	start_player_turn()

# Checks if the battle has been won, if so create a new enemy.
func _process(_delta: float) -> void:
	if !enemy_alive() && player_alive():
		await get_tree().create_timer(ENEMY_TURN_DELAY).timeout
		end_battle(true)
	elif !player_alive():
		end_battle(false)
	

func start_player_turn() -> void:
	state = CombatState.PlayerTurn
	turn_label.text = "Your turn"

func evaluate_equation() -> Variant:
	var container = equation_area.get_child(EQUATION_AREA_CARD_CONTAINER_INDEX)
	var cards = container.get_children()
	
#	Error no cards in equation area
	if cards.is_empty():
		return null
	
	var array_cards = []
#	append all cards to an array to do calculations later
#	Error cards in equation area are not num op num format
	for i in range(cards.size()):
		if i % 2 == 0:
			if get_operator_type(cards[i]):
				return null
			else:
				array_cards.append(extract_card_value(cards[i]))
		elif i % 2 == 1:
			if not get_operator_type(cards[i]):
				return null
			else:
				array_cards.append(get_operator_type(cards[i]))
	
	if extract_card_value(cards[cards.size()-1]) == null:
		return null
	
#	equation stuff with pemdas
#	do multiplication and division first
	var i = 1
	while i < array_cards.size():
		if array_cards[i] == "*" or array_cards[i] == "/":
			array_cards[i-1] = apply_operator(array_cards[i-1], array_cards[i], array_cards[i+1])
			if array_cards[i-1] == null:
				return null
			array_cards.pop_at(i)
			array_cards.pop_at(i)
		else:
			i += 2
	i = 1
#	next do addition and subtraction
	while i < array_cards.size():
		if array_cards[i] == "+" or array_cards[i] == "-":
			array_cards[i-1] = apply_operator(array_cards[i-1], array_cards[i], array_cards[i+1])
			array_cards.pop_at(i)
			array_cards.pop_at(i)
		else:
			i += 2
			
	var result = array_cards[0]
	return result

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
		if card.get_parent() == container and is_instance_valid(card):
			container.remove_child(card)
			Global.discardPile.append(card)

func player_choose_attack() -> void:
	if state != CombatState.PlayerTurn: 
		return
	state = CombatState.Busy
	
	var result = evaluate_equation()
	check_criterias_of_result(result)
	
	if result == null:
		turn_label.text = "I messed up!"
		await get_tree().create_timer(MESSAGE_DISPLAY_TIME).timeout
		clear_equation_area()
		transition(CombatState.PlayerTurn)
	else:
		var damage = max(result, 0)
		for req in current_req_list:
			if req.call(damage):
				damage *= 2
		$User/AnimationPlayer.play("attack")
		enemy_hp_bar.value -= damage * Global.damage_multiplier
		await get_tree().create_timer(ATTACK_DELAY).timeout
		clear_equation_area()
		transition(CombatState.PlayerTurn)

func check_criterias_of_result(result: Variant):
	if result == null:
		return
	#placeholder for damager multipler stuff
	Global.damage_multiplier *= 1

func start_enemy_turn() -> void:
	state = CombatState.EnemyTurn
	turn_label.text = "Enemy turn"

	$Enemy/AnimationPlayer.play("enemy_attack")
	await get_tree().create_timer(ENEMY_TURN_DELAY).timeout
	GameState.player_health -= ENEMY_DAMAGE
	hp_bar.value = GameState.player_health

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
	return enemy_hp_bar.value > 0

func player_alive() -> bool:
	return hp_bar.value > 0

func end_battle(victory: bool) -> void:
	if victory:
		print("Got a victory")
		GameState.player_score += 1000
		GameState.current_level += 1
		score.text = str(GameState.player_score).pad_zeros(8)
		var hand_container = hand_area.get_node("CardContainer")
		var equation_container = equation_area.get_child(EQUATION_AREA_CARD_CONTAINER_INDEX)
		Global.reset_round(hand_container, equation_container)
		get_tree().change_scene_to_file("res://Scenes/adding_card.tscn")
	elif !victory:
		get_tree().change_scene_to_file("res://Scenes/Defeated_Screen.tscn")

func even_num(num) -> bool:
	return num % 2 == 0

func odd_num(num) -> bool:
	return !(num % 2 == 0)

func greater_than(num, num2) -> bool:
	return num > num2

func less_than(num, num2) -> bool:
	return num < num2
