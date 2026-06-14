extends Control

export var mod_id = "TriggeredP-ModPanelTest"

var mod_name = "ModPanelTest"
var mod_author = "TriggeredP"

func _ready():
	var mod_raw_name = mod_id.split("-")
	
	mod_author = mod_raw_name[0]
	mod_name = mod_raw_name[1]
	
	$"%Name".text = mod_name
	$"%Author".text = "Author: {0}".format([mod_author])
