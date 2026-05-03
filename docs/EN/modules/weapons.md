# Weapons
[Back](/docs/EN/main.md)

Note: Only the methods and classes of the module are described here
Module guides can be found on the main page

This module allows you to create your own weapons
# Methods

`new_weapon() -> weapon`  
Returns new weapons

`add_weapon(recived_weapon : weapon) -> void`  
Adds a new weapon to the game

recived_weapon: The new weapon that will be added to the game must be the `weapon` class for it to work correctly
# Classes:

```python
class weapon:

id: String = "Test weapon" # Weapon ID
ammo_type = null # Type of ammo used
mesh: Mesh = null # Weapon model
barrel_mesh: Mesh = null # Weapon barrel model
material = preload("res://Materials/gun_metal.tres") # Weapon Material
icon = preload("res://Icons/smg.png") # Icon
tracer_material = preload("res://Bullets/Tracer.tres")
sfx = preload("res://SFX/weapon_sfx/20mmrapid.wav")
fire_modes: Array = [true, false, false]
mods_installed: Array = ["Standard"]
current_mod = "Standard"
description = "???" # Weapon description in the menu
orgone = false # Weapons will use orgone instead of ammo
unlocked = false # Whether the default weapon is unlocked
price = 0 # The price of weapons in the store
revolver = false
universal = false
col_shape = null
melee = false
sp_ammo_types = null
single_use = false
purchase_flag = "NOFLAG"
giant = false
first_sale_day = 0
toxic_damage: float = 0.0
small_arm = false # Determines the type of weapon (for Mech or Player)
taser = false
ammo: float = 0
loadout = 1
spread: float = 0 # Weapon Spread
burst_count = 3
strength_req = 0
projectile_count: int = 1
aim_speed = 10.0
silenced = false
non_lethal = false
shield = false
ammo_cost: float = 14.5
magazine_size: float = 500
zoom_offset = true
explosive: float = false
explosive_charge: float = 0
fire_mode: int = AUTO
weapon_mass: float = 92 * 1000
energy: float = 1050
effective_range = 600
zoom_modifier = 1
ammo_mass: float = 320
mass: float = 100 # Weapon mass
rof: float = 0.01

var is_custom_weapon = false # Disables the original functionality of the weapon and allows you to load your own scene
	
var custom_weapon_scene = load("res://path_to/scene.tscn") # The scene that will be loaded if is_custom_weapon == True
	
var custom_weapon_flags = [] # Custom Weapon Flags

#Flags list:
#custom_fire - Use custom fire method do_shoot()
#custom_reload - Use the custom reload method do_reload()
#custom_mesh - Hides the original weapon model
#hide_status_label - Hides status label

func has_flag(recived_flag): # Checks if the weapon has a certain flag
	return custom_weapon_flags.has(recived_flag)
	
func set_flags(recived_flags: Array): # Sets flags for weapons
	custom_weapon_flags = recived_flags
```