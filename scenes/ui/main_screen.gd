extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_speeds()
	
	var state = GameManager.state
	var label: String
	match state:
		GameManager.State.MENU:
			label = 'WELCOME'
		GameManager.State.DEAD:
			label = 'GAME OVER'
			$Screen/statisticsLabel.text = 'Score: %d' % GameManager.score
		GameManager.State.WIN:
			label = 'YOU WON'
			$Screen/statisticsLabel.text = 'Score %d' % GameManager.score

	
	$Screen/conditionalLabel.text = label

func _set_speeds():
	LaneManager.set_speed_for_lane($Lanes/Lane3, 200.0)
	LaneManager.set_speed_for_lane($Lanes/Lane2, 200.0)

func _on_highscores_button_pressed():
	GameManager.state = GameManager.State.MENU
	get_tree().change_scene_to_file("res://scenes/ui/highscores.tscn")
