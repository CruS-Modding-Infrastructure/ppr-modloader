extends Spatial

enum {AUTO, SINGLE, BURST}
enum w_slot{LEFT, RIGHT, AUX, INFANTRY}
export var weapon_slot = 0
export var turret = false
var fire_flag = false
var fire_mode = AUTO
var ammo_type
onready var fire_mode_index = fire_mode
var bullet: PackedScene = preload("res://Bullets/Bullet3D.tscn")
var weapon_owner = null
var hit_marker = preload("res://Bullets/hit_market.tscn")
var rocket = preload("res://Bullets/Bullet_Rocket.tscn")
var bullet_taser: PackedScene = preload("res://Bullets/BulletTaser.tscn")
var shell = preload("res://Gibs/Shell.tscn")
onready var body = $Body_Mesh
onready var barrel = $Body_Mesh / Barrel_Mesh
onready var shoot_pos = $Position3D
export var player = false
export var on_foot = false
export var sound_3d = true
export var weapon_id = "Vulcan"
export (Array, String) var random_weapons = []
export var ammo_label_offset: float = 0
export var manual_reload = false
onready var enemy_root = get_parent().get_parent().get_parent()
var audio = preload("res://Sound_Emitters/Weapon1.tscn")
var burst_shots = 0
var flash_counter = 0.0
var burst_velocity
var burst_ignore
var b_count = 3
var mag_shots_fired = 0
var health = 100
var ammo_setup = true
onready var firemode_label = $CanvasLayer / VBoxContainer / Firemode_Label
onready var ammo_label = $CanvasLayer / VBoxContainer / Ammo_Label
onready var magazine_label = $CanvasLayer / VBoxContainer / Magazine_Label
onready var ammo_label_pos = $Body_Mesh / Ammo_Label_Pos
onready var weapon_mod = Dataset.weapon_mods[0]
var destroyed = false
onready var weapon_type = Dataset.weapons[0]
var ammo = 0
var audio_players = []
var armor = 0
var mag_ammo = 0
var max_ammo = 0
var timer = 0
var reload_timer = 0
var rot_vel = 0
var sound_area = preload("res://Noise_Area.tscn")
var sound_area_node: Area
var shells: Array = []
export var hide = false
var max_shell_count = 10
var current_ammo_type = 0

var modded = false
var is_custom_weapon = false

var custom_weapon_scene = null

func init_custom_weapon():
	modded = weapon_type.has_meta("modded")
	
	if is_instance_valid(custom_weapon_scene):
		if custom_weapon_scene.has_method("on_drop"):
			custom_weapon_scene.on_drop()
		custom_weapon_scene.queue_free()
	
	if modded:
		is_custom_weapon = weapon_type.is_custom_weapon
		
		if is_custom_weapon:
			if weapon_type.custom_weapon_scene != null:
				custom_weapon_scene = weapon_type.custom_weapon_scene.instance()
				add_child(custom_weapon_scene)
			
			if weapon_type.has_flag("custom_mesh"):
				body.mesh = null
				barrel.mesh = null
			
			if weapon_type.has_flag("hide_status_label"):
				$CanvasLayer.hide()
	else:
		is_custom_weapon = false

func swap_ammo():
	if weapon_type.sp_ammo_types != null:
		var ammo_types: Array = weapon_type.sp_ammo_types.duplicate()
		ammo_types.invert()
		ammo_types.append(weapon_type.ammo_type)
		ammo_types.invert()
		
		current_ammo_type += 1
		current_ammo_type = wrapi(current_ammo_type, 0, ammo_types.size())
		ammo_type = ammo_types[current_ammo_type]
		match_fire_mode_label()

var new_audio

func damage(v: Vector3 = Vector3.ZERO, mass: float = 0, p_ratio = 0.0):
	_reduce_health(((v.length() - armor) * mass) / 10000, v)

func set_fire_mode():
	fire_mode_index = wrapi(fire_mode_index + 1, AUTO, BURST + 1)
	
	if weapon_type.fire_modes[fire_mode_index] or weapon_mod.fire_modes[fire_mode_index]:
		fire_mode = fire_mode_index
		
	else:
		set_fire_mode()
	match_fire_mode_label()

