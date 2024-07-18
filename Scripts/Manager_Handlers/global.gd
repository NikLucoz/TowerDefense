extends Node

const BERRY_BUSH = preload("res://Assets/Resources/Forages/berry_bush.png")
const NO_BERRY_BUSH = preload("res://Assets/Resources/Forages/no_berry_bush.png")
const MUSHROOM = preload("res://Assets/Resources/Forages/mushrooms.png")
const RESOURCE_DROP = preload("res://Scenes/Resources/resource_drop.tscn")
const WOOD_TEXTURE = preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/W_Idle.png")
const GOLD_TEXTURE = preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/G_Idle.png")
const FOOD_TEXTURE = preload("res://Assets/Tilesets/Tiny Swords/Resources/Resources/M_Idle.png")
const TREE = preload("res://Scenes/Resources/tree.tscn")
const FORAGE = preload("res://Scenes/Resources/forage.tscn")
const GOLD_ORE = preload("res://Scenes/Resources/gold_ore.tscn")
const CASTLE = preload("res://Scenes/Level/town_hall.tscn")


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
