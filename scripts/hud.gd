extends CanvasLayer

@onready var level_label: Label = $HBoxContainer/LevelLabel
@onready var lives_label: Label = $HBoxContainer/LivesLabel
@onready var switch_timer: ProgressBar = $HBoxContainer/SwitchTimer
@onready var score_label: Label = $HBoxContainer/ScoreLabel
@onready var timer_label: Label = $HBoxContainer/SwitchTimer/TimerLabel

func _ready():
	add_to_group("hud")
	
	GameManager.lives_changed.connect(update_lives)
	GameManager.level_changed.connect(update_level)
	GameManager.score_changed.connect(update_score)

	
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

func update_timer(time_remaining: float):
	switch_timer.value = time_remaining
	switch_timer.max_value = SwitchManager.last_time_until_switch
	switch_timer.min_value = 0.0
	timer_label.text = "%d s" % int(ceil(time_remaining))
	
func update_score(new_score: int):
	score_label.text = "Score: %d" % new_score
