extends Control
## Level select: builds one card per level (from LevelManager.LEVEL_COUNT)
## showing its number, star rating and lock state. Cards for locked levels
## are visible but disabled, so progression is always legible at a glance.

@onready var background: TextureRect = $Background
@onready var card_row: HBoxContainer = $VBox/CardRow
@onready var back_button: Button = $VBox/BackButton
@onready var title_label: Label = $VBox/Title

const CARD_SCENE_TEMPLATE := preload("res://scenes/LevelCard.tscn")

func _ready() -> void:
	background.texture = UITheme.background_gradient()
	UITheme.style_title(title_label, 48)
	UITheme.style_secondary_button(back_button)
	back_button.pressed.connect(_on_back)
	_build_cards()

func _build_cards() -> void:
	var unlocked: int = SaveManager.get_unlocked_level()
	for i in range(1, LevelManager.LEVEL_COUNT + 1):
		var card := CARD_SCENE_TEMPLATE.instantiate()
		card_row.add_child(card)
		var is_unlocked: bool = i <= unlocked
		var stars: int = SaveManager.get_stars(i)
		var high_score: int = SaveManager.get_high_score(i)
		card.bind(i, stars, is_unlocked, high_score)
		card.level_selected.connect(_on_level_selected)

func _on_level_selected(level_number: int) -> void:
	SoundManager.play_sfx("button")
	LevelManager.set_current_level(level_number)
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_back() -> void:
	SoundManager.play_sfx("button")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
