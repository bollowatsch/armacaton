extends Node

func _ready():
	LaneManager.register_lanes($Lanes, Vector2.UP)
	
	LaneManager.set_speed_for_lane($Lanes/Lane2, 130.0)
	LaneManager.set_speed_for_lane($Lanes/Lane4, 60.0)
	LaneManager.set_speed_for_lane($Lanes/Lane4, 150.0)
	var offset: Vector2 = GameManager.OFFSET_PER_LEVEL[2]
	GameManager.mouse.respawn(offset)
