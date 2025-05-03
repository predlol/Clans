# GameController.gd
extends Node
class_name CombatController

@export var grid: Node3D
@export var unit_scene: PackedScene
@export var tile_radius: float = 2.0

var selected_unit: UnitBase = null

func _ready():
	spawn_unit_at(0, 0)

func spawn_unit_at(q: int, r: int):
	if not unit_scene:
		push_error("No unit scene assigned!")
		return

	var unit = unit_scene.instantiate() as UnitBase
	unit.grid_q = q
	unit.grid_r = r
	unit.global_position = axial_to_world(q, r)
	unit.unit_selected.connect(_on_unit_selected)
	grid.add_child(unit)

	# Optional direkt auswählen
	selected_unit = unit

func _on_tile_clicked(q: int, r: int):
	if selected_unit:
		var world_pos = axial_to_world(q, r)
		selected_unit.move_to_tile(q, r, world_pos)

func _on_unit_selected(unit: UnitBase):
	selected_unit = unit
	print("Unit ausgewählt: " + unit.unit_name)

func axial_to_world(q: int, r: int) -> Vector3:
	var x = 1.5 * tile_radius * q
	var z = sqrt(3) * tile_radius * (r + 0.5 * (q % 2))
	return Vector3(x, 0.05, z)
