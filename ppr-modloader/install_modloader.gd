extends MainLoop

const MODLOADER_VERSION: = "ppr-modloader-0.3"

# we put the modloader's overrides here so we don't mess with the user's overrides
const CFG_PATH: = "res://override_ppr-modloader.cfg"

const NEW_CONFIG: = {
	"debug": {
		"settings/stdout/print_fps": false, # stop spamming fps into console
		"gdscript/warnings/enable.release": false,
	},
}

const NEW_AUTOLOADS: = {
	PPRUtilities = "*res://PPR_Utilities/init.tscn",
	ModLoaderStore = "*res://addons/mod_loader/mod_loader_store.gd",
	ModLoader = "*res://addons/mod_loader/mod_loader.gd",
}

const NEW_GLOBALS: = [
	{
		"base": "Reference",
		"class": "JSONSchema",
		"language": "GDScript",
		"path": "res://addons/JSON_Schema_Validator/json_schema_validator.gd"
	},
	{
		"base": "Resource",
		"class": "ModConfig",
		"language": "GDScript",
		"path": "res://addons/mod_loader/resources/mod_config.gd"
	},
	{
		"base": "Resource",
		"class": "ModData",
		"language": "GDScript",
		"path": "res://addons/mod_loader/resources/mod_data.gd"
	},
	{
		"base": "Object",
		"class": "ModLoaderConfig",
		"language": "GDScript",
		"path": "res://addons/mod_loader/api/config.gd"
	},
	{
		"base": "Resource",
		"class": "ModLoaderCurrentOptions",
		"language": "GDScript",
		"path": "res://addons/mod_loader/resources/options_current.gd"
	},
	{
		"base": "Node",
		"class": "ModLoaderDeprecated",
		"language": "GDScript",
		"path": "res://addons/mod_loader/api/deprecated.gd"
	},
	{
		"base": "Node",
		"class": "ModLoaderLog",
		"language": "GDScript",
		"path": "res://addons/mod_loader/api/log.gd"
	},
	{
		"base": "Object",
		"class": "ModLoaderMod",
		"language": "GDScript",
		"path": "res://addons/mod_loader/api/mod.gd"
	},
	{
		"base": "Reference",
		"class": "ModLoaderModManager",
		"language": "GDScript",
		"path": "res://addons/mod_loader/api/mod_manager.gd"
	},
	{
		"base": "Resource",
		"class": "ModLoaderOptionsProfile",
		"language": "GDScript",
		"path": "res://addons/mod_loader/resources/options_profile.gd"
	},
	{
		"base": "Reference",
		"class": "ModLoaderSetupLog",
		"language": "GDScript",
		"path": "res://addons/mod_loader/setup/setup_log.gd"
	},
	{
		"base": "Reference",
		"class": "ModLoaderSetupUtils",
		"language": "GDScript",
		"path": "res://addons/mod_loader/setup/setup_utils.gd"
	},
	{
		"base": "Object",
		"class": "ModLoaderUserProfile",
		"language": "GDScript",
		"path": "res://addons/mod_loader/api/profile.gd"
	},
	{
		"base": "Node",
		"class": "ModLoaderUtils",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/mod_loader_utils.gd"
	},
	{
		"base": "Resource",
		"class": "ModManifest",
		"language": "GDScript",
		"path": "res://addons/mod_loader/resources/mod_manifest.gd"
	},
	{
		"base": "Resource",
		"class": "ModUserProfile",
		"language": "GDScript",
		"path": "res://addons/mod_loader/resources/mod_user_profile.gd"
	},
	{
		"base": "Reference",
		"class": "_ModLoaderCLI",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/cli.gd"
	},
	{
		"base": "Reference",
		"class": "_ModLoaderCache",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/cache.gd"
	},
	{
		"base": "Reference",
		"class": "_ModLoaderDependency",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/dependency.gd"
	},
	{
		"base": "Reference",
		"class": "_ModLoaderFile",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/file.gd"
	},
	{
		"base": "Object",
		"class": "_ModLoaderGodot",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/godot.gd"
	},
	{
		"base": "Reference",
		"class": "_ModLoaderPath",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/path.gd"
	},
	{
		"base": "Reference",
		"class": "_ModLoaderScriptExtension",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/script_extension.gd"
	},
	{
		"base": "Node",
		"class": "_ModLoaderSteam",
		"language": "GDScript",
		"path": "res://addons/mod_loader/internal/third_party/steam.gd"
	},
]


