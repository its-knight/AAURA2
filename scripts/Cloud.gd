extends Node2D
## Soft drifting cloud, purely decorative. Drift speed is randomized slightly
## per-instance so a row of clouds doesn't look mechanically uniform.

var drift_speed: float = 8.0

func _ready() -> void:
	drift_speed = randf_range(4.0, 14.0)

func set_pool_active(_active: bool) -> void:
	pass

func _process(delta: float) -> void:
	position.x += drift_speed * delta
