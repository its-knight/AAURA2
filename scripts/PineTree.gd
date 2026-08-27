extends Node2D
## Decorative pine tree with a subtle wind-sway animation (no collision -
## purely visual, sits behind the player in the same layer as the terrain).

@onready var foliage: Polygon2D = $Foliage
var _sway_offset: float = 0.0

func _ready() -> void:
	_sway_offset = randf() * TAU

func set_pool_active(active: bool) -> void:
	if active:
		_sway_offset = randf() * TAU

func _process(delta: float) -> void:
	_sway_offset += delta
	foliage.skew = sin(_sway_offset * 0.8) * 0.04
