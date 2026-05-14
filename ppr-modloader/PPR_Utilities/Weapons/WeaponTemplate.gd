extends Spatial

func on_shoot():
	pass

func on_reload():
	pass

func on_drop():
	pass

func is_player() -> bool:
	return get_node("../../../") == Global.player_inf

func is_mech() -> bool:
	return get_node("../../") == Global.player_ship
