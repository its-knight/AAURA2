extends Control
## Settings: music volume, sfx volume, jump sensitivity sliders, and a
## light/dark theme toggle. All values are read from / written straight
## to SaveManager so they persist and apply immediately (SoundManager
## re-reads volumes on every change).

@onready var background: TextureRect = $Background
@onready var panel: PanelContainer = $VBox/Panel
@onready var title_label: Label = $VBox/Title
@onready var music_slider: HSlider = $VBox/Panel/VBox/MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $VBox/Panel/VBox/SfxRow/SfxSlider
@onready var jump_slider: HSlider = $VBox/Panel/VBox/JumpRow/JumpSlider
@onready var theme_toggle: CheckButton = $VBox/Panel/VBox/ThemeRow/ThemeToggle
@onready var back_button: Button = $VBox/BackButton

func _ready() -> void:
	background.texture = UITheme.background_gradient()
	panel.add_theme_stylebox_override("panel", UITheme.glass_panel())
	UITheme.style_title(title_label, 44)
	UITheme.style_secondary_button(back_button)
	back_button.pressed.connect(_on_back)

	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.05
	music_slider.value = SaveManager.get_setting("music_volume")
	music_slider.value_changed.connect(_on_music_changed)

	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.step = 0.05
	sfx_slider.value = SaveManager.get_setting("sfx_volume")
	sfx_slider.value_changed.connect(_on_sfx_changed)

	jump_slider.min_value = 0.6
	jump_slider.max_value = 1.4
	jump_slider.step = 0.05
	jump_slider.value = SaveManager.get_setting("jump_sensitivity")
	jump_slider.value_changed.connect(_on_jump_changed)

	theme_toggle.button_pressed = SaveManager.get_setting("dark_theme")
	theme_toggle.toggled.connect(_on_theme_toggled)

func _on_music_changed(value: float) -> void:
	SoundManager.set_music_volume(value)

func _on_sfx_changed(value: float) -> void:
	SoundManager.set_sfx_volume(value)
	SoundManager.play_sfx("button")

func _on_jump_changed(value: float) -> void:
	SaveManager.set_setting("jump_sensitivity", value)

func _on_theme_toggled(pressed: bool) -> void:
	SaveManager.set_setting("dark_theme", pressed)
	# The whole UI is built from UITheme's fixed palette, so a full visual
	# re-skin is out of scope here; this flag is persisted for gameplay
	# scripts (e.g. a future light-mode background) to read.

func _on_back() -> void:
	SoundManager.play_sfx("button")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
