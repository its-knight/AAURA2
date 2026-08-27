extends Area2D
## A collectible coin. Bobs gently and spins for visual polish, awards score
## and is released back to the pool on pickup (never freed/instantiated at runtime).

signal collected(coin: Area2D)

@onready var visual: Polygon2D = $Visual
var _time_offset: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_time_offset = randf() * TAU

func set_pool_active(active: bool) -> void:
	if active:
		_time_offset = randf() * TAU

func _process(delta: float) -> void:
	_time_offset += delta * 4.0
	visual.position.y = sin(_time_offset) * 4.0
	visual.rotation = _time_offset * 0.5

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		GameManager.add_coin()
		SoundManager.play_sfx("coin")
		emit_signal("collected", self)
