extends Node

func _ready():
	LaneManager.set_speed_for_lane($Lanes/Lane4, 40.0)
	LaneManager.set_speed_for_lane($Lanes/Lane5, 110.0)
	var offset: Vector2 = GameManager.OFFSET_PER_LEVEL[1]
	GameManager.mouse.respawn(offset)

# Beim Switch-Event:
func on_switch_triggered():
	LaneManager.set_direction_for_lane($Lanes/Lane3, Vector2.LEFT)
