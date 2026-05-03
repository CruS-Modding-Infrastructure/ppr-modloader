extends Node

# TODO: Made a config file or something for disabling PPR Utils
# It's probably will be needed for big mods like online multiplayer and etc. (and maybe it's a huge mistake)
var enabled = true

onready var main_menu = $MainMenu
onready var locations = $Locations
onready var weapons = $Weapons

const SCRIPT_EXTS: = {
	"res://Scripts/Info_Panel.gd": "res://PPR_Utilities/MainMenu/Info_Panel.gd",
	"res://Scripts/Map.gd": "res://PPR_Utilities/Locations/Map.gd",
	"res://Scripts/Data.gd": "res://PPR_Utilities/QuestLoader/QuestLoader.gd",
	"res://Scripts_3D/Weapon.gd": "res://PPR_Utilities/Weapons/Custom_Weapon.gd"
	#"res://Original_script.gd": "res://Changed_script.gd"
}

const SCENE_EXTS: = {
	#"res://Original_scene.tscn": "res://Changed_scene.tscn",
}

# store references to scripts and scenes here so they wont be unloaded from memory
var _scripts: = []
var _scenes: = []

func _init() -> void:
	if enabled:
		init_scripts()
		init_scenes()

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
