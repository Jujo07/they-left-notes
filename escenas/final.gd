extends Area3D

var jugador_cerca := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_cerca = true

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("interact"):
		var gasolina = get_tree().get_first_node_in_group("gasolina")
		if gasolina and gasolina.guardado:
			activar_final()
		else:
			print("Necesitas la gasolina")

func activar_final():
	var pantalla = get_tree().current_scene.get_node("PantallaFinal")
	if pantalla == null:
		push_error("No encuentra PantallaFinal")
		return
	
	var rect = pantalla.get_node("ColorRect")
	var label = pantalla.get_node("Label")
	
	if label == null or rect == null:
		push_error("No encuentra ColorRect o Label")
		return
	
	label.text = "Coges la gasolina y vuelves al coche.\nEl motor arranca por fin.\nMientras te alejas por el camino, ves por el retrovisor\nuna figura entre los árboles.\nTe quedas mirando.\nCuando vuelves la vista a la carretera, ya no está.\n\n\nFIN"
	label.visible = false
	pantalla.visible = true
	
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 2.0)
	tween.tween_callback(func(): label.visible = true)
	tween.tween_interval(5.0)
	tween.tween_callback(func(): get_tree().quit())
