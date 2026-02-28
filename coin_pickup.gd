extends Area2D

@export var coin_value: int = 1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameState.add_coins(coin_value)
		queue_free()
