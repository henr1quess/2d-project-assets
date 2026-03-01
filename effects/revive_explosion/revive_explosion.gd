extends Area2D

const REVIVE_DAMAGE: int = 5


func _ready() -> void:
	# Dá dano em todos os inimigos próximos
	await get_tree().physics_frame
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(REVIVE_DAMAGE)

	# Efeito visual (reutiliza o smoke_explosion)
	const SMOKE_SCENE = preload("res://effects/smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_SCENE.instantiate()
	smoke.global_position = global_position
	get_parent().add_child(smoke)

	# Remove após o frame
	await get_tree().create_timer(0.1).timeout
	queue_free()
