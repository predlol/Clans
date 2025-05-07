#UnitBase.gd
extends CharacterBody3D
class_name UnitBase

@export var unit_name: String = "Player1"
@export var grid_q: int
@export var grid_r: int
@export var max_movement_points: int = 4
@export var initiative: int = 10

var movement_points: int = 0
var is_enemy = false
var is_selected := false
var selected_unit : UnitBase

signal unit_selected(unit: UnitBase)


func _input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Unit wurde angeklickt!")
		SignalBus.emit_signal("unit_selected", self)


func start_turn():
	movement_points = max_movement_points
	print(unit_name + " beginnt den Zug mit " + str(movement_points) + " Bewegungspunkten.")


func move_to_tile(new_q: int, new_r: int, world_pos: Vector3):
	var distance = hex_distance(grid_q, grid_r, new_q, new_r)
	if distance <= movement_points:
		grid_q = new_q
		grid_r = new_r
		movement_points -= distance
		var tween = create_tween()
		tween.tween_property(self, "global_position", world_pos, 0.4)


func hex_distance(q1: int, r1: int, q2: int, r2: int) -> int:
	var s1 = -q1 - r1
	var s2 = -q2 - r2
	return max(abs(q1 - q2), abs(r1 - r2), abs(s1 - s2))


func select():
	is_selected = true
	# z. B. Highlight zeigen


func deselect():
	is_selected = false
	# z. B. Highlight ausblenden+
