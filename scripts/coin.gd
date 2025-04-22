extends Area2D

signal pickup

func _on_body_entered(body: Node2D) -> void:
	print("+1 coin!")
	pickup.emit()
	queue_free()
	
