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


func _ready() -> void:
	GameSession.world = self
	for entityid in Constants.EntityID:
		if (entityid < 0): 
			plants_enums.push_back(entityid)
		elif (0 <= entityid < 100): 
			tier0_enums.push_back(entityid)
		elif (100 <= entityid < 200): 
			tier1_enums.push_back(entityid)
		elif (200 <= entityid < 300): 
			tier2_enums.push_back(entityid)
		elif (300 <= entityid < 400): 
			tier3_enums.push_back(entityid)
		elif (400 <= entityid < 500): 
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
	

func spawn_entity(entityenum : int):
	var animal_scene: PackedScene = Constants.entity_dict.get(entityenum)
	var animal = animal_scene.instantiate()
	self.add_child(animal)
	
	animal.position = Vector2(200, 30)
	

func timeout_spawn(targetlist : Array) -> void:
	if (targetlist):
		var randval = targetlist[randi_range(0, len(targetlist))]
		spawn_entity(randval)
