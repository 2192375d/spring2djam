extends Node

@export var rainbow_speed: float = 0.5
@export_range(1.0, 60.0, 1.0) var updates_per_second: float = 10.0

var _hue: float = 0.0
var _accum: float = 0.0
var _rainbow_materials: Array[ShaderMaterial] = []

func _ready() -> void:
	for child: Node in get_children():
		var guide := child as Label
		if guide == null:
			continue

		var shader_material := guide.material as ShaderMaterial
		if shader_material == null or _rainbow_materials.has(shader_material):
			continue

		_rainbow_materials.append(shader_material)
		shader_material.set_shader_parameter("hue_offset", _hue)

	set_process(!_rainbow_materials.is_empty())

func _process(delta: float) -> void:
	_accum += delta

	var step: float = 1.0 / max(updates_per_second, 1.0)
	if _accum < step:
		return

	_hue = wrapf(_hue + rainbow_speed * _accum, 0.0, 1.0)
	for shader_material: ShaderMaterial in _rainbow_materials:
		shader_material.set_shader_parameter("hue_offset", _hue)

	_accum = 0.0
