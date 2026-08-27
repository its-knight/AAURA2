extends Node
## SaveManager (Singleton)
## Handles all persistent data: unlocked levels, stars, high scores, and settings.
## Uses Godot's ConfigFile so no plugins/external DB are needed.

const SAVE_PATH := "user://aura_save.cfg"

var config := ConfigFile.new()

# Defaults --------------------------------------------------------------
const DEFAULT_SETTINGS := {
	"music_volume": 0.8,
	"sfx_volume": 1.0,
	"jump_sensitivity": 1.0,
	"dark_theme": true,
}

func _ready() -> void:
	load_data()

func load_data() -> void:
	var err := config.load(SAVE_PATH)
	if err != OK:
		# First run: create defaults
		for i in range(1, 6):
			set_high_score(i, 0)
			set_stars(i, 0)
		set_unlocked_level(1)
		for key in DEFAULT_SETTINGS.keys():
			config.set_value("settings", key, DEFAULT_SETTINGS[key])
		save_data()

func save_data() -> void:
	config.save(SAVE_PATH)

# High scores -------------------------------------------------------------
func get_high_score(level: int) -> int:
	return config.get_value("scores", "level_%d" % level, 0)

func set_high_score(level: int, score: int) -> void:
	var current: int = get_high_score(level)
	if score > current:
		config.set_value("scores", "level_%d" % level, score)
		save_data()

# Stars ---------------------------------------------------------------------
func get_stars(level: int) -> int:
	return config.get_value("stars", "level_%d" % level, 0)

func set_stars(level: int, stars: int) -> void:
	var current: int = get_stars(level)
	if stars > current:
		config.set_value("stars", "level_%d" % level, stars)
		save_data()

# Unlock progress -------------------------------------------------------------
func get_unlocked_level() -> int:
	return config.get_value("progress", "unlocked_level", 1)

func set_unlocked_level(level: int) -> void:
	var current: int = get_unlocked_level()
	if level > current:
		config.set_value("progress", "unlocked_level", level)
		save_data()

func unlock_next_level(current_level: int) -> void:
	set_unlocked_level(min(current_level + 1, 5))

# Settings ----------------------------------------------------------------
func get_setting(key: String):
	return config.get_value("settings", key, DEFAULT_SETTINGS.get(key))

func set_setting(key: String, value) -> void:
	config.set_value("settings", key, value)
	save_data()
