extends KinematicBody2D

var ground_length
var repos_start_pos

func _ready():
	ground_length = $Sprite.get_rect().size.x
	repos_start_pos = -1024


func _physics_process(delta):
	position.x -= GameVariables.scroll_speed * delta
	if position.x < repos_start_pos:
		_reposition()
		
	
func _reposition():
	position.x += ground_length
