extends CanvasLayer

func _ready():
  visible = false
  GameEvents.game_over.connect(on_game_over)

func on_game_over():
  visible = true
  get_tree().paused = true

func _unhandled_input(event):
  print(event)
  if event.is_action_pressed("ui_accept") && visible == true:
      # This restarts the current scene.
      get_tree().reload_current_scene()
      get_tree().paused = false
