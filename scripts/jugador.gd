extends CharacterBody3D

var velocidad: int = 200
var direccion: Vector3

var sensibilidad: float = 0.003
@onready var camara: Camera3D = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	caminar(delta)
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		mover_camara(event)

func caminar(delta):
	direccion = transform.basis * Vector3(
		Input.get_axis("izquierda", "derecha"),
		0,
		Input.get_axis("adelante", "atras")
	)
	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad

func mover_camara(event: InputEventMouseMotion):
	# Rotar el cuerpo horizontalmente (eje Y)
	rotate_y(-event.relative.x * sensibilidad)

	# Rotar la cámara verticalmente (eje X)
	camara.rotate_x(-event.relative.y * sensibilidad)

	# Limitar la rotación vertical de la cámara
	camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func ocultar_raton():
	if Input.is_action_just_pressed("ocultar_raton"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
