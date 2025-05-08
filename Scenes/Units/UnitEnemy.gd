#UnitPlayer.gd
extends UnitBase

func _ready():
	unit_name = "Enemy"
	is_enemy=false
	play_idle()

func play_idle():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("mixamo_com")
