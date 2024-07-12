class_name StateMachine extends Node

@export var CURRENT_STATE: State
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_error("This state machine contains an invalid children")
	
	if CURRENT_STATE == null:
		push_error("Default CURRENT_STATE not set for thi state machine")
	CURRENT_STATE.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	CURRENT_STATE.update(delta)

func _physics_process(delta) -> void:
	CURRENT_STATE.physics_update(delta)

func _input(event: InputEvent): # This function avoids checking whether inputs are activated in the state update
	CURRENT_STATE.handle_input(event) # This way if an interrupt arrives I only call the handle of the current state

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state:
		CURRENT_STATE.exit()
		CURRENT_STATE = new_state
		CURRENT_STATE.enter()
	else:
		push_warning("The new state passed in the transition does not exists")
