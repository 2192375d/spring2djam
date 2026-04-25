extends GroundState
class_name GroundRunAwayState

func enter() -> void:
	# logic
	pass
func exit() -> void:
	pass
	
func setup(actor : GroundAnimal) -> void:
	self.actor = actor
	self.state_name = GroundState.Name.RUN_AWAY

func process_physics_frame(delta : float) -> GroundState.Name:
	# logic
	return GroundState.Name.RUN_AWAY
