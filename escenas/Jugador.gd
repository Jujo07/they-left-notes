extends CharacterBody3D
var velocidad: int = 7
var direccion: Vector3
var sensibilidad: float = 0.003
@onready var camara: Camera3D = $Camera3D
var rot_y: float = 0.0
var rot_x: float = 0.0
var bloqueado := false
var susto_activo := false
var susto_rot_y_objetivo: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var meta = get_tree().current_scene.get_meta("entrada", null)
	if meta and meta.has("spawn_point"):
		var spawn = get_tree().current_scene.find_child(meta.spawn_point, true, false)
		if spawn:
			global_transform.origin = spawn.global_transform.origin
	var tiempo = randf_range(30.0, 60.0)
	await get_tree().create_timer(tiempo).timeout
	var sombra = get_tree().current_scene.find_child("sombra", true, false)
	if sombra:
		activar_susto_sombra(sombra)
	else:
		print("ERROR: no encuentra sombra")

func _physics_process(delta):
	if susto_activo:
		rot_y = lerp_angle(rot_y, susto_rot_y_objetivo, 0.05)
		rotation.y = rot_y
	if bloqueado:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	caminar(delta)
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		mover_camara(event)
	if bloqueado:
		return
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
	#else:
	#	velocity.y = 0

func mover_camara(event: InputEventMouseMotion):
	if susto_activo:
		return
	rot_y -= event.relative.x * sensibilidad
	rot_x -= event.relative.y * sensibilidad
	rot_x = clamp(rot_x, deg_to_rad(-89), deg_to_rad(89))
	rotation.y = rot_y
	camara.rotation.x = rot_x

func bloquear():
	bloqueado = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func desbloquear():
	bloqueado = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func activar_susto_sombra(sombra: Node3D):
	susto_activo = true
	bloqueado = true
	var pos_delante = global_position + (-global_transform.basis.z * 8)
	pos_delante.y = global_position.y + 2.5
	sombra.global_position = pos_delante
	var dir = global_position.direction_to(sombra.global_position)
	susto_rot_y_objetivo = atan2(-dir.x, -dir.z)
	sombra.visible = true
	# $AudioStreamPlayer.play()  <-- comentado por ahora
	await get_tree().create_timer(2.0).timeout
	sombra.visible = false
	susto_activo = false
	bloqueado = false
