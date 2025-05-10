extends Node3D
class_name HealthBar3D

@onready var label := $Label3D


func _ready() -> void:
	scale.x = -1

func set_health(current: int, max: int):
	label.text = "HP: %d / %d" % [current, max]
	label.modulate = Color.RED


func _process(_delta):
	var camera = get_viewport().get_camera_3d()
	if camera:
		look_at(camera.global_position, Vector3.UP)
