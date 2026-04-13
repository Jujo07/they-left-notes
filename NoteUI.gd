extends CanvasLayer

@onready var label = $Panel/Label

func _ready():
	visible = false   # empieza invisible

func show_note(text):
	label.text = text
	visible = true
	get_tree().paused = true  # pausa el juego
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # muestra el cursor

func close_note():
	visible = false
	get_tree().paused = false  # reanuda el juego
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # oculta el cursor

func _input(event):
	if visible and event.is_action_pressed("interact"):
		close_note()
