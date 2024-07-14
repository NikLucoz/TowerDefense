extends TabContainer

@onready var forager_food_cost_label = $Villagers/MarginContainer/Control/ForagerControl/FoodCost/Label
@onready var woodcutter_food_cost_label = $Villagers/MarginContainer/Control/WoodcutterControl/FoodCost/Label
@onready var gold_finder_food_cost_label = $Villagers/MarginContainer/Control/GoldFinderControl/FoodCost/Label

@onready var forager_wood_cost_label = $Villagers/MarginContainer/Control/ForagerControl/WoodCost/Label
@onready var woodcutter_wood_cost_label = $Villagers/MarginContainer/Control/WoodcutterControl/WoodCost/Label
@onready var gold_finder_wood_cost_label = $Villagers/MarginContainer/Control/GoldFinderControl/WoodCost/Label

@onready var forager_gold_cost_label = $Villagers/MarginContainer/Control/ForagerControl/GoldCost/Label
@onready var woodcutter_gold_cost_label = $Villagers/MarginContainer/Control/WoodcutterControl/GoldCost/Label
@onready var gold_finder_gold_cost_label = $Villagers/MarginContainer/Control/GoldFinderControl/GoldCost/Label

func _ready():
	update_ui()
	#visible = false
	GameManager.connect("_open_close_action_panel", _on_open_close_action_panel)

func update_ui():
	forager_food_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.FORAGER][GameManager.resource_type.FOOD])
	woodcutter_food_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.WOODCUTTER][GameManager.resource_type.FOOD])
	gold_finder_food_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.GOLDFINDER][GameManager.resource_type.FOOD])
	
	forager_wood_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.FORAGER][GameManager.resource_type.WOOD])
	woodcutter_wood_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.WOODCUTTER][GameManager.resource_type.WOOD])
	gold_finder_wood_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.GOLDFINDER][GameManager.resource_type.WOOD])

	forager_gold_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.FORAGER][GameManager.resource_type.GOLD])
	woodcutter_gold_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.WOODCUTTER][GameManager.resource_type.GOLD])
	gold_finder_gold_cost_label.text = "x" + str(GameManager.villagers_costs[GameManager.villagers_type.GOLDFINDER][GameManager.resource_type.GOLD])


func _on_forager_buy_button_pressed():
	GameManager.buy_villager(GameManager.villagers_type.FORAGER)

func _on_woodcutter_buy_button_pressed():
	GameManager.buy_villager(GameManager.villagers_type.WOODCUTTER)

func _on_gold_finder_buy_button_pressed():
	GameManager.buy_villager(GameManager.villagers_type.GOLDFINDER)

func _on_open_close_action_panel():
	visible = !visible
