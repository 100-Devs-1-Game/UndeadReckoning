class_name TerrainProvider
extends Node

@export var terrain_generator: BaseTerrainGenerator
@export var overall_scale: float = 1.0


func get_height_at(_x: float, _z: float)-> float:
	return 0
