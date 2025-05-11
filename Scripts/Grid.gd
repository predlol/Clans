extends Node3D

@export var tile_scene: PackedScene
@export var tile_radius: float = 2.0
@export var grid_width: int = 20
@export var grid_height: int = 10

var center_offset: Vector3 = Vector3.ZERO


func generate_fixed_grid(width: int, height: int):
	var radius = tile_radius
	center_offset = axial_to_world(width / 2.0, height / 2.0)

	for q in range(width):
		for r in range(height):
			var pos = axial_to_world(q, r) - center_offset
			var tile = tile_scene.instantiate()
			tile.position = pos
			tile.grid_q = q
			tile.grid_r = r

			add_child(tile)


func axial_to_world(q: int, r: int) -> Vector3:
	var R = tile_radius

	var x = 1.5 * R * q
	var z = sqrt(3) * R * (r + 0.5 * (q % 2))
	return Vector3(x, 0.05, z)
