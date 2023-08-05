extends Node

signal apple_collected
signal game_over

func emit_apple_collected():
  apple_collected.emit()

func emit_game_over():
  print("GAME OVER EMITED")
  game_over.emit()
