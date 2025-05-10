#UnitPlayer.gd
extends UnitBase

func _ready():
	unit_name = "Enemy"
	is_enemy = true
	stats = StatTemplates.get_template("enemy_basic")
	play_idle()

func play_idle():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("mixamo_com")


func start_turn():
	action_points = max_action_points
	movement_points = max_movement_points
	print(unit_name + " (Enemy) beginnt den Zug mit %d AP." % action_points)

	call_deferred("_take_turn")  # kurze Verzögerung, falls nötig für sauberen Ablauf

func _take_turn():
	await get_tree().create_timer(0.5).timeout  # kleine Pause für Lesbarkeit

	var target = TurnManager.find_closest_player(self)
	if target == null:
		print("Kein Ziel gefunden.")
		SignalBus.emit_signal("turn_end", self)
		return

	var distance = hex_distance(grid_q, grid_r, target.grid_q, target.grid_r)

	if distance <= 1:
		# Direkt angreifen
		if default_attack and action_points > 0:
			var result = Combat.perform_attack(self, target, default_attack)
			use_action_point()
			await get_tree().create_timer(0.5).timeout
	else:
		# Bewegung in Richtung Ziel
		if action_points > 0:
			var dir_q = sign(target.grid_q - grid_q)
			var dir_r = sign(target.grid_r - grid_r)
			move_to_tile(grid_q + dir_q, grid_r + dir_r, GridHelper.grid.axial_to_world(grid_q + dir_q, grid_r + dir_r))
			use_action_point()
			await get_tree().create_timer(0.5).timeout

	SignalBus.emit_signal("turn_end", self)
