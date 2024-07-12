class_name VillagerState extends State

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var actor: Node2D = $"../.."
@export var move_speed = 200

enum res_type {TREE, FORAGE}

func find_target_resources(x: int, type: res_type):
	var resources = []
	
	if type == res_type.TREE:
		resources = GameManager.get_tree_list()
	elif type == res_type.FORAGE:
		resources = GameManager.get_forage_list()
	
	var closest_resources = []
	
	for res in resources:
		if res != null:
			if type == res_type.TREE and res.chopped == true:
				continue
				
			if type == res_type.FORAGE and not res.damage_handler.damageable:
				continue 
			
			var res_position = res.global_transform.origin
			var distance = actor.global_position.distance_to(res_position)
			closest_resources.append({"resource": res, "distance": distance})

	# Sort trees by distance
	closest_resources.sort_custom(func(a, b): return a["distance"] < b["distance"])

	# Get the 3 closest trees
	var top_x_resources = closest_resources.slice(0, x)
	
	if top_x_resources.is_empty():
		print("No forage found -> Keep running idle state")
	else:
		actor.target = top_x_resources.pick_random().resource
		transition.emit("ReachState")
