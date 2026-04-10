extends Area2D
# extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var width: float 
var height: float 
var sprite_size: Vector2

const MOVE_DELAY = 0.15
var move_timer: float = 0.0
var first_move: bool = true

const TILE_SIZE = 16

var can_move = true

func _ready():
	sprite.play("walk_up")
	add_to_group("mouse")
	
	area_entered.connect(_on_area_entered)
	
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	
	var frames = $AnimatedSprite2D.sprite_frames
	sprite_size = frames.get_frame_texture("waits", 0).get_size()
	respawn()
	
func _process(delta: float) -> void:
	# Frisch gedrückte Taste hat Priorität — sofort reagieren
	var just_pressed = get_just_pressed_vector()
	if just_pressed != Vector2.ZERO:
		var direction = SwitchManager.get_mapped_direction(just_pressed)
		move(direction)
		move_timer = MOVE_DELAY
		return
	
	# Gehaltene Taste — nur nach Timer
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
		move_timer = MOVE_DELAY
		first_move = false

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
	
func play_walk(): #todo: needs to be triggered via events
	if sprite.animation != "walk_up":
		sprite.play("walk")

func play_idle(): #todo: needs to be triggered via events
	if sprite.animation != "idle":
		sprite.play("idle")

func play_dead(): #todo: needs to be triggered via events
	sprite.play("dead")
		
func move(dir: Vector2):
	var target = position + dir * TILE_SIZE
	
	# Check borders
	if target.x < 0 + sprite_size.x / 2 or target.x + sprite_size.x / 2 > width:
		print('position %s out of bounds' % [str(position)])
		return
	if target.y > height - sprite_size.y / 2:
		print('position %s out of bounds' % [str(position)])
		return
	if target.y <= 0:
		GameManager.player_reached_goal()
		return
	
	can_move = false
	position = target
	
	# Kurze Pause damit man nicht zu schnell drücken kann
	#await get_tree().create_timer(0.1).timeout
	can_move = true
	
	# Ziel erreicht?
	if position.y == 0:
		GameManager.player_reached_goal()

func respawn():	
	position = Vector2(
		width / 2,
		height - sprite_size.y / 2
	)

func _on_area_entered(area: Area2D):
	if area.is_in_group("cat"):
		GameManager.player_died()
