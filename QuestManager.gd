# QuestManager.gd
extends Node

signal objective_updated(new_text)

# Definimos la secuencia de misiones
var objectives = [
	"Coge la nota del suelo",
	"Acércate al árbol cercano",
	"Investiga lo que hay en las ramas",
	"Encuentra la salida"
]

var current_index = 0

func _ready():
	emit_signal("objective_updated", objectives[current_index])

func complete_current_objective():
	if current_index < objectives.size():
		current_index += 1
		if current_index < objectives.size():
			# Cambia el objetivo
			emit_signal("objective_updated", objectives[current_index])
		else:
			emit_signal("objective_updated", "NO HAY SALIDA")

func get_current_index():
	return current_index
