extends Node

# Item Spawn Configuration
const SPAWN_CONFIG = {
	"heart": 1, # Extra Leben
	"milk": 2, # speed
	"tnt": 3, # Minus Leben
	"coin": 2, # Bonus Punkte
}

func _ready():
	LaneManager.register_lanes($Lanes, Vector2.RIGHT)
	LaneManager.set_speed_for_lane($Lanes/Lane4, 40.0)
	LaneManager.set_speed_for_lane($Lanes/Lane5, 80.0)
	LaneManager.set_speed_for_lane($Lanes/Lane2, 110.0)
	var offset: Vector2 = GameManager.OFFSET_PER_LEVEL[1]
	GameManager.mouse.respawn(offset)

	# Spawn Items
	_spawn_items()

func _spawn_items():
	# Erstelle Container für Items falls nicht vorhanden
	var items_container = get_node_or_null("Items")
	if not items_container:
		items_container = Node2D.new()
		items_container.name = "Items"
		add_child(items_container)

	# Erstelle und konfiguriere Spawner
	var spawner = ItemSpawner.new()
	spawner.setup(SPAWN_CONFIG, items_container)
	spawner.spawn_all_items()

	# Spawner wird nicht mehr gebraucht
	spawner.queue_free()

# Beim Switch-Event:
func on_switch_triggered():
	LaneManager.set_direction_for_lane($Lanes/Lane3, Vector2.LEFT)
