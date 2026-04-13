extends CharacterBody3D

var velocidad: int = 10
var direccion: Vector3

var sensibilidad: float = 0.003
@onready var camara: Camera3D = $Camera3D

# Variables para controlar la rotación
var rot_y: float = 0.0 # rotación del cuerpo (horizontal)
var rot_x: float = 0.0 # rotación de la cámara (vertical)

# 🔹 NUEVO: estado de bloqueo para entradas
var bloqueado := false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# 🔹 NUEVO: aparecer en punto de spawn si venimos de una entrada
	var meta = get_tree().current_scene.get_meta("entrada", null)
	if meta and meta.has("spawn_point"):
		var spawn = get_tree().current_scene.find_child(meta.spawn_point, true, false)
		if spawn:
			global_transform.origin = spawn.global_transform.origin


func _physics_process(delta):
	# 🔹 NUEVO: si está bloqueado, no se mueve
	if bloqueado:
		velocity = Vector3.ZERO
		return
		
	caminar(delta)
	move_and_slide() # esta llamada usa la propiedad velocity del CharacterBody3D


func _input(event):
	# 🔹 NUEVO: ignorar input si está bloqueado
	if bloqueado:
		return
		
	if event is InputEventMouseMotion:
		mover_camara(event)


func caminar(delta):
	direccion = transform.basis * Vector3(
		Input.get_axis("izquierda", "derecha"),
		0,
		Input.get_axis("adelante", "atras")
	)
	direccion = direccion.normalized() # para que no corra más en diagonal

	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad

	# Añadimos un poco de gravedad opcional para que se mantenga en el suelo
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0


func mover_camara(event: InputEventMouseMotion):
	# Ajustar valores según el movimiento del ratón
	rot_y -= event.relative.x * sensibilidad
	rot_x -= event.relative.y * sensibilidad

	# Limitar la rotación vertical entre -90 y 90 grados
	rot_x = clamp(rot_x, deg_to_rad(-89), deg_to_rad(89))

	# Aplicar rotaciones
	rotation.y = rot_y
	camara.rotation.x = rot_x


func ocultar_raton():
	if Input.is_action_just_pressed("ocultar_raton"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# 🔹 NUEVO: funciones para bloquear/desbloquear desde triggers
func bloquear():
	bloqueado = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func desbloquear():
	bloqueado = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
