extends Node

class_name FlyingStateMachine

@export var actor : FlyingAnimal
@export var starting_state : FlyingState
@export var state_dictionary : Dictionary[FlyingState.Name, FlyingState]

var current_state : FlyingState

func setup() -> void:
	for key: FlyingState.Name in state_dictionary:
		state_dictionary[key].setup(self.actor)
	change_state(starting_state)

func change_state(new_state: FlyingState) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func process_physics_frame(delta: float) -> void:
	var new_state: FlyingState = state_dictionary[current_state.process_physics_frame(delta)]
	if new_state != current_state:
		change_state(new_state)
	#actor.move_and_slide()
