extends Node

export (bool) var god_mode = false

export (int) var score = 0
export (int) var high_score = 0
export (int) var money = 0
export (float) var scroll_speed


const COLUMN_SPAWN_X_POS = 2000
const COLUMN_SPAWN_MIN_Y_POS = 109.422
const COLUMN_SPAWN_MAX_Y_POS = 485.642

export (float) var column_spawn_delay = 3
export (float) var coin_spawn_delay = 10
export (int) var column_spawn_count

const CONFIG_KEY = 'лезгинку!'
