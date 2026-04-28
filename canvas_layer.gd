# HUD.gd
extends CanvasLayer

@export var total_notas := 7
var notas_recogidas := 0
@onready var label = $LabelNotas

func _ready():
	await get_tree().process_frame
	actualizar_hud()
	
func nota_recogida():
	notas_recogidas += 1
	actualizar_hud()
	if notas_recogidas == total_notas:
		final_del_juego()

func actualizar_hud():
	label.text = "Notas: " + str(notas_recogidas) + "/" + str(total_notas)

func final_del_juego():
	print("¡Has recogido todas las notas! Revelación final...")
	# Aquí puedes mostrar la nota final, cargar otra escena, etc.
