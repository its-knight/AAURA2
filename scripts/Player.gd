extends CharacterBody2D
## Aura - the player character. Auto-runs to the right; tap to jump (double
## jump available in-air); hold to boost. Emits signals the Game/HUD/GameManager
## react to (landed, jumped, crashed).

signal jumped
signal landed
signal crashed

@export var base_run_speed: float = 320.0
@export var boost_multiplier: float = 1.55
@export var jump_velocity: float = -720.0
@export var gravity: float = 1800.0
@export var max_fall_speed: float = 1400.0

var run_speed: float = 320.0
var is_boosting: bool = false
var jumps_used: int = 0
const MAX_JUMPS := 2

var _was_on_floor := true
var _trail_points: Array[Vector2] = []
const TRAIL_MAX_POINTS := 18

@onready var trail: Line2D = $Trail
@onready var sprite: Polygon2D = $Body
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	run_speed = base_run_speed
	trail.clear_points()

func configure(cfg: Dictionary) -> void:
	run_speed = cfg.get("base_speed", base_run_speed)

func _physics_process(delta: float) -> void:
	if GameManager.is_paused or GameManager.is_game_over or GameManager.is_level_complete:
		return

	# --- Horizontal auto-run ---
	var target_speed: float = run_speed * (boost_multiplier if is_boosting else 1.0)
	velocity.x = target_speed

	# --- Gravity ---
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)

	move_and_slide()

	# --- Landing / falling detection ---
	if is_on_floor():
		if not _was_on_floor:
			emit_signal("landed")
		jumps_used = 0
	_was_on_floor = is_on_floor()

	# --- Fell off the world (missed a gap) ---
	if global_position.y > 2000:
		emit_signal("crashed")

	_update_trail()

func try_jump() -> void:
	if GameManager.is_paused or GameManager.is_game_over or GameManager.is_level_complete:
		return
	if jumps_used < MAX_JUMPS:
		var sensitivity: float = SaveManager.get_setting("jump_sensitivity")
		velocity.y = jump_velocity * sensitivity
		jumps_used += 1
		GameManager.register_jump_combo()
		SoundManager.play_sfx("jump")
		emit_signal("jumped")

func set_boosting(value: bool) -> void:
	is_boosting = value

func hit_obstacle() -> void:
	emit_signal("crashed")

func _update_trail() -> void:
	_trail_points.append(global_position)
	if _trail_points.size() > TRAIL_MAX_POINTS:
		_trail_points.pop_front()
	trail.clear_points()
	for p in _trail_points:
		trail.add_point(trail.to_local(p))
