# Locations
[Back](/docs/EN/main.md)

Note: Only the methods and classes of the module are described here
Module guides can be found on the main page

This module allows you to interact with the locations of the game
# Methods

`new_location() -> location`  
Returns a new location

`add_location(recived_location : location) -> void`  
Adds a new location to the game

recived_location: The new location that will be added to the game must be the `location` class for it to work correctly

`add_object(location_id: String, path: String, position: Vector3, rotation: Vector3) -> void`  
Adds an object to the list of loading objects of the location
When entering a location with this ID, it will spawn an object at the specified point
# Classes:

```python
class location:

id = "Test location" # Location ID, must be unique
level = "res://path_to/location.tscn" # Path to the Location Scene
description = "test :3" # Location descriptions

icon = null # Menu icon (Optional)
icon_color = Color.white # Icon color in the menu (Optional)

spawn_points = [] # Spawn points, the location will not be displayed in the menu if left empty
indoors = false # If True, the player spawns without mech
items_picked_up = []
persistent_dead = []
```