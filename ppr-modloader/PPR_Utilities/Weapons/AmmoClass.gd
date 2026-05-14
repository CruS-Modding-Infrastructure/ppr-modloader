extends Node

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
