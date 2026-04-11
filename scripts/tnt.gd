extends Area2D

func _ready():
	$AnimatedSprite2D.play("default")
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	if body.is_in_group("mouse"):
		reduce_lives()

func _on_area_entered(area):
	if area.is_in_group("mouse"):
		reduce_lives()

func reduce_lives():
	GameManager.reduce_life()
	queue_free()
