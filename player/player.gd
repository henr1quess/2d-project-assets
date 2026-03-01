extends CharacterBody2D

signal health_depleted

const BASE_MAX_HEALTH: float = 100.0
const BASE_DAMAGE: int = 1
const DAMAGE_RATE: float = 50.0
const INVINCIBILITY_DURATION: float = 3.0

var max_health: float = BASE_MAX_HEALTH
var health: float = BASE_MAX_HEALTH
var bonus_damage: int = 0

# ── Revive (dados da run) ──
var revive_used_this_run: bool = false
var is_invincible: bool = false

const EXPLOSION_SCENE = preload("res://effects/revive_explosion/revive_explosion.tscn")


func _ready() -> void:
	# Aplica upgrades do GameState
	bonus_damage = GameState.get_bonus_damage()
	max_health = GameState.get_max_health(BASE_MAX_HEALTH)
	health = max_health

	%ProgressBar.max_value = max_health
	%ProgressBar.value = health
	_update_coin_label()


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 800.0
	move_and_slide()

	if direction != Vector2.ZERO:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()

	# Atualiza moedas na HUD
	_update_coin_label()

	# Dano dos mobs
	if not is_invincible:
		var overlapping_mobs = %HurtBox.get_overlapping_bodies()
		if overlapping_mobs.size() > 0:
			health -= DAMAGE_RATE * overlapping_mobs.size() * delta
			health = max(health, 0.0)
			%ProgressBar.value = health

			if health <= 0.0:
				_try_revive()


func get_total_damage() -> int:
	return BASE_DAMAGE + bonus_damage


func _try_revive() -> void:
	if GameState.revive_owned and not revive_used_this_run:
		# Revive!
		revive_used_this_run = true
		health = max_health
		%ProgressBar.value = health

		# Invencibilidade temporária
		is_invincible = true
		_start_invincibility_timer()

		# Explosão de revive
		var explosion = EXPLOSION_SCENE.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
	else:
		health_depleted.emit()


func _start_invincibility_timer() -> void:
	var timer = get_tree().create_timer(INVINCIBILITY_DURATION)
	timer.timeout.connect(_on_invincibility_ended)

	# Efeito visual: piscar durante invencibilidade
	_blink_effect()


func _on_invincibility_ended() -> void:
	is_invincible = false
	%HappyBoo.modulate.a = 1.0


func _blink_effect() -> void:
	while is_invincible:
		%HappyBoo.modulate.a = 0.3
		await get_tree().create_timer(0.15).timeout
		%HappyBoo.modulate.a = 1.0
		await get_tree().create_timer(0.15).timeout


func _update_coin_label() -> void:
	%CoinLabel.text = "Moedas: " + str(GameState.coins)
