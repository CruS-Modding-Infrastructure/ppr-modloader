extends "_orig_Data.gd"

# QuestLoader changes

#Loads a single new or existing NPC
func load_npc(name, path):
	#Load existing NPC
	for i in NPCs:
		if name == i.data.n:
			var new_data = read_json_file(path)
			i.data.merge(new_data)
			
			#merge function only merges top level keys
			#so merge dialogue seperately
			i.data["offline_dialogue"].merge(new_data["offline_dialogue"])
			if i.data.has("online_dialogue"):
				i.data["online_dialogue"].merge(new_data["online_dialogue"])
			return
	#Load new NPC
	#Copied from init_people()
	#Todo: Add support for portraits
	var new_npc = NPC.new()
	new_npc.data = read_json_file(path)
	new_npc.portrait = portrait_placeholder
	if "items_owned" in new_npc.data:
		new_npc.starting_items = new_npc.data.items_owned
	if "tracked" in new_npc.data:
		new_npc.tracked = new_npc.data.tracked
	NPCs.append(new_npc)

#Load tasks from json
func load_tasks(path):
	print("loading tasks!")
	var task_data = read_json_file(path)
	var task
	for key in task_data:
		#Check for duplicates
		var no_duplicates = true
		for i in tasks:
			if i.id == key:
				no_duplicates = false
		
		if no_duplicates:
			#Copied from init_tasks()
			task = Task.new()
			task.id = key
			for k in task_data.get(key):
				task[k] = task_data.get(key).get(k)
			tasks.append(task)
			print("task", key, "added.")

# Weapons changes

