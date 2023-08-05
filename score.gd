extends CanvasLayer

@export var score_manager: Node
@onready var label: Label = $CenterContainer/MarginContainer/ScoreLabel

func _ready():
  score_manager.score_updated.connect(handle_score_update)
  label.text = "SCORE: 0"

func handle_score_update(new_score: int):
  label.text = "SCORE: " + str(new_score)
