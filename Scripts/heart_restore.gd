extends Area2D

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
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		var gm = get_node("/root/Main/GameManager")
		if gm:
			gm.heal_life()
	queue_free()
