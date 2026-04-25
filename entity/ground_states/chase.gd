extends GroundState
class_name GroundChaseState

var target : Animal

func enter() -> void:
	print("entered chase")
	if (len(self.actor.preylist) >= 1):
		self.target = self.actor.preylist[0]

func exit() -> void:
	print("exited chase")
	# logic
	pass

func setup(actor : GroundAnimal) -> void:	
	self.actor = actor
	self.state_name = GroundState.Name.CHASE
	
func process_physics_frame(delta : float) -> GroundState.Name:
	# prey escapes
	if ((len(self.actor.preylist) >= 1 and self.actor.preylist[0] != target) or len(self.actor.preylist) == 0):
		return GroundState.Name.HEAD_BACK
	self.actor.velocity = (target.global_position - self.actor.global_position).normalized() * self.actor.speed
	return GroundState.Name.CHASE
