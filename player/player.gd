extends Node2D

class_name Player

var animal: Animal
@export var ui: GameUI

var hunger_value: float = 100:
	set(value):
		hunger_value = value
		if ui != null:
			ui.update_hunger_bar(hunger_value)

var hunger_max: float = 100:
	set(value):
		hunger_max = value
		if ui != null:
			ui.update_hunger_bar_max(hunger_max)

var exp_value: float = 30:
	set(value):
		exp_value = value
		if ui != null:
			ui.update_exp_bar(exp_value)

var exp_max: float = 50:
	set(value):
		exp_max = value
		if ui != null:
			ui.update_exp_bar_max(exp_max)

func _ready() -> void:
	var animal_scene: PackedScene = Constants.entity_dict.get(Constants.EntityID.KIWI)
	animal = animal_scene.instantiate()
	var camera: Camera2D = Camera2D.new()
	camera.zoom = Vector2(3, 3)
	animal.add_child(camera)
	add_child(animal)
	
	animal.position = Vector2(200, 30)
	
	hunger_max = animal.entity_resource.hunger_max
	hunger_value = float(hunger_max) / 2
	exp_max = animal.entity_resource.exp_max
	exp_value = 0.0

func change_playing_animal(animal_id: Constants.EntityID) -> void:
	# change player as the correct animal
	
	var spawnpoint: Vector2 = animal.position
	animal.queue_free()
	
	var animal_scene: PackedScene = Constants.entity_dict.get(animal_id)
	animal = animal_scene.instantiate()
	
	hunger_max = animal.entity_resource.hunger_max
	hunger_value = float(animal.entity_resource.hunger_max) / 2
	exp_max = animal.entity_resource.exp_max
	exp_value = 0.0
	
	animal.position = spawnpoint
	
	add_child(animal)

func _physics_process(delta: float) -> void:
	
	if !animal:
		return
	if hunger_value < 0.0:
		animal.die()
		animal = null
		return
	animal.player_movement(delta)

func eat(experience: float, hunger: float) -> void:
	exp_value = min(exp_max, exp_value + experience)
	hunger_value = min(hunger_max, hunger_value + hunger)

func _on_hunger_drain_timer_timeout() -> void:
	hunger_value -= hunger_max / 50.0