func match_fire_mode_label():
	match fire_mode:
		AUTO:
			firemode_label.text = "A"
			firemode_label.modulate = Color(1, 0, 0)
		SINGLE:
			firemode_label.text = "S"
			firemode_label.modulate = Color(0, 1, 0)
		BURST:
			firemode_label.text = "B"
			firemode_label.modulate = Color(1, 1, 0)
	firemode_label.text += "\n" + ammo_type.id

func _reduce_health(d, v):
	health -= d
	if health <= 0:
		body.hide()
		barrel.hide()
		destroyed = true

func _ready():
	if weapon_id == "random":
		randomize()
		weapon_id = random_weapons[randi() % random_weapons.size()]
	if player:
		sound_area_node = sound_area.instance()
		max_shell_count = 10
		add_child(sound_area_node)
		sound_area_node.set_as_toplevel(true)
		sound_area_node.global_transform.origin = global_transform.origin
		$Orgone_Ray.set_collision_mask_bit(3, 0)
	else:
		$Orgone_Ray.set_collision_mask_bit(4, 0)
		$Body_Mesh / KinematicBody.queue_free()
		set_process_input(false)
		set_process_unhandled_input(false)
	if sound_3d:
		new_audio = audio.instance()
		add_child(new_audio)
		new_audio.global_transform.origin = global_transform.origin
		new_audio.bus = "Gunshots"
		new_audio.attenuation_filter_db = 0
		new_audio.attenuation_filter_cutoff_hz = 500
		new_audio.unit_size = 100
	else:
		new_audio = AudioStreamPlayer.new()
		new_audio.bus = "Gunshots"
		add_child(new_audio)
	$Energy_Ray.visible = false
	$Energy_Ray.scale.x = 0
	new_audio.stream = weapon_type.sfx
	
	ammo_label_pos.translation.x += ammo_label_offset
	if ammo_label_offset == 0:
		$CanvasLayer.hide()
		set_process(false)
	if weapon_id != "Vulcan" and not player:
		for w in Dataset.weapons:
			if w.id == weapon_id:
				weapon_type = w
	if not hide:
		barrel.mesh = weapon_type.barrel_mesh
		barrel.material_override = weapon_type.material
		body.mesh = weapon_type.mesh
		body.material_override = weapon_type.material
	else:
		barrel.mesh = null
		body.mesh = null
	fire_mode = weapon_type.fire_mode
	ammo_type = weapon_type.ammo_type
	if ammo_type == null:
		ammo_type = Dataset.ammo_types[0]
	armor = weapon_type.weapon_mass
	if not player:
		ammo = weapon_type.ammo
		mag_ammo = weapon_type.magazine_size
		set_process_input(false)
		set_process_unhandled_input(false)
		set_process_unhandled_key_input(false)
	if player:
		weapon_mod = Dataset.get_mod(weapon_type.current_mod)
		if weapon_type.giant:
			weapon_type.barrel_mesh = load("res://Models/mech_arm.obj")
		if weapon_mod.fire_mode != null:
			body.material_override = weapon_mod.material
			barrel.material_override = weapon_mod.material
			fire_mode_index = weapon_mod.fire_mode
			fire_mode = fire_mode_index
		match_fire_mode_label()
	
	init_custom_weapon()
	
