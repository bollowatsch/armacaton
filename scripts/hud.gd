extends CanvasLayer

@onready var level_label: Label = $LevelLabel
@onready var lives_label: Label = $LivesLabel
@onready var switch_timer: ProgressBar = $SwitchTimer

func _ready():
	GameManager.lives_changed.connect(update_lives)
	GameManager.level_changed.connect(update_level)
	
	update_lives(GameManager.lives)
	update_level(GameManager.level)

func update_level(new_level: int):
	level_label.text = "Level: %d" % new_level

func update_lives(new_lives: int):
	lives_label.text = "Lives: %d" % new_lives
	if is_inside_tree():
		var tween = create_tween()
		tween.tween_property(lives_label, "modulate", Color.RED, 0.1)
		tween.tween_property(lives_label, "modulate", Color.WHITE, 0.3)

func update_timer(percent: float):
	switch_timer.value = percent
