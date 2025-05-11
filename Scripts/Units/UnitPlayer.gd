#UnitPlayer.gd
extends UnitBase

func _ready():
	super._ready()
	unit_name = "Clansman"
	is_enemy = false
	stats = StatTemplates.get_template("clansman")
	hp = stats.max_hp
	movement_points = stats.max_movement_points
	action_points = stats.max_action_points
	health_bar.position = Vector3(0, 6.0, 0)  # anpassen je nach Modellhöhe
	health_bar.set_health(hp, stats.max_hp)
	play_idle()

func play_idle():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("mixamo_com")
