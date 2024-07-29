extends Node

const BERRY_BUSH = preload("res://Assets/Resources/Forages/berry_bush.png")
const NO_BERRY_BUSH = preload("res://Assets/Resources/Forages/no_berry_bush.png")
const MUSHROOM = preload("res://Assets/Resources/Forages/mushrooms.png")

const WOOD_TEXTURE = preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/W_Idle.png")
const GOLD_TEXTURE = preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/G_Idle.png")
const FOOD_TEXTURE = preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/M_Idle.png")
const CASTLE_CONSTRUCTION = preload("res://Modules/TownHall/Castle_Construction.png")
const HOUSE_CONSTRUCTION_TEXTURE = preload("res://Assets/Tilesets/Tiny Swords/Factions/Knights/Buildings/House/House_Construction.png")

var map_size_width = 200
var map_size_height = 200

var villagers_costs: Dictionary = { 
	villagers_type.FORAGER: {
		resource_drop_type.FOOD: 30,
		resource_drop_type.WOOD: 0,
		resource_drop_type.GOLD: 0,
	}, 
	villagers_type.WOODCUTTER: {
		resource_drop_type.FOOD: 50,
		resource_drop_type.WOOD: 0,
		resource_drop_type.GOLD: 10,
	}, 
	villagers_type.GOLDFINDER: {
		resource_drop_type.FOOD: 120,
		resource_drop_type.WOOD: 30,
		resource_drop_type.GOLD: 0,
	}
}

var structure_costs: Dictionary = { 
	structure_type.HOUSE: {
		resource_drop_type.FOOD: 0,
		resource_drop_type.WOOD: 40,
		resource_drop_type.GOLD: 0,
	}, 
	structure_type.TOWER: {
		resource_drop_type.FOOD: 0,
		resource_drop_type.WOOD: 150,
		resource_drop_type.GOLD: 80,
	}, 
}

enum villagers_type {
	FORAGER,
	WOODCUTTER,
	GOLDFINDER
}

enum resource_drop_type {
	WOOD, 
	GOLD, 
	FOOD 
}

enum resource_type {
	TREE,
	FORAGE,
	GOLDORE
}

enum forage_type {
	BERRY, 
	MUSHROOM
}

enum structure_type {
	HOUSE,
	TOWER,
}
