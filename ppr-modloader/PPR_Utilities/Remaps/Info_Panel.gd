extends "_orig_Info_Panel.gd"

func _ready():
	PPRUtilities.main_menu.set_menu_on_ready($UI/Menu_Select/VBoxContainer2, $UI)

func set_menu(menu_node):
	for child in $UI.get_children():
		if child != $UI/Menu_Select:
			if child != menu_node:
				child.hide()
			else:
				child.show()

func _on_Save_pressed():
	set_menu($UI/Save)

func _on_My_Computer_pressed():
	set_menu($UI/File_System)

func _on_Settings_pressed():
	set_menu($UI/Settings)

func _on_New_Game_pressed():
	set_menu($UI/New_Game)

func _on_Help_pressed():
	set_menu($UI/Help)
