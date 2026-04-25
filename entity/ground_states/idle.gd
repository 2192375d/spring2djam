extends GroundState
class_name GroundIdleState

func enter() -> void:
	# logic
	pass
func exit() -> void:
	# logic
	pass
func setup(actor : GroundAnimal) -> void:
	var rval = [-1,1][randi_range(0, 1)] # random -1 or 1
	actor.velocity.x = rval * 100
	
func process_physics_frame(delta : float) -> GroundState.Name:
	# logic
	return GroundState.Name.IDLE
