extends FlyingState
class_name FlyingHeadBackState

func enter() -> void:
	# logic
	pass
func exit() -> void:
	# logic
	pass

func setup(actor : FlyingAnimal) -> void:
	self.actor = actor
	self.state_name = FlyingState.Name.HEAD_BACK
	
func process_physics_frame(delta : float) -> FlyingState.Name:
	# go back to domain
	self.actor.navagent.target_position = self.actor.domain_point
	self.actor.velocity = self.actor.global_position.direction_to(self.actor.navagent.get_next_path_position()).normalized() * self.actor.speed
	#self.actor.velocity = self.actor.navagent.get_next_path_position().normalized() * self.actor.speed * delta

	#actor.velocity = (actor.domain_point - actor.global_position).normalized() * actor.speed

	# check if predators exist
	if (len(self.actor.predatorlist) > 0):
		return FlyingState.Name.RUN_AWAY
		
	# check if prey exists
	if (len(self.actor.preylist) > 0):
		return FlyingState.Name.CHASE
	
	# back in domain
	if ((actor.domain_point - actor.global_position).length() < actor.domain_radius):
		return FlyingState.Name.IDLE
	
	return FlyingState.Name.HEAD_BACK
