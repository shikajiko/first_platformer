extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not body.is_invincible:
		body.take_damage(global_position, 1.5)
