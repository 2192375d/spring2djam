class_name FlyingAnimal
extends SentientAnimal


var accel_scale = 1



func player_movement(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction_vector * speed
	

func _physics_process(_delta: float) -> void:
	if get_parent() is not Player:
		state_machine.process_physics_frame(_delta)

	if !is_on_floor():
		animation.play("fly")	
		self.animation.rotation = self.velocity.normalized().angle()
		
		if velocity.x < 0:
			self.animation.rotation = self.animation.rotation-PI
			animation.flip_h = true
		elif velocity.x > 0:
			animation.flip_h = false
		elif (velocity.x == 0 && velocity.y != 0):
			if (animation.flip_h):
				self.animation.rotation = self.animation.rotation+PI
		
		if (self.velocity.y > 0):
			accel_scale += Constants.GRAVITY / 10 * _delta
		else:
			#pass
			accel_scale -= Constants.GRAVITY / 20 * _delta 
		accel_scale = min(max(1, accel_scale), 2)
		
		self.velocity *= accel_scale
	
	else:
		animation.play("walk")
		self.animation.rotation = 0
		if velocity.x < 0:
			animation.flip_h = true
		elif velocity.x > 0:
			animation.flip_h = false
	move_and_slide()
