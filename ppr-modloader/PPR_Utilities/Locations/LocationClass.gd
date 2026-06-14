extends Node

class location:
	var id = "Versten Residential"
	var level = "res://Levels/Locations/Helsinki.tscn"
	var description = "Funzone."
	var spawn_points = []
	var indoors = false
	var items_picked_up = []
	var persistent_dead = []
	var record = 240
	
	func save(save_all = false):
		var d = {"id": id, 
			"type": "location", 
		}
		if spawn_points != [] or save_all:
			d["spawn_points"] = spawn_points
		if persistent_dead != [] or save_all:
			d["persistent_dead"] = persistent_dead
		if items_picked_up != [] or save_all:
			d["items_picked_up"] = items_picked_up
		return d
	
	# modded stuff
	var icon = null
	var icon_color = Color.white
