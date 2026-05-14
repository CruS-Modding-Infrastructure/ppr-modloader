extends Node

onready var weapon_class = $WeaponClass
onready var ammo_class = $AmmoClass

onready var blank_ammo_type = ammo_class.ammo.new()

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
