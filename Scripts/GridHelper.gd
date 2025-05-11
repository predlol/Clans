extends Node

static var grid: Node3D

static func axial_to_world(q: int, r: int) -> Vector3:
	var tile_radius = grid.tile_radius
	var center_offset = grid.center_offset  # <--- Zugriff auf gespeicherten Offset

	var x = 1.5 * tile_radius * q
	var z = sqrt(3) * tile_radius * (r + 0.5 * (q % 2))
	return Vector3(x, 0.05, z) - center_offset


func hex_distance(q1: int, r1: int, q2: int, r2: int) -> int:
	var x1 = q1
	var z1 = r1
	var y1 = -x1 - z1

	var x2 = q2
	var z2 = r2
	var y2 = -x2 - z2

	return max(abs(x1 - x2), abs(y1 - y2), abs(z1 - z2))
