class_name NewTerrainGenerator
extends BaseTerrainGenerator


@export_group("Base Height")
@export var base_noise_scale: float= 0.1
@export var noise_height: FastNoiseLite
@export var min_height: float = 0
@export var max_height: float = 300.0

@export_group("Mountains")
@export var base_mountain_scale: float= 0.1
@export var noise_mountains: FastNoiseLite
@export var mountains_threshold: float = 0
@export var mountain_max_height: float = 3000.0


func get_height_at(pos: Vector2)-> float:
	var height: float= noise_height.get_noise_2dv(pos * base_noise_scale)
	height= remap(height, -1.0, 1.0, min_height, max_height)
	#var height: float= 0.0

	var mountains: float= noise_mountains.get_noise_2dv(pos * base_mountain_scale)
	if mountains > mountains_threshold:
		height= lerp(height, mountain_max_height, remap(mountains, mountains_threshold, 1.0, 0.0, 1.0))
	
	return height
