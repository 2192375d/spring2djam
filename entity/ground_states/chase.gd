extends GroundState
class_name GroundChaseState

func enter() -> void:
	# logic
	pass
func exit() -> void:
	# logic
	pass
func setup(actor : GroundAnimal) -> void:
	# logic
	pass
func process_physics_frame(delta : float) -> GroundState.Name:
	# logic
	return GroundState.Name.CHASE
