extends Node2D

class_name World

const RELATION_LIGHT_NAME := "RelationLight"
const RELATION_GLOW_NAME := "RelationGlow"
const RELATION_LIGHT_TEXTURE := preload("res://asset/circle-light.png")
const PREDATOR_LIGHT_COLOR := Color(1.0, 0.05, 0.05, 1.0)
const PREY_LIGHT_COLOR := Color(0.05, 1.0, 0.15, 1.0)

var plants_enums : Array[int]
var tier0_enums : Array[int]
var tier1_enums : Array[int]
var tier2_enums : Array[int]
var tier3_enums : Array[int]
var tier4_enums : Array[int]
var dominant_enums : Array[int]


@onready var animals_root: Node2D = $animals
@onready var player: Player = $Player

func _ready() -> void:
	AudioManager.play_game_music()
	GameSession.world = self


func _process(_delta: float) -> void:
	_update_relation_lights()




func _update_relation_lights() -> void:
	if !player or !player.animal or !is_instance_valid(player.animal):
		_hide_relation_lights()
		return

	var player_hierarchy: Constants.FoodHierarchy = player.animal.entity_resource.hierarchy
	for animal: Animal in _get_tracked_animals():
		if animal.entity_resource == null:
			_set_relation_light_visible(animal, false)
			continue

		var relation_hierarchy: Constants.FoodHierarchy = animal.entity_resource.hierarchy
		if relation_hierarchy == player_hierarchy:
			_set_relation_light_visible(animal, false)
		elif relation_hierarchy > player_hierarchy:
			_configure_relation_light(animal, PREDATOR_LIGHT_COLOR)
		else:
			_configure_relation_light(animal, PREY_LIGHT_COLOR)

func _hide_relation_lights() -> void:
	for animal: Animal in _get_tracked_animals():
		_set_relation_light_visible(animal, false)

func _get_tracked_animals() -> Array[Animal]:
	var tracked_animals: Array[Animal] = []

	if animals_root:
		for child: Node in animals_root.get_children():
			var animal := child as Animal
			if animal:
				tracked_animals.append(animal)

	for child: Node in get_children():
		if child is Spawner:
			for spawned_child: Node in child.get_children():
				var spawned_animal := spawned_child as Animal
				if spawned_animal:
					tracked_animals.append(spawned_animal)

	return tracked_animals

func _configure_relation_light(animal: Animal, color: Color) -> void:
	var relation_light := animal.get_node_or_null(RELATION_LIGHT_NAME) as PointLight2D
	if relation_light == null:
		relation_light = PointLight2D.new()
		relation_light.name = RELATION_LIGHT_NAME
		relation_light.texture = RELATION_LIGHT_TEXTURE
		relation_light.texture_scale = 1.0
		relation_light.energy = 0.85
		relation_light.position = Vector2.ZERO
		animal.add_child(relation_light)

	relation_light.color = color
	relation_light.enabled = true

	var relation_glow := animal.get_node_or_null(RELATION_GLOW_NAME) as Sprite2D
	if relation_glow == null:
		relation_glow = Sprite2D.new()
		relation_glow.name = RELATION_GLOW_NAME
		relation_glow.texture = RELATION_LIGHT_TEXTURE
		relation_glow.centered = true
		relation_glow.scale = Vector2.ONE * 0.06
		relation_glow.show_behind_parent = true
		relation_glow.z_index = -1
		animal.add_child(relation_glow)

	relation_glow.modulate = Color(color.r, color.g, color.b, 0.55)
	relation_glow.visible = true

func _set_relation_light_visible(animal: Animal, is_visible: bool) -> void:
	var relation_light := animal.get_node_or_null(RELATION_LIGHT_NAME) as PointLight2D
	if relation_light:
		relation_light.enabled = is_visible

	var relation_glow := animal.get_node_or_null(RELATION_GLOW_NAME) as Sprite2D
	if relation_glow:
		relation_glow.visible = is_visible
