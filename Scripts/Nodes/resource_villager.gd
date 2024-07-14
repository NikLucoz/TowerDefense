class_name ResourceVillager extends CharacterBody2D

enum res_type {TREE, FORAGE, GOLDORE}
var target: Node2D
@export var move_speed: int = 200
@export var target_resource_type: res_type
@export var max_searching_target_number: int = 3
@export var damage_to_resource: int = 3
