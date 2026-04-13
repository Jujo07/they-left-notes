extends CanvasLayer

@onready var label = $Label

func show_prompt():
	label.text = "Pulsa I para recoger"
	visible = true

func hide_prompt():
	visible = false
