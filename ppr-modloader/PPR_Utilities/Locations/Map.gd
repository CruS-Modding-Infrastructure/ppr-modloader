extends "_orig_Map.gd"

onready var modded_map = preload("res://PPR_Utilities/Locations/ModdedMap.tscn")

func _ready():
	loc_list.clear()
	var i = 0
	for l in Dataset.locations:
		if not l.has_meta("modded"):
			if not l.spawn_points.empty() or Global.debug:
				loc_list.add_item(l.id)
				loc_list.set_item_metadata(i, l)
				i += 1

	loc_list.select(0)

	_on_Location_List_item_selected(0)

	if get_node("../..").name == "WindowDialog":
		if get_node_or_null("../ModdedMap") == null:
			var new_modded_map = modded_map.instance()
			get_parent().call_deferred("add_child", new_modded_map)
			get_parent().call_deferred("move_child", new_modded_map, 1)

func update_locations():
	loc_list.clear()
	var i = 0
	var l_i = 0
	for l in Dataset.locations:
		if not l.has_meta("modded"):
			if not l.spawn_points.empty() or Global.debug:
				loc_list.add_item(l.id)

				loc_list.set_item_metadata(i, l)
				if l.id == Dataset.current_location.id:
					loc_list.select(i)
					l_i = i
				i += 1
	_on_Location_List_item_selected(l_i)

func _on_Location_List_item_selected(index):
	spawn_list.clear()
	var l = loc_list.get_item_metadata(index)
	c_location = l
	var s_i = 0
	var i = 0
	if not l.has_meta("modded"):
		for s in l.spawn_points:
			spawn_list.add_item(s)
			if s == Dataset.current_spawn_point:
				s_i = i
			i += 1
	spawn_list.select(s_i)
	#_on_Spawn_List_item_selected(s_i)
	$VBoxContainer3 / PanelContainer3 / RichTextLabel.text = l.description
