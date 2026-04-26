extends Node2D

class_name Player

const CAMERA_ZOOM_MAX := 2.0
const CAMERA_ZOOM_MIN := 0.35
const CAMERA_REFERENCE_VISION_RADIUS := 33.359993
const EVOLUTION_PROTECTION_MS := 750

var animal: Animal
var _evolution_protection_until_msec: int = 0
@export var STARTING_CHARACTER : Constants.EntityID

@export var spawnpoint_marker: Marker2D

@export var ui: GameUI
@export var camera: Camera2D
@export var evolution_animation: AnimatedSprite2D

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
	change_playing_animal(STARTING_CHARACTER)
	evolution_animation.hide()

func on_animal_died() -> void:
	if animal:
		animal = null
	if ui:
		ui.show_death_screen()

func is_evolution_protected() -> bool:
	return Time.get_ticks_msec() < _evolution_protection_until_msec

func _physics_process(delta: float) -> void:
	#print(self.animal.global_position)
	if !animal:
		return
	camera.position = animal.position
	if hunger_value < 0.0:
		on_animal_died()
		return
	if exp_value > exp_max:
		# do level up
		pass
	animal.player_movement(delta)

func change_playing_animal(animal_id: Constants.EntityID) -> void:
	var spawnpoint: Vector2 = spawnpoint_marker.global_position
	if animal:
		var previous_animal := animal
		spawnpoint = previous_animal.global_position
		animal = null
	
		previous_animal.set_physics_process(false)
		previous_animal.collision_layer = 0
		previous_animal.collision_mask = 0
	
		if previous_animal is SentientAnimal:
			var sentient_previous := previous_animal as SentientAnimal
			if sentient_previous.eating_area:
				sentient_previous.eating_area.monitoring = false
				sentient_previous.eating_area.monitorable = false
			if sentient_previous.vision_area:
				sentient_previous.vision_area.monitoring = false
				sentient_previous.vision_area.monitorable = false
	
		remove_child(previous_animal)
		previous_animal.queue_free()
	
	evolution_animation.global_position = spawnpoint
	evolution_animation.z_index = 200
	evolution_animation.stop()
	evolution_animation.frame = 0
	evolution_animation.frame_progress = 0.0
	evolution_animation.show()
	evolution_animation.play("default")
	
	var animal_scene: PackedScene = Constants.entity_dict.get(animal_id)
	animal = animal_scene.instantiate()
	
	hunger_max = animal.entity_resource.hunger_max
	hunger_value = float(animal.entity_resource.hunger_max) / 2
	exp_max = animal.entity_resource.exp_max
	exp_value = 0.0
	
	add_child(animal)
	animal.global_position = spawnpoint
	_evolution_protection_until_msec = Time.get_ticks_msec() + EVOLUTION_PROTECTION_MS
	_update_camera_zoom()

func eat(experience: float, hunger: float) -> void:
	exp_value += experience
	hunger_value = min(hunger_max, hunger_value + hunger)
	
	if exp_value >= exp_max:
		change_playing_animal(get_next_entity_id(animal.entity_resource.id))

func _on_hunger_drain_timer_timeout() -> void:
	hunger_value -= hunger_max / 100.0

func get_next_entity_id(current_id: Constants.EntityID) -> Constants.EntityID:
	var ids: Array = Constants.EntityID.values()
	var index := ids.find(current_id)
	if index == -1:
		return Constants.EntityID.NONE
	
	for i in range(index + 1, ids.size()):
		var candidate = ids[i]
		if candidate == Constants.EntityID.KIWI:
			continue
		if Constants.entity_dict.has(candidate):
			return candidate
	
	return Constants.EntityID.NONE

func _get_camera_zoom_amount_for_rank(hierarchy: Constants.FoodHierarchy) -> float:
	match hierarchy:
		Constants.FoodHierarchy.SEED:
			return CAMERA_ZOOM_MAX
		Constants.FoodHierarchy.TIER0:
			return 1.4
		Constants.FoodHierarchy.TIER1:
			return 1.0
		Constants.FoodHierarchy.TIER2:
			return 0.75
		Constants.FoodHierarchy.TIER3:
			return 0.55
		Constants.FoodHierarchy.TIER4:
			return 0.45
		Constants.FoodHierarchy.DOMINANT:
			return CAMERA_ZOOM_MIN
		_:
			return 1.0

func _update_camera_zoom() -> void:
	if !animal or !animal.entity_resource:
		return

	var zoom_amount := _get_camera_zoom_amount_for_rank(animal.entity_resource.hierarchy)
	camera.zoom = Vector2.ONE * zoom_amount

func _on_evolution_animation_animation_finished() -> void:
	evolution_animation.hide()
