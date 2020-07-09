extends Node2D

var column = preload("res://scenes/column.tscn")
var spawned_column_count = 0

var old_scroll_speed = GameVariables.scroll_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_load_game_data()
	$ColumnSpawnTimer.set("wait_time", GameVariables.column_spawn_delay)
	GameVariables.score = 0
	$HUD.update_text()

func _process(delta):
	pass


func _on_Bird_hit():
	GameVariables.scroll_speed = 0
	if GameVariables.score > GameVariables.high_score:
		GameVariables.high_score = GameVariables.score


func _on_ColumnSpawnTimer_timeout():
	if spawned_column_count > GameVariables.column_spawn_count:
		$ColumnSpawnTimer.stop()
		return

	spawned_column_count += 1
	var column_instance = column.instance()
	var y_spawn_pos = rand_range(GameVariables.column_spawn_min_y_pos, 
			GameVariables.column_spawn_max_y_pos)
	column_instance.position = Vector2(GameVariables.column_spawn_x_pos,
		y_spawn_pos)

	# Connect each column's scored signal to _on_scored
	column_instance.connect("scored", self, "_on_scored")
	add_child(column_instance)


func _on_scored():
	GameVariables.score += 1
	$HUD.update_text()


func _restart_game():
	GameVariables.scroll_speed = old_scroll_speed
	_save_game_data()
	get_tree().change_scene("res://scenes/level0.tscn")


func _load_game_data():
	var config = ConfigFile.new()
	var res = config.load_encrypted_pass('data.enc', GameVariables.CONFIG_KEY)
	if res != OK:  # Config doesn't exist yet
		return

	GameVariables.high_score = config.get_value('GameVariables', 'high_score')
	GameVariables.money = config.get_value('GameVariables', 'money')
	# Don't forget to update text!
	$HUD.update_text()

func _save_game_data():
	var config = ConfigFile.new()
	
	config.set_value('GameVariables', 'high_score', GameVariables.high_score)
	config.set_value('GameVariables', 'money', GameVariables.money)
	
	var res = config.save_encrypted_pass('data.enc', GameVariables.CONFIG_KEY)
	if res != OK:
		print("Error: Couldn't save game data")
