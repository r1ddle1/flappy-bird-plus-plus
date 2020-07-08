extends KinematicBody2D

signal scored

func _ready():
	$ChangePosTimer.set("wait_time", GameVariables.column_spawn_delay - 1)


func _physics_process(delta):
	position.x -= GameVariables.scroll_speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	# Start timer after which the column will be moved
	$ChangePosTimer.start()


func _on_ChangePosTimer_timeout():
	position.x = GameVariables.column_spawn_x_pos
	position.y = rand_range(GameVariables.column_spawn_min_y_pos, 
		GameVariables.column_spawn_max_y_pos)


func _on_ScoredDetector_body_entered(body):
	emit_signal("scored")
