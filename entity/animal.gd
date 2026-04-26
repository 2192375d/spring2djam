@abstract class_name Animal

extends CharacterBody2D

@export var entity_resource: EntityResource
@abstract func player_movement(delta: float) -> void

func _get_blood_effect_scale_multiplier() -> float:
	match entity_resource.hierarchy:
		Constants.FoodHierarchy.SEED:
			return 0.5
		Constants.FoodHierarchy.TIER0:
			return 0.8
		Constants.FoodHierarchy.TIER1:
			return 1.0
		Constants.FoodHierarchy.TIER2:
			return 1.25
		Constants.FoodHierarchy.TIER3:
			return 1.5
		Constants.FoodHierarchy.TIER4:
			return 1.8
		Constants.FoodHierarchy.DOMINANT:
			return 2.2
		_:
			return 1.0

func _get_blood_particle_amount_multiplier() -> float:
	match entity_resource.hierarchy:
		Constants.FoodHierarchy.SEED:
			return 0.35
		Constants.FoodHierarchy.TIER0:
			return 0.7
		Constants.FoodHierarchy.TIER1:
			return 1.0
		Constants.FoodHierarchy.TIER2:
			return 1.35
		Constants.FoodHierarchy.TIER3:
			return 1.75
		Constants.FoodHierarchy.TIER4:
			return 2.2
		Constants.FoodHierarchy.DOMINANT:
			return 3.0
		_:
			return 1.0

func die() -> void:
	set_physics_process(false)
	velocity = Vector2.ZERO
	collision_layer = 0
	collision_mask = 0
	
	var blood_effect: Node2D = Constants.blood_effect_scene.instantiate()
	get_parent().add_child(blood_effect)
	blood_effect.global_position = global_position
	var blood_particles: GPUParticles2D = blood_effect.get_node("GPUParticles2D")

	blood_effect.scale *= 10 * _get_blood_effect_scale_multiplier()
	blood_particles.amount = maxi(1, 50 * int(round(blood_particles.amount * _get_blood_particle_amount_multiplier())))
	blood_particles.emitting = true
	await blood_particles.finished
	blood_effect.queue_free()
	
	var parent = get_parent()
	if parent is Player:
		if parent.animal == self:
			parent.on_animal_died()
	
	queue_free()
