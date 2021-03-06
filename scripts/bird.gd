extends RigidBody2D

signal hit
signal restart_game

export(float) var jump_force = 300

export(AudioStream) var flap_sound
export(AudioStream) var die_sound

var already_died = false


# Called when the node enters the scene tree for the first time.
func _ready():
	connect('body_entered', self, '_on_Bird_body_entered')
	$AudioStreamPlayer2D.stream = flap_sound


func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		if not already_died:
			set_linear_velocity(Vector2(get_linear_velocity().x, -jump_force))
			$AudioStreamPlayer2D.play()
		else:
			emit_signal("restart_game")


func _on_Bird_body_entered(_body):
	if GameVariables.god_mode:
		return

	if !already_died:
		emit_signal("hit")
		already_died = true
		$AudioStreamPlayer2D.stream = die_sound
		$AudioStreamPlayer2D.play()

