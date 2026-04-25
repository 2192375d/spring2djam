extends Node

class_name GroundStateMachine

@export var actor : GroundAnimal
@export var starting_state : GroundState
@export var state_dictionary : Dictionary[GroundState.Name, GroundState]

var current_state : GroundState

func setup() -> void:
	for key: GroundState.Name in state_dictionary:
		print("ACTOR:", self.actor)
		state_dictionary[key].setup(self.actor)
	change_state(starting_state)

func change_state(new_state: GroundState) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func process_physics_frame(delta: float) -> void:
	var new_state: GroundState = state_dictionary[current_state.process_physics_frame(delta)]
	if new_state != current_state:
		change_state(new_state)
	#actor.move_and_slide()
