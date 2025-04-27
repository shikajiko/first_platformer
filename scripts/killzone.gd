extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.health = 0
	body._set_state(body.States.DEATH)
	

	
	