var install_errors: int = 0

func _initialize() -> void:
	pprml_print_step(
		"Installing mod loader version: " + MODLOADER_VERSION
	)

	# set our new override file location in the user's override.cfg
	pprml_handle_override()
	# insert new globals into the list of globals save it into our override file
	pprml_handle_globals()
	# insert new project settings into our override file
	pprml_handle_projsets()
	# insert new autoloads into our override file
	pprml_handle_autoloads()
	# create and copy necessary folders into the game's install folder
	pprml_handle_folders()

	if install_errors:
		pprml_print_step(
			"FAIL: %d errors encountered during installation!" % install_errors,
			true
		)
	else:
		pprml_print_step(
			"SUCCESS: Installation finished!"
		)

	# this is the only way to check for --no-window for some reason
	if VisualServer.get_video_adapter_name():
		OS.alert(
			"FAIL: %d errors encountered during installation!" % install_errors
			if install_errors
			else "Mod loader installed, please change your launch options back to normal, thanks!",
			"Psycho Patrol R Mod Loader Installer"
		)


func _idle(delta: float) -> bool:
	# force quit
	return true


func pprml_handle_override() -> void:
	var cfg: = ConfigFile.new()

	# ignore the override.cfg from ppr-modloader-0.2 and below
	# we should probably eventually remove this check in the future
	if File.new().get_md5("override.cfg") == "d46e58d08665d877f065f7b1e1226b69":
		pprml_print_step(
			"Found outdated override.cfg from versions ppr-modloader-0.2 or older"
		)
	else:
		# load the user's overrides
		cfg.load("override.cfg")

	if (
		cfg.has_section_key("application", "config/project_settings_override")
		and cfg.get_value("application", "config/project_settings_override") == CFG_PATH
	):
		pprml_print_step(
			"Override file was already set to \"%s\"!" % CFG_PATH
		)
		# don't mess with user's overrides unless we actually have to
		return

	cfg.set_value("application", "config/project_settings_override", CFG_PATH)

	var error: int = cfg.save("override.cfg")

	if error == OK:
		pprml_print_step(
			"Successfully set override file to: %s" % CFG_PATH
		)
	else:
		install_errors += 1
		pprml_print_step(
			"Failed to set override file to \"%s\"! Error: %d" % [CFG_PATH, error],
			true
		)


func pprml_handle_globals() -> void:
	var globals: Array = ProjectSettings.get_setting("_global_script_classes")

	# prevent duplicate entries
	var indices: = {}

	for i in len(globals):
		indices[globals[i].path] = i

	for dict in NEW_GLOBALS:
		if dict.path in indices:
			globals[indices[dict.path]] = dict
		else:
			globals.append(dict)

	var cfg: = ConfigFile.new()

	cfg.set_value("", "_global_script_classes", globals)

	var error: int = cfg.save(CFG_PATH)

	if error == OK:
		pprml_print_step("Successfully inserted new global classes:")

		for dict in NEW_GLOBALS:
			print("%s = %s" % [dict.class, dict.path])
	else:
		install_errors += 1
		pprml_print_step(
			"Failed to insert new global classes! Error: %d" % error,
			true
		)


func pprml_handle_projsets() -> void:
	var cfg: = ConfigFile.new()

	var error_load: int = cfg.load(CFG_PATH)

	if error_load != OK:
		install_errors += 1
		pprml_print_step(
			"Failed to load cfg file at %s! Error: %d" % [CFG_PATH, error_load],
			true
		)

	for section in NEW_CONFIG:
		for key in NEW_CONFIG[section]:
			cfg.set_value(section, key, NEW_CONFIG[section][key])

	var error_save: int = cfg.save(CFG_PATH)

	if error_save == OK:
		pprml_print_step("Successfully set new project settings:")

		for section in NEW_CONFIG:
			for key in NEW_CONFIG[section]:
				print("%s/%s = %s" % [section, key, str(NEW_CONFIG[section][key])])
	else:
		install_errors += 1
		pprml_print_step(
			"Failed to set new project settings! Error: %d" % error_save,
			true
		)


