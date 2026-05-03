# Weapons
[Назад](/docs/RU/main.md)

Внимание: здесь описаны только возможные методы и классы модуля
Гайды по модулю можно найти на главной странице

Данный модуль позволяет создавать свои собственные оружия
# Методы

`new_weapon() -> weapon`  
Возвращает новое оружие

`add_weapon(recived_weapon : weapon) -> void`  
Добавляет новое оружие в игру

recived_weapon: Новое оружие которое будет добавлено в игру, должен являться классом `weapon` для корректной работы
# Классы:

```python
class weapon:

id: String = "Test weapon" # ID оружия
ammo_type = null # Тип используемых патронов
mesh: Mesh = null # Модель оружия
barrel_mesh: Mesh = null # Доп. модель оружия
material = preload("res://Materials/gun_metal.tres") # Материал оружия
icon = preload("res://Icons/smg.png") # Иконка
tracer_material = preload("res://Bullets/Tracer.tres")
sfx = preload("res://SFX/weapon_sfx/20mmrapid.wav")
fire_modes: Array = [true, false, false]
mods_installed: Array = ["Standard"]
current_mod = "Standard"
description = "???" # Описание оружия в меню
orgone = false # Оружие вместо патрон будет использовать оргон
unlocked = false # Открыто ли оружие по умолчанию
price = 0 # Цена оружия в магазине
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
small_arm = false # Определяет тип оружия (Для меха или игрока)
taser = false
ammo: float = 0
loadout = 1
spread: float = 0 # Разброс оружия
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
mass: float = 100 # Масса оружия
rof: float = 0.01

var is_custom_weapon = false # Отключает оригинальный функционал оружия и позволяет загрузить собственную сцену
	
var custom_weapon_scene = load("res://path_to/scene.tscn") # Сцена которая будет подгружена если is_custom_weapon == True
	
var custom_weapon_flags = [] # Флаги кастомного оружия

#Список флагов:
#custom_fire - Использовать кастомную функцию огня do_shoot()
#custom_reload - Использовать кастомную функцию перезарядки do_reload()
#custom_mesh - Прячет оригинальную модель оружия
#hide_status_label - Прячет статус оружия

func has_flag(recived_flag): # Проверяет есть ли у оружия определённый флаг
	return custom_weapon_flags.has(recived_flag)
	
func set_flags(recived_flags: Array): # Задаёт флаги оружию
	custom_weapon_flags = recived_flags
```