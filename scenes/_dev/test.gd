# test_switch.gd  — läuft wenn du F6 drückst
extends Node

func _ready():
	# SwitchManager direkt instanzieren ohne Autoload
	var sm = preload("res://scripts/switch_manager.gd").new()
	add_child(sm)
	
	# Testen:
	var inp = Vector2.UP
	
	print("Modus nach Switch: ", sm.current_mode)
	print(sm.get_mapped_direction(inp))
	
	sm.trigger_switch()
	print("Modus nach Switch: ", sm.current_mode)
	print(sm.get_mapped_direction(inp))
	
	sm.trigger_switch()
	print("Modus nach 2. Switch: ", sm.current_mode)
	print(sm.get_mapped_direction(inp))
	
