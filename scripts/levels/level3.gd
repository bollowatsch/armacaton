extends Node
# Item Spawn Configuration
const SPAWN_CONFIG = {
	"cheese": 3, # Extra Leben
	"milk": 2, # Münzen
	"tnt": 2, # Minus Leben
	"coin": 5 # Bonus Punkte
}

func _ready():
	LaneManager.register_lanes($Lanes, Vector2.UP)
	
	LaneManager.set_speed_for_lane($Lanes/Lane2, 130.0)
	LaneManager.set_speed_for_lane($Lanes/Lane4, 60.0)
	LaneManager.set_speed_for_lane($Lanes/Lane4, 150.0)
	var offset: Vector2 = GameManager.OFFSET_PER_LEVEL[3]
	GameManager.mouse.respawn(offset)

func _spawn_items():
	# Erstelle Container für Items falls nicht vorhanden
	var items_container = get_node_or_null("Items")
	if not items_container:
		items_container = Node2D.new()
		items_container.name = "Items"
		add_child(items_container)
