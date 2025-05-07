# GameController.gd
extends Node
class_name GameController

@export var grid: Node3D
@export var tile_radius: float = 2.0

var selected_unit: UnitBase = null


func _ready():
	var unit_player_scene = load("res://Scenes/Units/UnitPlayer.tscn")
	var player_unit = spawn_unit(unit_player_scene, 0, 0, false)
	#var unit_enemy_scene = load("res://Scenes/Units/UnitEnemy.tscn")
	#spawn_unit(unit_enemy_scene, 3, 0, true)
	
	SignalBus.connect("unit_selected", Callable(self, "_on_unit_selected"))
	SignalBus.connect("tile_clicked", Callable(self, "_on_tile_clicked"))
	
	TurnManager.start_combat([player_unit])


func _on_unit_selected(unit: UnitBase):
	selected_unit = unit
	print("Unit ausgewählt: " + unit.unit_name)


func _on_tile_clicked(q: int, r: int):
	if selected_unit:
		var distance = selected_unit.hex_distance(selected_unit.grid_q, selected_unit.grid_r, q, r)
		if distance <= selected_unit.movement_points:
			var world_pos = axial_to_world(q, r)
			selected_unit.move_to_tile(q, r, world_pos)
		else:
			print("Nicht genug Bewegungspunkte.")


func spawn_unit(scene: PackedScene, q: int, r: int, is_enemy: bool):
	var unit = scene.instantiate() as UnitBase
	if unit == null:
		push_error("Fehler: Unit konnte nicht instanziiert werden!")
		return

	unit.grid_q = q
	unit.grid_r = r
	unit.is_enemy = is_enemy
	unit.unit_selected.connect(_on_unit_selected)
	grid.add_child(unit)
	unit.global_position = axial_to_world(q, r)
	return unit


func axial_to_world(q: int, r: int) -> Vector3:
	var x = 1.5 * tile_radius * q
	var z = sqrt(3) * tile_radius * (r + 0.5 * (q % 2))
	return Vector3(x, 0.05, z)
