extends Area2D
# Buah jatuh ke bawah dan hilang saat tersentuh atau lewat bawah layar.

@export var fall_speed : float = 500.0

func _ready():
	add_to_group("falling_items")
	area_entered.connect(_on_area_entered)

func _process(delta):
	var gm = get_node("/root/Main/GameManager")
	if gm and gm.is_game_over:
		return
	
	position.y += fall_speed * delta

	# Lewat bawah layar -> hapus.
	if position.y > get_viewport_rect().size.y + 50:
		if gm:
			gm.lose_life()
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		if area.has_method("play_catch_sfx"):
			area.play_catch_sfx()
		collect()

func collect():
	var gm = get_node("/root/Main/GameManager")
	if gm:
		gm.add_score(10)
	queue_free()
