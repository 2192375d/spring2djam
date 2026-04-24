class_name CollectableResource
extends Resource

@export var id : Constants.EntityID
@export var hierarchy : Constants.FoodHierarchy
@export var energy_gain : int

func _init(id = null, exp_gain = 0, hp_gain = 0, energy_gain = 0, hierarchy=Constants.FoodHierarchy.TIER0):
	self.id = id
	self.exp_gain = exp_gain
	self.energy_gain = energy_gain
	self.hierarchy = hierarchy