func _physics_process(delta):
	flash_counter -= delta
	if flash_counter <= 0:
		shoot_pos.hide()
	else:
		shoot_pos.rotation.z = rand_range( - PI, PI)
		shoot_pos.show()
	if manual_reload and not Global.player_inf.dual_wield and not Global.player_inf.disabled:
		if not Input.is_action_pressed("RELOAD"):
			$CanvasLayer / VBoxContainer / Reload.visible = false
			$Reload_Sound.stop()
		elif not weapon_type.melee and not weapon_type.orgone:
			if mag_ammo < weapon_type.magazine_size:
				$CanvasLayer / VBoxContainer / Reload.modulate = Color(1, 0, 0)
			else:
				$CanvasLayer / VBoxContainer / Reload.modulate = Color(0, 1, 0)
			$CanvasLayer / VBoxContainer / Reload.visible = true
		body.rotation.x = lerp(body.rotation.x, 0, delta * 10)
		body.rotation.x = clamp(body.rotation.x, - 0.7, 0.7)
		if body.rotation.x < - 0.5 and mag_ammo < weapon_type.magazine_size and ammo > 0:
			reload_timer = 0
			$Reload_Complete.play()
			ammo = clamp(ammo, 0, 100000)
			if ammo >= weapon_type.magazine_size:
				ammo -= (weapon_type.magazine_size - mag_ammo)
				mag_ammo = weapon_type.magazine_size
			elif ammo > 0:
				var ammo_left = mag_ammo
				mag_ammo = ammo + mag_ammo
				mag_ammo = clamp(mag_ammo, 0, weapon_type.magazine_size)
				ammo -= mag_ammo - ammo_left
			if weapon_type.revolver:
				for n in mag_shots_fired:
					var n_shell = shell.instance()
					add_child(n_shell)
					n_shell.set_as_toplevel(true)
					shells.append(n_shell)
					if shells.size() > max_shell_count:
						shells[0].queue_free()
						shells.remove(0)
					n_shell.id = ammo_type.id + " Casing"
					n_shell.global_transform.origin = $Body_Mesh / ShellPos.global_transform.origin
					n_shell.velocity = - ($Body_Mesh / ShellPos.global_transform.origin - $Body_Mesh / ShellPos.to_global(Vector3.RIGHT)).normalized() * rand_range(0, 1)
			mag_shots_fired = 0
		elif body.rotation.x > 0.5 and mag_ammo > 0:
			$Reload_Complete.play()
			for n in clamp(mag_ammo, 0, 30):
				var n_shell = shell.instance()
				add_child(n_shell)
				n_shell.set_as_toplevel(true)
				shells.append(n_shell)
				if shells.size() > max_shell_count:
					shells[0].queue_free()
					shells.remove(0)
				n_shell.id = ammo_type.id + " Casing"
				n_shell.global_transform.origin = $Body_Mesh / ShellPos.global_transform.origin
				n_shell.velocity = - ($Body_Mesh / ShellPos.global_transform.origin - $Body_Mesh / ShellPos.to_global(Vector3.FORWARD)).normalized() * rand_range(1, 10)
			mag_ammo = 0
	timer -= delta
	
	if not manual_reload:
		reload_timer -= delta
	if not player:
		ammo = 10000
	if reload_timer <= 0 and mag_ammo <= 0 and not manual_reload and ammo > 0:
		$Reload_Complete.play()
		if ammo > weapon_type.magazine_size:
			mag_ammo = weapon_type.magazine_size
		else:
			mag_ammo = ammo
		if player:
			ammo -= weapon_type.magazine_size
			ammo = clamp(ammo, 0, 1000)
	rot_vel -= delta * 100
	rot_vel = clamp(rot_vel, 0, 100)
	if not weapon_type.giant:
		barrel.rotation.z -= rot_vel * delta
	else:
		barrel.rotation.z = 0
	timer = clamp(timer, 0, 1000)
	reload_timer = clamp(reload_timer, 0, 1000)
	b_count = weapon_type.burst_count
	if weapon_mod.burst_count != null:
		b_count = weapon_mod.burst_count
	burst_shots = clamp(burst_shots, 0, b_count)
	if not player and weapon_type.orgone:
		$Energy_Ray.scale.x = lerp($Energy_Ray.scale.x, 0, delta * 15)
		$Energy_Ray.scale.y = $Energy_Ray.scale.x
		$Energy_Ray.visible = $Energy_Ray.scale.x > 0.01
		$Energy_Ray / OmniLight.omni_range = $Energy_Ray.scale.x * 100
	if burst_shots > 0:
		
		shoot(burst_velocity, burst_ignore)
	if player and weapon_type != Dataset.empty_weapon:
		
		if body.mesh != null:
			var pos = body.mesh.get_aabb().get_center().z - body.mesh.get_aabb().size.z / 2
			if barrel.mesh != null:
				pos = barrel.mesh.get_aabb().get_center().z - barrel.mesh.get_aabb().size.z / 2
			$Position3D.transform.origin.z = pos
			$Energy_Ray.transform.origin.z = pos

func _process(delta):
	var camera = get_viewport().get_camera()
	body.transform.origin.z = lerp(body.transform.origin.z, 0.126, delta * 10)
	sound_area_node.global_transform.origin = global_transform.origin
	if ammo <= 0 or weapon_type.melee or weapon_type.orgone:
		ammo_label.hide()
	else:
		ammo_label.show()
		
	ammo_label.text = str(ammo)
	magazine_label.text = str(mag_ammo)
	ammo_label.get_parent().visible = visible
	
	if visible:
		$Energy_Ray.scale.x = lerp($Energy_Ray.scale.x, 0, delta * 15)
		$Energy_Ray.scale.y = $Energy_Ray.scale.x
		$Energy_Ray.visible = $Energy_Ray.scale.x > 0.01
		$Energy_Ray / OmniLight.omni_range = $Energy_Ray.scale.x * 100
		if not camera.is_position_behind(ammo_label_pos.global_transform.origin):
			var dist = global_transform.origin.distance_to(Global.target.global_transform.origin)
			ammo_label.get_parent().rect_position = camera.unproject_position(ammo_label_pos.global_transform.origin)
			ammo_label.get_parent().visible = dist < 5
	
