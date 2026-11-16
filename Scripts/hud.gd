extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel
@onready var start_label = $StartLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gm = get_node("/root/Main/GameManager")
	if gm:
		gm.score_changed.connect(_on_score_changed)
		gm.lives_changed.connect(_on_lives_changed)
		gm.game_started.connect(_on_game_started)
		# GameManager emits these in its own _ready, before HUD connects.
		_on_score_changed(gm.score)
		_on_lives_changed(gm.lives)
		start_label.visible = not gm.is_started


func _on_score_changed(score):
	score_label.text = "Score: " + str(score)
 
func _on_lives_changed(lives):
	lives_label.text = "Lives: " + str(lives)
 
func _on_game_started():
	start_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
