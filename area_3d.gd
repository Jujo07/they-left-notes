extends Area3D

# Señal para notificar al jugador que puede interactuar
signal player_entered_interaction_area
signal player_exited_interaction_area

# Ruta al punto de teletransporte dentro de la casa
@export var house_teleport_position: Vector3

# Opcional: si usas una escena separada para el interior
@export var house_interior_scene: PackedScene

func _ready():
	# Asegúrate de que el área detecte cuerpos
	monitoring = true
	monitorable = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Jugador":  # Asegúrate de que el jugador se llame "Player"
		player_entered_interaction_area.emit()

func _on_body_exited(body):
	if body.name == "Jugador":
		player_exited_interaction_area.emit()

# Función para teletransportar al jugador
func teleport_player(player):
	if house_interior_scene:
		# Si usas una escena diferente para el interior
		get_tree().change_scene_to_packed(house_interior_scene)
		# En ese caso, el jugador debería reaparecer en la escena nueva
