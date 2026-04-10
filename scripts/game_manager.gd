extends Node

# CONSTANTS
var LIVES_START: int = 5
var LEVEL_START: int = 1
var LEVELS_AVAILABLE: int = 2

enum State { MENU, PLAYING, DEAD, WIN }
var state: State = State.PLAYING

var lives: int
var level: int

signal lives_changed(new_lives)
signal level_changed(new_level)
signal game_over()
signal game_won()

func start_game():
	lives = LIVES_START
	level = LEVEL_START
	state = State.PLAYING
	emit_signal("lives_changed", lives)
	emit_signal("level_changed", level)

func player_died():
	if state != State.PLAYING:
		return
	
	lives -= 1
	emit_signal("lives_changed", lives)
	
	if lives <= 0:
		state = State.DEAD
		print("state dead")

		# TODO back to start screen
	else:
		# Spieler respawnen — Signal an mouse.gd
		get_tree().call_group("mouse", "respawn")

func player_reached_goal():
	if state != State.PLAYING:
		return
	
	level += 1
	emit_signal("level_changed", level)
	
	if level > LEVELS_AVAILABLE:
		state = State.WIN
		print("state win")
		# TODO back to start screen
	else:
		print('respawn')
		get_tree().call_group("mouse", "respawn")
		

func go_to_menu():
	state = State.MENU
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func restart():
	start_game()
	get_tree().change_scene_to_file("res://scenes/levels/1.tscn")
