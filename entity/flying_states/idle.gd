extends FlyingState
class_name FlyingIdleState

var destvec : Vector2

func enter() -> void:
	#dirvec = (self.actor.domain_point - self.actor.global_position)
	#dirvec.x *= [0.5,1.5][randi_range(0, 1)]
	#dirvec.y *= [0.5,1.5][randi_range(0, 1)]
	#dirvec = dirvec.normalized() * self.actor.speed
	self.destvec = generate_dest_vec()

func generate_dest_vec() -> Vector2:
	var rand_rads = randf_range(0, 2*PI)
	return self.actor.domain_point + Vector2(cos(rand_rads), sin(rand_rads)) * self.actor.domain_radius
	
func exit() -> void:
	pass

func setup(actor : FlyingAnimal) -> void:
	self.actor = actor
	self.state_name = FlyingState.Name.IDLE
	
func process_physics_frame(delta : float) -> FlyingState.Name:
	#actor.velocity = dirvec
	if (actor.velocity.length() < self.actor.speed/2):
		self.destvec = generate_dest_vec()
	self.actor.navagent.target_position = destvec
	self.actor.velocity = self.actor.global_position.direction_to(self.actor.navagent.get_next_path_position()).normalized() * self.actor.speed
	#self.actor.velocity = self.actor.navagent.get_next_path_position().normalized() * self.actor.speed

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
