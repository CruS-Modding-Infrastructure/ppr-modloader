extends Node

class item:
	var id = "NA"
	var event_flag = ""
	var icon = preload("res://Icons/Empty.png")
	var mesh = preload("res://Models/3dlogo.obj")
	var description = "???"
	var sfx = preload("res://SFX/standard_use_item.wav")
	var material = preload("res://Materials/Items/Energy_Drink_1.tres")
	var weight = 500
	var amount_owned: int = 0
	var shop_amount: int = 5
	var shop_amount_bought: int = 0
	var shop_added_per_day: int = 0
	var key_item = false
	var valuable = false
	var infinite_uses = false
	var usable = true
	var droppable = true
	var cook = null
	var cook_amount = 1
	var price = 100
	var frag = false
	var purchase_flag = "NOFLAG"
	var barter_hostility = 50
	var first_sale_day: int = 0
	var toxicity: float = 2.0
	var fatigue: float = 0.0
	var healing: float = 0.0
	var piercing_ratio = 0.0
	var cocaine = 0
	var dna_damage = 0
	var grenade = false
	var cigarettes = 0
	var shrapnels = 0
	var common = false
	var sticky = false
	var toxic = false
	var throw_offset = Vector3.ZERO
	var throw_speed = 10
	var rappel = false
	var explosive_charge = 0
	var explosive_radius = 0
	
	func get_price(hostility):
		var p = price
		if hostility >= 75:
			p *= 2
		if hostility >= 90:
			p *= 10
		hostility = Global.f_norm(hostility, - 50, 50)
		return p * hostility
	
	func get_sell_price(hostility):
		var p = price * 0.5
		if hostility >= 75:
			p *= 0.5
		if hostility >= 90:
			p *= 0.1
		hostility = Global.f_norm(100 - hostility, - 50, 50)
		return p * hostility * 0.5
	
	func save(save_all = false):
		var d = {"id": id, 
			"type": "item", 
			"amount_owned": amount_owned, 
			"shop_amount": shop_amount, 
			"shop_amount_bought": shop_amount_bought
		}
		return d
	
	func get_color(v):
		var c = "[color=#00FF00]"
		if v < 0:
			c = "[color=#FF0000]"
		return c
	
	func get_description(shop = false, npc = null):
		var d = ""
		var color = Color(0, 1, 0)
		if valuable:
			d += "[rainbow val=2.0 freq=0.2]Valuable[/rainbow]: Use to sell online for an immediate access to funds.\n\n"
		d += "[color=#FFFFFF]" + description + "[/color]\n\n"
		d += "Amount Owned: [color=#FFFFFF]" + str(amount_owned) + "[/color]\n"
		
		if shop:
			if npc == null:
				d += "In Stock: " + str(shop_amount) + "\n"
			else:
				if npc.npc != null:
					if id in npc.npc.data.items_owned:
						d += "Owned by " + npc.id + ": " + str(npc.npc.data.items_owned[id]) + "\n"
				else:
					d += "Owned by " + npc.id + ": " + str(npc.items_owned[id]) + "\n"
		if valuable:
			d += "Price: " + str(price) + "\n"
		if healing != 0:
			d += "Health: " + get_color(healing) + str(healing) + "[/color]\n"
		if cigarettes > 0:
			d += "Cigarettes: " + str(cigarettes)
		if fatigue != 0:
			d += "Fatigue: " + get_color( - fatigue) + str(fatigue) + "[/color]\n"
		if toxicity != 0:
			d += "Toxicity: " + get_color( - toxicity) + str(toxicity) + "[/color]\n"
		if explosive_charge != 0:
			d += "Explosive Charge: " + get_color(explosive_charge) + str(explosive_charge) + "[/color]\n"
		if explosive_radius != 0:
			d += "Explosive Radius: " + get_color(explosive_radius) + str(explosive_radius) + " m[/color]\n"
		return d
