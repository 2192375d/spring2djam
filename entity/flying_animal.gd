extends Animal

class_name FlyingAnimal

@export var speed: float
@export var animation: AnimatedSprite2D
@export var domain_radius : int
@export var domain_point : Vector2
#@export var state_machine : FlyingStateMachine
@export var vision_area : Area2D
@export var eating_area : Area2D

var preylist : Array[Animal]
var predatorlist : Array[Animal]
var accel_scale = 1

func _ready() -> void:
	print(self)
	animation.play("idle")

	# connect signals
	self.vision_area.body_entered.connect(_on_vision_body_entered)
	self.vision_area.body_exited.connect(_on_vision_body_exited)
	self.eating_area.body_entered.connect(_on_eating_area_body_entered)
	pass

func player_movement(_delta: float) -> void:
	

	velocity = Vector2.ZERO
	
	var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction_vector * speed
	
	if !is_on_floor():
		animation.play("fly")	
		self.rotation = self.velocity.normalized().angle()
		
		if velocity.x < 0:
			self.rotation = self.rotation-PI
			animation.flip_h = true
		elif velocity.x > 0:
			animation.flip_h = false
		elif (velocity.x == 0 && velocity.y != 0):
			if (animation.flip_h):
				self.rotation = self.rotation+PI
		
		if (self.velocity.y > 0):
			accel_scale += Constants.GRAVITY / 10 * _delta
		else:
			accel_scale -= Constants.GRAVITY / 20 * _delta 
		accel_scale = max(1, accel_scale)
	
		self.velocity *= accel_scale

	
	else:
		animation.play("walk")
		self.rotation = 0
		if velocity.x < 0:
			animation.flip_h = true
		elif velocity.x > 0:
			animation.flip_h = false



func _physics_process(delta: float) -> void:
	if get_parent() is not Player:
		pass	
	move_and_slide()

func _on_vision_body_entered(body: Node2D) -> void:
	# check predator or prey
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			preylist.push_back(body)
		elif body.entity_resource.hierarchy > entity_resource.hierarchy:
			predatorlist.push_back(body)

func _on_vision_body_exited(body: Node2D) -> void:
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			# remove the corresponding body
			if (body in preylist):
				preylist.remove_at(preylist.find(body))
		elif body.entity_resource.hierarchy > entity_resource.hierarchy:
			if (body in predatorlist):
				predatorlist.remove_at(predatorlist.find(body))

func _on_eating_area_body_entered(body: Node2D) -> void:
	if body is Animal:
		if body.entity_resource.hierarchy < entity_resource.hierarchy:
			if get_parent() is Player:
				var player: Player = get_parent() as Player
				player.eat(body.entity_resource.exp_gain, body.entity_resource.hunger_gain)
			body.die()
