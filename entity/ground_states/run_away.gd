extends GroundState
class_name GroundRunAwayState

var predator : Animal

func enter() -> void:
	if (len(self.actor.predatorlist) >= 1):
		self.predator = self.actor.predatorlist[0]
	
func exit() -> void:
	pass
	
func setup(actor : GroundAnimal) -> void:
	self.actor = actor
	self.state_name = GroundState.Name.RUN_AWAY

func process_physics_frame(delta : float) -> GroundState.Name:
	# prey escapes
	if ((len(self.actor.predatorlist) >= 1 and self.actor.predatorlist[0] != predator) or len(self.actor.predatorlist) == 0):
		return GroundState.Name.HEAD_BACK
	self.actor.navagent.target_position = self.actor.global_position + (self.actor.global_position - predator.global_position) * self.actor.speed * 2
	self.actor.navagent.target_position.y -= 50
	self.actor.velocity = self.actor.global_position.direction_to(self.actor.navagent.get_next_path_position()).normalized() * self.actor.speed

	#self.actor.velocity = (self.actor.global_position - predator.global_position).normalized() * self.actor.speed 
	#self.actor.velocity.y -= 20 # to go up platforms
	return GroundState.Name.RUN_AWAY
