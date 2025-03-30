extends PanelContainer

var mods = []

onready var mod_list = $VBoxContainer/ModsList
onready var mods_label = $VBoxContainer/ModsLabel

func _ready():
	mods_list_update()

func mods_list_update():
	print("Updating mods list")
	mods = ModLoaderMod.get_mod_data_all()
	
	mod_list.clear()
	
	var i = 0
	for mod in mods:
		i += 1
		mod_list.add_item(str(i) + ": " + mod)
	
	mods_label.text = "Mods: " + str(i)
