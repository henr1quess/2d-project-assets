extends Area2D

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)


func shoot():
	const BULLET = preload("res://weapons/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	# Aplica dano do player (base + upgrade)
	var player_node = get_parent()
	if player_node.has_method("get_total_damage"):
		new_bullet.damage = player_node.get_total_damage()
	get_tree().current_scene.add_child(new_bullet)


func _on_timer_timeout() -> void:
	shoot()
