extends PanelContainer
## A single level card used on the Level Select screen. Shows the level
## number, up to 3 stars (filled/empty), and either a Play button or a
## lock icon depending on unlock state.

signal level_selected(level_number: int)

@onready var number_label: Label = $VBox/NumberLabel
@onready var stars_row: HBoxContainer = $VBox/StarsRow
@onready var score_label: Label = $VBox/ScoreLabel
@onready var play_button: Button = $VBox/PlayButton
@onready var lock_label: Label = $VBox/LockLabel

var _level_number: int = 1

func _ready() -> void:
	add_theme_stylebox_override("panel", UITheme.glass_panel(20))
	UITheme.style_primary_button(play_button)
	play_button.pressed.connect(func(): emit_signal("level_selected", _level_number))

func bind(level_number: int, stars: int, unlocked: bool, high_score: int) -> void:
	_level_number = level_number
	number_label.text = "Level %d" % level_number
	score_label.text = "Best: %d" % high_score

	for i in range(stars_row.get_child_count()):
		var star: Label = stars_row.get_child(i)
		star.text = "★"
		star.modulate = UITheme.COLOR_GOLD if i < stars else Color(1, 1, 1, 0.25)

	play_button.visible = unlocked
	lock_label.visible = not unlocked
	score_label.visible = unlocked
	modulate = Color(1, 1, 1, 1) if unlocked else Color(1, 1, 1, 0.5)
