extends CanvasLayer

@onready var score = 0

func update_score():
	score += 1
	print("why is it not updated")
	$ScoreLabel.text = "Score: " + str(score)
