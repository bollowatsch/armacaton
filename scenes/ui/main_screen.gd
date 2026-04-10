extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
