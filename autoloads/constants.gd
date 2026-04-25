extends Node

var GRAVITY: float = 20.0
var JUMP_SPEED: float = 100.0

enum FoodHierarchy { 
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
	WORM = 0,
	KIWI = 100,
} # TODO: finish entities

var entity_dict: Dictionary[EntityID, PackedScene] = {
	EntityID.WORM: load("uid://d2kw626g1cvh2"),
	EntityID.KIWI: load("uid://n17g23ay3e7i"),
}

var blood_effect_scene: PackedScene = load("uid://cdage3p7lypba")
