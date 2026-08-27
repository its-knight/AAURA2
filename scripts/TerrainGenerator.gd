extends StaticBody2D
## Builds the wavy ground as a single collision polygon + visual mesh, generated
## once when a level loads (not per-frame, so there's no runtime allocation cost).
## The ground height follows a sum of two sine waves for a natural rolling-hills look.

@export var segment_width: float = 24.0
@export var base_height: float = 500.0
@export var amplitude_a: float = 55.0
@export var amplitude_b: float = 22.0
@export var wavelength_a: float = 900.0
@export var wavelength_b: float = 340.0

@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var visual: Polygon2D = $Visual
@onready var grass_line: Line2D = $GrassLine

var level_length: float = 3000.0

func height_at(x: float) -> float:
	var h := base_height
	h -= sin(x / wavelength_a) * amplitude_a
	h -= sin(x / wavelength_b + 1.3) * amplitude_b
	return h

func build(p_level_length: float) -> void:
	level_length = p_level_length
	var margin := 800.0 # extra ground before start & after finish
	var start_x := -margin
	var end_x := level_length + margin
	var points := PackedVector2Array()
	var grass_points := PackedVector2Array()

	var x := start_x
	while x <= end_x:
		var y := height_at(x)
		points.append(Vector2(x, y))
		grass_points.append(Vector2(x, y))
		x += segment_width

	# Close the polygon along the bottom so it has solid fill/collision.
	var bottom_y := base_height + 400.0
	var poly := points.duplicate()
	poly.append(Vector2(end_x, bottom_y))
	poly.append(Vector2(start_x, bottom_y))

	visual.polygon = poly
	collision.polygon = poly
	grass_line.points = grass_points

func get_ground_y(x: float) -> float:
	return height_at(x)
