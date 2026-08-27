extends Node
## GameManager (Singleton)
## Owns the state of the CURRENT run: score, coins collected, combo streak,
## pause/game-over flags. Scenes read/write this instead of passing values
## around the tree. Reset at the start of every level attempt.

signal score_changed(new_score: int)
signal coins_changed(new_coin_count: int)
signal game_over
signal level_finished

var score: int = 0
var coins_collected: int = 0
var combo: int = 0
var distance_traveled: float = 0.0
var is_paused: bool = false
var is_game_over: bool = false
var is_level_complete: bool = false

const COMBO_BONUS_PER_JUMP := 5
const COIN_SCORE := 10

func reset_run() -> void:
	score = 0
	coins_collected = 0
	combo = 0
	distance_traveled = 0.0
	is_paused = false
	is_game_over = false
	is_level_complete = false
	emit_signal("score_changed", score)
	emit_signal("coins_changed", coins_collected)

func add_coin() -> void:
	coins_collected += 1
	add_score(COIN_SCORE)
	emit_signal("coins_changed", coins_collected)

func add_score(amount: int) -> void:
	score += amount
	emit_signal("score_changed", score)

func register_jump_combo() -> void:
	combo += 1
	if combo > 1:
		add_score(COMBO_BONUS_PER_JUMP * combo)

func reset_combo() -> void:
	combo = 0

func add_distance_score(delta_distance: float, speed_ratio: float) -> void:
	# Faster travel => more points per pixel traveled.
	distance_traveled += delta_distance
	var bonus := int(delta_distance * 0.05 * (1.0 + speed_ratio))
	if bonus > 0:
		add_score(bonus)

func trigger_game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	SoundManager.play_sfx("crash")
	emit_signal("game_over")

func trigger_level_complete() -> void:
	if is_level_complete:
		return
	is_level_complete = true
	SoundManager.play_sfx("level_complete")
	emit_signal("level_finished")

func compute_stars(level_number: int) -> int:
	var max_score: int = LevelManager.max_possible_score(level_number)
	if max_score <= 0:
		return 1
	var ratio: float = float(score) / float(max_score)
	if ratio >= 0.8:
		return 3
	elif ratio >= 0.5:
		return 2
	else:
		return 1
