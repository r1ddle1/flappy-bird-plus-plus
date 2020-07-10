extends Area2D

signal coin_collected


func _physics_process(delta):
	position.x -= GameVariables.scroll_speed * delta


func _on_Coin_body_entered(body):
	if body.name != "Bird":  # We're colliding with column
		position.x += 100
	else:
		emit_signal("coin_collected")
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
