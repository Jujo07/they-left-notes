# GameManager.gd
extends Node

var jugador: CharacterBody3D = null

func _ready():
	# Buscar al jugador en el grupo "player"
	jugador = get_tree().get_first_node_in_group("player")

func bloquear_movimiento():
	if jugador:
		jugador.bloqueado = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func desbloquear_movimiento():
	if jugador:
		jugador.bloqueado = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