func set_weapon(w):
	weapon_type = w
	
	if not hide:
		barrel.mesh = weapon_type.barrel_mesh
		if weapon_type.giant:
			barrel.material_override = Dataset.get_by_id(Dataset.weapons, "V16").material
			barrel.mesh = load("res://Models/mech_arm.obj")
		else:
			barrel.material_override = weapon_type.material
		body.mesh = weapon_type.mesh
		body.material_override = weapon_type.material
	else:
		barrel.mesh = null
		body.mesh = null
	ammo_type = weapon_type.ammo_type
	if ammo_type == null:
		ammo_type = Dataset.ammo_types[0]
	if player:
		if weapon_type.shield:
			$Body_Mesh / KinematicBody / CollisionShape.shape = weapon_type.col_shape
			$Body_Mesh / KinematicBody / CollisionShape.disabled = false
			$Body_Mesh / KinematicBody.set_collision_layer_bit(3, 1)
			$Body_Mesh / KinematicBody / CollisionShape.visible = true
		else:
			$Body_Mesh / KinematicBody.set_collision_layer_bit(3, 0)
			$Body_Mesh / KinematicBody / CollisionShape.visible = false
		if ammo_setup:
			ammo = clamp(weapon_type.magazine_size * 3 * weapon_type.loadout, 0, 1000)
			mag_ammo = clamp(weapon_type.magazine_size, 0, ammo)
			ammo -= mag_ammo
			ammo = clamp(ammo, 0, 1000)
			ammo_setup = false
		else:
			ammo = clamp(weapon_type.magazine_size * 2 * weapon_type.loadout, 0, 500)
		if on_foot:
			ammo = clamp(weapon_type.magazine_size * 2, 0, 500)
		max_ammo = weapon_type.ammo

	fire_mode = weapon_type.fire_mode
	
	if player:
		if weapon_type.single_use:
			ammo = 0
		weapon_mod = Dataset.get_mod(weapon_type.current_mod)
		if weapon_mod.fire_mode != null:
			fire_mode_index = weapon_mod.fire_mode
			fire_mode = fire_mode_index
		match_fire_mode_label()
	reload_timer = 0
	match_fire_mode_label()
	
	init_custom_weapon()

