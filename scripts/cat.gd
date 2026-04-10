extends Area2D

@export_enum("orange", "grey", "white") var variant: String

var speed := 100.0
var direction := Vector2.RIGHT
var width := 0
var size: Vector2


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func setup(spd: float, dir: Vector2, var_name: String = "white"):
	speed = spd
	direction = dir
	variant = var_name
	update_animation()

func _ready():
	width = get_viewport_rect().size.x
	var frames = $AnimatedSprite2D.sprite_frames
	size = frames.get_frame_texture("walk_right", 0).get_size()
	update_animation()

func _process(delta):
	position += direction * speed * delta
	
	if position.x > width + size.x:
		position.x = -(size.x/2.0)

func update_animation():
	var suffix = ""
	if variant == "grey":
		suffix = "_grey"
	elif variant == "white":
		suffix = "_white"

	if direction.x != 0:
		sprite.play("walk_right" + suffix)
		sprite.flip_h = direction.x < 0
		sprite.flip_v = false
	else:
		sprite.play("walk_down" + suffix)
		sprite.flip_h = false
		sprite.flip_v = direction.y < 0
	
#cat in	main dann erzeugen 
#var cat1 = cat_scene.instantiate()
#cat1.setup(100.0, Vector2.RIGHT, "brown")
