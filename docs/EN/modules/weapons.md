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
recived_weapon - The new weapon that will be added to the game. Must be the `weapon` class for it to work correctly

`new_ammo() -> ammo`  
Returns a new ammo type

`add_ammo(recived_ammo : ammo) -> void`  
Adds a new ammo type to the game  
recived_ammo - The new ammo type that will be added to the game. Must be the `ammo` class for it to work properly
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

```python
class ammo:
	var id: String = "Pure void"
	var bullet_node = preload("res://Bullets/Bullet3D.tscn")
	var casing_node = preload("res://Gibs/Shell.tscn")
	var max_amount = 9999
	var amount_owned = 0
	var loadout = 0
	var local_load = 0
	
	var max_loadout = 2000
	var caseless = false
	var projectile_count: int = 1
	var accuracy_override: float = - 1
	var price: float = 14.5
	var piercing_ratio: float = 0.0
	var breaching = false
	var fire = false
	var bouncy = false
	var bounciness = 0.3
	var orgone_beam = false
	var air_burst = false
	var underwater = false
	var ricochet = false
	var guided = false
	var smart = false
	var timer = 0
	var explosive: float = false
	var toxic = false
	var toxic_damage = 0
	var non_lethal_damage = 0
	var explosive_charge: float = 0
	var dna_tracker = false
	var explosion_radius: float = 0
	var rocket = false
	var rope = false
	var recoil = 1.0
	var muzzle_flash = true
	var ammo_mass: float = 320
	var projectile_mass: float = 100
```