extends CharacterBody2D

signal health_depleted

const MAX_HEALTH: float = 100.0
var health: float = MAX_HEALTH

const DAMAGE_RATE: float = 50.0

func _ready() -> void:
	%ProgressBar.max_value = MAX_HEALTH
	%ProgressBar.value = health

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 800.0
	move_and_slide()

	if direction != Vector2.ZERO:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()

	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		health = max(health, 0.0)

		%ProgressBar.value = health

		if health <= 0.0:
			health_depleted.emit()
