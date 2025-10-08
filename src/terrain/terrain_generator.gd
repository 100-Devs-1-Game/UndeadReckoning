class_name TerrainGenerator
extends BaseTerrainGenerator


@export_group("Base Continent")
@export var noise_continent: FastNoiseLite
@export var continent_slope_scale: float = 8.0
@export var continent_min_height: float = -10.0
@export var continent_max_height: float = 25.0
@export_group("Mountain Control")
@export var noise_mountain: FastNoiseLite
@export var mountain_scale: float = 220
@export var mountain_start_height: float = 5.0
@export var mountain_fade_height: float = 10.0
@export_group("Valley Control")
@export var noise_valley: FastNoiseLite
@export var valley_carve_scale: float = 15.0
@export var valley_apply_threshold: float = 5.0
@export_group("Erosion Control")
@export var noise_erosion: FastNoiseLite
@export var erosion_scale: float = 2.5


func get_height_at(pos: Vector2)-> float:
	var raw_continent_noise = noise_continent.get_noise_2dv(pos)
	var normalized_continent_noise = (raw_continent_noise + 1.0) * 0.5
	var conceptual_base_height = lerp(continent_min_height, continent_max_height, normalized_continent_noise)
	
	var mountain_modulator = clamp((conceptual_base_height - mountain_start_height) / mountain_fade_height, 0.0, 1.0)
	var m_potential = max(0.0, noise_mountain.get_noise_2dv(pos)) * mountain_scale
	var m = m_potential * mountain_modulator
	
	var valley_carve = 0.0
	if conceptual_base_height < valley_apply_threshold:
		var valley_noise = noise_valley.get_noise_2dv(pos)
		var negative_valley = min(valley_noise, 0.0)
		var valley_modulator = clamp((valley_apply_threshold - conceptual_base_height) / valley_apply_threshold, 0.0, 1.0)
		valley_carve = negative_valley * valley_carve_scale * valley_modulator
	
	var erosion_modulator = 1.0 - abs(normalized_continent_noise - 0.5) * 2.0
	var bump_e = noise_erosion.get_noise_2dv(pos) * erosion_scale * erosion_modulator
	var c_slope_contribution = raw_continent_noise * continent_slope_scale
	
	var height = c_slope_contribution + m + valley_carve + bump_e
	return height
