extends Node
class_name FloatingTextManager

const TEXT_SCENE = preload("res://UI/FloatingText.tscn")

static var current_scene: Node = null

static func show(text: String, world_position: Vector3, color: Color = Color.WHITE):
	if current_scene == null:
		push_error("FloatingTextManager.current_scene not set!")
		return

	var instance = TEXT_SCENE.instantiate()
	instance.text = text
	instance.modulate = color
	current_scene.add_child(instance)
	instance.global_position = world_position + Vector3.UP * 2
