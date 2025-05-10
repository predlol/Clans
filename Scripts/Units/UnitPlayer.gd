#UnitPlayer.gd
extends UnitBase

func _ready():
	unit_name = "Clansman"
	is_enemy = false
	stats = StatTemplates.get_template("clansman")
	play_idle()

func play_idle():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("mixamo_com")
