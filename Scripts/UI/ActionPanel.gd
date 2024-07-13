extends TabContainer


func _on_forager_buy_button_pressed():
	GameManager.buy_villager(GameManager.villagers_type.FORAGER)

func _on_woodcutter_buy_button_pressed():
	GameManager.buy_villager(GameManager.villagers_type.WOODCUTTER)
	
