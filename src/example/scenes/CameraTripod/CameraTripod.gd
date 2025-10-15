class_name CameraTripod
extends Node3D


@export var TargetNode: NodePath
@export var RotationSpeed: float = 1.0

@onready var target_node = get_node_or_null(TargetNode)
@onready var camera: Camera3D = $Camera3D


func _process(delta):
	if target_node and is_instance_valid(target_node):
		global_transform.origin = target_node.global_transform.origin
		rotation.x = lerp_angle(rotation.x, target_node.rotation.x, delta*RotationSpeed)
		rotation.y = lerp_angle(rotation.y, target_node.rotation.y, delta*RotationSpeed)
		rotation.z = lerp_angle(rotation.z, target_node.rotation.z, delta*RotationSpeed)
