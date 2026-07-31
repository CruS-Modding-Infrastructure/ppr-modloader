extends Node

onready var item_class = $ItemClass

func on_ready_items_check():
	if Dataset.locations.size() != 0:
		var saves = Dataset.list_files_in_directory("user://")
		
		for save in saves:
			check_items(save)
		
		$CheckTimer.stop()

func check_items(recived_save_path):
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
		
		if data.has("type") and data.type == "item":
			var loaded_item = Dataset.get_by_id(Dataset.inventory, data.id)
			
			if loaded_item == null:
				create_placeholder_item(data.id)
	
	save_game.close()

func create_placeholder_item(recived_item_id):
	var placeholder_item = item_class.item.new()
	
	placeholder_item.id = recived_item_id
	placeholder_item.description = "This item gives you a strange feeling that it was once something else. Now it is useless."
	placeholder_item.mesh = preload("res://Models/Items/potato.obj")
	placeholder_item.material = preload("res://Materials/Items/Potato.tres")
	placeholder_item.icon = preload("res://Icons/Food.png")
	placeholder_item.weight = 20
	placeholder_item.toxicity = 0
	placeholder_item.fatigue = 0
	placeholder_item.common = true
	placeholder_item.healing = 0.0
	placeholder_item.grenade = false
	
	placeholder_item.set_meta("modded", true)
	placeholder_item.set_meta("deleted", true)
	
	Dataset.inventory.append(placeholder_item)

func new_item():
	return item_class.item.new()

func add_item(recived_item):
	if PPRUtilities.enabled:
		recived_item.set_meta("modded", true)
		
		if Dataset.get_by_id(Dataset.inventory, recived_item.id) != null:
			Dataset.inventory.erase(Dataset.get_by_id(Dataset.inventory, recived_item.id))

		Dataset.inventory.append(recived_item)
