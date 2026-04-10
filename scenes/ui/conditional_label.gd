class_name Conditional_label

extends Label

enum GameState { NEW_GAME, GAME_OVER }

func set_state(state: GameState):
	match state:
		GameState.NEW_GAME:
			text = "New Game"
		GameState.GAME_OVER:
			text = "Game Over"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(GameState.NEW_GAME)

	# Connect to GameManager (autoload)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
