# Psycho Patrol R Mod Loader

## Installing the loader

1. Download the [latest release](https://github.com/CruS-Modding-Infrastructure/ppr-modloader/releases)
2. Extract the contents of the zip into your Psycho Patrol R installation folder  
You can access this folder from Steam by right-clicking the game in your library, then clicking Manage > Browse local files  
It is usually found at this path: `C:/Program Files (x86)/Steam/steamapps/common/Psycho Patrol R`
3. Run `_install_modloader.bat`
4. Start the game

## Uninstalling the loader

1. Delete the `override_ppr-modloader.cfg` file in the game's installation folder

## Installing mods

1. Place mod zip file into the `mods` folder  
(The mod zip file's name looks something like: `ExampleAuthor-ExampleModName-1.2.3.zip`)
3. Launch the game

## Uninstalling mods

1. Remove the mod zip file from the `mods` folder

## How to create mods

*Note: The following instructions are for mod developers only! If you just want to install mods, then you don't need to do anything below here!*

#### PPR-specific instructions for setting up a decompiled Godot project for modding:

Requirements:
- [Godot v3.6](https://godotengine.org/download/archive/3.6-stable/)
- [Godot RE Tools](https://github.com/GDRETools/gdsdecomp/releases)
- [Psycho Patrol R Mod Loader](https://github.com/CruS-Modding-Infrastructure/ppr-modloader/releases)
- [TrenchBroom v2023.1](https://github.com/TrenchBroom/TrenchBroom/releases/tag/v2023.1) (if you're planning on making custom levels)

Instructions:
1. Decompile the game's `psychopatrolr.pck` file using Godot RE Tools ([specific instructions here](https://wiki.godotmodding.com/guides/modding/tools/decompile_games/))
2. You should now have a decompiled Godot project for Psycho Patrol R, you should move its folder to somewhere that's easy to find later
3. Copy the `addons` folder and `PPR_Utilities` folder from the Psycho Patrol R Mod Loader into the decompiled project
4. Open the `project.godot` file with a text editor
5. Find the `[autoload]` line and paste these lines directly below it:
```ini
PPRUtilities="*res://PPR_Utilities/init.tscn"
ModLoaderStore="*res://addons/mod_loader/mod_loader_store.gd"
ModLoader="*res://addons/mod_loader/mod_loader.gd"
```
6. Save and close the `project.godot` file
7. Run the Godot v3.6 editor
8. Click the "Import" button and find the decompiled project's folder
9. "Psycho Patrol R" should now be added to the project list and you can open the project in the Godot editor from here

To update your project when PPR receives a new patch, you will have to repeat these instructions. Though make sure to backup your `mods-unpacked` folder beforehand and then move it into the new updated project afterwards.

## Using the Questloader
Quests can be created through exclusively the Tasks.json and NPC .json files, found in the NPCs folder.  
Create a file called `Tasks.json` containing all the quests you are planning on adding:
 ```
 {
  "Task Name":
   {
      "completion_flag": "flag_with_no_spaces",
      "full_name": "Full Task Name",
      "description": "Informative Description"
   }
 }
 ```
Copy the .json file of an existing NPC or create a file for a new NPC who will give you these quests:
 ```
{
  "n": "Lorenzo Visconti",
  ...
  "offline_dialogue":
  {
    "flag": "Task Name",
    "task": "Task Name",
    "line": "Eye Heart Wilheim Reich!"
  }
}
```
Putting your quests in the game ([with child nodes](https://wiki.godotmodding.com/guides/modding/global_classes_and_child_nodes/)):
```
var questLoader = get_node("/root/Dataset")

questLoader.load_tasks("/path/to/your/Tasks.json")
# Note: must be done for each NPC
questLoader.load_npc("/path/to/your/NPC.json")
```  

To learn about modding a Godot game, please read through the Godot Mod Loader wiki:  
https://wiki.godotmodding.com

To learn about Godot itself, please use the official Godot Docs:  
https://docs.godotengine.org/en/3.6/

IMPORTANT: Psycho Patrol R currently uses Godot v3.6, so make sure you're using documentation/guides/tutorials for Godot 3 and not Godot 4

## Credits

Made for [Psycho Patrol R](https://store.steampowered.com/app/1907590/Psycho_Patrol_R/)

Based on [Godot Mod Loader](https://github.com/GodotModding/godot-mod-loader)
