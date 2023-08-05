extends Area2D

func _on_area_entered(_area:Area2D):
  GameEvents.emit_game_over()
