extends CharacterBody3D

var velocidad: int = 10
var direccion: Vector3

var sensibilidad: float = 0.003
@onready var camara: Camera3D = $Camera3D

# Variables para controlar la rotación
var rot_y: float = 0.0 # rotación del cuerpo (horizontal)
var rot_x: float = 0.0 # rotación de la cámara (vertical)

# 🔹 Estado de bloqueo para entradas
var bloqueado := false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# 🔹 Spawn point si venimos de otra escena
	var meta = get_tree().current_scene.get_meta("entrada", null)
	if meta and meta.has("spawn_point"):
		var spawn = get_tree().current_scene.find_child(meta.spawn_point, true, false)
		if spawn:
			global_transform.origin = spawn.global_transform.origin


func _physics_process(delta):
	# 🔹 SOLO BLOQUEAMOS EL MOVIMIENTO FÍSICO (WASD)
	if bloqueado:
		velocity = Vector3.ZERO
		move_and_slide() # Importante llamarlo para evitar bugs físicos
		return
		
	caminar(delta)
	move_and_slide()


func _input(event):
	# 🔹 EL MOUSE SIEMPRE FUNCIONA (incluso si bloqueado = true)
	# Esto permite mirar alrededor durante el diálogo
	if event is InputEventMouseMotion:
		mover_camara(event)
	
	# 🔹 EL RESTO DE INPUTS SE BLOQUEAN SI ESTAMOS EN DIÁLOGO
	if bloqueado:
		return
	
	# Aquí puedes añadir más inputs que solo funcionen si NO está bloqueado
	if Input.is_action_just_pressed("ocultar_raton"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func caminar(delta):
	direccion = transform.basis * Vector3(
		Input.get_axis("izquierda", "derecha"),
		0,
		Input.get_axis("adelante", "atras")
	)
	direccion = direccion.normalized()

	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad

	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0


func mover_camara(event: InputEventMouseMotion):
	rot_y -= event.relative.x * sensibilidad
	rot_x -= event.relative.y * sensibilidad

	rot_x = clamp(rot_x, deg_to_rad(-89), deg_to_rad(89))

	rotation.y = rot_y
	camara.rotation.x = rot_x


# 🔹 Funciones para bloquear/desbloquear desde diálogos o triggers
func bloquear():
	bloqueado = true
	# Opcional: dejar el mouse visible durante el diálogo
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func desbloquear():
	bloqueado = false
	# Opcional: capturar el mouse al volver al juego
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
