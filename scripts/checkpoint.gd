extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.spawn_point = global_position
		body.spawn_point.y -= 3
