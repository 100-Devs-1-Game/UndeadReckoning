class_name RngUtils

static func get_random_vec3()-> Vector3:
	return Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
