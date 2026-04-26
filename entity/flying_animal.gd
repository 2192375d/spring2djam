extends Animal

class_name FlyingAnimal

@export var speed: float
@export var animation: AnimatedSprite2D
@export var domain_radius : int
# @export var domain_point : Vector2
@export var state_machine : FlyingStateMachine
@export var vision_area : Area2D
@export var eating_area : Area2D
@onready var navagent : NavigationAgent2D = $NavigationAgent2D

var preylist : Array[Animal]
var predatorlist : Array[Animal]
var accel_scale = 1

func _ready() -> void:
	animation.play("idle")

	if (!eating_area):
		push_error("no eating area for", self)
	eating_area.body_entered.connect(_on_eating_area_body_entered)
	
	# AI specific configurations
	if get_parent() is not Player:
		if (!vision_area):
			push_error("no vision area for", self)
		vision_area.body_entered.connect(_on_vision_body_entered)
		vision_area.body_exited.connect(_on_vision_body_exited)
		# default domain unassigned
		if (domain_point == Vector2(0,0)): 
			domain_point = self.global_position
		if (!domain_radius):
			domain_radius = Constants.CONSTANT_DOMAIN_RADIUS
		if (!state_machine):
			push_error("no state machine for", self)
		self.state_machine.setup()
	pass



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
