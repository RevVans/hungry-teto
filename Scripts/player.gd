extends Area2D
# Player memakai Area2D supaya buah bisa mendeteksi sentuhan.

@export var speed : float = 700.0
@export var dash_speed : float = 1800.0
@export var dash_duration : float = 0.15
@export var dash_cooldown : float = 0.6

var _dash_time_left : float = 0.0
var _dash_cooldown_left : float = 0.0
var _dash_direction : float = 0.0
var _last_direction : float = 1.0
var _start_position : Vector2

func _ready():
	add_to_group("player")
	_start_position = position
	var gm = get_node("/root/Main/GameManager")
	if gm:
		gm.game_started.connect(_on_game_started)

func _on_game_started():
	position = _start_position
	_dash_time_left = 0.0
	_dash_cooldown_left = 0.0
	_dash_direction = 0.0
	_last_direction = 1.0
	
func _process(delta):
	var gm = get_node("/root/Main/GameManager")
	if gm:
		if not gm.is_started:
			# Tekan SPACE untuk mulai. return supaya dash tidak ikut terpicu.
			if Input.is_action_just_pressed("dash"):
				gm.start_game()
			return
		if gm.is_game_over:
			return
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		_last_direction = direction

	# Atur waktu dash dan cooldown.
	_dash_time_left = max(_dash_time_left - delta, 0.0)
	_dash_cooldown_left = max(_dash_cooldown_left - delta, 0.0)

	# Mulai dash mengikuti arah input (kalau tidak ada input, pakai arah terakhir).
	if Input.is_action_just_pressed("dash") and _dash_cooldown_left <= 0.0:
		_dash_direction = direction if direction != 0.0 else _last_direction
		_dash_time_left = dash_duration
		_dash_cooldown_left = dash_cooldown

	# Selama dash, bergerak sesuai arah dash dengan kecepatan dash.
	var is_dashing = _dash_time_left > 0.0
	var move_direction = _dash_direction if is_dashing else direction
	var current_speed = dash_speed if is_dashing else speed
	position.x += move_direction * current_speed * delta

	# Jangan keluar layar.
	var view_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, view_size.x)
	
func play_catch_sfx():
	$CatchSound.play()
