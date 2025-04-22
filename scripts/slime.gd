extends Node2D

const SPEED = 60
var direction = 1

func _process(delta: float) -> void:
	if $RayCastLeft.is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = false
	if $RayCastRight.is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = true
		
	position.x += SPEED * direction * delta
