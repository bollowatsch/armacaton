extends Node

func set_speed_for_lane(lane: Node, new_speed: float):
	for child in lane.get_children():
		if child is Cat:
			child.speed = new_speed

func set_direction_for_lane(lane: Node, new_dir: Vector2):
	for child in lane.get_children():
		if child is Cat:
			child.direction = new_dir
			child.update_animation()

func set_speed_all_lanes(new_speed: float):
	for lane in $Lanes.get_children():
		set_speed_for_lane(lane, new_speed)
