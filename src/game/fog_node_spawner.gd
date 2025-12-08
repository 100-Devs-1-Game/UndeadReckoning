class_name FogNodeSpawner
extends Node

@export var viewer: Node3D
@export var remove_distance: float= 100
@export var minimum_spread: float= 25
@export var fog_node_scene: PackedScene

var last_viewer_pos: Vector3


func _ready() -> void:
	assert(viewer)
	assert(fog_node_scene)
	spawn_fog(viewer.global_position)


func _physics_process(delta: float) -> void:
	if not viewer or not is_instance_valid(viewer):
		return
		
	var velocity: Vector3
	if last_viewer_pos:
		velocity= (viewer.global_position - last_viewer_pos) / delta

	for i in 5:
		var look_target: Vector3= viewer.global_position - viewer.global_basis.z * i * (minimum_spread + 1) + velocity
		
		if get_fog_nodes_in_radius(look_target, minimum_spread).is_empty():
			spawn_fog(look_target)
			assert(get_child_count() < 50)

	for remove_node in get_fog_nodes_in_radius(viewer.global_position, remove_distance, true):
		remove_node.queue_free()

	last_viewer_pos= viewer.global_position


func spawn_fog(pos: Vector3):
	var fog: FogVolume= fog_node_scene.instantiate()
	fog.position= pos
	add_child(fog)
	fog.look_at(fog.position - viewer.global_basis.z)


func get_fog_nodes_in_radius(pos: Vector3, radius: float, invert: bool= false)-> Array[FogVolume]:
	var result: Array[FogVolume]
	for fog: FogVolume in get_children():
		if invert and fog.global_position.distance_to(pos) > radius:
			result.append(fog)
		elif not invert and fog.global_position.distance_to(pos) < radius:
			result.append(fog)
	return result
