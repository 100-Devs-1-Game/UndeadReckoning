extends Node3D

@export var fog_speed := 10.0

@onready var fog_volume1: FogVolume = $FogVolume
@onready var fog_volume2: FogVolume = $FogVolume2

@onready var fog: Array[FogVolume] = [ fog_volume1, fog_volume2 ]

@onready var plane: Node3D = $full_plane



func _process(delta: float) -> void:
	for fog_node in fog:
		fog_node.position.z -= delta * fog_speed
		if fog_node.position.z < -100:
			fog_node.position.z += 200

	plane.rotation.z= lerp(plane.rotation.z, 0.0, delta * 2)
	
	if randf() < 10 * delta:
		plane.rotation.z+= randf_range(-0.005, 0.005)
