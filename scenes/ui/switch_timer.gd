extends ProgressBar

func _ready() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.8)
	add_theme_stylebox_override("background", style)
	
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color(0.698, 0.666, 0.674, 1.0)
	add_theme_stylebox_override("fill", fill_style)
