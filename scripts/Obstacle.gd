extends Area2D
class_name Obstacle
## A rock obstacle. Comes in 3 sizes (small/medium/large) driven by scale,
## set by the spawner when it's pulled from the pool.

enum Size { SMALL, MEDIUM, LARGE }

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var visual: Polygon2D = $Visual

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func set_pool_active(_active: bool) -> void:
	pass # nothing extra to reset; position/size are set by the spawner each reuse

func configure(size: Size) -> void:
	var scale_amount: float
	match size:
		Size.SMALL:
			scale_amount = 0.7
		Size.MEDIUM:
			scale_amount = 1.0
		Size.LARGE:
			scale_amount = 1.4
		_:
			scale_amount = 1.0
	visual.scale = Vector2(scale_amount, scale_amount)
	shape.scale = Vector2(scale_amount, scale_amount)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.hit_obstacle()
