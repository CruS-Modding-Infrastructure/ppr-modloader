extends PanelContainer

onready var mod_panel = preload("res://PPR_Utilities/MainMenu/ModPanel.tscn")

var mods = []

onready var mod_list = $"%ModsList"
onready var mods_label = $"%ModsLabel"

func _ready():
	mods_list_update()

func mods_list_update():
	print("Updating mods list")
	mods = ModLoaderMod.get_mod_data_all()
	
	var i = 0
	
	for mod in mods:
		var new_mod_panel = mod_panel.instance()
		new_mod_panel.mod_id = mod
		$VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_mod_panel)
		
		i += 1
	
	mods_label.text = "Mods: " + str(i)
