extends ColorRect
## Smoothly shifts the sky from day colors to night colors as the player
## progresses through the level (0.0 = start/day, 1.0 = finish/night).
## Implemented as two overlaid ColorRects (Top/Bottom children) whose colors
## are lerped -- cheap and shader-free, so it's safe on low-end devices.

const DAY_TOP := Color(0.176, 0.451, 0.71)
const DAY_BOTTOM := Color(0.71, 0.85, 0.95)
const NIGHT_TOP := Color(0.063, 0.063, 0.145)
const NIGHT_BOTTOM := Color(0.176, 0.161, 0.32)

func set_progress(t: float) -> void:
	t = clamp(t, 0.0, 1.0)
	if has_node("Top"):
		$Top.color = DAY_TOP.lerp(NIGHT_TOP, t)
	if has_node("Bottom"):
		$Bottom.color = DAY_BOTTOM.lerp(NIGHT_BOTTOM, t)
