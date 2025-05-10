extends Node

var grid: Node = null

func axial_to_world(q: int, r: int) -> Vector3:
	if grid and grid.has_method("axial_to_world"):
		return grid.axial_to_world(q, r)
	else:
		push_error("GridHelper: grid not set or invalid")
		return Vector3.ZERO
