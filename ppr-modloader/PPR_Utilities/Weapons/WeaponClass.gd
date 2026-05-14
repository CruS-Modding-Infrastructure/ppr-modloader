extends Node

enum {AUTO, SINGLE, BURST}

class weapon:
	var id: String = "V61 Hephaestus"
	var ammo_type = null
	var mesh: Mesh = preload("res://Models/Weapons/vulcan_body.obj")
	var barrel_mesh: Mesh = preload("res://Models/Weapons/vulcan_barrel.obj")
	var material = preload("res://Materials/gun_metal.tres")
	var icon = preload("res://Icons/smg.png")
	var tracer_material = preload("res://Bullets/Tracer.tres")
	var sfx = preload("res://SFX/weapon_sfx/20mmrapid.wav")
	var fire_modes: Array = [true, false, false]
	var mods_installed: Array = ["Standard"]
	var upgrade_ammo_types = []
	var current_mod = "Standard"
	var description = "???"
	var orgone = false
	var unlocked = false
	var price = 0
	var level = 1
	var level_velocity = 0.2
	var double_barrel = false
	var level_damage = 0.2
	var level_rof = 0
	var revolver = false
	var universal = false
	var col_shape = null
	var melee = false
	var sp_ammo_types = []
	var single_use = false
	var purchase_flag = "NOFLAG"
	var giant = false
	var arm_offset = Vector3(0.025, 0.04, - 0.341)
	var first_sale_day = 0
	var toxic_damage: float = 0.0
	var small_arm = false
	var taser = false
	var ammo: float = 0
	var ammo_modifier = 1.0
	var loadout = 1
	var spread: float = 0
	var burst_count = 3
	var strength_req = 0
	var luck_scaling = 0
	var projectile_count: int = 1
	var aim_speed = 10.0
	var silenced = false
	var non_lethal = false
	var shield = false
	var ammo_cost: float = 14.5
	var magazine_size: float = 500
	var zoom_offset = true
	var explosive: float = false
	var explosive_charge: float = 0
	var fire_mode: int = AUTO
	var weapon_mass: float = 92 * 1000
	var energy: float = 900
	var effective_range = 600
	var zoom_modifier = 1
	var ammo_mass: float = 320
	var mass: float = 100
	var rof: float = 0.01
	
	var machine_zone = false
	var mz_rarity = 0
	var mz_damage = 0
	var mz_a_damage = 0
	var mz_shot_count = 0
	var mz_accuracy = 0.9
	
	func get_icon():
		if self == Dataset.player_stats.l_weapon and self == Dataset.player_stats.r_weapon and self == Dataset.player_stats.a_weapon:
			return Dataset.lra_icon
		elif self == Dataset.player_stats.l_weapon and self == Dataset.player_stats.r_weapon:
			return Dataset.lr_icon
		elif self == Dataset.player_stats.l_weapon and self == Dataset.player_stats.a_weapon:
			return Dataset.la_icon
		elif self == Dataset.player_stats.r_weapon and self == Dataset.player_stats.a_weapon:
			return Dataset.ar_icon
		elif self == Dataset.player_stats.weapon_1 and self == Dataset.player_stats.weapon_2:
			return Dataset.onetwo_icon
		elif self == Dataset.player_stats.a_weapon:
			return Dataset.aux_icon
		elif self == Dataset.player_stats.l_weapon:
			return Dataset.l_icon
		elif self == Dataset.player_stats.r_weapon:
			return Dataset.r_icon
		elif self == Dataset.player_stats.weapon_1:
			return Dataset.one_icon
		elif self == Dataset.player_stats.weapon_2:
			return Dataset.two_icon
		else:
			return icon
	
	func get_ammo_types():
		var a_types = [ammo_type]
		a_types.append_array(sp_ammo_types)
		if level > 5 and not upgrade_ammo_types.empty():
			a_types.append(upgrade_ammo_types[0])
		if level > 10 and upgrade_ammo_types.size() > 1:
			a_types.append(upgrade_ammo_types[1])
		return a_types
		
	func get_price(hostility):
		var p = price
		if hostility >= 75:
			p *= 2
		if hostility >= 90:
			p *= 10
		hostility = Global.f_norm(hostility, - 50, 50)
		return p * hostility
	
	func save(save_all = false):
		var d = Dictionary()
		d["id"] = id
		d["type"] = "weapon"
		d["level"] = level
		d["unlocked"] = unlocked
		return d
	
	func get_total_mass() -> float:
		var t_mass = weapon_mass
		t_mass += ammo * ammo_mass
		return t_mass
	
	func calculate_damage(m, v, piercing_ratio, explosive = false):
		if not explosive:
			v *= 0.5
		var dmg: float = 1.0 / 2.0 * m * pow(v, 2.0)
		dmg /= 123100
		
		var p_dmg = dmg * piercing_ratio
		dmg -= p_dmg

		var no_a_dmg = false
		if piercing_ratio == 2.0:
			p_dmg *= 0.5
			dmg = 0
		else:
			p_dmg *= 0.75
		return ([dmg * 0.8, p_dmg * 0.8])
	
	func get_m_velocity(lvl):
		var t: = float(lvl - 1) / 10.0
		var m_velocity: float = energy * (1.0 + (sqrt(2.0) - 1.0) * t)
		
		if luck_scaling != 0:
			m_velocity += luck_scaling * Dataset.player_stats.luck
		return m_velocity
	
	func get_rof(lvl):
		var t: = float(lvl - 1) / 9.0
		var r: float = rof * (1.0 - 0.25 * t)
		return r

	func get_description(shop = false, npc = null, hint = false) -> String:
		var item_data = ""
		var muzzle_energy: float = 0
		var m_velocity: float = get_m_velocity(level)
		var pmass = 0
		if ammo_type != null:
			muzzle_energy = 1.0 / 2.0 * ammo_type.projectile_mass * 0.001 * pow(m_velocity, 2)
			pmass = ammo_type.projectile_mass
		if id == "Empty":
			return ""
		if level == 1:
			item_data += id + "\n"
		else:
			item_data += id + str(" +", level - 1) + "\n"
		item_data += "[color=#ff00ff]" + Dataset.get_weapon_type(self) + "[/color]\n\n"
		if not hint:
			item_data += description + "\n\n"
		if strength_req > 0:
			item_data += str("Strength Requirement: ", strength_req, "\n")
		item_data += "Damage:          "
		var regex = RegEx.new()
		regex.compile("(?![mm])[a-z\\s]")
		var colors = ["[color=lime]", "[color=red]", "[color=aqua]", "[color=pink]"]
		var i = 0
		
		for at in get_ammo_types():
			var at_id_shortened = regex.sub(at.id, "", true)
			if not melee:
				item_data += str(colors[i], at_id_shortened, " (", stepify(calculate_damage(at.projectile_mass, m_velocity, at.piercing_ratio)[0], 0.1) * projectile_count, ")[/color] ")
			else:
				item_data += str(colors[i], "MELEE", " (", stepify(calculate_damage(m_velocity, m_velocity, at.piercing_ratio)[0], 0.1) * projectile_count, ")[/color] ")
			i += 1
		i = 0
		item_data += "\nPiercing Damage: "
		var prc = false
		for at in get_ammo_types():
			var at_id_shortened = regex.sub(at.id, "", true)
			var pdmg = stepify(calculate_damage(at.projectile_mass, m_velocity, at.piercing_ratio)[1], 0.1) * projectile_count
			if pdmg > 0.0:
				prc = true
				item_data += str(colors[i], at_id_shortened, " (", pdmg, ")[/color] ")
			i += 1
		item_data += "\nExplosive Damage: "
		var expls = false
		i = 0
		for at in get_ammo_types():
			var at_id_shortened = regex.sub(at.id, "", true)
			var pdmg = stepify(calculate_damage(at.explosive_charge, at.explosive_charge, 0.0, true)[0], 0.1) * projectile_count
			if at.explosive_charge > 0.0:
				item_data += str(colors[i], at_id_shortened, " (", pdmg, ")[/color] ")
				expls = true
			i += 1
		if not prc:
			item_data = item_data.replace("\nPiercing Damage: ", " ")
		if not expls:
			item_data = item_data.replace("\nExplosive Damage: ", " ")
		
		
		item_data += "\n"
		if Dataset.player_stats.perception >= 50 and luck_scaling > 0:
			item_data += str("Luck Scaling: ", luck_scaling) + "\n"
		item_data += str("Weapon mass: ", weapon_mass / 1000.0) + " kg\n"
		if not melee:
			item_data += str("Magazine size: ", magazine_size) + "\n"
			item_data += str("Projectile mass: ", pmass) + " g\n"
			item_data += str("Muzzle velocity: ", round(m_velocity)) + " m/s\n"
			item_data += str("Rate of fire: ", stepify(60.0 / get_rof(level), 0.1)) + " rpm\n"
			item_data += str("Muzzle energy: ", round(muzzle_energy)) + " J\n"
			item_data += str("Effective range: ", effective_range) + " m\n"
		else:
			item_data += str("Range: ", effective_range) + " m\n"
		if hint:
			item_data = Dataset.strip_bbcode(item_data)
		return item_data
	
	# modded stuff
	
	# Disabling all original weapon functionality and load custom scene into it
	var is_custom_weapon = false 
	
	var custom_weapon_scene = null
	
	var custom_weapon_flags = []
	#custom_fire - use custom fire function
	#custom_reload - use custom reload function
	#custom_mesh - hides original meshes
	#hide_status_label - hide status label
	
	func has_flag(recived_flag):
		return custom_weapon_flags.has(recived_flag)
	
	func set_flags(recived_flags: Array):
		custom_weapon_flags = recived_flags
	
	var ammo_type_fix
	
	func set_ammo_type(recived_type):
		ammo_type_fix = recived_type
	
	func fix_ammo_type():
		ammo_type = Dataset.get_by_id(Dataset.ammo_types, ammo_type_fix)
