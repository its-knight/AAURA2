extends Control
## High Scores: a simple list of best score + stars per level, read straight
## from SaveManager. Purely informational (no interaction beyond Back).

@onready var background: TextureRect = $Background
@onready var panel: PanelContainer = $VBox/Panel
@onready var title_label: Label = $VBox/Title
@onready var list_box: VBoxContainer = $VBox/Panel/List
@onready var back_button: Button = $VBox/BackButton

func _ready() -> void:
	background.texture = UITheme.background_gradient()
	panel.add_theme_stylebox_override("panel", UITheme.glass_panel())
	UITheme.style_title(title_label, 44)
	UITheme.style_secondary_button(back_button)
	back_button.pressed.connect(_on_back)
	_build_list()

func _build_list() -> void:
	for i in range(1, LevelManager.LEVEL_COUNT + 1):
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 24)

		var name_label := Label.new()
		name_label.text = "Level %d" % i
		name_label.custom_minimum_size = Vector2(140, 0)
		name_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		name_label.add_theme_font_size_override("font_size", 22)
		row.add_child(name_label)

		var stars_label := Label.new()
		var stars: int = SaveManager.get_stars(i)
		stars_label.text = "★".repeat(stars) + "☆".repeat(3 - stars)
		stars_label.add_theme_color_override("font_color", UITheme.COLOR_GOLD)
		stars_label.add_theme_font_size_override("font_size", 22)
		stars_label.custom_minimum_size = Vector2(90, 0)
		row.add_child(stars_label)

		var score_label := Label.new()
		score_label.text = "Best: %d" % SaveManager.get_high_score(i)
		score_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.85))
		score_label.add_theme_font_size_override("font_size", 22)
		row.add_child(score_label)

		list_box.add_child(row)

func _on_back() -> void:
	SoundManager.play_sfx("button")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
