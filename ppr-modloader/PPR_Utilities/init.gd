extends Node

onready var main_menu = $MainMenu
onready var locations = $Locations

const SCRIPT_EXTS: = {
	"res://Scripts/Info_Panel.gd": "res://PPR_Utilities/MainMenu/Info_Panel.gd",
	"res://Scripts/Map.gd": "res://PPR_Utilities/Locations/Map.gd",
}

var _scripts: = []

func _init() -> void:
	for k in SCRIPT_EXTS:
		var path_orig: String = k
		var path_new: String = SCRIPT_EXTS[k]

		var script_orig: Script = load(path_orig)

		if is_instance_valid(script_orig):
			script_orig.take_over_path(
				path_new.get_base_dir().plus_file("_orig_" + path_new.get_file())
			)

		var script_new: Script = load(path_new)

		if is_instance_valid(script_new):
			script_new.take_over_path(path_orig)

			_scripts.append(script_new)
