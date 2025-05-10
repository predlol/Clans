extends Node
class_name StatTemplates

static func get_template(template_name: String) -> Dictionary:
	match template_name:
		"clansman":
			return {
				"max_hp": 40,
				"armor": 30,
				"stamina": 120,
				"focus": 0,
				"attack_skill": 80,
				"defense_skill": 35,
				"magic_attack": 0,
				"magic_defense": 25,
				"willpower": 60,
				"resolve": 70,
				"initiative": 55,
				"max_movement_points": 3,
				"max_action_points": 1
			}
		"enemy_basic":
			return {
				"max_hp": 30,
				"armor": 30,
				"stamina": 80,
				"focus": 0,
				"attack_skill": 75,
				"defense_skill": 30,
				"magic_attack": 0,
				"magic_defense": 20,
				"willpower": 50,
				"resolve": 50,
				"initiative": 50,
				"max_movement_points": 3,
				"max_action_points": 1
			}
		"base":
			return {
				"max_hp": 30,
				"armor": 30,
				"stamina": 100,
				"focus": 30,
				"attack_skill": 30,
				"defense_skill": 30,
				"magic_attack": 30,
				"magic_defense": 30,
				"willpower": 30,
				"resolve": 30,
				"initiative": 30,
				"max_movement_points": 3,
				"max_action_points": 1
			}
		_:
			push_warning("Unbekanntes Stat-Template: " + template_name)
			return {}
