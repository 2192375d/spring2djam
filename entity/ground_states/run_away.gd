extends GroundState
class_name GroundRunAwayState

var predator : Animal

func enter() -> void:
	print("entered run away")
	if (len(self.actor.predatorlist) >= 1):
		self.predator = self.actor.predatorlist[0]
	
func exit() -> void:
	print("exited run away")
	pass
	
func setup(actor : GroundAnimal) -> void:
	self.actor = actor
	self.state_name = GroundState.Name.RUN_AWAY

func process_physics_frame(delta : float) -> GroundState.Name:
	# prey escapes
	if ((len(self.actor.predatorlist) >= 1 and self.actor.predatorlist[0] != predator) or len(self.actor.predatorlist) == 0):
		return GroundState.Name.HEAD_BACK
	self.actor.velocity = (self.actor.global_position - predator.global_position).normalized() * self.actor.speed
	return GroundState.Name.RUN_AWAY
