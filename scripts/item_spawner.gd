class_name ItemSpawner
extends Node

# Preload item scenes
const CHEESE_SCENE = preload("res://scenes/figures/cheese.tscn")
const MILK_SCENE = preload("res://scenes/figures/milk_bottle.tscn")
const TNT_SCENE = preload("res://scenes/figures/tnt.tscn")

# Spawn configuration
var spawn_config: Dictionary = {
	"cheese": 0,
	"milk": 0,
	"tnt": 0
}

# Screen bounds
var screen_width: float
var screen_height: float
var margin: float = 30.0 # Abstand vom Rand
var lane_start_y: float = 100.0 # Wo die Lanes beginnen
var lane_end_y: float = 900.0 # Wo die Lanes enden
var safe_zone_height: float = 80.0 # Sichere Zone am Boden für Respawn

# Container für gespawnte Items
var items_container: Node2D

func _init():
	name = "ItemSpawner"

func setup(config: Dictionary, container: Node2D):
	spawn_config = config
	items_container = container

	# Screen-Größe holen
	var viewport = container.get_viewport()
	if viewport:
		var rect = viewport.get_visible_rect()
		screen_width = rect.size.x
		screen_height = rect.size.y

func spawn_all_items():
	if not items_container:
		push_error("ItemSpawner: No container set!")
		return

	# Cheese spawnen
	for i in range(spawn_config.get("cheese", 0)):
		_spawn_item(CHEESE_SCENE, "cheese")

	# Milk spawnen
	for i in range(spawn_config.get("milk", 0)):
		_spawn_item(MILK_SCENE, "milk")

	# TNT spawnen
	for i in range(spawn_config.get("tnt", 0)):
		_spawn_item(TNT_SCENE, "tnt")

func _spawn_item(scene: PackedScene, type: String):
	var item = scene.instantiate()
	var pos = _get_random_position()
	item.position = pos
	items_container.add_child(item)

func _get_random_position() -> Vector2:
	# Zufällige Position im spielbaren Bereich
	# Vermeide den Spawn-Bereich unten (sichere Zone)
	var x = randf_range(margin, screen_width - margin)
	var y = randf_range(lane_start_y, screen_height - safe_zone_height)

	return Vector2(x, y)

# Optional: Position mit Kollisionsprüfung
func _get_safe_random_position(max_attempts: int = 10) -> Vector2:
	var attempts = 0
	var pos = Vector2.ZERO

	while attempts < max_attempts:
		pos = _get_random_position()

		# Prüfe, ob Position sicher ist (nicht zu nah an anderen Items)
		if _is_position_safe(pos):
			return pos

		attempts += 1

	# Nach max_attempts gib einfach letzte Position zurück
	return pos

func _is_position_safe(pos: Vector2, min_distance: float = 50.0) -> bool:
	if not items_container:
		return true

	# Prüfe Abstand zu allen bereits gespawnten Items
	for child in items_container.get_children():
		if child is Area2D:
			var distance = pos.distance_to(child.position)
			if distance < min_distance:
				return false

	return true
