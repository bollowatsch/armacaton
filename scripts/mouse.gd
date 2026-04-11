class_name Mouse1
extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var width: float
var height: float
var sprite_size: Vector2

const TILE_SIZE = 16
const MOVE_DELAY_START = 0.15
const MOVE_DELAY_MIN = 0.05      # maximale Geschwindigkeit
const SPEED_INCREASE = 0.005     # pro Bewegung schneller

var move_delay: float = MOVE_DELAY_START
var move_timer: float = 0.0
var first_move: bool = true

# Smooth movement
var target_position: Vector2
var is_moving: bool = false
const MOVE_SPEED: float = 300.0  # Pixel pro Sekunde

func _ready():
	add_to_group("mouse")
	sprite.play("walk_up")
	add_to_group("mouse")
	area_entered.connect(_on_area_entered)
	
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	
	GameManager.register_mouse(self)
	
	var frames = $AnimatedSprite2D.sprite_frames
	sprite_size = frames.get_frame_texture("waits", 0).get_size()

func _process(delta: float) -> void:
	# Smooth movement — zuerst zum Ziel gleiten
	if is_moving:
		position = position.move_toward(target_position, MOVE_SPEED * delta)
		if position == target_position:
			is_moving = false
		return  # kein neuer Input während Bewegung
	
	# Frisch gedrückte Taste hat Priorität
	var just_pressed = get_just_pressed_vector()
	if just_pressed != Vector2.ZERO:
		var direction = SwitchManager.get_mapped_direction(just_pressed)
		move(direction)
		move_timer = move_delay
		return
	
	# Gehaltene Taste
	move_timer -= delta
	if move_timer > 0:
		return
	
	var held = get_held_vector()
	if held == Vector2.ZERO:
		first_move = true
		move_timer = 0.0
		return
	
	if first_move or move_timer <= 0:
		var direction = SwitchManager.get_mapped_direction(held)
		move(direction)
		move_timer = move_delay
		first_move = false

func move(dir: Vector2):
	var new_target = target_position + dir * TILE_SIZE
	
	if new_target.x < sprite_size.x / 2 or new_target.x + sprite_size.x / 2 > width:
		return
	if new_target.y > height - sprite_size.y / 2:
		return
	if new_target.y <= 0:
		GameManager.player_reached_goal()
		return
	
	target_position = new_target
	is_moving = true
	
	# Mit jeder Bewegung schneller werden
	move_delay = max(MOVE_DELAY_MIN, move_delay - SPEED_INCREASE)

func respawn(offset: Vector2 = Vector2.ZERO):
	position = Vector2(width / 2, height - sprite_size.y / 2) + offset
	target_position = position
	is_moving = false
	first_move = true
	move_timer = 0.0
	move_delay = MOVE_DELAY_START  # Geschwindigkeit zurücksetzen
	play_walk()

func get_just_pressed_vector() -> Vector2:
	if Input.is_action_just_pressed("ui_up"):    return Vector2.UP
	if Input.is_action_just_pressed("ui_down"):  return Vector2.DOWN
	if Input.is_action_just_pressed("ui_left"):  return Vector2.LEFT
	if Input.is_action_just_pressed("ui_right"): return Vector2.RIGHT
	return Vector2.ZERO

func get_held_vector() -> Vector2:
	if Input.is_action_pressed("ui_up"):    return Vector2.UP
	if Input.is_action_pressed("ui_down"):  return Vector2.DOWN
	if Input.is_action_pressed("ui_left"):  return Vector2.LEFT
	if Input.is_action_pressed("ui_right"): return Vector2.RIGHT
	return Vector2.ZERO

func _on_area_entered(area: Area2D):
	if area.is_in_group("cat"):
		audio.play()
		GameManager.player_died()

func play_walk():
	if sprite.animation != "walk_up":
		sprite.play("walk_up")

func play_idle():
	if sprite.animation != "idle":
		sprite.play("idle")

func play_dead():
	sprite.play("dies_up")