func pprml_handle_autoloads() -> void:
	# we don't use the ConfigFile class here because it can't save null values
	# setting an autoload's value to null allows the autoload order to be overriden

	var autoloads: = {}

	for prop in ProjectSettings.get_property_list():
		var name: String = prop.name

		if not name.begins_with("autoload/"):
			continue

		name = name.trim_prefix("autoload/")

		if name in NEW_AUTOLOADS:
			continue

		autoloads[name] = ProjectSettings.get_setting(prop.name)

	var content: String = ""

	# clear old autoloads by setting their value to null
	for name in autoloads:
		content += "%s=null\n" % name

	# insert new autoloads from the mod loader
	for name in NEW_AUTOLOADS:
		content += "%s=\"%s\"\n" % [name, NEW_AUTOLOADS[name].json_escape()]

	# insert old autoloads from the vanilla game
	for name in autoloads:
		content += "%s=\"%s\"\n" % [name, autoloads[name].json_escape()]

	# append our changes to the cfg file
	var file: = File.new()
	var error: int = file.open(CFG_PATH, File.READ_WRITE)
	if error == OK:
		file.seek_end()
		file.store_string("\n[autoload]\n\n" + content)
	file.close()

	if error == OK:
		pprml_print_step("Successfully set autoloads:")
		print(content.strip_edges())
	else:
		install_errors += 1
		pprml_print_step(
			"Failed to set autoloads! Error: %d" % error,
			true
		)


func pprml_handle_folders() -> void:
	var dir: = Directory.new()

	# go to working directory
	var error_open: int = dir.open(".")

	if error_open != OK:
		install_errors += 1
		pprml_print_step(
			"Failed to open working directory! Error: %d" % error_open,
			true
		)
		return

	# create an empty "mods" folder
	if dir.dir_exists("mods"):
		pprml_print_step("The \"mods\" folder already exists!")
	else:
		var error: int = dir.make_dir("mods")

		if error == OK:
			pprml_print_step("Created an empty \"mods\" folder!")
		else:
			pprml_print_step(
				"Failed to create a \"mods\" folder! Error: %d" % error,
				true
			)

	# get absolute paths
	var workingdir: String = OS.get_executable_path().get_base_dir()
	var basedir: String = get_script().resource_path.get_base_dir()

	if basedir.begins_with("res://"):
		basedir = workingdir.plus_file(basedir.trim_prefix("res://"))
	elif basedir.is_rel_path():
		basedir = ProjectSettings.globalize_path(basedir)

	# copy these folders into the working dir
	for foldername in [
		"PPR_Utilities",
		"addons/JSON_Schema_Validator",
		"addons/mod_loader",
	]:
		var from_path: String = basedir.plus_file(foldername)
		var into_path: String = workingdir.plus_file(foldername)

		if not dir.dir_exists(from_path):
			install_errors += 1
			pprml_print_step(
				"Error: The \"%s\" folder is missing!" % from_path,
				true
			)
			continue

		if dir.dir_exists(into_path):
			pprml_print_step(
				"The \"%s\" folder already exists, replacing contents..." % foldername
			)
			OS.move_to_trash(into_path)
		else:
			pprml_print_step(
				"Copying the \"%s\" folder..." % foldername
			)

		pprml_recursive_copy(from_path, into_path)

const ILLEGAL_FILENAMES: = {"": null, ".": null, "..": null}

func pprml_recursive_copy(from_path: String, into_path: String) -> void:
	# godot makes you implement this manually for some reason

	var dir: = Directory.new()

	var error: int = dir.open(from_path)

	if error != OK:
		install_errors += 1
		pprml_print_step(
			"Failed to open folder \"%s\"! Error: %d" % [from_path, error],
			true
		)
		return

	error = dir.make_dir_recursive(into_path)

	if error == OK:
		pass#print("Folder copied: %s" % from_path)
	else:
		install_errors += 1
		pprml_print_step(
			"Failed to copy folder \"%s\"! Error: %d" % [from_path, error],
			true
		)
		return

	dir.list_dir_begin()

	var filename: = "."

	while filename != "":
		filename = dir.get_next()

		if filename in ILLEGAL_FILENAMES:
			# stop infinite recursion
			continue

		var from_file: = from_path.plus_file(filename)
		var into_file: = into_path.plus_file(filename)

		if dir.current_is_dir():
			pprml_recursive_copy(from_file, into_file)
			continue

		error = dir.copy(from_file, into_file)

		if error == OK:
			print("File copied: %s" % from_file)
		else:
			install_errors += 1
			pprml_print_step(
				"Failed to copy file \"%s\"! Error: %d" % [from_file, error],
				true
			)


func pprml_print_step(msg: String, error:=false) -> void:
	print(
		"\u001b[91m" if error else "\u001b[95m",
		"[PPR-ModLoader Installer]\u001b[0m ",
		msg
	)
