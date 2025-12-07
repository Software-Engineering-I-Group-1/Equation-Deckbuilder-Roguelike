extends Area2D

var normal_offset := 0
var hover_offset := -20
var tween: Tween

@onready var card := get_parent() as Control   # the Control node that needs to move

func _ready() -> void:
	normal_offset = card.offset_top
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(card, "offset_top", hover_offset, 0.15)

func _on_mouse_exited():
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(card, "offset_top", normal_offset, 0.15)
