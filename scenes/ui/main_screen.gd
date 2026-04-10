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
			label = 'YOU DIED'
		GameManager.State.WIN:
			label = 'YOU WON'
	
	$Screen/conditionalLabel.text = label
	
func _set_speeds():
	LaneManager.set_speed_for_lane($Lanes/Lane3, 200.0)
	LaneManager.set_speed_for_lane($Lanes/Lane2, 200.0)
