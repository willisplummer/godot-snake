extends Node2D

@export var tile_size: float = 16
@export var move_interval: float = 0.2
@export var min_move_interval: float = 0.1
@export var player_square_scene: PackedScene

@onready var squares_container: Node = $SquaresContainer
@onready var current_direction: String = "up"
@onready var new_direction: String = "up"
@onready var time_passed: float = 0
@onready var element_positions: Array[Vector2] = []
@onready var make_longer: bool = false

var inputs = {
  "up" = {
  vector = Vector2.UP,
  valid_inputs = ["left", "right"]
  },
  "down" = {
  vector = Vector2.DOWN,
  valid_inputs = ["left", "right"]
  },
  "left" = {
  vector = Vector2.LEFT,
  valid_inputs = ["up", "down"]
  },
  "right" = {
  vector = Vector2.RIGHT,
  valid_inputs = ["up", "down"]
  }
}

func _ready():
  GameEvents.apple_collected.connect(on_apple_collected)
  var screen_size = get_viewport_rect().size
  var center = screen_size / 2
  var initial_position: Vector2 = snap_and_center_pos(center)
  var down = Vector2.DOWN * 16
  element_positions = [initial_position, initial_position + down, initial_position + (down * 2)]
  print(element_positions)
  for pos in element_positions:
    render_square(pos)

func _process(delta):
  time_passed += delta #wonder if someone would tell me this should use a timer or something
  if (time_passed > move_interval):
    time_passed = 0
    add_new_front_element()
    if make_longer:
      make_longer = false
    else:
      delete_tail()

func _unhandled_input(event):
  for dir in inputs[current_direction].valid_inputs:
    # prevents player from changing dir twice to achieve invalid direction
    # before snake advances
    if event.is_action_pressed(dir):
      new_direction = dir

func add_new_front_element():
  var new_front_position: Vector2 = calculate_new_front_position()
  # Possible refactor: implement a queue to make this more efficient
  element_positions.push_front(new_front_position)
  render_square(new_front_position)

func delete_tail():
  var oldest_square: Node2D = squares_container.get_children()[0]
  oldest_square.queue_free()

func calculate_new_front_position() -> Vector2:
  current_direction = new_direction
  var previous_front_position: Vector2 = element_positions[0]
  var new_front_position: Vector2 = previous_front_position + inputs[current_direction].vector * tile_size

  # handle screen_wrap
  var screen_size = get_viewport_rect().size
  new_front_position.x = wrapf(new_front_position.x, 0, screen_size.x)
  new_front_position.y = wrapf(new_front_position.y, 0, screen_size.y)
  return new_front_position

func render_square(pos: Vector2):
  var square: Node2D = player_square_scene.instantiate()
  squares_container.add_child(square)
  square.position = pos

func on_apple_collected():
  make_longer = true
  move_interval = max(move_interval - 0.01, min_move_interval)

func snap_and_center_pos(pos: Vector2) -> Vector2:
  # snaps the player to the top left corner of nearest grid square
  var snapt = pos.snapped(Vector2(tile_size, tile_size))
  # centers player within square
  return snapt + Vector2(tile_size/2, tile_size/2)
