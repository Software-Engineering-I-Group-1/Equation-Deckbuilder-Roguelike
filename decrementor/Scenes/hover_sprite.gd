extends Sprite2D

func _on_card_mouse_entered():
	#print("Mouse entered!")
	self.visible = true
func _on_card_mouse_exited():
	#print("Mouse exited!")
	self.visible = false
