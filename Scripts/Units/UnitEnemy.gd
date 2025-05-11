extends UnitBase

func _ready():
	super._ready()
	unit_name = "Enemy"
	is_enemy = true
	stats = StatTemplates.get_template("enemy_basic")
	hp = stats.max_hp
	movement_points = stats.max_movement_points
	action_points = stats.max_action_points

	health_bar.position = Vector3(0, 2.0, 0)
	health_bar.set_health(hp, stats.max_hp)

	print("READY: %s | grid (%d, %d), global: %s" % [unit_name, grid_q, grid_r, str(global_position)])
	play_idle()

	await get_tree().process_frame
	print("AFTER READY FRAME: %s | global_position: %s" % [unit_name, str(global_position)])
	if has_node("char"):
		print("CHAR: global: ", $char.global_transform.origin, ", local: ", $char.transform.origin)
	if has_node("ModelRoot"):
		print("ModelRoot: global: ", $ModelRoot.global_transform.origin, ", local: ", $ModelRoot.transform.origin)
	if has_node("ModelRoot"):
		print("ModelRoot: local = ", $ModelRoot.transform.origin, ", global = ", $ModelRoot.global_transform.origin)
	if has_node("char"):
		print("char: local = ", $char.transform.origin, ", global = ", $char.global_transform.origin)




func play_idle():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("mixamo_com")


func start_turn():
	action_points = stats.max_action_points
	movement_points = stats.max_movement_points

	print("--- %s ist am Zug ---" % unit_name)
	print("%s START TURN: grid (%d, %d), global_position: %s" % [unit_name, grid_q, grid_r, str(global_position)])

	call_deferred("_take_turn")


func _take_turn():
	await get_tree().create_timer(0.5).timeout

	var target = TurnManager.find_closest_player(self)
	if target == null:
		print("Kein Ziel gefunden.")
		SignalBus.emit_signal("turn_end", self)
		return

	print("→ Ziel: %s bei grid (%d, %d)" % [target.unit_name, target.grid_q, target.grid_r])
	print("→ Ich: %s bei grid (%d, %d), global: %s" % [unit_name, grid_q, grid_r, str(global_position)])

	while movement_points > 0:
		var distance = GridHelper.hex_distance(grid_q, grid_r, target.grid_q, target.grid_r)
		print("→ Distanz zum Ziel: %d | MP: %d" % [distance, movement_points])

		if distance <= 1:
			print("→ Bin in Reichweite, bewege mich nicht.")
			break

		var dir_q = sign(target.grid_q - grid_q)
		var dir_r = sign(target.grid_r - grid_r)

		if dir_q == 0 and dir_r == 0:
			print("→ Keine Richtung zum Ziel, abbrechen.")
			break

		var next_q = grid_q + dir_q
		var next_r = grid_r + dir_r

		var world_pos = GridHelper.axial_to_world(next_q, next_r)

		print("→ Versuche move_to_tile: (%d, %d) → (%d, %d), world: %s" % [
			grid_q, grid_r, next_q, next_r, str(world_pos)
		])

		await move_to_tile(next_q, next_r, world_pos)
		print("→ Nach Bewegung: grid (%d, %d), global: %s" % [grid_q, grid_r, str(global_position)])

	if GridHelper.hex_distance(grid_q, grid_r, target.grid_q, target.grid_r) <= 1 and action_points > 0:
		print("→ In Angriffsreichweite. Führe Angriff aus.")
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
	else:
		print("→ Nicht in Angriffsreichweite oder keine AP.")

	SignalBus.emit_signal("turn_end", self)
