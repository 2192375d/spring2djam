@tool
extends EditorScript

const SOURCE_SCENE_PATH := "res://entity/scenes/duck.tscn"
const TARGET_NAME := "crow"
const TARGET_TYPE := 1

const TYPE_TO_SCRIPT := {
	0: "res://entity/plant.gd",
	1: "res://entity/ground_animal.gd",
	2: "res://entity/low_flying_animal.gd",
}

func _run() -> void:
	var source_scene: PackedScene = load(SOURCE_SCENE_PATH)
	if source_scene == null:
		push_error("Could not load source scene: %s" % SOURCE_SCENE_PATH)
		return
	
	var root: Node = source_scene.instantiate()
	if root == null:
		push_error("Could not instantiate source scene: %s" % SOURCE_SCENE_PATH)
		return
	
	var target_script_path: String = TYPE_TO_SCRIPT.get(TARGET_TYPE, "")
	if target_script_path.is_empty():
		push_error("Unsupported TARGET_TYPE %s. Use 0 for plant, 1 for ground, 2 for flying." % TARGET_TYPE)
		return
	
	var target_script: Script = load(target_script_path)
	if target_script == null:
		push_error("Could not load target script: %s" % target_script_path)
		return
	
	root.set_script(target_script)
	root.name = TARGET_NAME.capitalize()
	
	var label: Label = root.get_node_or_null("Label")
	if label == null:
		push_error("Expected a Label node under %s." % SOURCE_SCENE_PATH)
		return
	label.text = TARGET_NAME
	
	var target_scene_path := "res://entity/scenes/%s.tscn" % TARGET_NAME
	
	var packed_scene := PackedScene.new()
	var pack_result: Error = packed_scene.pack(root)
	if pack_result != OK:
		push_error("Failed to pack duplicated scene. Error code: %s" % pack_result)
		return
	
	var save_result: Error = ResourceSaver.save(packed_scene, target_scene_path)
	if save_result != OK:
		push_error("Failed to save %s. Error code: %s" % [target_scene_path, save_result])
		return
	
	print("Created %s from %s." % [target_scene_path, SOURCE_SCENE_PATH])
