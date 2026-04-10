extends Area2D
# extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Rastergröße: Spieler springt immer um genau 1 Tile
const TILE_SIZE = 8

# Verhindert mehrfaches Drücken pro Frame
var can_move = true

func _ready():
	sprite.play("walk")
	
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
	var input_vector = SwitchManager.input_event_to_vector2(event)
	var direction = SwitchManager.get_mapped_direction(input_vector)
	
	if direction != Vector2.ZERO:
		move(direction)

func move(dir: Vector2):
	var target = position + dir * TILE_SIZE
	
	# Spielfeldgrenzen prüfen (Spielfeld: 10x8 Tiles)
	if target.x < 0 or target.x > 9 * TILE_SIZE:
		return
	if target.y < 0 or target.y > 7 * TILE_SIZE:
		return
	
	can_move = false
	position = target
	
	# Kurze Pause damit man nicht zu schnell drücken kann
	await get_tree().create_timer(0.1).timeout
	can_move = true
	
	# Ziel erreicht?
	if position.y == 0:
		pass
		#GameManager.win() todo
