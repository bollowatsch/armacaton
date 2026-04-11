extends Node

# CONSTANTS
var LIVES_START: int = 5
var LEVEL_START: int = 1
var LEVELS_AVAILABLE: int = 2

enum State { MENU, PLAYING, DEAD, WIN }
var state: State

var lives: int
var level: int

var mouse: Mouse1

signal lives_changed(new_lives)
signal level_changed(new_level)

func _ready() -> void:
	state = State.MENU

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
	mouse.sprite.play("dies_up")
	await mouse.sprite.animation_finished
	
	if lives <= 0:
		state = State.DEAD
		mouse.play_dead()
		level -= 1
		go_to_menu()
	else:
		# Spieler respawnen — Signal an mouse.gd
		mouse.respawn()
	
func player_reached_goal():
	if state != State.PLAYING:
		return
	
	level += 1
	emit_signal("level_changed", level)
	
	if level > LEVELS_AVAILABLE:
		state = State.WIN
		level -= 1  # set level to last achieved one
		go_to_menu()
	else:
		get_tree().change_scene_to_file("res://scenes/levels/%d.tscn" % level)
		mouse.respawn()

func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/ui/mainScreen.tscn")

func register_mouse(m : Mouse1):
	mouse = m
	
func add_life():
	lives += 1
	emit_signal("lives_changed", lives)
