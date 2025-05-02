extends Node3D

@export var tile_scene: PackedScene
@export var terrain: Node3D  
@export var tile_radius: float = 2  

func _ready():
	var terrain_size_x = terrain.scale.x * 2.0
	var terrain_size_z = terrain.scale.z * 2.0
	var half_x = terrain_size_x / 2.0
	var half_z = terrain_size_z / 2.0

	generate_grid_in_area(-half_x, half_x, -half_z, half_z)

func generate_grid_in_area(min_x: float, max_x: float, min_z: float, max_z: float):
	var radius = tile_radius
	var hex_width = sqrt(3) * radius
	var hex_height = 2.0 * radius

	var q_start = int(floor(min_x / (hex_width * 0.75)))
	var q_end = int(ceil(max_x / (hex_width * 0.75)))
	var r_start = int(floor(min_z / (hex_height * 0.5)))
	var r_end = int(ceil(max_z / (hex_height * 0.5)))

	for q in range(q_start, q_end):
		for r in range(r_start, r_end):
			var pos = axial_to_world(q, r)
			if pos.x < min_x or pos.x > max_x or pos.z < min_z or pos.z > max_z:
				continue
			var tile = tile_scene.instantiate()
			tile.position = pos
			add_child(tile)

func axial_to_world(q: int, r: int) -> Vector3:
	var radius = tile_radius  
	var x = radius * sqrt(3) * (q + r * 0.5)
	var z = radius * 1.5 * r
	return Vector3(x, 0.05, z)
