extends CharacterBody2D

const COIN_SCENE = preload("res://coin_pickup.tscn")

var health = 3

@onready var player = get_node("/root/Game/Player")

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 200
	move_and_slide()

func take_damage(amount: int = 1):
	health -= amount
	%Slime.play_hurt()

	if health <= 0:
		_die.call_deferred()

func _die() -> void:
	# Drop moeda
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position
	get_parent().add_child(coin)

	# Efeito de morte
	const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_SCENE.instantiate()
	smoke.global_position = global_position
	get_parent().add_child(smoke)

	queue_free()
