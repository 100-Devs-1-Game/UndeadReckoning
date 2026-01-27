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
@export var vertices_x: int = 33
@export var vertices_z: int = 33

# --- Internal State ---
var chunk_coords: Vector2i = Vector2i.ZERO


func initialize_chunk(coords: Vector2i, chunk_manager: ChunkManager) -> void:
	chunk_coords = coords
	
	global_position.x = coords.x * chunk_manager.chunk_size_x * chunk_manager.overall_scale
	global_position.z = coords.y * chunk_manager.chunk_size_z * chunk_manager.overall_scale
	name = "Chunk_%d_%d" % [coords.x, coords.y]
	
	generate_terrain(chunk_manager)
	
	scale = Vector3.ONE * chunk_manager.overall_scale



func generate_terrain(chunk_manager: ChunkManager) -> void:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var step_x = chunk_manager.chunk_size_x / float(vertices_x - 1)
	var step_z = chunk_manager.chunk_size_z / float(vertices_z - 1)
	
	for z in range(vertices_z):
		for x in range(vertices_x):
			var vx = x * step_x
			var vz = z * step_z
			var wx = vx + chunk_coords.x * chunk_manager.chunk_size_x
			var wz = vz + chunk_coords.y * chunk_manager.chunk_size_z
			
			var vertex = Vector3(vx, chunk_manager.terrain_generator.get_height_at(Vector2(wx, wz)), vz)
			
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