func shoot(velocity: Vector3 = Vector3.ZERO, ignore: KinematicBody = KinematicBody.new()):
	if modded and weapon_type.has_flag("custom_fire") and custom_weapon_scene.has_method("on_shoot"):
		custom_weapon_scene.on_shoot()
		return Vector3.ZERO
	
	rot_vel += 5
	
	if timer > 0 or reload_timer > 0 or destroyed or (rot_vel < 50 and barrel.mesh != null and not weapon_type.giant):
		return Vector3.ZERO
	if weapon_type.orgone and Global.target.orgone <= 0:
		return Vector3.ZERO
		
	if weapon_type.melee:
		timer += weapon_type.rof
		body.transform.origin.z = - 0.8
		body.rotation.x = - 0.5
		if player:
			var n_audio = new_audio.duplicate()
			n_audio.stream = weapon_type.sfx
			if max_ammo > 0 and player:
				if not weapon_type.orgone:
					n_audio.pitch_scale = mag_ammo / weapon_type.magazine_size * 0.5 + 0.5
				else:
					n_audio.pitch_scale = min(weapon_owner.orgone, weapon_type.energy) / weapon_type.energy * 0.5 + 0.75
			add_child(n_audio)
			n_audio.play()
			audio_players.append(n_audio)
			var ap: Array = []
			ap.append_array(audio_players)
			for a in ap:
				if not a.is_playing():
					a.queue_free()
					ap.remove(ap.find(a))
			audio_players = ap
		if $Orgone_Ray.is_colliding():
			var col = $Orgone_Ray.get_collider()
			
			var col_point = $Orgone_Ray.get_collision_point()
			if global_transform.origin.distance_to(col_point) < weapon_type.effective_range:
				$Melee_Audio.play()
				if col.get_collision_layer_bit(0):
						Global.target.velocity -= - (shoot_pos.global_transform.origin - shoot_pos.to_global(Vector3.FORWARD)) * weapon_type.energy / 100
				if col.has_method("damage"):
					var t_a = true
					var bv: Vector3 = - (shoot_pos.global_transform.origin - shoot_pos.to_global(Vector3.FORWARD)) * weapon_type.energy
					
					
					if "vehicle" in col:
						if "target_acquired" in col.vehicle:
							if not col.vehicle.target_acquired:
								t_a = false
								bv *= 1.5
					if player:
						var hm = hit_marker.instance()
						add_child(hm)
						hm.set_as_toplevel(true)
						hm.global_transform.origin = $Energy_Ray / Orgone_Hit.global_transform.origin
					if weapon_type.non_lethal:
						if not t_a:
							col.non_lethal_damage(100)
						else:
							col.non_lethal_damage(50)
					else:
						col.damage(bv, weapon_type.energy)
		return (Vector3.ZERO)
	if fire_mode == BURST and burst_shots == 0:
		burst_shots += b_count
		burst_velocity = velocity
		burst_ignore = ignore
	if burst_shots > 0:
		burst_shots -= 1
	timer += weapon_type.rof
	if fire_mode == SINGLE and not player:
		timer += weapon_type.rof
	if not weapon_type.orgone:
		mag_ammo -= 1
	if player:
		
		Dataset.player_stats.ammo_debt += ammo_type.price
		ammo_type.amount_owned -= 1
	if player and not weapon_type.silenced:
		
		
		for b in sound_area_node.in_range:
			if b.has_method("alert"):
				b.alert(Global.target.global_transform.origin, true)
	body.transform.origin.z = 0.3
	if mag_ammo <= 0 and not weapon_type.orgone:
		
		reload_timer += 1
	
	var total_bv = Vector3.ZERO
	
	if not weapon_type.orgone:
		for b in ammo_type.projectile_count:
			var new_bullet
			if not weapon_type.taser and not ammo_type.rocket:
				new_bullet = ammo_type.bullet_node.instance()
				add_child(new_bullet)
			elif ammo_type.rocket:
				new_bullet = rocket.instance()
				add_child(new_bullet)
			else:
				
				new_bullet = bullet_taser.instance()
				add_child(new_bullet)
				new_bullet.start_pos = shoot_pos
			if player:
				new_bullet.set_collision_mask_bit(4, 1)
				new_bullet.player_bullet = true
				$Energy_Ray.visible = false
			else:
				if turret:
					new_bullet.set_collision_mask_bit(4, 1)
				new_bullet.set_collision_mask_bit(3, 1)
			if ammo_type.explosive:
				new_bullet.explosive = true
			if not weapon_type.taser:
				new_bullet.toxic_damage = weapon_type.toxic_damage
			new_bullet.set_as_toplevel(true)
			new_bullet.weapon_type = weapon_type
			new_bullet.ammo_type = ammo_type
			if not weapon_type.taser:
				new_bullet.set_tracer_material(weapon_type.tracer_material)
			new_bullet.add_collision_exception_with(ignore)
			var e = weapon_type.energy
			if weapon_mod != null:
				e *= weapon_mod.energy_bonus
				if weapon_mod.sub_sonic:
					e = clamp(e, 0, 200)
				if weapon_mod.explosive:
					new_bullet.explosive = true
			if ammo_type.rocket:
				new_bullet.rocket = true
				
			var bv: Vector3 = shoot_pos.global_transform.origin - shoot_pos.to_global((Vector3.FORWARD) * (weapon_type.energy))
			bv = bv.rotated(Vector3.UP, rand_range( - weapon_type.spread, weapon_type.spread))
			bv = bv.rotated(shoot_pos.global_transform.origin - shoot_pos.to_global(Vector3.LEFT), rand_range( - weapon_type.spread, weapon_type.spread))
			
			total_bv += bv
			if ammo_type.rocket:
				new_bullet.rocket_velocity -= bv * 0.01
			new_bullet.velocity -= bv * 0.5 - velocity
			new_bullet.global_transform.origin = shoot_pos.global_transform.origin
	else:
		if player:
			weapon_owner = Global.target
		if $Orgone_Ray.is_colliding() and weapon_owner.orgone > 0:
			$Energy_Ray.visible = true
			$Energy_Ray.scale.x = min(weapon_owner.orgone, weapon_type.energy) / weapon_type.energy
			$Energy_Ray.scale.y = min(weapon_owner.orgone, weapon_type.energy) / weapon_type.energy

			var col = $Orgone_Ray.get_collider()
			$Energy_Ray.visible = true
			$Energy_Ray / Orgone_Hit.global_transform.origin = $Orgone_Ray.get_collision_point()
			$Energy_Ray.scale.z = $Position3D.global_transform.origin.distance_to($Orgone_Ray.get_collision_point())
			var bv: Vector3 = - (shoot_pos.global_transform.origin - shoot_pos.to_global(Vector3.FORWARD)) * weapon_type.energy
			if col.has_method("damage"):
				$Energy_Ray / Orgone_Hit.pitch_scale = 1.0
				if player:
					var hm = hit_marker.instance()
					add_child(hm)
					hm.set_as_toplevel(true)
					hm.global_transform.origin = $Energy_Ray / Orgone_Hit.global_transform.origin
					
				col.damage(bv, min(weapon_owner.orgone, weapon_type.energy) / weapon_type.energy)
			else:
				$Energy_Ray / Orgone_Hit.pitch_scale = 2.0
			$Energy_Ray / Orgone_Hit.play()
			if player:
				Global.target.orgone -= min(Global.target.orgone, weapon_type.energy * 0.25)
			else:
				weapon_owner.orgone -= min(weapon_owner.orgone, weapon_type.energy)
	if not ammo_type.fire and not weapon_type.orgone:
		flash_counter = get_physics_process_delta_time() * 2
	if not weapon_type.revolver and not weapon_type.orgone and player and not ammo_type.caseless:
		var n_shell = shell.instance()
		add_child(n_shell)
		n_shell.set_as_toplevel(true)
		shells.append(n_shell)
		if shells.size() > max_shell_count:
			shells[0].queue_free()
			shells.remove(0)
		n_shell.id = ammo_type.id + " Casing"
		n_shell.global_transform.origin = $Body_Mesh / ShellPos.global_transform.origin
		n_shell.velocity = - ($Body_Mesh / ShellPos.global_transform.origin - $Body_Mesh / ShellPos.to_global(Vector3.RIGHT)).normalized() * rand_range(7, 10)
	else:
		mag_shots_fired += 1
		
	if player:
		var n_audio = new_audio.duplicate()
		n_audio.stream = weapon_type.sfx
		if max_ammo > 0 and player:
			if not weapon_type.orgone:
				n_audio.pitch_scale = mag_ammo / weapon_type.magazine_size * 0.5 + 0.5
			else:
				n_audio.pitch_scale = min(weapon_owner.orgone, weapon_type.energy) / weapon_type.energy * 0.5 + 0.75
		add_child(n_audio)
		n_audio.play()
		audio_players.append(n_audio)
		var ap: Array = []
		ap.append_array(audio_players)
		for a in ap:
			if not a.is_playing():
				a.queue_free()
				ap.remove(ap.find(a))
		audio_players = ap
	else:
		new_audio.stream = weapon_type.sfx
		if global_transform.origin.distance_to(Global.target.global_transform.origin) > 40:
			new_audio.bus = "Distant"
		else:
			new_audio.bus = "Gunshots"
		new_audio.play()
	if ammo_type.rocket:
		return total_bv * 0.01
	return total_bv

func _input(event):
	if Global.player_inf.disabled or not visible or Global.player_inf.dual_wield or weapon_type.melee or weapon_type.orgone:
		return
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		if Input.is_action_pressed("RELOAD") and manual_reload:
			if is_custom_weapon and weapon_type.has_flag("custom_reload") and custom_weapon_scene.has_method("on_reload"):
				custom_weapon_scene.on_reload()
				return
			
			var sensitivity = Global.mouse_sens
			var rot_deg_y = deg2rad(event.relative.y * - 1 * sensitivity)
		
			body.rotate_x(clamp(rot_deg_y, - 1, 1))
			
			body.rotation.x = clamp(body.rotation.x, - 0.7, 0.7)

			$Reload_Sound.play()
			$Reload_Sound.seek(abs(rot_deg_y))
