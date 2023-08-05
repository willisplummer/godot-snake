extends Node

@export var apple_scene: PackedScene
@export var tile_size: float = 16

func _ready():
  GameEvents.apple_collected.connect(add_apple)
  add_apple()

func add_apple():
  if (apple_scene == null):
    print("apple_scene is null")
    return
  var apple: Node2D = apple_scene.instantiate()
  owner.get_parent().add_child.call_deferred(apple)
  var targetPosition: Vector2 = get_random_position().snapped(Vector2(tile_size, tile_size)) + (Vector2.ONE * (tile_size / 2))
  apple.set_position(targetPosition)

# todo: some logic about being x distance from the player
func get_random_position():
  # todo: calculate the max based on the window size
  var target = Vector2(randf_range(0, 30), randf_range(0,30))
  return target * tile_size
