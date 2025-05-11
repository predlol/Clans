# GameController.gd
extends Node
class_name GameController

@export var grid: Node3D
@export var tile_radius: float = 2.0
@export var unit_info_panel: UnitInfoPanel


var selected_unit: UnitBase = null

func _unhandled_input(event):
	if event.is_action_pressed("end_turn"):
		var current_unit = TurnManager.get_current_unit()
		SignalBus.emit_signal("turn_end", current_unit)

func _ready():	
	FloatingTextManager.current_scene = get_tree().current_scene
	GridHelper.grid = grid
	grid.generate_fixed_grid(grid.grid_width, grid.grid_height)
	
	SignalBus.connect("unit_selected", Callable(self, "_on_unit_selected"))
	SignalBus.connect("tile_clicked", Callable(self, "_on_tile_clicked"))
	
	var units: Array[UnitBase] = []
	var unit_player_scene = load("res://Scenes/Units/UnitPlayer.tscn")
	var unit_enemy_scene = load("res://Scenes/Units/UnitEnemy.tscn")

	units.append(spawn_unit(unit_player_scene, 5, 5, false))
	units.append(spawn_unit(unit_enemy_scene, 15, 5, true))
	
	TurnManager.start_combat(units)


func _on_unit_selected(unit: UnitBase):
	if selected_unit and unit.is_enemy:
		# Angriff auf Gegner
		if selected_unit.default_attack:
			if selected_unit.action_points < 1:
				print("Keine Aktionspunkte für Angriff!")
				return

			var result = Combat.perform_attack(selected_unit, unit, selected_unit.default_attack)
			selected_unit.use_action_point()

			if result.success:
				print("%s trifft %s! Schaden: %d (HP -%d / Armor -%d)" % [
					selected_unit.unit_name,
					unit.unit_name,
					result.damage,
					result.hp_damage,
					result.armor_damage
				])
			else:
				print("%s verfehlt %s (Wurf %d / Chance %d%%)" % [
					selected_unit.unit_name,
					unit.unit_name,
					result.hit_roll,
					result.hit_chance
				])
	else:
		# Eigene Einheit auswählen
		selected_unit = unit
		print("Unit ausgewählt: %s (HP: %d / %d | MP: %d / %d | AP: %d / %d)" % [
			unit.unit_name,
			unit.hp, unit.stats.max_hp,
			unit.movement_points, unit.stats.max_movement_points,
			unit.action_points, unit.stats.max_action_points
		])
		if unit_info_panel:
			unit_info_panel.update_from_unit(unit)



func _on_tile_clicked(q: int, r: int):
	if selected_unit:
		print("Tile clicked: (%d, %d)" % [q, r])
		print("Unit steht auf: (%d, %d)" % [selected_unit.grid_q, selected_unit.grid_r])
		var distance = GridHelper.hex_distance(selected_unit.grid_q, selected_unit.grid_r, q, r)

		if distance <= selected_unit.movement_points:
			var world_pos = GridHelper.axial_to_world(q, r)
			selected_unit.move_to_tile(q, r, world_pos)
		else:
			print("Nicht genug Bewegungspunkte.")


func spawn_unit(scene: PackedScene, q: int, r: int, is_enemy: bool):
	var unit = scene.instantiate() as UnitBase
	if unit == null:
		push_error("Fehler: Unit konnte nicht instanziiert werden!")
		return null

	grid.add_child(unit)

	unit.grid_q = q
	unit.grid_r = r
	unit.is_enemy = is_enemy
	unit.set_deferred("global_position", GridHelper.axial_to_world(q, r))

	return unit
