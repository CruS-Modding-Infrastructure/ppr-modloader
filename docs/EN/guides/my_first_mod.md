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

The first step is to decompile Psycho Patrol R 
At this point, we'll have the scripts, textures, and game models we'll be working with

To do this, use the Godot RE Tools

Next, download PPR Modloader and move the **addons** and **PPR_Utilities** folders to the folder with the decompiled Psycho Patrol R

Open **project.godot** in any text editor, look for the line `[autoload]` and insert these lines under it:

```
PPRUtilities="*res://PPR_Utilities/init.tscn"
ModLoaderStore="*res://addons/mod_loader/mod_loader_store.gd"
ModLoader="*res://addons/mod_loader/mod_loader.gd"
```

Close and save **project.godot**

Running Godot v3.6

Click the `Import` button and look for the decompiled Psycho Patrol R

After that, we can open the project and start creating mods
# Creating a basic mod