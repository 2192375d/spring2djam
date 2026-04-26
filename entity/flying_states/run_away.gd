extends FlyingState
class_name FlyingRunAwayState

var predator : Animal

func enter() -> void:
	if (len(self.actor.predatorlist) >= 1):
		self.predator = self.actor.predatorlist[0]
	
func exit() -> void:
	pass
	
func setup(actor : FlyingAnimal) -> void:
	self.actor = actor
	self.state_name = FlyingState.Name.RUN_AWAY

func process_physics_frame(delta : float) -> FlyingState.Name:
	# prey escapes
	if ((len(self.actor.predatorlist) >= 1 and self.actor.predatorlist[0] != predator) or len(self.actor.predatorlist) == 0):
		return FlyingState.Name.HEAD_BACK
	self.actor.navagent.target_position = self.actor.global_position + (self.actor.global_position - predator.global_position) * self.actor.speed * 2
	self.actor.velocity = self.actor.global_position.direction_to(self.actor.navagent.get_next_path_position()).normalized() * self.actor.speed
	#print(self.actor.velocity)	

	#self.actor.velocity = (self.actor.global_position - predator.global_position).normalized() * self.actor.speed
	return FlyingState.Name.RUN_AWAY
