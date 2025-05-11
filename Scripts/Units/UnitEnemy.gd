#UnitPlayer.gd
extends UnitBase

func _ready():
	super._ready()
	unit_name = "Enemy"
	is_enemy = true
	stats = StatTemplates.get_template("enemy_basic")
	hp = stats.max_hp
	movement_points = stats.max_movement_points
	action_points = stats.max_action_points
	health_bar.position = Vector3(0, 2.0, 0)  # anpassen je nach Modellhöhe
	health_bar.set_health(hp, stats.max_hp)
	play_idle()

func play_idle():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("mixamo_com")


func start_turn():
	action_points = stats.max_action_points
	movement_points = stats.max_movement_points
	print("%s beginnt den Zug mit %d MP / %d AP" % [
		unit_name, movement_points, action_points
	])

	call_deferred("_take_turn")  # kurze Verzögerung, falls nötig für sauberen Ablauf

func _take_turn():
	await get_tree().create_timer(0.5).timeout  # kleine Pause für Lesbarkeit

	var target = TurnManager.find_closest_player(self)
	if target == null:
		print("Kein Ziel gefunden.")
		SignalBus.emit_signal("turn_end", self)
		return

	# Bewegung in Richtung Ziel
	while movement_points > 0:
		var distance = hex_distance(grid_q, grid_r, target.grid_q, target.grid_r)
		if distance <= 1:
			break  # Jetzt in Reichweite

		var dir_q = sign(target.grid_q - grid_q)
		var dir_r = sign(target.grid_r - grid_r)

		# keine Bewegung möglich (z. B. wenn dir_q/r = 0)
		if dir_q == 0 and dir_r == 0:
			break

		var next_q = grid_q + dir_q
		var next_r = grid_r + dir_r
		var world_pos = GridHelper.grid.axial_to_world(next_q, next_r)

		move_to_tile(next_q, next_r, world_pos)
		await get_tree().create_timer(0.4).timeout


	# Angriff, falls möglich
	if hex_distance(grid_q, grid_r, target.grid_q, target.grid_r) <= 1 and action_points > 0:
		var result = Combat.perform_attack(self, target, default_attack)

		if result.success:
			print("%s trifft %s! Schaden: %d (HP -%d / Armor -%d)" % [
				self.unit_name,
				target.unit_name,
				result.damage,
				result.hp_damage,
				result.armor_damage
			])
		else:
			print("%s verfehlt %s (Wurf %d / Chance %d%%)" % [
				self.unit_name,
				target.unit_name,
				result.hit_roll,
				result.hit_chance
			])
		use_action_point()
		await get_tree().create_timer(0.5).timeout

	SignalBus.emit_signal("turn_end", self)
