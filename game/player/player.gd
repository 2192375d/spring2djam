extends Node2D

class_name Player

const CAMERA_ZOOM_MAX := 2.0
const CAMERA_ZOOM_MIN := 0.35
const CAMERA_REFERENCE_VISION_RADIUS := 33.359993

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
	change_playing_animal(STARTING_CHARACTER)

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
	var spawnpoint: Vector2 = spawnpoint_marker.global_position
	if animal:
		spawnpoint = animal.global_position
		animal.queue_free()
	
	var animal_scene: PackedScene = Constants.entity_dict.get(animal_id)
	animal = animal_scene.instantiate()
	
	hunger_max = animal.entity_resource.hunger_max
	hunger_value = float(animal.entity_resource.hunger_max) / 2
	exp_max = animal.entity_resource.exp_max
	exp_value = 0.0
	
	add_child(animal)
	animal.global_position = spawnpoint
	_update_camera_zoom()

func eat(experience: float, hunger: float) -> void:
	exp_value += exp_value + experience
	hunger_value = min(hunger_max, hunger_value + hunger)
	
	if exp_value > exp_max:
		change_playing_animal(get_next_entity_id(animal.entity_resource.id))

func _on_hunger_drain_timer_timeout() -> void:
	hunger_value -= hunger_max / 50.0

func get_next_entity_id(current_id: Constants.EntityID) -> Constants.EntityID:
	var ids: Array = Constants.EntityID.values()
	var index := ids.find(current_id)
	if index == -1:
		return Constants.EntityID.NONE
	
	for i in range(index + 1, ids.size()):
		var candidate = ids[i]
		if Constants.entity_dict.has(candidate):
			return candidate
	
	return Constants.EntityID.NONE

func _update_camera_zoom() -> void:
	var vision_shape: CollisionShape2D = animal.get_node_or_null("VisionArea/CollisionShape2D")
	if !vision_shape or !(vision_shape.shape is CircleShape2D):
		return

	var vision_radius: float = (vision_shape.shape as CircleShape2D).radius
	var zoom_amount: float = clamp(
		CAMERA_REFERENCE_VISION_RADIUS / vision_radius * CAMERA_ZOOM_MAX,
		CAMERA_ZOOM_MIN,
		CAMERA_ZOOM_MAX
	)
	camera.zoom = Vector2.ONE * zoom_amount
