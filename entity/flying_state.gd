@abstract class_name FlyingState
extends Node

enum Name { IDLE, CHASE, RUN_AWAY, HEAD_BACK }

var actor: FlyingAnimal
var state_name: Name

func enter() -> void:
	print("Entered state ", state_name)
	# logic on enter
	pass

func exit() -> void:
	print("Exited state ", state_name)
	# logic on exit
	pass

@abstract func setup(actor : FlyingAnimal) -> void
@abstract func process_physics_frame(delta: float) -> Name
