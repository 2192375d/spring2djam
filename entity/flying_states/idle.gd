extends FlyingState
class_name FlyingIdleState

var dirvec : Vector2

func enter() -> void:
	dirvec = (self.actor.domain_point - self.actor.global_position)
	dirvec.x *= [0.5,1.5][randi_range(0, 1)]
	dirvec.y *= [0.5,1.5][randi_range(0, 1)]
	dirvec = dirvec.normalized() * self.actor.speed
	
	
func exit() -> void:
	pass

func setup(actor : FlyingAnimal) -> void:
	self.actor = actor
	self.state_name = FlyingState.Name.IDLE	
	
func process_physics_frame(delta : float) -> FlyingState.Name:
	actor.velocity = dirvec
	# check if predators exist
	if (len(self.actor.predatorlist) > 0):
		return FlyingState.Name.RUN_AWAY
		
	# check if prey exists
	if (len(self.actor.preylist) > 0):
		return FlyingState.Name.CHASE
		
	# check if outside of domain
	if ((actor.global_position - actor.domain_point).length() > actor.domain_radius ):
		return FlyingState.Name.HEAD_BACK
	return FlyingState.Name.IDLE
