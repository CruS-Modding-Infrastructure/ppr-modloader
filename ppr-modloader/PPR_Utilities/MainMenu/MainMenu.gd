extends Node

onready var menu_button = preload("res://PPR_Utilities/MainMenu/MenuButton.tscn")

var menus = [
	["Mods", load("res://PPR_Utilities/MainMenu/ModsMenu.tscn")]
]

func add_menu(menu_name : String, menu_node_path : String):
	menus.append([menu_name, load(menu_node_path)])

func set_menu_on_ready(buttons_node, menu_node):
	for menu in menus:
		var loaded_menu = menu[1].instance()
		var loaded_button = menu_button.instance()
		
		menu_node.add_child(loaded_menu)
		menu_node.move_child(loaded_menu, 2)
		
		loaded_menu.hide()
		
		loaded_menu.set_name(menu[0])

		loaded_button.text = menu[0]
		loaded_button.menu = loaded_menu
		loaded_button.ui = menu_node
		
		buttons_node.add_child(loaded_button)
		buttons_node.move_child(loaded_button, 5)
		
		loaded_button.set_name(menu[0])
