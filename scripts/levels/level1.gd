extends Node

func _ready():
	LaneManager.set_speed_for_lane($Lanes/Lane3, 150.0)
	LaneManager.set_speed_for_lane($Lanes/Lane2, 80.0)

# Beim Switch-Event:
func on_switch_triggered():
	LaneManager.set_direction_for_lane($Lanes/Lane3, Vector2.LEFT)
