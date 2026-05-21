# My first mod
[Back](/docs/EN/main.md)

And so you decided to create your own mod for the game Psycho Patrol R 
This small guide should help in your endeavors

Psycho Patrol R is based on the **Godot v3.6 game engine**
# Important: use the right version of the engine
**Godot v3.6 is very different from Godot v4.0**

I highly advise you to read the Godot 3.6 documentation before you start creating your own mods for the game (It will also be nice to look at the guides if you are just a complete beginner)

All code in Godot is written in the GDScript programming language 
Without going into too much detail, this language is very similar to Python
# That's all well and good, but where do I start?

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