# TurnManager.gd
extends Node
class_name TurnManager

var units: Array[UnitBase] = []
var current_unit_index: int = -1

func start_combat(all_units: Array[UnitBase]):
	units = all_units.duplicate()
	units.sort_custom(func(a, b): return a.initiative > b.initiative)
	current_unit_index = -1
	print("Kampfbeginn. Reihenfolge:")
	for u in units:
		print("- " + u.unit_name + " (INI: " + str(u.initiative) + ")")
	next_turn()

func next_turn():
	current_unit_index = (current_unit_index + 1) % units.size()
	var unit = units[current_unit_index]
	unit.start_turn()
	print("--- " + unit.unit_name + " ist am Zug ---")

func _compare_initiative(a: UnitBase, b: UnitBase) -> bool:
	return a.initiative > b.initiative
