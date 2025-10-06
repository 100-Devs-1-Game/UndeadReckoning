# Chunk.gd
# Generates and holds the data for a single segment of the world,
# including terrain mesh, water, grass, and trees.
class_name Chunk
extends Node3D

signal finished_generating

# --- Node References ---
@export var mesh_instance: MeshInstance3D
@export var collision_shape: CollisionShape3D

# --- Chunk Configuration ---
@export_group("Chunk Size")
@export var chunk_size_x: int = 32
@export var chunk_size_z: int = 32
@export var vertices_x: int = 33
@export var vertices_z: int = 33


# --- Terrain Generation ---
@export_group("Base Continent")
@export var noise_continent: FastNoiseLite
@export var continent_slope_scale: float = 8.0
@export var continent_min_height: float = -10.0
@export var continent_max_height: float = 25.0
@export_group("Mountain Control")
@export var noise_mountain: FastNoiseLite
@export var mountain_scale: float = 40.0
@export var mountain_start_height: float = 10.0
@export var mountain_fade_height: float = 10.0
@export_group("Valley Control")
@export var noise_valley: FastNoiseLite
@export var valley_carve_scale: float = 15.0
@export var valley_apply_threshold: float = 5.0
@export_group("Erosion Control")
@export var noise_erosion: FastNoiseLite
@export var erosion_scale: float = 2.5


# --- Overall Scaling ---
@export_group("Overall Scaling")
@export var overall_scale: float = 10.0

# --- Internal State ---
var chunk_coords: Vector2i = Vector2i.ZERO
var _grass_blade_mesh: ArrayMesh
var _tree_mesh: ArrayMesh
var _sorted_grass_transforms: Array[Transform3D] = []
var _noise_path: FastNoiseLite # Reference to the global path noise generator.


func initialize_chunk(coords: Vector2i, path_noise: FastNoiseLite) -> void:
	chunk_coords = coords
	_noise_path = path_noise
	
	global_position.x = coords.x * chunk_size_x * overall_scale
	global_position.z = coords.y * chunk_size_z * overall_scale
	name = "Chunk_%d_%d" % [coords.x, coords.y]
	
	generate_terrain()
	
	scale = Vector3(overall_scale, overall_scale, overall_scale)



func generate_terrain() -> void:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var step_x = chunk_size_x / float(vertices_x - 1)
	var step_z = chunk_size_z / float(vertices_z - 1)
	
	for z in range(vertices_z):
		for x in range(vertices_x):
			var vx = x * step_x
			var vz = z * step_z
			var wx = vx + chunk_coords.x * chunk_size_x
			var wz = vz + chunk_coords.y * chunk_size_z
			
			var raw_continent_noise = noise_continent.get_noise_2d(wx, wz)
			var normalized_continent_noise = (raw_continent_noise + 1.0) * 0.5
			var conceptual_base_height = lerp(continent_min_height, continent_max_height, normalized_continent_noise)
			
			var mountain_modulator = clamp((conceptual_base_height - mountain_start_height) / mountain_fade_height, 0.0, 1.0)
			var m_potential = max(0.0, noise_mountain.get_noise_2d(wx, wz)) * mountain_scale
			var m = m_potential * mountain_modulator
			
			var valley_carve = 0.0
			if conceptual_base_height < valley_apply_threshold:
				var valley_noise = noise_valley.get_noise_2d(wx, wz)
				var negative_valley = min(valley_noise, 0.0)
				var valley_modulator = clamp((valley_apply_threshold - conceptual_base_height) / valley_apply_threshold, 0.0, 1.0)
				valley_carve = negative_valley * valley_carve_scale * valley_modulator
			
			var erosion_modulator = 1.0 - abs(normalized_continent_noise - 0.5) * 2.0
			var bump_e = noise_erosion.get_noise_2d(wx, wz) * erosion_scale * erosion_modulator
			var c_slope_contribution = raw_continent_noise * continent_slope_scale
			
			var height = c_slope_contribution + m + valley_carve + bump_e
			var vertex = Vector3(vx, height, vz)
			
			var uv = Vector2(x / float(vertices_x - 1), z / float(vertices_z - 1))
			st.set_uv(uv)
			st.add_vertex(vertex)
			
		#await get_tree().process_frame
			
			
	for z in range(vertices_z - 1):
		for x in range(vertices_x - 1):
			var i00 = z * vertices_x + x; var i10 = i00 + 1
			var i01 = (z + 1) * vertices_x + x; var i11 = i01 + 1
			st.add_index(i00); st.add_index(i10); st.add_index(i01)
			st.add_index(i10); st.add_index(i11); st.add_index(i01)
			
	st.generate_normals(); st.generate_tangents()
	
	var mesh: ArrayMesh = st.commit()
	mesh_instance.mesh = mesh
	
	#var coll_shape = ConcavePolygonShape3D.new()
	#coll_shape.set_faces(mesh.get_faces())
	#collision_shape.shape = coll_shape


	finished_generating.emit()
