extends Camera3D

var move_speed := 10.0
var boost_speed := 30.0
var rotation_sensitivity := 0.003
var zoom_speed := 2.0

var yaw : float = 0.0
var pitch : float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	handle_rotation(event)
	handle_zoom(event)

func _process(delta):
	handle_movement(delta)

func handle_rotation(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		yaw -= event.relative.x * rotation_sensitivity
		pitch = clamp(pitch - event.relative.y * rotation_sensitivity, -PI/2, PI/2)
		
		rotation_degrees = Vector3(rad_to_deg(pitch), rad_to_deg(yaw), 0)

func handle_movement(delta):
	var input_vector = Vector3.ZERO

	if Input.is_action_pressed("move_backward"):
		input_vector.z -= 1
	if Input.is_action_pressed("move_forward"):
		input_vector.z += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

		var move_dir = Vector3.ZERO
		var forward = Vector3(
			-sin(deg_to_rad(yaw)),
			0,
			-cos(deg_to_rad(yaw))
		)

		var right = Vector3(
			cos(deg_to_rad(yaw)),
			0,
			-sin(deg_to_rad(yaw))
		)

		move_dir = (right * input_vector.x) + (forward * input_vector.z)
		move_dir = move_dir.normalized()

		var speed = move_speed
		if Input.is_action_pressed("move_boost"):
			speed = boost_speed

		translate(move_dir * speed * delta)

func handle_zoom(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			position += -transform.basis.z * zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			position += transform.basis.z * zoom_speed
