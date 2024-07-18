class_name VillagerState extends State

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var state_machine = %StateMachine
@onready var actor = get_owner()
@onready var move_speed: int = actor.move_speed

func find_target_resources(x: int, type: Global.resource_type):
	var resources = []
	if type == Global.resource_type.TREE:
		resources = GameManager.get_tree_list()
	elif type == Global.resource_type.FORAGE:
		resources = GameManager.get_forage_list()
	elif type == Global.resource_type.GOLDORE:
		resources = GameManager.get_goldore_list()
	
	var closest_resources = []
	
	for res in resources:
		if res != null:
			if type == Global.resource_type.TREE and res.chopped == true:
				continue
				
			if type == Global.resource_type.FORAGE and not res.damage_handler.damageable:
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
		transition.emit("IdleState")
	else:
		actor.target = top_x_resources.pick_random().resource
		transition.emit("ReachState")
