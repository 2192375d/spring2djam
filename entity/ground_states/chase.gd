extends GroundState
class_name GroundChaseState


func enter() -> void:
	pass

func exit() -> void:
	# logic
	pass

func setup(actor : GroundAnimal) -> void:	
	self.actor = actor
	self.state_name = GroundState.Name.CHASE
	
func process_physics_frame(delta : float) -> GroundState.Name:
	# logic
	return GroundState.Name.CHASE
