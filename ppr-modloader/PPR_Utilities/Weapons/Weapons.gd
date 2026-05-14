extends Node

onready var weapon_class = $WeaponClass
onready var ammo_class = $AmmoClass

onready var blank_ammo_type = ammo_class.ammo.new()

var modded_weapons = []

func new_weapon():
	var new_weapon = weapon_class.weapon.new()
	return new_weapon

func add_weapon(recived_weapon):
	recived_weapon.set_meta("modded", true)
	
	if Dataset.get_by_id(Dataset.weapons, recived_weapon.id) != null:
		Dataset.weapons.erase(Dataset.get_by_id(Dataset.weapons, recived_weapon.id))
	
	if recived_weapon.ammo_type == null:
		recived_weapon.ammo_type = blank_ammo_type

	Dataset.weapons.append(recived_weapon)
	modded_weapons.append(recived_weapon)

func fix_ammo():
	for weapon in modded_weapons:
		weapon.fix_ammo_type()
	
	var saves = Dataset.list_files_in_directory("user://")
		
	for save in saves:
		check_weapons(save)

func check_weapons(recived_save_path):
	var save_game = File.new()
	
	if not save_game.file_exists("user://" + recived_save_path):
		print("Save file not found.")
		return 
	
	save_game.open("user://" + recived_save_path, File.READ)
	
	while save_game.get_position() < save_game.get_len():
		var data = parse_json(save_game.get_line())
		
		if typeof(data) != TYPE_DICTIONARY:
			print("ERROR: Wrong data type: " + str(typeof(data)))
			save_game.close()
			return 
		
		if data.has("type") and data.type == "weapon":
			var loaded_location = Dataset.get_by_id(Dataset.weapons, data.id)
			
			if loaded_location == null:
				create_placeholder_weapon(data.id)
	
	save_game.close()

func create_placeholder_weapon(recived_weapon_id):
	var placeholder_weapon = new_weapon()
	
	placeholder_weapon.id = recived_weapon_id
	placeholder_weapon.description = "A piece of scrap metal.\n\nIt looks like it was once a weapon \n(perhaps even a very powerful one)."
	
	placeholder_weapon.ammo_type = blank_ammo_type
	placeholder_weapon.set_ammo_type("NA")
	placeholder_weapon.melee = true
	
	placeholder_weapon.small_arm = true
	
	placeholder_weapon.mesh = load("res://Models/Weapons/ventman_organ.obj")
	placeholder_weapon.barrel_mesh = null
	placeholder_weapon.material = load("res://Materials/rheinstahl_material.tres")
	placeholder_weapon.sfx = load("res://SFX/weapon_sfx/dagger.wav")
	
	placeholder_weapon.weapon_mass = 1000
	placeholder_weapon.rof = 1.0
	
	placeholder_weapon.effective_range = 0.01
	
	placeholder_weapon.set_meta("modded", true)
	placeholder_weapon.set_meta("deleted", true)
	
	Dataset.weapons.append(placeholder_weapon)
