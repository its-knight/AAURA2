extends Node
## Boot scene. Autoloads (SaveManager, SoundManager, LevelManager,
## GameManager) are already initialized by the time _ready() runs, so this
## just hands off to the main menu. Kept as its own tiny scene rather than
## making MainMenu the run/main_scene so a splash/loading step can be
## inserted here later without touching the menu itself.

func _ready() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
