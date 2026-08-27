extends Control
## Shown when the player crashes into a rock or falls off the world.
## Displays the run's final score and offers Retry / Main Menu. A short
## "shatter" animation plays first so the failure state is legible before
## menu input is accepted (also guards against an accidental extra tap
## from the same touch that caused the crash from re-triggering a button).

@onready var panel: PanelContainer = $CenterContainer/Panel
@onready var title_label: Label = $CenterContainer/Panel/VBox/Title
@onready var score_label: Label = $CenterContainer/Panel/VBox/ScoreLabel
@onready var retry_button: Button = $CenterContainer/Panel/VBox/RetryButton
@onready var menu_button: Button = $CenterContainer/Panel/VBox/MenuButton

func _ready() -> void:
	panel.add_theme_stylebox_override("panel", UITheme.glass_panel())
	UITheme.style_title(title_label, 44)
	UITheme.style_primary_button(retry_button)
	UITheme.style_secondary_button(menu_button)

	score_label.text = "Score: %d" % GameManager.score
	retry_button.disabled = true
	menu_button.disabled = true

	modulate.a = 0.0
	scale = Vector2(0.85, 0.85)
	# Tween inherits this node's PROCESS_MODE_ALWAYS (set by Game.gd), so it
	# keeps animating even while get_tree().paused == true.
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.35)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(_enable_buttons)

	retry_button.pressed.connect(_on_retry)
	menu_button.pressed.connect(_on_menu)

func _enable_buttons() -> void:
	retry_button.disabled = false
	menu_button.disabled = false

func _on_retry() -> void:
	SoundManager.play_sfx("button")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu() -> void:
	SoundManager.play_sfx("button")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
