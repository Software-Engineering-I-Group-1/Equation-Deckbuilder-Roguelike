extends Node2D

const CARD_COLLISION_MASK = 1
const ZONE_COLLISION_MASK = 2

var card_being_dragged: Node
var card_original_parent: Node
var card_original_position: Vector2

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = mouse_pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_on_mouse_pressed()
		else:
			_on_mouse_released()

func _on_mouse_pressed() -> void:
	var card = _raycast_for_card()
	if card:
		card_being_dragged = card
		card_original_parent = card.get_parent()
		card_original_position = card.position

func _on_mouse_released() -> void:
	if not card_being_dragged:
		return
	
	var equation_area = _raycast_for_zone()
	if equation_area and equation_area.name == "Equation Area":
		card_being_dragged.reparent(equation_area.get_child(2))
	else:
		card_being_dragged.reparent(card_original_parent)
		card_being_dragged.position = card_original_position
	
	card_being_dragged = null

func _raycast_for_card() -> Node:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_COLLISION_MASK
	
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func _raycast_for_zone() -> Node:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = ZONE_COLLISION_MASK
	
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func _ready() -> void:
	pass
