extends Node
## LevelManager (Singleton)
## Holds the data-driven definition of all 5 levels: length, obstacle density,
## base speed, and coin count. Gameplay scripts read from here instead of
## hard-coding numbers, so difficulty tuning happens in one place.

const LEVEL_COUNT := 5
const COINS_PER_LEVEL := 50

# level_length: total horizontal distance (px) to reach the finish line
# obstacle_count: number of rocks spawned along the level
# base_speed: starting auto-run speed (px/s)
# max_speed: speed reached near the end of the level (via boost / ramps)
# obstacle_gap_min/max: min/max horizontal gap between obstacles (px)
var levels := [
	{ "id": 1, "length": 3000.0, "obstacle_count": 10, "base_speed": 320.0, "max_speed": 460.0, "gap_min": 260.0, "gap_max": 420.0 },
	{ "id": 2, "length": 3800.0, "obstacle_count": 16, "base_speed": 360.0, "max_speed": 520.0, "gap_min": 230.0, "gap_max": 380.0 },
	{ "id": 3, "length": 4600.0, "obstacle_count": 22, "base_speed": 400.0, "max_speed": 580.0, "gap_min": 210.0, "gap_max": 350.0 },
	{ "id": 4, "length": 5400.0, "obstacle_count": 28, "base_speed": 440.0, "max_speed": 640.0, "gap_min": 190.0, "gap_max": 320.0 },
	{ "id": 5, "length": 6200.0, "obstacle_count": 36, "base_speed": 480.0, "max_speed": 720.0, "gap_min": 170.0, "gap_max": 300.0 },
]

var current_level_index: int = 0 # 0-based; level 1 == index 0

func get_level_config(level_number: int) -> Dictionary:
	var idx: int = clamp(level_number - 1, 0, levels.size() - 1)
	return levels[idx]

func get_current_config() -> Dictionary:
	return levels[current_level_index]

func set_current_level(level_number: int) -> void:
	current_level_index = clamp(level_number - 1, 0, levels.size() - 1)

func get_current_level_number() -> int:
	return current_level_index + 1

func max_possible_score(level_number: int) -> int:
	# Used to compute star rating: coins (10 pts each) + a generous speed/combo estimate.
	var cfg := get_level_config(level_number)
	var coin_points: int = COINS_PER_LEVEL * 10
	var distance_points: int = int(cfg["length"] / 10.0) # rough speed-bonus ceiling
	return coin_points + distance_points
