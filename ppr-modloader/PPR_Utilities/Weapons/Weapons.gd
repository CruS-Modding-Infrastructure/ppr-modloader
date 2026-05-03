extends Node

enum {AUTO, SINGLE, BURST}

class weapon:
	var id: String = "Empty"
	var ammo_type = null
	var mesh: Mesh = null
	var barrel_mesh: Mesh = null
	var material = preload("res://Materials/gun_metal.tres")
	var icon = preload("res://Icons/smg.png")
	var tracer_material = preload("res://Bullets/Tracer.tres")
	var sfx = preload("res://SFX/weapon_sfx/20mmrapid.wav")
	var fire_modes: Array = [true, false, false]
	var mods_installed: Array = ["Standard"]
	var current_mod = "Standard"
	var description = "???"
	var orgone = false
	var unlocked = false
	var price = 0
	var revolver = false
	var universal = false
	var col_shape = null
	var melee = false
	var sp_ammo_types = null
	var single_use = false
	var purchase_flag = "NOFLAG"
	var giant = false
	var first_sale_day = 0
	var toxic_damage: float = 0.0
	var small_arm = false
	var taser = false
	var ammo: float = 0
	var loadout = 1
	var spread: float = 0
	var burst_count = 3
	var strength_req = 0
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
	var energy: float = 1050
	var effective_range = 600
	var zoom_modifier = 1
	var ammo_mass: float = 320
	var mass: float = 100
	var rof: float = 0.01
	
	# modded stuff
	
	# Disabling all original weapon functionality and load custom scene into it
	var is_custom_weapon = false 
	
	var custom_weapon_scene = null
	
	var custom_weapon_flags = []
		#custom_fire - use custom fire function
		#custom_reload - use custom reload function
		#custom_mesh - hides original meshes
		#hide_status_label - FALSE hide status label
	
	func has_flag(recived_flag):
		return custom_weapon_flags.has(recived_flag)
	
	func set_flags(recived_flags: Array):
		custom_weapon_flags = recived_flags
	
	func get_price(hostility):
		var p = price
		if hostility >= 75:
			p *= 2
		if hostility >= 90:
			p *= 10
		hostility = Global.f_norm(hostility, - 50, 50)
		return p * hostility
	
	func save():
		var d = Dictionary()
		d["id"] = id
		d["type"] = "weapon"
		d["unlocked"] = unlocked
		d["mods_installed"] = mods_installed
		d["current_mod"] = current_mod
		return d
	
	func get_total_mass() -> float:
		var t_mass = weapon_mass
		t_mass += ammo * ammo_mass
		return t_mass
	
	func get_description(shop = false, npc = null) -> String:
		var item_data = ""
		var muzzle_energy: float = 0
		var pmass = 0
		if ammo_type != null:
			muzzle_energy = 1.0 / 2.0 * ammo_type.projectile_mass * 0.001 * pow(energy, 2)
			pmass = ammo_type.projectile_mass
		if id == "Empty":
			return ""
		item_data += id + "\n\n"
		item_data += description + "\n\n"
		if strength_req > 0:
			item_data += str("Strength Requirement: ", strength_req, "\n")
		item_data += str("Weapon mass: ", weapon_mass / 1000.0) + " kg\n"
		item_data += str("Magazine size: ", magazine_size) + "\n"
		item_data += str("Projectile mass: ", pmass) + " g\n"
		item_data += str("Muzzle velocity: ", energy) + " m/s\n"
		item_data += str("Rate of fire: ", 60 / rof) + " rpm\n"
		item_data += str("Muzzle energy: ", muzzle_energy) + " J\n"
		item_data += str("Effective range: ", effective_range) + " m\n"
		return item_data

var weapons_init_ammo = []

func init_weapons_ammo():
	for raw_weapon in weapons_init_ammo:
		if raw_weapon.ammo_type == null:
			raw_weapon.ammo_type = "NA"
		
		var new_ammo_type = Dataset.get_by_id(Dataset.ammo_types, str(raw_weapon.ammo_type))
		raw_weapon.ammo_type = new_ammo_type
		print(raw_weapon.ammo_type)

func new_weapon():
	return weapon.new()

func add_weapon(recived_weapon):
	recived_weapon.set_meta("modded", true)
	
	if Dataset.get_by_id(Dataset.weapons, recived_weapon.id) != null:
		Dataset.weapons.erase(Dataset.get_by_id(Dataset.weapons, recived_weapon.id))

	Dataset.weapons.append(recived_weapon)
	weapons_init_ammo.append(recived_weapon)
