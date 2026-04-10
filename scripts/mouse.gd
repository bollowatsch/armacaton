extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite.play("walk")

func play_walk():
	if sprite.animation != "walk":
		sprite.play("walk")

func play_idle():
	if sprite.animation != "idle":
		sprite.play("idle")

func play_dead():
	sprite.play("dead")
