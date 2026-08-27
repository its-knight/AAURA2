extends Control
## Main menu: title with a soft pulsing glow, Start / Levels / Settings /
## High Scores / Exit (with confirmation). Built with the shared glass
## panel + gold/purple button styling from UITheme.

@onready var background: TextureRect = $Background
@onready var title_label: Label = $VBox/Title
@onready var start_button: Button = $VBox/Panel/ButtonList/StartButton
@onready var levels_button: Button = $VBox/Panel/ButtonList/LevelsButton
@onready var settings_button: Button = $VBox/Panel/ButtonList/SettingsButton
@onready var scores_button: Button = $VBox/Panel/ButtonList/ScoresButton
@onready var exit_button: Button = $VBox/Panel/ButtonList/ExitButton
@onready var panel: PanelContainer = $VBox/Panel
@onready var exit_dialog: ConfirmationDialog = $ExitDialog

func _ready() -> void:
	background.texture = UITheme.background_gradient()
	panel.add_theme_stylebox_override("panel", UITheme.glass_panel())
	UITheme.style_title(title_label, 96)

	UITheme.style_primary_button(start_button)
	UITheme.style_secondary_button(levels_button)
	UITheme.style_secondary_button(settings_button)
	UITheme.style_secondary_button(scores_button)
	UITheme.style_secondary_button(exit_button)

	start_button.pressed.connect(_on_start)
	levels_button.pressed.connect(_on_levels)
	settings_button.pressed.connect(_on_settings)
	scores_button.pressed.connect(_on_scores)
	exit_button.pressed.connect(_on_exit)
	exit_dialog.confirmed.connect(_on_exit_confirmed)

	_pulse_title()
	SoundManager.play_music()

func _pulse_title() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(title_label, "modulate:a", 0.7, 1.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title_label, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_SINE)

func _on_start() -> void:
	SoundManager.play_sfx("button")
	LevelManager.set_current_level(SaveManager.get_unlocked_level())
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_levels() -> void:
	SoundManager.play_sfx("button")
	get_tree().change_scene_to_file("res://scenes/LevelSelect.tscn")

func _on_settings() -> void:
	SoundManager.play_sfx("button")
	get_tree().change_scene_to_file("res://scenes/Settings.tscn")

func _on_scores() -> void:
	SoundManager.play_sfx("button")
	get_tree().change_scene_to_file("res://scenes/HighScores.tscn")

func _on_exit() -> void:
	SoundManager.play_sfx("button")
	exit_dialog.popup_centered()

func _on_exit_confirmed() -> void:
	get_tree().quit()
