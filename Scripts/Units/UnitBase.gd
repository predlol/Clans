#UnitBase.gd
extends CharacterBody3D
class_name UnitBase

@export var unit_name: String = "Unknown"
@export var grid_q: int
@export var grid_r: int
@export var initiative: int = 10

var hp: int = 0
var movement_points: int = 0
var action_points: int = 0
var is_enemy = false
var is_selected := false
var selected_unit : UnitBase

signal unit_selected(unit: UnitBase)

var health_bar: HealthBar3D = null

var stats := {}

var default_attack := {
	"name": "Default Attack",
	"type": "physical",
	"subtype": "melee",
	"base_damage": 25,
	"armor_penetration": 0.2,
	"stamina_cost": 15,
	"focus_cost": 0,
	"range": 1,
	"accuracy_modifier": 0,
	"element": null
}


func _ready() -> void:
	var bar_scene = preload("res://UI/HealthBar3D.tscn")
	health_bar = bar_scene.instantiate()
	add_child(health_bar)


func _input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Unit wurde angeklickt!")
		SignalBus.emit_signal("unit_selected", self)


func start_turn():
	action_points = stats.max_action_points
	movement_points = stats.max_movement_points
	print("%s beginnt den Zug mit %d MP / %d AP" % [
		unit_name, movement_points, action_points
	])


func use_action_point():
	action_points -= 1
	print(unit_name + " hat jetzt %d AP." % action_points)


func move_to_tile(new_q: int, new_r: int, world_pos: Vector3):
	var distance = hex_distance(grid_q, grid_r, new_q, new_r)
	if distance <= movement_points:
		grid_q = new_q
		grid_r = new_r
		movement_points -= distance

		var tween = create_tween()
		tween.tween_property(self, "global_position", world_pos, 0.4)

		# Wenn keine Bewegungspunkte mehr → TurnManager benachrichtigen
		await tween.finished
		if movement_points <= 0:
			SignalBus.emit_signal("turn_end", self)


func hex_distance(q1: int, r1: int, q2: int, r2: int) -> int:
	var s1 = -q1 - r1
	var s2 = -q2 - r2
	return max(abs(q1 - q2), abs(r1 - r2), abs(s1 - s2))


func select():
	is_selected = true
	# z. B. Highlight zeigen


func deselect():
	is_selected = false
	# z. B. Highlight ausblenden+


func apply_damage(amount: int):
	hp -= amount
	if health_bar:
		health_bar.set_health(hp, stats.max_hp)  # oder stats.max_hp
	if hp <= 0:
		die()


func die():
	print(unit_name + " has died.")
	FloatingTextManager.show("DEAD", global_position, Color.DARK_RED)

	# Hier ggfe Animation abspielen oder eine Ragdoll erzeugen

	queue_free()

	# Optional: Informiere andere Systeme
	if Engine.has_singleton("TurnManager"):
		TurnManager.on_unit_died(self)
