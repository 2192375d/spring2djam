extends Node2D

class_name World

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


func _ready() -> void:
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
	plant_timer.timeout.connect(func(): timeout_spawn(plants_enums))
	tier0_timer.timeout.connect(func(): timeout_spawn(tier0_enums))
	tier1_timer.timeout.connect(func(): timeout_spawn(tier1_enums))
	tier2_timer.timeout.connect(func(): timeout_spawn(tier2_enums))
	tier3_timer.timeout.connect(func(): timeout_spawn(tier3_enums))
	tier4_timer.timeout.connect(func(): timeout_spawn(tier4_enums))
	dominant_timer.timeout.connect(func(): timeout_spawn(dominant_enums))
	
func random_position(spawn_enum : int) -> Vector2:
	var ranges : Array
	if (spawn_enum & Constants.SpawnHeight.LOW):
		ranges.append(low_spawn)
	if (spawn_enum & Constants.SpawnHeight.MEDIUM):
		ranges.append(med_spawn)
	if (spawn_enum & Constants.SpawnHeight.HIGH):
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
		self.add_child(animal)
		# get animal spawn position enums
		var pos : Vector2 = random_position(animal.entity_resource.spawn_height)
		animal.global_position = pos
		animal.position = pos
		animal.domain_point = pos


func timeout_spawn(targetlist : Array) -> void:
	if (targetlist):
		var randval = targetlist[randi_range(0, len(targetlist)-1)]
		spawn_entity(randval)
