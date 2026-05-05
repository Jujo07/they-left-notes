extends Area3D

var jugador_cerca := false
var inspeccionando := false
var guardado := false
var jugador: CharacterBody3D
var camara: Camera3D
var pos_original: Vector3
var tiempo_inspeccion := 0.0

@onready var mesh = $"../root/GLTF_SceneRootNode"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador = body
		camara = jugador.get_node("Camera3D")
		jugador_cerca = true

func _on_body_exited(body):
	if body.name == "Jugador":
		jugador_cerca = false

func _process(delta):
	if jugador_cerca and not inspeccionando and not guardado:
		if Input.is_action_just_pressed("interact"):
			iniciar_inspeccion()
			tiempo_inspeccion = 0.0

	if inspeccionando:
		tiempo_inspeccion += delta
		
		var objetivo = camara.global_position + (-camara.global_transform.basis.z * 1.0)
		objetivo.y = camara.global_position.y - 0.15
		mesh.global_position = mesh.global_position.lerp(objetivo, 0.2)
		
		var mov = Input.get_last_mouse_velocity()
		mesh.rotate_y(mov.x * delta * 0.003)
		mesh.rotate_x(mov.y * delta * 0.003)
		
		if tiempo_inspeccion > 0.5 and Input.is_action_just_pressed("interact"):
			guardar()

func iniciar_inspeccion():
	inspeccionando = true
	jugador.bloqueado = true
	pos_original = mesh.global_position
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func guardar():
	inspeccionando = false
	guardado = true
	jugador.bloqueado = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mesh.visible = false
	print("Bidón guardado")
