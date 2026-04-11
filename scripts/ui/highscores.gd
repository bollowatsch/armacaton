extends Node2D

@onready var scores_container: VBoxContainer
@onready var new_score_panel: PanelContainer
@onready var your_score_label: Label
@onready var name_input: LineEdit
@onready var submit_button: Button
@onready var title_label: Label

var is_new_highscore: bool = false
var score_entry_labels: Array = []

func _ready() -> void:
	# Set up lanes for background animation
	if has_node("Lanes"):
		LaneManager.register_lanes($Lanes, Vector2.RIGHT)

	# Get references to UI nodes
	_setup_node_references()

	# Check if player just finished game and got a highscore
	var from_game_end = GameManager.state in [GameManager.State.WIN, GameManager.State.DEAD]

	if from_game_end and new_score_panel:
		var current_score = GameManager.score
		var highscores = GameManager.load_highscores()

		# Check if it's a new highscore (top 10 or better)
		is_new_highscore = _is_highscore(current_score, highscores)

		if is_new_highscore:
			new_score_panel.visible = true
			if your_score_label:
				your_score_label.text = "Your score: %d" % current_score
			if name_input:
				name_input.text = ""
				name_input.grab_focus()
			if submit_button:
				submit_button.pressed.connect(_on_submit_pressed)
		else:
			new_score_panel.visible = false
	elif new_score_panel:
		# Viewing from main menu, hide input panel
		new_score_panel.visible = false

	# Always display current highscores
	_display_highscores()

func _setup_node_references():
	# Try to get node references, handle if they don't exist yet
	if has_node("UI/ScoresContainer"):
		scores_container = $UI/ScoresContainer

	if has_node("UI/NewScorePanel"):
		new_score_panel = $UI/NewScorePanel

		# Try both with and without MarginContainer
		var vbox_path = "VBoxContainer"
		if new_score_panel.has_node("MarginContainer/VBoxContainer"):
			vbox_path = "MarginContainer/VBoxContainer"

		if new_score_panel.has_node(vbox_path + "/CongratsLabel"):
			var congrats_label = new_score_panel.get_node(vbox_path + "/CongratsLabel")
			congrats_label.text = "NEW HIGHSCORE!"
			congrats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		if new_score_panel.has_node(vbox_path + "/YourScoreLabel"):
			your_score_label = new_score_panel.get_node(vbox_path + "/YourScoreLabel")
			your_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		if new_score_panel.has_node(vbox_path + "/NameInput"):
			name_input = new_score_panel.get_node(vbox_path + "/NameInput")
			name_input.placeholder_text = "ABC"
			name_input.max_length = 3
			name_input.alignment = HORIZONTAL_ALIGNMENT_CENTER

		if new_score_panel.has_node(vbox_path + "/SubmitButton"):
			submit_button = new_score_panel.get_node(vbox_path + "/SubmitButton")
			submit_button.text = "Submit"

	if has_node("UI/titleLabel"):
		title_label = $UI/titleLabel
		title_label.text = "HIGH SCORES"
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	elif has_node("Screen/titleLabel"):
		title_label = $Screen/titleLabel
		title_label.text = "HIGH SCORES"
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _is_highscore(score: int, highscores: Array) -> bool:
	# True if score makes it into top 10
	if highscores.size() < 10:
		return true
	return score > highscores[9].score

func _display_highscores():
	if not scores_container:
		return

	var highscores = GameManager.load_highscores()

	# Get or create score entry children
	var num_entries = scores_container.get_child_count()

	for i in range(10):
		var entry: HBoxContainer

		# Get or create entry
		if i < num_entries:
			entry = scores_container.get_child(i)
		else:
			# Create new entry if it doesn't exist
			entry = _create_score_entry()
			scores_container.add_child(entry)

		# Update labels
		var rank_label = entry.get_node("RankLabel") as Label
		var name_label = entry.get_node("NameLabel") as Label
		var score_label = entry.get_node("ScoreLabel") as Label

		if i < highscores.size():
			rank_label.text = "%d." % (i + 1)
			name_label.text = highscores[i].name
			score_label.text = str(highscores[i].score)
		else:
			# Empty slot
			rank_label.text = "%d." % (i + 1)
			name_label.text = "---"
			score_label.text = "---"

func _create_score_entry() -> HBoxContainer:
	var entry = HBoxContainer.new()
	entry.add_theme_constant_override("separation", 20)

	# Rank label
	var rank_label = Label.new()
	rank_label.name = "RankLabel"
	rank_label.custom_minimum_size = Vector2(50, 30)
	rank_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	rank_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	entry.add_child(rank_label)

	# Name label
	var name_label = Label.new()
	name_label.name = "NameLabel"
	name_label.custom_minimum_size = Vector2(120, 30)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	entry.add_child(name_label)

	# Score label
	var score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.custom_minimum_size = Vector2(120, 30)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	score_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry.add_child(score_label)

	return entry

func _on_submit_pressed():
	var player_name = name_input.text.strip_edges().to_upper()

	if player_name.is_empty():
		player_name = "NAM" # Default name

	# Limit to 3 characters
	if player_name.length() > 3:
		player_name = player_name.substr(0, 3)

	# Save the highscore
	GameManager.save_highscore(player_name, GameManager.score)

	# Hide panel and refresh display
	new_score_panel.visible = false
	_display_highscores()

func _input(event):
	# Allow Enter key to submit
	if is_new_highscore and new_score_panel and new_score_panel.visible:
		if event.is_action_pressed("ui_accept"):
			_on_submit_pressed()
