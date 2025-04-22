extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var coins = get_tree().get_nodes_in_group("Coins")
	for coin in coins:
		coin.pickup.connect($hud.update_score)
		coin.pickup.connect($coin_pickup.play)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
