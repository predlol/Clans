extends Control
class_name UnitInfoPanel

@onready var background = $Background
@onready var hbox = $HBoxContainer

@onready var name_label = $HBoxContainer/NameLabel
@onready var hp_label = $HBoxContainer/HpLabel
@onready var armor_label = $HBoxContainer/ArmorLabel
@onready var mp_label = $HBoxContainer/MpLabel
@onready var ap_label = $HBoxContainer/ApLabel


func _ready():
	update_background_size()

func update_background_size():
	background.size = hbox.size
	background.position = hbox.position

func update_from_unit(unit: UnitBase):
	name_label.text = unit.unit_name
	hp_label.text = "HP: %d / %d" % [unit.hp, unit.stats.max_hp]
	armor_label.text = "Armor: %d" % unit.stats.armor
	mp_label.text = "MP: %d / %d" % [unit.movement_points, unit.stats.max_movement_points]
	ap_label.text = "AP: %d / %d" % [unit.action_points, unit.stats.max_action_points]

func clear():
	name_label.text = ""
	hp_label.text = ""
	armor_label.text = ""
	mp_label.text = ""
	ap_label.text = ""
