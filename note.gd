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
	print("📝 === INICIO open_note() ===")
	
	var note_ui = get_node("/root/NoteUI")
	var hud = get_node("/root/CanvasLayer")
	
	print("📦 note_ui encontrado: ", note_ui != null)
	print("📦 hud encontrado: ", hud != null)
	
	if note_ui != null:
		note_ui.show_note(note_text)
		print("✅ show_note() llamado")
	
	if hud != null:
		print("🔍 HUD script: ", hud.get_script())
		print("🔍 HUD tiene nota_recogida: ", hud.has_method("nota_recogida"))
		hud.nota_recogida()
		print("✅ nota_recogida() llamado")
	else:
		push_error("❌ HUD es NULL")
	
	print("📝 === FIN open_note() ===")
	
	queue_free()
