extends Node3D

@export var dialogue_resource: DialogueResource = preload("res://terror.dialogue")

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout  # Espera 2 segundos al inicio (opcional)
	
	if dialogue_resource:
		DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
		print("Diálogo iniciado!")
	else:
		print("¡Error! No se cargó el DialogueResource.")
