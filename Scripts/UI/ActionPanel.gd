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
	EventBus.connect("_open_close_action_panel", _on_open_close_action_panel)

func update_ui():
	forager_food_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.FORAGER][Global.resource_drop_type.FOOD])
	woodcutter_food_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.WOODCUTTER][Global.resource_drop_type.FOOD])
	gold_finder_food_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.GOLDFINDER][Global.resource_drop_type.FOOD])
	
	forager_wood_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.FORAGER][Global.resource_drop_type.WOOD])
	woodcutter_wood_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.WOODCUTTER][Global.resource_drop_type.WOOD])
	gold_finder_wood_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.GOLDFINDER][Global.resource_drop_type.WOOD])

	forager_gold_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.FORAGER][Global.resource_drop_type.GOLD])
	woodcutter_gold_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.WOODCUTTER][Global.resource_drop_type.GOLD])
	gold_finder_gold_cost_label.text = "x" + str(GameManager.villagers_costs[Global.villagers_type.GOLDFINDER][Global.resource_drop_type.GOLD])


func _on_forager_buy_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.buy_villager(Global.villagers_type.FORAGER)

func _on_woodcutter_buy_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.buy_villager(Global.villagers_type.WOODCUTTER)

func _on_gold_finder_buy_button_pressed():
	var entity_manager: EntityManager = GameManager.get_entity_manager()
	entity_manager.buy_villager(Global.villagers_type.GOLDFINDER)

func _on_open_close_action_panel():
	visible = !visible
