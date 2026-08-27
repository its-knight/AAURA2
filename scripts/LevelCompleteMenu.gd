extends Control
## Shown when the player reaches the finish line. Displays score, coins
## collected, star rating (1-3, filled progressively with a little pop
## animation), and lets the player advance to the next level or replay.

@onready var panel: PanelContainer = $CenterContainer/Panel
@onready var title_label: Label = $CenterContainer/Panel/VBox/Title
@onready var score_label: Label = $CenterContainer/Panel/VBox/ScoreLabel
@onready var coin_label: Label = $CenterContainer/Panel/VBox/CoinLabel
@onready var stars_row: HBoxContainer = $CenterContainer/Panel/VBox/StarsRow
@onready var next_button: Button = $CenterContainer/Panel/VBox/Buttons/NextButton
@onready var replay_button: Button = $CenterContainer/Panel/VBox/Buttons/ReplayButton

var _level_number: int = 1

func _ready() -> void:
	panel.add_theme_stylebox_override("panel", UITheme.glass_panel())
	UITheme.style_title(title_label, 40)
	UITheme.style_primary_button(next_button)
	UITheme.style_secondary_button(replay_button)
	next_button.pressed.connect(_on_next)
	replay_button.pressed.connect(_on_replay)

func bind(score: int, coins: int, stars: int, level_number: int) -> void:
	_level_number = level_number
	score_label.text = "Score: %d" % score
	coin_label.text = "Coins: %d / %d" % [coins, LevelManager.COINS_PER_LEVEL]
	_animate_stars(stars)
	next_button.disabled = level_number >= LevelManager.LEVEL_COUNT
	next_button.text = "Next Level" if level_number < LevelManager.LEVEL_COUNT else "All Done!"

func _animate_stars(stars: int) -> void:
	for i in range(stars_row.get_child_count()):
		var star: Label = stars_row.get_child(i)
		star.text = "★"
		star.modulate = Color(1, 1, 1, 0.25)
		if i < stars:
			var tween := create_tween()
			tween.tween_interval(0.15 * i)
			tween.tween_property(star, "modulate", UITheme.COLOR_GOLD, 0.25)
			tween.parallel().tween_property(star, "scale", Vector2(1.3, 1.3), 0.15)
			tween.tween_property(star, "scale", Vector2.ONE, 0.15)

func _on_next() -> void:
	SoundManager.play_sfx("button")
	LevelManager.set_current_level(_level_number + 1)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_replay() -> void:
	SoundManager.play_sfx("button")
	get_tree().paused = false
	get_tree().reload_current_scene()
