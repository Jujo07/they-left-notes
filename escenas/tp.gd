extends Area3D

@export var destino: Node3D
var jugador_cerca := false
var jugador: CharacterBody3D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador = body
		jugador_cerca = true

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false

func _process(delta):
	if jugador_cerca and Input.is_action_just_pressed("entrar"):
		if destino != null:
			jugador.global_position = destino.global_position
