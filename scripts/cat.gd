class_name Cat
extends Area2D

@export_enum("brown", "black", "white") var variant: String = "white"

var speed := 100.0
var direction := Vector2.RIGHT
var viewport_size : Vector2
var size: Vector2


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func setup(spd: float, dir: Vector2, var_name: String):
	speed = spd
	direction = dir
	variant = var_name
	update_animation()

func _ready():
	add_to_group("cat")
	viewport_size = get_viewport_rect().size
	var frames = $AnimatedSprite2D.sprite_frames
	size = frames.get_frame_texture("walk_right_white", 0).get_size()
	update_animation()

func _process(delta):
	position += direction * speed * delta
	
	if position.x > viewport_size.x + (size.x*2) && direction == Vector2.RIGHT:
		position.x = -(size.x/2.0)
	elif position.x < 0 && direction == Vector2.LEFT:
		position.x = viewport_size.x + size.x
	
	if position.y > viewport_size.y + size.y && direction == Vector2.DOWN:
		position.y = -size.y
	elif position.y < -size.y && direction == Vector2.UP:
		position.y = viewport_size.y + size.y

func update_animation():
	var suffix = ""
	if variant == "brown":
		suffix = "_brown"
	elif variant == "white":
		suffix = "_white"
	elif variant == "black":
		suffix = "_black"
	
	if direction == Vector2.RIGHT:
		sprite.play("walk_right" + suffix)
		#sprite.flip_h = direction.x < 0
		#sprite.flip_v = false
	elif direction == Vector2.LEFT:
		sprite.play("walk_left" + suffix)
	elif direction == Vector2.DOWN:
		sprite.play("walk_down" + suffix)
	else:
		sprite.play("walk_down" + suffix)
		sprite.flip_h = false
		sprite.flip_v = direction.y < 0
	
#cat in	main dann erzeugen 
#var cat1 = cat_scene.instantiate()
#cat1.setup(100.0, Vector2.RIGHT, "brown")
