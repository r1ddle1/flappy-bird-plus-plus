extends CanvasLayer


func _ready():
	$DeadLabel.hide()

func update_text():
	$MoneyLabel.text = "Money: " + str(GameVariables.money)
	$ScoreLabel.text = "Score: " + str(GameVariables.score)


func _on_Bird_hit():
	$DeadLabel.text = "You're dead!\nHigh score: " + str(GameVariables.high_score)
	$DeadLabel.show()
