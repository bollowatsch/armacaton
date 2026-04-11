extends Node

# Item Spawn Configuration
const SPAWN_CONFIG = {
	"heart": 2, # Extra Leben
	"milk": 3, # Münzen
	"tnt": 5, # Minus Leben
	"coin": 4, # Bonus Punkte
	"trap": 1 # direkter Tod
}

func _ready():
	LaneManager.register_lanes($Lanes, Vector2.RIGHT)
	LaneManager.set_speed_for_lane($Lanes/Lane2, 200.0)
	LaneManager.set_speed_for_lane($Lanes/Lane4, 60.0)
	var offset: Vector2 = GameManager.OFFSET_PER_LEVEL[2]
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
