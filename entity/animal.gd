@abstract class_name Animal

extends CharacterBody2D

@export var entity_resource: EntityResource

@abstract func player_movement(delta: float) -> void

func die() -> void:
	var blood_effect: Node2D = Constants.blood_effect_scene.instantiate()
	add_child(blood_effect)
	queue_free()
