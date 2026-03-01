extends Node2D

const MOB_SCENE: PackedScene = preload("res://mob.tscn")
const GAME_OVER_SCENE: PackedScene = preload("res://game_over.tscn")

@export var mobs_per_tick: int = 1

func _ready() -> void:
	%Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	for i in range(mobs_per_tick):
		spawn_mob()

func spawn_mob() -> void:
	var mob = MOB_SCENE.instantiate()
	%PathFollow2D.progress_ratio = randf()
	mob.global_position = %PathFollow2D.global_position
	get_tree().current_scene.add_child(mob)


func _on_player_health_depleted():
	# Mostra tela de Game Over com botões
	var game_over_ui = GAME_OVER_SCENE.instantiate()
	%GameOverScreen.add_child(game_over_ui)
	%GameOverScreen.visible = true
	get_tree().paused = true
