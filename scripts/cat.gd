extends Area2D

var speed := 100.0
var direction := Vector2.RIGHT
var width := 0
var size: Vector2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func setup(spd: float, dir: Vector2):
	speed = spd
	direction = dir
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
	if direction.x > 0:
		sprite.play("walk_right")
	else:
		sprite.play("walk_left")
