extends Control
class_name View

func _process(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		_go_back()
		
func _go_back():
	pass
