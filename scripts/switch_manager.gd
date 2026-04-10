extends Node

# Mögliche Modi
enum Mode { NORMAL, SWAP_LR, ROTATE_CW, INVERT_ALL, RANDOM }

var current_mode: Mode = Mode.NORMAL
var last_time_until_switch: float = 8.0
var time_until_switch: float = last_time_until_switch
var min_time_until_switch: float = 4.0
var random_vector: Dictionary

func _process(delta):
	time_until_switch -= delta
	if time_until_switch <= 0:
		trigger_switch()

func trigger_switch():
	# Zufälligen neuen Modus wählen (nicht den aktuellen)
	var modes = Mode.values()
	modes.erase(current_mode)
	current_mode = modes.pick_random()
	
	# Timer wird mit der Zeit kürzer (Schwierigkeit!)
	last_time_until_switch = max(min_time_until_switch, last_time_until_switch * 0.85)
	time_until_switch = last_time_until_switch
	
	var temp = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	temp.shuffle()
	random_vector = {
		Vector2.UP: temp.pop_front(),
		Vector2.DOWN: temp.pop_front(),
		Vector2.RIGHT: temp.pop_front(),
		Vector2.LEFT: temp.pop_front(),
		}
	
	# UI benachrichtigen
	emit_signal("switch_triggered", current_mode)

func input_event_to_vector2(event: InputEvent) -> Vector2:
	if event.is_action_pressed("ui_up"):    return Vector2.UP
	if event.is_action_pressed("ui_down"):  return Vector2.DOWN
	if event.is_action_pressed("ui_left"):  return Vector2.LEFT
	if event.is_action_pressed("ui_right"): return Vector2.RIGHT
	return Vector2.ZERO

# Wird von mouse.gd aufgerufen
func get_mapped_direction(raw: Vector2) -> Vector2:
	if raw == Vector2.ZERO:
		return Vector2.ZERO
	
	# Mapping anwenden
	match current_mode:
		Mode.NORMAL:
			return raw
		Mode.SWAP_LR:
			if raw == Vector2.LEFT:  return Vector2.RIGHT
			if raw == Vector2.RIGHT: return Vector2.LEFT
			return raw
		Mode.ROTATE_CW:
			# Links→Oben, Oben→Rechts, Rechts→Unten, Unten→Links
			return Vector2(raw.y * -1, raw.x)  # 90° Rotation
		Mode.INVERT_ALL:
			return raw * -1
		Mode.RANDOM:
			return random_vector[raw]
		
	push_error('No vector could be determined for move')
	return Vector2.ZERO

signal switch_triggered(new_mode)
