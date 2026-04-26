extends Node2D

class_name World

const RELATION_LIGHT_NAME := "RelationLight"
const RELATION_GLOW_NAME := "RelationGlow"
const RELATION_LIGHT_TEXTURE := preload("res://asset/huge-light.png")
const PREDATOR_LIGHT_COLOR := Color(1.0, 0.05, 0.05, 1.0)
const PREY_LIGHT_COLOR := Color(0.05, 1.0, 0.15, 1.0)

var plants_enums : Array[int]
var tier0_enums : Array[int]
var tier1_enums : Array[int]
var tier2_enums : Array[int]
var tier3_enums : Array[int]
var tier4_enums : Array[int]
var dominant_enums : Array[int]

@export var plant_timer : Timer
@export var tier0_timer : Timer
@export var tier1_timer : Timer
@export var tier2_timer : Timer
@export var tier3_timer : Timer
@export var tier4_timer : Timer
@export var dominant_timer : Timer

@export var low_spawn : Area2D
@export var med_spawn : Area2D
@export var high_spawn : Area2D

@onready var animals_root: Node2D = $animals
@onready var player: Player = $Player

func _ready() -> void:
	AudioManager.play_game_music()
	GameSession.world = self
	for key in Constants.EntityID:
		var entityid = Constants.EntityID[key]
		if (entityid < 0): 
			plants_enums.push_back(entityid)
		elif (0 <= entityid && entityid < 100): 
			tier0_enums.push_back(entityid)
		elif (100 <= entityid  && entityid < 200): 
			tier1_enums.push_back(entityid)
		elif (200 <= entityid  && entityid < 300): 
			tier2_enums.push_back(entityid)
		elif (300 <= entityid && entityid < 400): 
			tier3_enums.push_back(entityid)
		elif (400 <= entityid && entityid < 500): 
			tier4_enums.push_back(entityid)
		elif (500 <= entityid): 
			dominant_enums.push_back(entityid)
	_connect_legacy_spawn_timer(plant_timer, plants_enums)
	_connect_legacy_spawn_timer(tier0_timer, tier0_enums)
	_connect_legacy_spawn_timer(tier1_timer, tier1_enums)
	_connect_legacy_spawn_timer(tier2_timer, tier2_enums)
	_connect_legacy_spawn_timer(tier3_timer, tier3_enums)
	_connect_legacy_spawn_timer(tier4_timer, tier4_enums)
	_connect_legacy_spawn_timer(dominant_timer, dominant_enums)

func _process(_delta: float) -> void:
	_update_relation_lights()

func _connect_legacy_spawn_timer(timer: Timer, targetlist: Array[int]) -> void:
	if timer == null:
		return
	if !timer.timeout.is_connected(timeout_spawn.bind(targetlist)):
		timer.timeout.connect(timeout_spawn.bind(targetlist))
	
func random_position(spawn_enum : int) -> Vector2:
	var ranges : Array
	if low_spawn and (spawn_enum & Constants.SpawnHeight.LOW):
		ranges.append(low_spawn)
	if med_spawn and (spawn_enum & Constants.SpawnHeight.MEDIUM):
		ranges.append(med_spawn)
	if high_spawn and (spawn_enum & Constants.SpawnHeight.HIGH):
		ranges.append(high_spawn)
	if (len(ranges) != 0):
		var target_area : Area2D = ranges[randi_range(0, len(ranges)-1)]
		var rect = target_area.get_node("CollisionShape2D").shape.get_rect()
		var top_left = rect.position
		var bottom_right = rect.end
		
		var debug = Vector2( randi_range(top_left.x, bottom_right.x), randi_range(top_left.y, bottom_right.y) )
		return debug
	
	return Vector2(0,0) # NEVER LET THIS FUCKING HAPPEN, PUT IN YOUR AREAS

func spawn_entity(entityenum : int):
	return
	var animal_scene: PackedScene = Constants.entity_dict.get(entityenum)
	if (animal_scene):
		var animal : Animal = animal_scene.instantiate()
		animals_root.add_child(animal)
		# get animal spawn position enums
		var pos : Vector2 = random_position(animal.entity_resource.spawn_height)
		animal.global_position = pos
		animal.position = pos
		animal.domain_point = pos


func timeout_spawn(targetlist : Array) -> void:
	if (targetlist):
		var randval = targetlist[randi_range(0, len(targetlist)-1)]
		spawn_entity(randval)

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
		relation_light.texture_scale = 4.0
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
		relation_glow.scale = Vector2.ONE * 0.18
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
