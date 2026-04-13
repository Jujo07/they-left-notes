@tool
class_name GlitchEffect
extends RichTextEffect

var bbcode = "glitch"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var time: float = char_fx.env.get("time", 2.0)
	var intensity: float = char_fx.env.get("intensity", 0.8)
	var delay: float = char_fx.env.get("delay", 0.3)

	var elapsed = char_fx.elapsed_time - delay
	
	if elapsed < 0:
		return true

	var t = elapsed / time
	
	if t > 1.0:
		char_fx.offset = Vector2.ZERO
		char_fx.color = Color.WHITE
		return true

	var progress = sin(t * PI) * intensity

	# Shake suave
	char_fx.offset = Vector2(
		randf_range(-8.0 * progress, 8.0 * progress),
		randf_range(-8.0 * progress, 8.0 * progress)
	)

	# Colores: blanco → negro → verde
	var color_cycle = fmod(elapsed * 15.0, 3.0)
	if color_cycle < 1.0:
		char_fx.color = Color(1.0, 1.0, 1.0, 1.0)     # Blanco
	elif color_cycle < 2.0:
		char_fx.color = Color(0.0, 0.0, 0.0, 1.0)     # Negro
	else:
		char_fx.color = Color(0.0, 1.0, 0.0, 1.0)     # Verde

	# Corrupción: solo algunas letras (ajusta el 0.6 si quieres más/menos)
	if randf() < progress * 0.6:
		var glitch_chars = "!@#$%^&*()_+{}[]|;:,.<>?/~`1234567890"
		var idx = randi() % glitch_chars.length()
		char_fx.glyph_index = glitch_chars.unicode_at(idx)

	return true
