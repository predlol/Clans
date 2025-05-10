extends Node
class_name AttackTemplates

static func get_template(template_name: String) -> Dictionary:
	match template_name:
		"default_melee":
			return {
				"name": "Standard Attack",
				"type": "physical",
				"subtype": "melee",
				"base_damage": 25,
				"armor_penetration": 0.2,
				"stamina_cost": 15,
				"focus_cost": 0,
				"range": 1,
				"accuracy_modifier": 0,
				"element": null
			}

		"bow_shot":
			return {
				"name": "Bow Shot",
				"type": "physical",
				"subtype": "ranged",
				"base_damage": 18,
				"armor_penetration": 0.1,
				"stamina_cost": 10,
				"focus_cost": 0,
				"range": 3,
				"accuracy_modifier": -5,
				"element": null
			}

		"fire_lance":
			return {
				"name": "Fire Lance",
				"type": "magic",
				"subtype": "projectile",
				"base_damage": 30,
				"armor_penetration": 0.4,
				"stamina_cost": 0,
				"focus_cost": 20,
				"range": 2,
				"accuracy_modifier": 0,
				"element": "fire"
			}

		_:
			push_warning("Unbekannte Attacke: " + template_name)
			return {}
