extends VBoxContainer

func _ready():
	$Info / Button.visible = Global.debug
	$Info / Button2.visible = Global.debug
	$Info / TimeScale.visible = Global.debug
	
	PPRUtilities.main_menu.set_menu_on_ready($UI/Menu_Select/VBoxContainer2, $UI)

func _physics_process(delta):
	if not visible:
		return 
	$Info / PanelContainer4 / HBoxContainer / FatigueBar.value = Global.fatigue
	$Info / PanelContainer / Money_Label.text = "Funds: " + str(Global.money) + "€"
	$Info / PanelContainer3 / Label.text = Global.convert_time(Global.time) + " " + Global.get_date()

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

func _on_Exit_Game_pressed():
	get_tree().quit()

func _on_Info_Panel_visibility_changed():
	if Dataset.current_location.id == "EFP HQ":
		Global.extraction_possible = true
	$UI / Menu_Select / VBoxContainer2 / Abort.disabled = not Global.extraction_possible
	$UI / Save / VBoxContainer / Save.disabled = not Global.extraction_possible
	$UI / File_System / Map / VBoxContainer3 / HBoxContainer2 / PanelContainer / Button.disabled = not Global.extraction_possible

func _on_Help_pressed():
	set_menu($UI/Help)
