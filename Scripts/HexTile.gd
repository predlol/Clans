extends MeshInstance3D

@export var outer_radius: float = 2
@export var thickness: float = 0.05
@export var color: Color = Color(0.1, 0.1, 0.1)

func _ready():
	generate_hex_ring()

func generate_hex_ring():
	var mesh = ArrayMesh.new()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var angle_step = TAU / 6.0
	var angle_offset = deg_to_rad(30)


	for i in range(6):
		var a1 = i * angle_step + angle_offset
		var a2 = ((i + 1) % 6) * angle_step + angle_offset

		var p1_outer = Vector3(outer_radius * cos(a1), 0, outer_radius * sin(a1))
		var p2_outer = Vector3(outer_radius * cos(a2), 0, outer_radius * sin(a2))

		var p1_inner = Vector3((outer_radius - thickness) * cos(a1), 0, (outer_radius - thickness) * sin(a1))
		var p2_inner = Vector3((outer_radius - thickness) * cos(a2), 0, (outer_radius - thickness) * sin(a2))

		# Zwei Dreiecke pro Segment
		st.set_color(color)
		st.add_vertex(p1_inner)
		st.add_vertex(p1_outer)
		st.add_vertex(p2_outer)

		st.add_vertex(p1_inner)
		st.add_vertex(p2_outer)
		st.add_vertex(p2_inner)

	st.generate_normals()
	st.index()
	st.commit(mesh)

	self.mesh = mesh
	
	self.rotation.y = deg_to_rad(30)
