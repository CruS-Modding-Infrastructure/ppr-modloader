extends "res://Scripts/Data.gd"

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


