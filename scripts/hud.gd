extends CanvasLayer

@onready var score = 0

func update_score():
	score += 1
	$ScoreLabel.text = "Score: " + str(score)
