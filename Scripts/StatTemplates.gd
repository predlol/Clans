extends Node
class_name StatTemplates

static func get_template(template_name: String) -> Dictionary:
	match template_name:
		"clansman":
			return {
				"hp": 90,
				"armor": 50,
				"stamina": 120,
				"focus": 0,
				"attack_skill": 80,
				"defense_skill": 60,
				"magic_attack": 0,
				"magic_defense": 25,
				"willpower": 60,
				"resolve": 70,
				"initiative": 45
			}
		"enemy_basic":
			return {
				"hp": 40,
				"armor": 20,
				"stamina": 80,
				"focus": 0,
				"attack_skill": 45,
				"defense_skill": 35,
				"magic_attack": 0,
				"magic_defense": 15,
				"willpower": 30,
				"resolve": 30,
				"initiative": 55
			}
		"base":
			return {
				"hp": 60,
				"armor": 30,
				"stamina": 100,
				"focus": 50,
				"attack_skill": 50,
				"defense_skill": 40,
				"magic_attack": 40,
				"magic_defense": 30,
				"willpower": 50,
				"resolve": 50,
				"initiative": 50
			}
		_:
			push_warning("Unbekanntes Stat-Template: " + template_name)
			return {}
