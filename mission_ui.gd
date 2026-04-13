extends Label

# Colores para el efecto glitch
@export var normal_color := Color.WHITE
@export var glitch_color := Color.RED

func _ready():
	# Verificar que el Autoload existe antes de usarlo
	if Engine.has_singleton("QuestManager") or get_node_or_null("/root/QuestManager"):
		QuestManager.objective_updated.connect(_on_objective_updated)
		# Inicializar con el primer objetivo
		text = QuestManager.objectives[0] if QuestManager.objectives.size() > 0 else "..."
	else:
		push_warning("⚠️ QuestManager no encontrado. ¿Lo añadiste en Autocarga?")
		text = "ERROR: Sin misiones"

func _on_objective_updated(new_text: String):
	text = new_text
	_glitch_effect()

func _glitch_effect():
	# Godot 4: Usar override para cambiar el color del texto del Label
	add_theme_color_override("font_color", glitch_color)
	
	# Pequeño temblor en la posición
	var original_pos = position
	position += Vector2(randf_range(-5, 5), randf_range(-5, 5))
	
	await get_tree().create_timer(0.1).timeout
	
	add_theme_color_override("font_color", normal_color)
	position = original_pos
