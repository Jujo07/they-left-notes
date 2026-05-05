extends Area3D

@export var destino: Node3D
@export var texto_boton := "Pulsa E para entrar"

var jugador_cerca := false
var jugador: CharacterBody3D
var en_uso := false  # ← esto evita el loop

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador = body
		jugador_cerca = true
		get_node("/root/NoteUI").show_prompt(texto_boton)

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false
		en_uso = false
		get_node("/root/NoteUI").hide_prompt()

func _process(delta):
	if jugador_cerca and not en_uso and Input.is_action_just_pressed("interact"):
		en_uso = true
		teleportar()

func teleportar():
	if destino != null:
		jugador.global_position = destino.global_position
	get_node("/root/NoteUI").hide_prompt()
