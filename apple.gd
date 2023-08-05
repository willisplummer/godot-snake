extends Area2D

func _process(_delta):
  var player_contact: bool = get_overlapping_areas().size() > 0
  if player_contact:
    GameEvents.emit_apple_collected()
    queue_free()

