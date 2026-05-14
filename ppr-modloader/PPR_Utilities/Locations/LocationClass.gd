extends Node

class location:
	var id = "Versten Residential"
	var level = "res://Levels/Locations/Helsinki.tscn"
	var description = "Funzone."
	
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
	
	# modded stuff
	var icon = null
	var icon_color = Color.white
