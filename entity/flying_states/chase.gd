extends FlyingState
class_name FlyingChaseState

var target : Animal

func enter() -> void:
	print("enter chase")
	if (len(self.actor.preylist) >= 1):
		self.target = self.actor.preylist[0]

func exit() -> void:
	# logic
	pass

func setup(actor : FlyingAnimal) -> void:	
	self.actor = actor
	self.state_name = FlyingState.Name.CHASE
	
func process_physics_frame(delta : float) -> FlyingState.Name:
	# prey escapes
	if ((len(self.actor.preylist) >= 1 and self.actor.preylist[0] != target) or len(self.actor.preylist) == 0):
		return FlyingState.Name.HEAD_BACK
	# not making progress
	if (self.actor.velocity.length() <= self.actor.speed/2):
		self.actor.preylist.remove_at(self.actor.preylist.find(target))
		self.actor.blacklistprey.push_back(target)
		return FlyingState.Name.HEAD_BACK
	#self.actor.velocity = (target.global_position - self.actor.global_position).normalized() * self.actor.speed
	self.actor.navagent.target_position = target.global_position
	self.actor.velocity = self.actor.global_position.direction_to(self.actor.navagent.get_next_path_position()).normalized() * self.actor.speed
	return FlyingState.Name.CHASE
