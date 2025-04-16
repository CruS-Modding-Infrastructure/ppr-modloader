extends HBoxContainer

var c_location = "EFP HQ"
onready var loc_list = $VBoxContainer4 / PanelContainer4 / Location_List
onready var spawn_list = $VBoxContainer5 / PanelContainer4 / Spawn_List

onready var icon = preload("res://UI/map.png")

func _ready():
	connect("visibility_changed", self, "vis_changed")
	var i = 0
	for l in Dataset.locations:
		if l.has_meta("modded") and not l.has_meta("deleted"):
			if not l.spawn_points.empty() or Global.debug:
				loc_list.add_item(l.id)
				loc_list.set_item_metadata(i, l)
				i += 1
	loc_list.select(0)
	
	_on_Location_List_item_selected(0)

func vis_changed():
	update_locations()

func update_locations():
	loc_list.clear()
	var i = 0
	var l_i = 0
	
	for l in Dataset.locations:
		if l.has_meta("modded") and not l.has_meta("deleted"):
			if not l.spawn_points.empty() or Global.debug:
				loc_list.add_item(l.id)
				
				loc_list.set_item_metadata(i, l)
				if l.id == Dataset.current_location.id:
					loc_list.select(i)
					l_i = i
				i += 1
	
	_on_Location_List_item_selected(l_i)

func _on_Button_pressed():
	if loc_list.items.size() > 0:
		var i = 1
		while i < 100:
			yield (get_tree(), "physics_frame")
			i *= 1.15
			
			$VBoxContainer3 / HBoxContainer2 / PanelContainer2 / TextureProgress.value = i
		
		Dataset.current_location = c_location
		
		Global.goto_scene(Dataset.current_location.level)


func _on_Location_List_item_selected(index):
	spawn_list.clear()
	
	if loc_list.items.size() > 0:
		var l = loc_list.get_item_metadata(index)
		c_location = l
		var s_i = 0
		var i = 0
		
		if l.has_meta("modded") and not l.has_meta("deleted"):
			if l.icon != null:
				$VBoxContainer3/HBoxContainer/PanelContainer/PanelContainer.texture = l.icon
				$VBoxContainer3/HBoxContainer/PanelContainer/PanelContainer.modulate = l.icon_color
			else:
				$VBoxContainer3/HBoxContainer/PanelContainer/PanelContainer.texture = icon
				$VBoxContainer3/HBoxContainer/PanelContainer/PanelContainer.modulate = Color.red
			
			for s in l.spawn_points:
				spawn_list.add_item(s)
				if s == Dataset.current_spawn_point:
					s_i = i
				i += 1
			spawn_list.select(s_i)
			$VBoxContainer3 / PanelContainer3 / RichTextLabel.text = l.description

func _on_Spawn_List_item_selected(index):
	var s = spawn_list.get_item_text(index)
	if s != "Office":
		Dataset.current_spawn_point = s

func _on_Map_visibility_changed():
	spawn_list.clear()
	if loc_list.get_selected_items().size() != 0:
		var item = loc_list.get_selected_items()[0]
		var l = loc_list.get_item_metadata(item)
		c_location = l
		for s in l.spawn_points:
			spawn_list.add_item(s)
		spawn_list.select(0)
