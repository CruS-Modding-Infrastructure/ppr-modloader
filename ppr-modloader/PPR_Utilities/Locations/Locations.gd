extends Node

onready var location_class = $LocationClass

func on_ready_locations_check():
	if Dataset.locations.size() != 0:
		var saves = Dataset.list_files_in_directory("user://")
		
		for save in saves:
			check_locations(save)
		
		$CheckTimer.stop()

func check_locations(recived_save_path):
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
		
		if data.has("type") and data.type == "location":
			var loaded_location = Dataset.get_by_id(Dataset.locations, data.id)
			
			if loaded_location == null:
				create_placeholder_location(data.id)
	
	save_game.close()

func create_placeholder_location(recived_location_id):
	var placeholder_location = location_class.location.new()
	
	placeholder_location.id = recived_location_id
	placeholder_location.description = "Edge of the world"
	placeholder_location.level = "res://PPR_Utilities/Locations/PlaceholderLocation.tscn"
	
	placeholder_location.set_meta("modded", true)
	placeholder_location.set_meta("deleted", true)
	
	Dataset.locations.append(placeholder_location)

func new_location():
	return location_class.location.new()

func add_location(recived_location):
	if PPRUtilities.enabled:
		recived_location.set_meta("modded", true)
		
		if Dataset.get_by_id(Dataset.locations, recived_location.id) != null:
			Dataset.locations.erase(Dataset.get_by_id(Dataset.locations, recived_location.id))

		Dataset.locations.append(recived_location)

var objects = {}
var weapons = {}

func spawn_object(recived_location_id, recived_path, recived_position, recived_rotation):
	if PPRUtilities.enabled:
		if not recived_location_id in objects:
			objects[recived_location_id] = []
		
		objects[recived_location_id].append([recived_path, recived_position, recived_rotation])

# Deprecated
func add_object(recived_location_id, recived_path, recived_position, recived_rotation):
	spawn_object(recived_location_id, recived_path, recived_position, recived_rotation)

func spawn_weapon(recived_location_id, recived_weapon_id, recived_position, recived_rotation):
	if PPRUtilities.enabled:
		if not recived_location_id in weapons:
			weapons[recived_location_id] = []
		
		weapons[recived_location_id].append([recived_weapon_id, recived_position, recived_rotation])

# Deprecated
func add_weapon(recived_location_id, recived_weapon_id, recived_position, recived_rotation):
	spawn_weapon(recived_location_id, recived_weapon_id, recived_position, recived_rotation)

func init_spawn_objects():
	if Dataset.current_location.id != null:
		if Dataset.current_location.id in objects:
			for i in objects[Dataset.current_location.id]:
				var new_object = load(i[0]).instance()
				
				Global.player.get_parent().add_child(new_object)
				
				new_object.global_position = i[1]
				new_object.rotation_degrees = i[2]
		
		if Dataset.current_location.id in weapons:
			for i in weapons[Dataset.current_location.id]:
				if Dataset.get_by_id(Dataset.weapons, i[0]) != null:
					var new_weapon = load("res://Gibs/Weapon_Item.tscn").instance()
					
					new_weapon.get_node("Weapon_Item").weapon_id = i[0]
					new_weapon.get_node("Weapon_Item").label_disabled = true
					
					Global.player.get_parent().add_child(new_weapon)
					
					new_weapon.global_position = i[1]
					new_weapon.rotation_degrees = i[2]
