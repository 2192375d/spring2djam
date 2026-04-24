class_name EntityResource
extends Resource

@export var id: Constants.EntityID
@export var hierarchy: Constants.FoodHierarchy
@export var exp_gain: int
@export var exp_max: int
@export var hunger_gain: int
@export var hunger_max: int
@export var ai_type: Constants.AIType

func _init() -> void:
	if ai_type == Constants.AIType.NONE:
		hunger_max = -1
		exp_max = -1

#func _init(id = null, exp_gain = 0, hp_gain = 0, energy_gain = 0, hierarchy=Constants.FoodHierarchy.TIER0):
	#self.id = id
	#self.exp_gain = exp_gain
	#self.energy_gain = energy_gain
	#self.hierarchy = hierarchy
