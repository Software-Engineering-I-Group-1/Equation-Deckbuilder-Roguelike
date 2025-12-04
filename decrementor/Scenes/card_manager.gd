extends Node2D

const CARD_LOCATION_MASKS = 2

var card_being_dragged

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = mouse_pos

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				card_being_dragged = card
		else:
			if card_being_dragged:
				var parent_of_card_being_dragged = card_being_dragged.get_parent()
				var equation_area_found = raycast_check_for_equation_area()
				var hand_area_found = raycast_check_for_hand_area()
				if equation_area_found:
					#set position of card in equation area
					parent_of_card_being_dragged.remove_child(card_being_dragged)
					equation_area_found.get_child(2).add_child(card_being_dragged)
					
				elif hand_area_found:
					#set position of card in equation area
					parent_of_card_being_dragged.remove_child(card_being_dragged)
					hand_area_found.get_child(2).add_child(card_being_dragged)
					
				else:
					parent_of_card_being_dragged.remove_child(card_being_dragged)
					parent_of_card_being_dragged.add_child(card_being_dragged)

			card_being_dragged = null

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

# function checks (mouse with card) collision with equation area
func raycast_check_for_equation_area():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_LOCATION_MASKS
	#print(parameters.collision_mask)
	var result = space_state.intersect_point(parameters)
	#print(result)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
	
# function checks (mouse with card) collision with hand area
func raycast_check_for_hand_area():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_LOCATION_MASKS
	#print(parameters.collision_mask)
	var result = space_state.intersect_point(parameters)
	#print(result)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
