extends Node2D

class_name Player

const CAMERA_ZOOM_MAX := 2.0
const CAMERA_ZOOM_MIN := 0.35
const CAMERA_REFERENCE_VISION_RADIUS := 33.359993
var CAMERA_RECT : Rect2 
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
	_resolve_scene_refs()
	change_playing_animal(STARTING_CHARACTER)
	if evolution_animation:
		evolution_animation.hide()

func _resolve_scene_refs() -> void:
	if spawnpoint_marker == null:
		spawnpoint_marker = get_node_or_null("../Spawnpoint Marker") as Marker2D
	if ui == null:
		ui = get_node_or_null("../game_ui") as GameUI
	if camera == null:
		camera = get_node_or_null("Camera2D") as Camera2D
	if evolution_animation == null:
		evolution_animation = get_node_or_null("EvolutionAnimation") as AnimatedSprite2D

func on_animal_died() -> void:
	AudioManager.play_death()
	AudioManager.stop_game_music()
	if animal:
		animal = null
	if ui:
		ui.show_death_screen()

func is_evolution_protected() -> bool:
	return Time.get_ticks_msec() < _evolution_protection_until_msec

func _physics_process(delta: float) -> void:
	if !animal:
		return
	if !camera:
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
	_resolve_scene_refs()
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
	
	if evolution_animation:
    AudioManager.play_evolution()
		evolution_animation.global_position = spawnpoint
		evolution_animation.z_index = 200
		evolution_animation.stop()
		evolution_animation.frame = 0
		evolution_animation.frame_progress = 0.0
		evolution_animation.show()
		evolution_animation.play("default")
	
	var animal_scene: PackedScene = Constants.entity_dict.get(animal_id)
	if animal_scene == null:
		push_error("Missing entity scene for id %s" % animal_id)
		return
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
	AudioManager.play_kill()
	
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
		Constants.FoodHierarchy.PREYS:
			return 1.7
		Constants.FoodHierarchy.TIER0:
			return 1.4
		Constants.FoodHierarchy.TIER1:
			return 1.0
		Constants.FoodHierarchy.TIER2:
			return 0.75
		Constants.FoodHierarchy.TIER3:
			return 0.55
		Constants.FoodHierarchy.DOMINANT:
			return CAMERA_ZOOM_MIN
		_:
			return 1.0

func _update_camera_zoom() -> void:
	if !animal or !animal.entity_resource or !camera:
		return

	var zoom_amount := _get_camera_zoom_amount_for_rank(animal.entity_resource.hierarchy)
	camera.zoom = Vector2.ONE * zoom_amount

func _on_evolution_animation_animation_finished() -> void:
	if evolution_animation:
		evolution_animation.hide()

func get_camera_rect() -> Rect2:
	if !camera:
		return Rect2()
	var viewport_size := get_viewport().get_visible_rect().size
	var center := camera.get_screen_center_position()
	# Camera2D zoom scales screen pixels per world unit; world-space visible size is viewport / zoom.
	var size := (viewport_size / camera.zoom) * 1.5
	return Rect2(center - size * 0.5, size)
	
func _on_repause_timer_timeout() -> void:
	# iterate through all animals
	CAMERA_RECT = get_camera_rect()
	for animal : Animal in get_tree().get_nodes_in_group("animals"):
		if CAMERA_RECT.has_point(animal.global_position):
			animal.process_mode = PROCESS_MODE_INHERIT
		else:
			animal.process_mode = PROCESS_MODE_DISABLED
			print("paused this", animal)
		
