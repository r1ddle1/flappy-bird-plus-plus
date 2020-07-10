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
	position.x = GameVariables.COLUMN_SPAWN_X_POS
	position.y = rand_range(GameVariables.COLUMN_SPAWN_MIN_Y_POS, 
		GameVariables.COLUMN_SPAWN_MAX_Y_POS)


func _on_ScoredDetector_body_entered(body):
	if body.name == 'Bird':
		emit_signal("scored")
