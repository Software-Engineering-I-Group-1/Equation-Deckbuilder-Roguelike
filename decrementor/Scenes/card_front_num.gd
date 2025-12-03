extends Control

var random_number = randi() % 10
@onready var label = $Area2D/CollisionShape2D/BaseNumCard/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(random_number)
	label.text = str(random_number)
