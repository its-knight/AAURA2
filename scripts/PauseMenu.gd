extends Control
## Pause overlay: Resume / Restart / Menu. Uses PROCESS_MODE_ALWAYS so its
## buttons keep working while get_tree().paused == true.

@onready var panel: PanelContainer = $CenterContainer/Panel
@onready var resume_button: Button = $CenterContainer/Panel/VBox/ResumeButton
@onready var restart_button: Button = $CenterContainer/Panel/VBox/RestartButton
@onready var menu_button: Button = $CenterContainer/Panel/VBox/MenuButton
@onready var title_label: Label = $CenterContainer/Panel/VBox/Title

func _ready() -> void:
	panel.add_theme_stylebox_override("panel", UITheme.glass_panel())
	UITheme.style_title(title_label, 40)
	UITheme.style_primary_button(resume_button)
	UITheme.style_secondary_button(restart_button)
	UITheme.style_secondary_button(menu_button)

	resume_button.pressed.connect(_on_resume)
	restart_button.pressed.connect(_on_restart)
	menu_button.pressed.connect(_on_menu)

func _on_resume() -> void:
	SoundManager.play_sfx("button")
	var game := get_tree().current_scene
	if game and game.has_method("toggle_pause"):
		game.toggle_pause()

func _on_restart() -> void:
	SoundManager.play_sfx("button")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu() -> void:
	SoundManager.play_sfx("button")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
