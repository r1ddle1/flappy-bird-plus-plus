extends Node2D

var column = preload("res://scenes/column.tscn")
var coin = preload("res://scenes/coin.tscn")

var spawned_columns_count = 0
var spawned_coins_count = 0
var old_scroll_speed = GameVariables.scroll_speed

export(AudioStream) var coin_collected_sound


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_load_game_data()
	$ColumnSpawnTimer.set("wait_time", GameVariables.column_spawn_delay)
	$CoinSpawnTimer.set("wait_time", GameVariables.coin_spawn_delay)
	GameVariables.score = 0
	$HUD.update_text()


func _on_Bird_hit():
	GameVariables.scroll_speed = 0
	if GameVariables.score > GameVariables.high_score:
		GameVariables.high_score = GameVariables.score


func _on_ColumnSpawnTimer_timeout():
	if spawned_columns_count > GameVariables.column_spawn_count:
		$ColumnSpawnTimer.stop()
		return

	spawned_columns_count += 1
	var column_instance = column.instance()
	var y_spawn_pos = rand_range(GameVariables.COLUMN_SPAWN_MIN_Y_POS, 
		GameVariables.COLUMN_SPAWN_MAX_Y_POS)
	column_instance.position = Vector2(GameVariables.COLUMN_SPAWN_X_POS,
		y_spawn_pos)

	# Connect each column's scored signal to _on_scored
	column_instance.connect("scored", self, "_on_scored")
	add_child(column_instance)


func _on_CoinSpawnTimer_timeout():
	var coin_instance = coin.instance()
	var y_spawn_pos = rand_range(GameVariables.COLUMN_SPAWN_MIN_Y_POS, 
		GameVariables.COLUMN_SPAWN_MAX_Y_POS)
	coin_instance.position = Vector2(GameVariables.COLUMN_SPAWN_X_POS,
		y_spawn_pos)

	# Connect each column's scored signal to _on_scored
	coin_instance.connect("coin_collected", self, "_on_coin_collected")
	add_child(coin_instance)


func _on_scored():
	GameVariables.score += 1
	$HUD.update_text()


func _on_coin_collected():
	GameVariables.money += 1
	$HUD.update_text()
	$AudioStreamPlayer2D.stream = coin_collected_sound
	$AudioStreamPlayer2D.play()


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

