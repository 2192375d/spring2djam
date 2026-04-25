extends GroundState
class_name GroundIdleState

var dirvec : Vector2

func enter() -> void:
	var rval = [-1,1][randi_range(0, 1)] # random -1 or 1
	dirvec = Vector2(rval * actor.speed, 0)
	
	
func exit() -> void:
	pass

func setup(actor : GroundAnimal) -> void:
	self.actor = actor
	self.state_name = GroundState.Name.IDLE	
	
func process_physics_frame(delta : float) -> GroundState.Name:
	self.actor.velocity = self.dirvec 
	# check if predators exist
	if (len(self.actor.predatorlist) > 0):
		return GroundState.Name.RUN_AWAY
		
	# check if prey exists
	if (len(self.actor.preylist) > 0):
		return GroundState.Name.CHASE
		
	# check if outside of domain
	if ((actor.global_position - actor.domain_point).length() > actor.domain_radius ):
		return GroundState.Name.HEAD_BACK
	return GroundState.Name.IDLE
