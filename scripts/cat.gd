extends Area2D

var speed := 100.0
var direction := Vector2.RIGHT

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func setup(spd: float, dir: Vector2):
	speed = spd
	direction = dir
	update_animation()

func _ready():
	update_animation()

func _process(delta):
	position += direction * speed * delta

func update_animation():
	if direction.x > 0:
		sprite.play("walk_right")
	else:
		sprite.play("walk_left")
