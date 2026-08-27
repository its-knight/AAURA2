extends Control
## In-game HUD: live score, coin counter, level progress bar, pause button.
## Reacts to GameManager signals for score/coins; the progress bar is updated
## once per frame by Game.gd via update_progress() since it needs player.x.

signal pause_pressed

@onready var score_label: Label = $Margin/VBox/TopRow/ScoreLabel
@onready var coin_label: Label = $Margin/VBox/TopRow/CoinLabel
@onready var level_label: Label = $Margin/VBox/TopRow/LevelLabel
@onready var progress_bar: ProgressBar = $Margin/VBox/ProgressBar
@onready var pause_button: Button = $PauseButton

var _level_length: float = 1.0

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.coins_changed.connect(_on_coins_changed)
	pause_button.pressed.connect(func(): emit_signal("pause_pressed"))
	UITheme.style_secondary_button(pause_button)
	_on_score_changed(GameManager.score)
	_on_coins_changed(GameManager.coins_collected)

func bind(level_number: int, level_length: float) -> void:
	_level_length = max(level_length, 1.0)
	level_label.text = "Level %d / 5" % level_number
	progress_bar.value = 0

func update_progress(player_x: float) -> void:
	progress_bar.value = clamp(player_x / _level_length, 0.0, 1.0) * 100.0

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_coins_changed(new_coins: int) -> void:
	coin_label.text = "Coins: %d / %d" % [new_coins, LevelManager.COINS_PER_LEVEL]
