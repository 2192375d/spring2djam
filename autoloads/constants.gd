extends Node

var GRAVITY: float = 30.0
var JUMP_SPEED: float = 100.0
var CONSTANT_DOMAIN_RADIUS : float = 50.0

enum FoodHierarchy { 
	SEED = -1,
	TIER0 = 0,
	TIER1 = 1, 
	TIER2 = 2, 
	TIER3 = 3, 
	TIER4 = 4, 
	DOMINANT = 5,
}
enum AIType {
	NONE = -1,
	GROUND = 0, 
	LOW = 1, 
	HIGH = 1,
}
enum EntityID {
	SEEDS = -100,
	BERRIES = -99,
	EGGS = -98,
	
	# tier 0
	WORM = 0,
	BUTTERFLY = 1,
	
	# tier 1
	KIWI = 100,
	DOVE = 101,
	PIGEON = 102,
	CROW = 103,
	
	# tier 2
	LOON = 201,
	DUCK = 202,
	GOOSE = 203,
	
	# tier 3
	HERON = 301,
} 

var entity_dict: Dictionary[EntityID, PackedScene] = {
	EntityID.WORM: load("uid://d2kw626g1cvh2"),
	EntityID.CROW : load("uid://cxb7ymqcrgll7"),
	EntityID.KIWI: load("uid://n17g23ay3e7i"),
}

var blood_effect_scene: PackedScene = load("uid://cdage3p7lypba")
