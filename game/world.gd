extends Node2D

class_name World

const RELATION_LIGHT_NAME := "RelationLight"
const RELATION_GLOW_NAME := "RelationGlow"
const RELATION_LIGHT_TEXTURE := preload("res://asset/circle-light.png")
const RELATION_GLOW_SHADER_PARAM := "glow_color"
const PREDATOR_LIGHT_COLOR := Color(1.0, 0.05, 0.05, 1.0)
const PREY_LIGHT_COLOR := Color(0.05, 1.0, 0.15, 1.0)
const SAME_LIGHT_COLOR := Color(1.0, 1.0, 1.0, 1.0)

@onready var animals_root: Node2D = $animals
@onready var player: Player = $Player
@onready var lightsupdatetimer : Timer = $LightUpdateTimer

func _ready() -> void:
	AudioManager.play_game_music()
	GameSession.world = self
	
	player.evolved.connect(_update_relation_lights)
	lightsupdatetimer.timeout.connect(_update_relation_lights)
	_update_relation_lights()

func _process(_delta: float) -> void:
	pass

func _update_relation_lights() -> void:
	if !player or !player.animal or !is_instance_valid(player.animal):
		return

	var player_hierarchy: Constants.FoodHierarchy = player.animal.entity_resource.hierarchy
	for animal: Animal in get_tree().get_nodes_in_group("animals"):

		if !is_instance_valid(animal) or animal.entity_resource == null:
			continue

		var relation_material := _get_relation_shader_material(animal)
		if relation_material == null:
			continue

		var relation_hierarchy: Constants.FoodHierarchy = animal.entity_resource.hierarchy
		if relation_hierarchy == player_hierarchy:
			relation_material.set_shader_parameter(RELATION_GLOW_SHADER_PARAM, SAME_LIGHT_COLOR)
		elif relation_hierarchy > player_hierarchy:
			relation_material.set_shader_parameter(RELATION_GLOW_SHADER_PARAM, PREDATOR_LIGHT_COLOR)
		else:
			relation_material.set_shader_parameter(RELATION_GLOW_SHADER_PARAM, PREY_LIGHT_COLOR)


func _get_relation_shader_material(animal: Animal) -> ShaderMaterial:
	if animal == null or animal.animation == null:
		return null

	var shader_material := animal.animation.material as ShaderMaterial
	if shader_material == null:
		return null

	# Duplicate shared resources so each animal can keep an independent glow color.
	if !animal.animation.material.resource_local_to_scene:
		shader_material = shader_material.duplicate()
		shader_material.resource_local_to_scene = true
		animal.animation.material = shader_material

	return shader_material
