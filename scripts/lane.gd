extends Node

var lanes_node: Node
var default_direction: Vector2

func register_lanes(node: Node, dir: Vector2):
	lanes_node = node
	default_direction = dir
	
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
		
func swap_directions():
	var lanes = lanes_node.get_children()
	
	# Random Anzahl an Lanes die geswitcht werden (min 1, max alle)
	var num_to_swap = randi_range(1, lanes.size())
	
	# Lanes shuffeln und ersten num_to_swap nehmen
	lanes.shuffle()
	var lanes_to_swap = lanes.slice(0, num_to_swap)
	
	for lane in lanes_to_swap:
		for child in lane.get_children():
			if child is Cat:
				child.direction *= -1
				child.update_animation()	

func restore_all_directions():	for lane in lanes_node.get_children():
		for child in lane.get_children():
			if child is Cat:
				child.direction = default_direction
				child.update_animation()
