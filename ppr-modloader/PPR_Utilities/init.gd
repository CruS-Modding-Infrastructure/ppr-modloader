extends Node

# TODO: Made a config file or something for disabling PPR Utils
# It's probably will be needed for big mods like online multiplayer and etc. (and maybe it's a huge mistake)
var enabled = false

onready var main_menu = $MainMenu
onready var locations = $Locations
onready var weapons = $Weapons
onready var items = $Items

var SCRIPT_EXTS: = {
	"res://Scripts/Info_Panel.gd": "res://PPR_Utilities/Remaps/Info_Panel.gd",
	"res://Scripts/Map.gd": "res://PPR_Utilities/Remaps/Map.gd",
	"res://Scripts/Data.gd": "res://PPR_Utilities/Remaps/Data.gd",
	"res://Scripts_3D/Weapon.gd": "res://PPR_Utilities/Remaps/Weapon.gd",
	#"res://Original_script.gd": "res://Remaped_script.gd"
}

var SCENE_EXTS: = {
	#"res://Original_scene.tscn": "res://Remaped_scene.tscn",
}

var config = {
	"enabled": true
}

func _init():
	load_config()
	
	if not enabled:
		SCRIPT_EXTS = {"res://Scripts/Info_Panel.gd": "res://PPR_Utilities/Remaps/Info_Panel.gd"}
		SCENE_EXTS = {}
	
	init_scripts()
	init_scenes()

func is_enabled():
	return enabled

var _scripts: = []
var _scenes: = []

func init_scripts():
	for k in SCRIPT_EXTS:
		var path_orig: String = k
		var path_new: String = SCRIPT_EXTS[k]

		var script_orig: Script = load(path_orig)

		if is_instance_valid(script_orig):
			script_orig.take_over_path(
				path_new.get_base_dir().plus_file("_orig_" + path_new.get_file())
			)

			_scripts.append(script_orig)

		var script_new: Script = load(path_new)

		if is_instance_valid(script_new):
			script_new.take_over_path(path_orig)

			_scripts.append(script_new)

func init_scenes():
	for k in SCENE_EXTS:
		var path_orig: String = k
		var path_new: String = SCENE_EXTS[k]

		var script_orig: PackedScene = load(path_orig)

		if is_instance_valid(script_orig):
			script_orig.take_over_path(
				path_new.get_base_dir().plus_file("_orig_" + path_new.get_file())
			)

			_scenes.append(script_orig)

		var scene_new: PackedScene = load(path_new)

		if is_instance_valid(scene_new):
			scene_new.take_over_path(path_orig)

			_scenes.append(scene_new)

func load_config():
	var config = ConfigFile.new()
	
	var err = config.load("user://modloader.cfg")

	if err != OK:
		save_config()
	else:
		enabled = config.get_value("PPR_Utilities", "enabled")

func save_config():
	var config = ConfigFile.new()

	config.set_value("PPR_Utilities", "enabled", enabled)

	config.save("user://modloader.cfg")
