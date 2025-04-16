extends Node

class location:
	var id = "Versten Residential"
	var level = "res://Levels/Locations/Helsinki.tscn"
	var description = "Funzone."
	
	# modded stuff
	var icon = null
	var icon_color = Color.white
	
	var spawn_points = []
	var indoors = false
	var items_picked_up = []
	var persistent_dead = []
	
	func save():
		var save_data = {
			"id": id, 
			"type": "location",
			"spawn_points": spawn_points, 
			"persistent_dead": persistent_dead, 
			"items_picked_up": items_picked_up
		}
		return save_data

func on_ready_locations_check():
	if Dataset.locations.size() != 0:
		var saves = Dataset.list_files_in_directory("user://")
		
		for save in saves:
			check_locations(save)
		
		$CheckTimer.stop()
		
		for level in Dataset.locations:
			print(level.id)
			print(level.level)

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
	var placeholder_location = location.new()
	
	placeholder_location.id = recived_location_id
	placeholder_location.description = "Edge of the world"
	placeholder_location.level = "res://PPR_Utilities/Locations/PlaceholderLocation.tscn"
	
	placeholder_location.set_meta("modded", true)
	placeholder_location.set_meta("deleted", true)
	
	Dataset.locations.append(placeholder_location)

func add_location(recived_location):
	recived_location.set_meta("modded", true)
	
	if Dataset.get_by_id(Dataset.locations, recived_location.id) != null:
		Dataset.locations.erase(Dataset.get_by_id(Dataset.locations, recived_location.id))

	Dataset.locations.append(recived_location)
