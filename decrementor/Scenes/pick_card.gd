extends HBoxContainer

const CARD_NUM_SCENE = preload("res://Scenes/card_front_num.tscn")
const CARD_BINOP_SCENE = preload("res://Scenes/card_front_binop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	var card1 = CARD_BINOP_SCENE.instantiate()
	random_binop_card(card1)
	add_child(card1)
	
	var card2 = CARD_NUM_SCENE.instantiate()
	random_num_card(card2)
	add_child(card2)
	
	var card3
	var random_number = randi_range(0,1)
	if random_number == 1:
		card3 = CARD_BINOP_SCENE.instantiate()
		random_binop_card(card3)
	else:
		card3 = CARD_NUM_SCENE.instantiate()
		random_num_card(card3)
	add_child(card3)

func random_binop_card(card: Control) -> void:
	var base_op_card = card.get_node("Area2D/CollisionShape2D/BaseOpCard")
	
	base_op_card.get_node("Plus").visible = false
	base_op_card.get_node("Minus").visible = false
	base_op_card.get_node("Multi").visible = false
	base_op_card.get_node("Div").visible = false
	
	var random_int = randi_range(1,4)
	base_op_card.get_child(random_int).visible = true

func random_num_card(card: Control) -> void:
	var label = card.get_node("Area2D/CollisionShape2D/BaseNumCard/Label")
	
	var random_int = randi_range(0,9)
	label.text = str(random_int)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				Global.deck.append(card)
				get_tree().change_scene_to_file("res://Scenes/Level1.tscn")

# function checks card collision with mouse
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	print(result)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
