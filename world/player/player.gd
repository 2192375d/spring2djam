extends Node2D

class_name Player

var animal: Animal
@export var STARTING_CHARACTER = Constants.EntityID.CROW

@export var spawnpoint_marker: Marker2D

@export var ui: GameUI
@export var camera: Camera2D

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
	var animal_scene: PackedScene = Constants.entity_dict.get(STARTING_CHARACTER)
	animal = animal_scene.instantiate()
	add_child(animal)
	
	animal.global_position = spawnpoint_marker.global_position
	
	hunger_max = animal.entity_resource.hunger_max
	hunger_value = float(hunger_max) / 2
	exp_max = animal.entity_resource.exp_max
	exp_value = 0.0

func _physics_process(delta: float) -> void:
	
	if !animal:
		return
	camera.position = animal.position
	if hunger_value < 0.0:
		animal.die()
		animal = null
		return
	if exp_value > exp_max:
		# do level up
		pass
	animal.player_movement(delta)

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

func eat(experience: float, hunger: float) -> void:
	exp_value += exp_value + experience
	hunger_value = min(hunger_max, hunger_value + hunger)
	
	if exp_value > exp_max:
		pass

func _on_hunger_drain_timer_timeout() -> void:
	hunger_value -= hunger_max / 50.0
