extends SpotLight3D

func _input(event):
	if event.is_action_pressed("on"):
		visible = true
	elif event.is_action_pressed("off"):
		visible = false
