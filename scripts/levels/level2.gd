extends Node

func _ready():
	LaneManager.set_speed_for_lane($Lanes/Lane2, 200.0)
	LaneManager.set_speed_for_lane($Lanes/Lane4, 60.0)
	
	#LaneManager.set_direction_for_lane($Lanes/Lane2, Vector2.LEFT)
