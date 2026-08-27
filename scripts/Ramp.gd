extends Area2D
## Golden jump ramp. Launching off one gives a strong upward boost and a
## spark burst (drawn procedurally via a one-shot particle system).

@export var launch_velocity: float = -900.0

@onready var particles: CPUParticles2D = $Sparks

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func set_pool_active(_active: bool) -> void:
	particles.emitting = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("try_jump"):
		body.velocity.y = launch_velocity
		body.jumps_used = 0 # refresh double jump after a ramp launch
		particles.restart()
		particles.emitting = true
		SoundManager.play_sfx("ramp")
