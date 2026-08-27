extends Camera2D
## Follows the player: locked X offset (player stays left-of-center like
## Alto's Adventure so incoming terrain/obstacles are visible), smoothed Y.

@export var target_path: NodePath
@export var x_offset: float = -260.0
@export var y_smooth_speed: float = 4.0

var target: Node2D

func _ready() -> void:
	if target_path != NodePath():
		target = get_node(target_path)
	position_smoothing_enabled = false

func set_target(node: Node2D) -> void:
	target = node

func _physics_process(delta: float) -> void:
	if target == null:
		return
	global_position.x = target.global_position.x - x_offset
	global_position.y = lerp(global_position.y, target.global_position.y, clamp(y_smooth_speed * delta, 0.0, 1.0))
