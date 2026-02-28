extends Area2D

@export var speed: float = 400.0
@export var max_travel_distance: float = 1200.0

var direction: Vector2 = Vector2.RIGHT
var start_position: Vector2

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)
	start_position = global_position

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.distance_to(start_position) >= max_travel_distance:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
