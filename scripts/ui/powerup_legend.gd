extends PanelContainer

# Powerup Definitionen
const POWERUPS = [
	{
		"name": "Cheese",
		"texture": "res://assets/Extras/swiss.png",
		"atlas_region": null,
		"description": "+1 Life"
	},
	{
		"name": "Milk",
		"texture": "res://assets/Extras/milk_1.png",
		"atlas_region": null,
		"description": "Speed Boost"
	},
	{
		"name": "Coin",
		"texture": "res://assets/Extras/coin2_20x20.png",
		"atlas_region": Rect2(0, 0, 20, 20),  # Nur erstes Frame vom Spritesheet
		"description": "Bonus Points"
	},
	{
		"name": "TNT",
		"texture": "res://assets/Extras/pixel_art.png",
		"atlas_region": null,
		"description": "-2 Lives"
	}
]

@export var icon_size: Vector2 = Vector2(40, 40)
@export var spacing: int = 12
@export var font_size: int = 18
@export var show_title: bool = true

var main_container: VBoxContainer

func _ready():
	# Setup Panel styling
	custom_minimum_size = Vector2(250, 0)

	# Margin Container für Padding
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	add_child(margin)

	# Main VBox Container
	main_container = VBoxContainer.new()
	main_container.add_theme_constant_override("separation", 8)
	margin.add_child(main_container)

	# Optional: Title
	if show_title:
		var title = Label.new()
		title.text = "POWERUPS"
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.add_theme_font_size_override("font_size", 20)
		main_container.add_child(title)

		# Spacer
		var spacer = Control.new()
		spacer.custom_minimum_size.y = 5
		main_container.add_child(spacer)

	_create_powerup_entries()

func _create_powerup_entries():
	for powerup in POWERUPS:
		var entry = _create_entry(powerup)
		main_container.add_child(entry)

		# Separator zwischen Einträgen (außer beim letzten)
		if powerup != POWERUPS[-1]:
			var spacer = Control.new()
			spacer.custom_minimum_size.y = spacing
			main_container.add_child(spacer)

func _create_entry(powerup: Dictionary) -> HBoxContainer:
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 15)

	# Icon Container (fixed size)
	var icon_container = Control.new()
	icon_container.custom_minimum_size = icon_size
	icon_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	hbox.add_child(icon_container)

	# Icon (TextureRect)
	var icon = TextureRect.new()
	icon.custom_minimum_size = icon_size
	icon.size = icon_size
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Versuche Texture zu laden
	if ResourceLoader.exists(powerup.texture):
		var tex = load(powerup.texture)

		# Wenn Atlas Region angegeben, nutze nur diesen Teil
		if powerup.has("atlas_region") and powerup.atlas_region != null:
			var atlas = AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = powerup.atlas_region
			icon.texture = atlas
		else:
			icon.texture = tex

		icon_container.add_child(icon)
	else:
		# Fallback: Colored Panel wenn Texture nicht existiert
		var panel = Panel.new()
		panel.custom_minimum_size = icon_size
		icon_container.add_child(panel)

		# Debug: Zeige dass Texture fehlt
		var debug_label = Label.new()
		debug_label.text = "?"
		debug_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		debug_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		panel.add_child(debug_label)

	# Description Label
	var label = Label.new()
	label.text = powerup.description
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Optional: Font Size anpassen
	if font_size > 0:
		label.add_theme_font_size_override("font_size", font_size)

	hbox.add_child(label)

	return hbox
