extends Area2D

@onready var timer = $Timer
var player: Node2D


func _on_body_entered(body: Node2D) -> void:
	player = body
	print("im reading")
	monitorable = false
	monitoring = false
	player.collision_layer = 3
	timer.start()
	



func _on_timer_timeout() -> void:
	print("tes")
	monitorable = true
	monitorable = true
	player.collision_layer = 2
	
	
