extends CanvasLayer
 
@onready var final_score_label = $VBoxContainer/ScoreResult
@onready var restart_button = $VBoxContainer/RestartButton
 
func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
 
	var gm = get_node("/root/Main/GameManager")
	if gm:
		gm.game_over.connect(_on_game_over)
 
func _on_game_over():
	visible = true
	var gm = get_node("/root/Main/GameManager")
	if gm:
		final_score_label.text = "Final Score: " + str(gm.score)
 
func _on_restart_pressed():
	visible = false
	var gm = get_node("/root/Main/GameManager")
	if gm:
		gm.start_game()
