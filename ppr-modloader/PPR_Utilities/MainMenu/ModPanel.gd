extends Control

export var mod_id = "TriggeredP-ModPanelTest"

var mod_name = "ModPanelTest"
var mod_author = "TriggeredP"

func _ready():
	if mod_id != "PPR Utilities":
		var mod_raw_name = mod_id.split("-")
		
		mod_author = mod_raw_name[0]
		mod_name = mod_raw_name[1]
		
		$"%Name".text = mod_name
		$"%Author".text = "Author: {0}".format([mod_author])
	else:
		$"%Name".text = "PPR Utilities"
		$"%Author".text = "Author: -"
		$"%Version".text = "Version: 0.5"
		
		$"%Description".bbcode_text = "This is the modloader's core library.\n\nResponsible for handling weapons, items, locations, and other things.\nIt ensures compatibility between mods.\nSome big mods may require [color=red]disabling[/color] this library."
