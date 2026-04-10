extends Area2D
# extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Rastergröße: Spieler springt immer um genau 1 Tile
const TILE_SIZE = 8
var width: float 
var height: float 
var sprite_size: Vector2

var can_move = true

func _ready():
	sprite.play("walk")
	add_to_group("mouse")
	
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	
	var frames = $AnimatedSprite2D.sprite_frames
	sprite_size = frames.get_frame_texture("idle", 0).get_size()
	respawn()
	
func play_walk(): #todo: needs to be triggered via events
	if sprite.animation != "walk":
		sprite.play("walk")

func play_idle(): #todo: needs to be triggered via events
	if sprite.animation != "idle":
		sprite.play("idle")

func play_dead(): #todo: needs to be triggered via events
	sprite.play("dead")
	
func _unhandled_input(event):
	if not can_move:
		return
	
	# SwitchManager gibt die "echte" Richtung zurück
	# (nach Input-Remapping!)
	print(event)
	var input_vector = SwitchManager.input_event_to_vector2(event)
	var direction = SwitchManager.get_mapped_direction(input_vector)
	
	if direction != Vector2.ZERO:
		move(direction)

func move(dir: Vector2):
	var target = position + dir * TILE_SIZE
	
	# Check borders
	if target.x < 0 + sprite_size.x / 2 or target.x + sprite_size.x / 2 > width:
		print('position %s out of bounds' % [str(position)])
		return
	if target.y > height - sprite_size.y / 2:
		print('position %s out of bounds' % [str(position)])
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
