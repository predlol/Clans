# TurnManager.gd
extends Node


var units: Array[UnitBase] = []
var current_unit_index: int = -1


func _ready():
	SignalBus.connect("turn_end", Callable(self, "_on_turn_end"))


func _on_turn_end(unit):
	# Nur reagieren, wenn das aktuelle Unit ist
	if units[current_unit_index] == unit:
		end_turn()


func on_unit_died(unit):
	units.erase(unit)
	if current_unit_index >= units.size():
		current_unit_index = 0
	next_turn()


func get_current_unit() -> UnitBase:
	if current_unit_index >= 0 and current_unit_index < units.size():
		return units[current_unit_index]
	return null


func start_combat(all_units: Array[UnitBase]):
	units = all_units.duplicate()
	units.sort_custom(func(a, b): return a.initiative > b.initiative)
	current_unit_index = -1
	print("Kampfbeginn. Reihenfolge:")
	for u in units:
		print("- " + u.unit_name + " (INI: " + str(u.initiative) + ")")
	next_turn()


func next_turn():
	if units.is_empty():
		print("Kampf beendet – keine Einheiten mehr.")
		return

	current_unit_index = (current_unit_index + 1) % units.size()
	var unit = units[current_unit_index]

	if unit:
		unit.start_turn()
		print("---", unit.unit_name, " ist am Zug ---")
		SignalBus.emit_signal("turn_started", unit)
	else:
		print("Warnung: Aktive Einheit ist null.")



func _compare_initiative(a: UnitBase, b: UnitBase) -> bool:
	return a.initiative > b.initiative


func end_turn():
	print("--- Zug von ", units[current_unit_index].unit_name, "beendet ---")
	next_turn()


func find_closest_player(from_unit: UnitBase) -> UnitBase:
	var closest = null
	var min_dist = INF
	for u in units:
		if not u.is_enemy:
			var dist = from_unit.hex_distance(from_unit.grid_q, from_unit.grid_r, u.grid_q, u.grid_r)
			if dist < min_dist:
				closest = u
				min_dist = dist
	return closest
