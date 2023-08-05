extends Node

# I think this is fiddly and here it might be easier for the score to just do
# @export var score: Node and then call update_score directly on that
# (or just combine them - still not fully seeing the boundaries or 
# the coherent units I guess
signal score_updated(new_score: int)

@onready var score: int = 0

func _ready():
  GameEvents.apple_collected.connect(increment_score)

func increment_score():
  score += 1
  score_updated.emit(score)
