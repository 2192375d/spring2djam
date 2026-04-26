@abstract class_name Animal

extends CharacterBody2D

@export var entity_resource: EntityResource
@export var domain_point: Vector2
@abstract func player_movement(delta: float) -> void

func die() -> void:
	set_physics_process(false)
	velocity = Vector2.ZERO
	collision_layer = 0
	collision_mask = 0
	
	var blood_effect: Node2D = Constants.blood_effect_scene.instantiate()
	get_parent().add_child(blood_effect)
	blood_effect.global_position = global_position
	var blood_particles: GPUParticles2D = blood_effect.get_node("GPUParticles2D")
	blood_particles.emitting = true
	await blood_particles.finished
	blood_effect.queue_free()
	queue_free()
