extends Node

# All possible combat states:
enum CombatState {
	PlayerTurn,
	EnemyTurn,
	Busy,
	End
}

# Initial state:
var state = CombatState.PlayerTurn

# Obtain Player, Enemy, and UI objects:
@onready var player = $User 
@onready var enemy = $Enemy 
# @onready var ui = $UI

@onready var attack_button = $Attack_Button
@onready var turn_label = $Label
@onready var hp_bar= $Player_HP/ProgressBar

func _on_attack_button_pressed():
	print("Attack button pressed")
	if state == CombatState.PlayerTurn:
		player_choose_attack()

func _ready() -> void:
	attack_button.pressed.connect(_on_attack_button_pressed)
	start_player_turn()
	

func start_player_turn():
	state = CombatState.PlayerTurn  # Change state to player turn.
	turn_label.text = "Your turn"
	# player_choose_attack()



func player_choose_attack():
	if state != CombatState.PlayerTurn: return  # Return if not player's turn.
	state = CombatState.Busy

	# Write out attack code here!

	transition(CombatState.PlayerTurn)

func start_enemy_turn():
	state = CombatState.EnemyTurn
	turn_label.text = "Enemy turn"

	await get_tree().create_timer(0.8).timeout	# Enemy attack	
	hp_bar.value -= 5

	transition(CombatState.EnemyTurn)

func transition(prev_state):
	match prev_state:
		CombatState.PlayerTurn:
			if !enemy_alive(): end_battle(true)
			else: start_enemy_turn()
		CombatState.EnemyTurn:
			if !player_alive(): end_battle(false)
			else: start_player_turn()
		_:
			print("Unknown State")

func enemy_alive() -> bool:
	return true

func player_alive() -> bool:
	return true

func end_battle(victory):
	return
