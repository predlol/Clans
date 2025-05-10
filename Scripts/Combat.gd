extends Node
class_name Combat

## Diese Klasse enthält alle zentralen Kampfmechaniken wie Trefferwürfe, Schadensberechnung etc.

static func perform_attack(attacker: UnitBase, defender: UnitBase, attack_data: Dictionary) -> Dictionary:
	var result = {
		"success": false,
		"damage": 0,
		"armor_damage": 0,
		"hp_damage": 0,
		"hit_roll": 0,
		"hit_chance": 0
	}

	# Ressourcenverbrauch
	if attack_data.type == "physical":
		attacker.stats.stamina -= attack_data.stamina_cost
	elif attack_data.type == "magic":
		attacker.stats.focus -= attack_data.focus_cost

	# Skill-Werte abrufen
	var attacker_skill = attacker.stats.magic_attack if attack_data.type == "magic" else attacker.stats.attack_skill
	var defender_skill = defender.stats.magic_defense if attack_data.type == "magic" else defender.stats.defense_skill

	# Trefferchance berechnen
	var hit_chance = clamp(attacker_skill - defender_skill + attack_data.accuracy_modifier, 5, 95)
	var roll = randi_range(1, 100)

	result.hit_chance = hit_chance
	result.hit_roll = roll

	if roll <= hit_chance:
		result.success = true

		var raw_damage = attack_data.base_damage
		var armor_pen = attack_data.armor_penetration

		var armor_damage = int(raw_damage * armor_pen)
		var hp_damage = int(raw_damage * (1.0 - armor_pen))

		# Rüstung absorbiert zuerst Schaden
		defender.stats.armor -= armor_damage
		if defender.stats.armor < 0:
			hp_damage += abs(defender.stats.armor)
			defender.stats.armor = 0

		# Hier HP-Schaden anwenden (defender = UnitBase)
		if defender.has_method("apply_damage"):
			defender.apply_damage(hp_damage)
		else:
			push_error("Defender has no apply_damage() function!")

		result.damage = raw_damage
		result.armor_damage = armor_damage
		result.hp_damage = hp_damage

	return result
