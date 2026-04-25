extends GroundState
class_name GroundHeadBackState

func enter() -> void:
	# logic
	pass
func exit() -> void:
	# logic
	pass

func setup(actor : GroundAnimal) -> void:
	self.actor = actor
	self.state_name = GroundState.Name.HEAD_BACK
	
func process_physics_frame(delta : float) -> GroundState.Name:
	# go back to domain
	self.actor.velocity = (actor.domain_point - actor.global_position).normalized() * actor.speed
	self.actor.velocity.y -= 20 # to go up platforms
	self.actor.velocity 

	# check if predators exist
	if (len(self.actor.predatorlist) > 0):
		return GroundState.Name.RUN_AWAY
		
	# check if prey exists
	if (len(self.actor.preylist) > 0):
		return GroundState.Name.CHASE
	
	# back in domain
	if ((actor.domain_point - actor.global_position).length() < actor.domain_radius):
		return GroundState.Name.IDLE
	
	return GroundState.Name.HEAD_BACK
