extends Node

signal score_changed(new_score)
signal lives_changed(new_lives)
signal game_over
signal game_started

var score : int = 0
var lives : int = 3
var is_game_over : bool = false
var is_started : bool = false

func _ready():
	reset_game()

func start_game():
	_clear_falling_items()
	reset_game()
	is_started = true
	game_started.emit()

# Hapus semua buah/heart yang masih ada di layar saat restart.
func _clear_falling_items():
	for item in get_tree().get_nodes_in_group("falling_items"):
		item.set_process(false)
		item.queue_free()

func reset_game():
	score = 0
	lives = 3
	is_game_over = false
	is_started = false
	score_changed.emit(score)
	lives_changed.emit(lives)

func add_score(points: int):
	if is_game_over or not is_started:
		return
	score += points
	score_changed.emit(score)

func lose_life():
	if is_game_over or not is_started:
		return
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		is_game_over = true
		game_over.emit()

func heal_life():
	if is_game_over or not is_started:
		return
	if lives < 3:
		lives += 1
		lives_changed.emit(lives)
