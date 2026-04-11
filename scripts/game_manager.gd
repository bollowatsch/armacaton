extends Node

# CONSTANTS
const LIVES_START: int = 5
const LEVEL_START: int = 1
const LEVELS_AVAILABLE: int = 2

const OFFSET_PER_LEVEL: Dictionary = {
	1: Vector2.ZERO,
	2: Vector2.ZERO,
	3: Vector2(110, 0)
}

const LEVEL_BONUS: int = 1000 # 1000 points pro Level
const COIN_BONUS: int = 300
const LIVES_BONUS: int = 500
const TIME_PENALTY: float = 2.0 # Punkte pro Sekunde

var score_update_timer: float = 0.0
const SCORE_UPDATE_INTERVAL: float = 0.1 # 10x pro Sekunde

var coins: int = 0
var elapsed_time: float = 0.0
var is_timing: bool = false
var score: int = 0

enum State {MENU, PLAYING, DEAD, WIN}
var state: State

var lives: int
var level: int

var mouse: Mouse1

signal lives_changed(new_lives)
signal level_changed(new_level)
signal score_changed(new_score)
signal coins_changed(new_coins)

func _ready() -> void:
	state = State.MENU

func _process(delta: float) -> void:
	if not is_timing:
		return

	elapsed_time += delta

	score_update_timer -= delta
	if score_update_timer <= 0:
		score_update_timer = SCORE_UPDATE_INTERVAL
		calculate_score()
		emit_signal("score_changed", score)

func calculate_score() -> void:
	var s = 0
	s += (level - 1) * LEVEL_BONUS
	s += coins * COIN_BONUS
	s += lives * LIVES_BONUS
	s -= int(elapsed_time * TIME_PENALTY)
	score = max(0, s)
	return

func start_game():
	lives = LIVES_START
	level = LEVEL_START
	state = State.PLAYING
	is_timing = true
	elapsed_time = 0.0
	emit_signal("lives_changed", lives)
	emit_signal("level_changed", level)
	emit_signal("score_changed", score)
	emit_signal("coins_changed", coins)

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
		mouse.respawn(OFFSET_PER_LEVEL[level])
	
func player_reached_goal():
	if state != State.PLAYING:
		return
	
	level += 1
	emit_signal("level_changed", level)
	
	if level > LEVELS_AVAILABLE:
		state = State.WIN
		level -= 1 # set level to last achieved one
		go_to_menu()
	else:
		get_tree().change_scene_to_file("res://scenes/levels/%d.tscn" % level)
		mouse.respawn(OFFSET_PER_LEVEL[level])

func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/ui/mainScreen.tscn")

func register_mouse(m: Mouse1):
	mouse = m
	
func add_life():
	lives += 1
	emit_signal("lives_changed", lives)

func collect_coin():
	coins += 1
	emit_signal("coins_changed", coins)
