#HexTile.gd
extends Area3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collider: CollisionShape3D = $CollisionShape3D

@export var outer_radius: float = 2.0
@export var thickness: float = 0.05
@export var color: Color = Color(0.1, 0.1, 0.1)

@export var grid_q: int
@export var grid_r: int

signal tile_clicked(q: int, r: int)


func _ready():
	var shape = CylinderShape3D.new()
	shape.radius = outer_radius
	shape.height = 0.1
	collider.shape = shape
	generate_hex_ring()


func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		SignalBus.emit_signal("tile_clicked", grid_q, grid_r)


func uv_from_pos(pos: Vector3) -> Vector2:
	return Vector2(pos.x, pos.z) / (outer_radius * 2.0) + Vector2(0.5, 0.5)


func generate_hex_ring():
	var mesh = ArrayMesh.new()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var angle_step = TAU / 6.0
	var angle_offset = deg_to_rad(30)

	var ring_color = color  # Exportierte Farbe für Flexibilität

	for i in range(6):
		var a1 = i * angle_step + angle_offset
		var a2 = ((i + 1) % 6) * angle_step + angle_offset

		var p1_outer = Vector3(outer_radius * cos(a1), 0.01, outer_radius * sin(a1))
		var p2_outer = Vector3(outer_radius * cos(a2), 0.01, outer_radius * sin(a2))

		var p1_inner = Vector3((outer_radius - thickness) * cos(a1), 0.01, (outer_radius - thickness) * sin(a1))
		var p2_inner = Vector3((outer_radius - thickness) * cos(a2), 0.01, (outer_radius - thickness) * sin(a2))

		st.set_color(ring_color)
		st.add_vertex(p1_inner)
		st.add_vertex(p1_outer)
		st.add_vertex(p2_outer)

		st.add_vertex(p1_inner)
		st.add_vertex(p2_outer)
		st.add_vertex(p2_inner)

	st.generate_normals()
	st.index()
	st.commit(mesh)

	mesh_instance.mesh = mesh
	mesh_instance.rotation.y = deg_to_rad(30)
