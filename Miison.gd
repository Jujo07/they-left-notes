extends Label  # o RichTextLabel

func _ready():
	QuestManager.objective_updated.connect(_on_objective_updated)

func _on_objective_updated(new_text):
	text = new_text
	# Efecto glitch al cambiar
	_glitch_effect()

func _glitch_effect():
	var original_color = color
	color = Color.RED
	await get_tree().create_timer(0.1).timeout
	color = original_color
