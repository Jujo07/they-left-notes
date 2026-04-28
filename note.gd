extends Area3D

@export var note_text := "VIVA LA PSOE"
var player_near = false

func _on_body_entered(body):
	if body.name == "Jugador":
		player_near = true

func _on_body_exited(body):
	if body.name == "Jugador":
		player_near = false

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):
		open_note()

func open_note():
	var note_ui = get_node("/root/NoteUI")
	var hud = get_node("/root/Hud")
	
	if note_ui != null:
		note_ui.show_note(note_text)
	
	if hud != null:
		hud.nota_recogida()
	else:
		push_error("HUD es NULL")
	
	queue_free()
