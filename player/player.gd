extends Node2D

class_name Player

@export var animal: Animal

func _physics_process(delta: float) -> void:
	if animal.entity_resource.ai_type == Constants.AIType.GROUND:
		animal.player_movement(delta)