class Player:
	var id = "Standard"
	var bodytype = "BodyMale1"
	var unlock_flag = ""
	var body_material = preload("res://Materials/Human/efp_material_mech_department.tres")
	var face_material = preload("res://Materials/Human/face_material_1.tres")
	var ammo_debt = 0
	var base_income = 300
	var op = 0
	var mz_level = 1
	var strength = 1
	var speed = 1
	var agility = 1
	var perception = 1
	var vitality = 1
	var bioenergy = 1
	var luck = 1
	var lack = 1
	var dna_damage = 0
	var cocaine = 0
	var cigarettes = 25
	var weapon_1 = null
	var weapon_2 = null
	var l_weapon = null
	var r_weapon = null
	var a_weapon = null
	var torso = null
	var head = null
	var arms = null
	var legs = null
	var slot_1 = null
	var slot_2 = null
	var mech_core = null
	var mech_armor = null
	var mech_legs = null
	var mech_engine = null
	var mech_slot_1 = null
	var mech_slot_2 = null
	var starting_items = {"Energy Drink": 2}
	
	# CHANGED: w: Weapon -> w
	func is_equipped(w):
		return w.id == l_weapon.id or w.id == r_weapon.id or w.id == a_weapon.id or w.id == weapon_1.id or w.id == weapon_2.id
		
	func get_strength():
		var s = strength
		for i in get_equipment():
			s += i.strength_bonus
		return s
	
	func get_luck():
		var s = luck
		for i in get_equipment():
			s += i.luck_bonus
		return s

	func get_description():
		var d = id + "\n"
		d += "Health: " + str(1.0 + vitality * 0.25, "\n")
		d += "Armor: " + str(get_armor(), "\n")
		d += "DNA Damage: " + str(dna_damage, "\n")
		d += "Cigarettes: " + str(cigarettes, "\n")
		d += "Toxic Resistance: " + str(vitality * 0.005 * 100, "%\n")
		d += "Heat Resistance: " + str(vitality * 0.005 * 100, "%\n")
		d += "DOR Resistance: " + str(lack * 0.005 * 100, "%\n\n")
		d += str("Weapon 1: ", weapon_1.id, "\n")
		d += str("Weapon 2: ", weapon_2.id, "\n")
		d += str("L Weapon: ", l_weapon.id, "\n")
		d += str("R Weapon: ", r_weapon.id, "\n")
		d += str("Aux Weapon: ", a_weapon.id, "\n\n")
		if head != null and head.id != "Empty":
			d += str(head.id, "\n")
		if torso != null:
			d += str(torso.id, "\n")
		if arms != null:
			d += str(arms.id, "\n")
		if legs != null:
			d += str(legs.id, "\n")
		if slot_1 != null:
			d += str(slot_1.id, "\n")
		if slot_2 != null:
			d += str(slot_2.id, "\n\n")
		if mech_core != null:
			d += str(mech_core.id, "\n")
		if mech_armor != null:
			d += str(mech_armor.id, "\n")
		if mech_engine != null:
			d += str(mech_engine.id, "\n")
		if mech_slot_1 != null:
			d += str(mech_slot_1.id, "\n")
		if mech_slot_2 != null:
			d += str(mech_slot_2.id, "\n\n")
		d += "Starting items:\n"
		for item in starting_items:
			d += item
			if starting_items[item] > 1:
				d += " x " + str(starting_items[item])
			d += "\n"
		
		return d
	
	func save(save_all = false):
		var d = {"id": id, 
			"type": "player", 
			"strength": strength, 
			"speed": speed, 
			"perception": perception, 
			"agility": agility, 
			"vitality": vitality, 
			"dna_damage": dna_damage, 
			"cigarettes": cigarettes, 
			"bioenergy": bioenergy, 
			"luck": luck, 
			"lack": lack, 
			"head": head.id, 
			"torso": torso.id, 
			"arms": arms.id, 
			"legs": legs.id, 
			"cocaine": cocaine, 
			"op": op, 
			"slot_1": slot_1.id, 
			"slot_2": slot_2.id, 
			"mech_core": mech_core.id, 
			"mech_armor": mech_armor.id, 
			"mech_legs": mech_legs.id, 
			"mech_engine": mech_engine.id, 
			"mech_slot_1": mech_slot_1.id, 
			"mech_slot_2": mech_slot_2.id, 
			"ammo_debt": ammo_debt, 
			"weapon_1": weapon_1.id, 
			"weapon_2": weapon_2.id, 
			"l_weapon": l_weapon.id, 
			"r_weapon": r_weapon.id, 
			"a_weapon": a_weapon.id, 
			"mz_level": mz_level, 
		}
		return d
	
	func get_level():
		return strength - 5 + speed - 5 + perception - 5 + vitality - 5 + luck - 5 - lack + agility - 5 + bioenergy - 5
	
	func get_level_cost():
		var x = get_level()
		
		return clamp(0.02 * pow(x, 3) + 3.06 * pow(x, 2) + 105.6 * x - 895, 1000, 999999)
	
	func get_level_cost_sim(level):
		var x = level
		
		return clamp(0.02 * pow(x, 3) + 3.06 * pow(x, 2) + 105.6 * x - 895, 1000, INF)
	
	func get_equipment():
		return [head, torso, arms, legs, slot_1, slot_2]
	
	func get_armor():
		var a = 0
		for e in get_equipment():
			a += e.armor
		return a
	
	func set_levels():
		strength = 99
		vitality = 99
		bioenergy = 99
		speed = 99
		perception = 99
		luck = 99
		lack = 99
		agility = 99
	func get_mech_parts():
		return [mech_core, mech_armor, mech_legs, mech_engine, mech_slot_1, mech_slot_2]
	func get_equipment_weight():
		return (torso.mass + legs.mass + head.mass + slot_1.mass + slot_2.mass)
	func get_mech_weight():
		return mech_core.mass + mech_armor.mass + mech_legs.mass + mech_engine.mass + mech_slot_1.mass + mech_slot_2.mass
	func get_total_load():
		var w = (get_mech_weight() - mech_legs.mass) / float(mech_legs.max_load)
		return float(w)
