class_name RngUtils


static func chance100(c: float)-> bool:
	return chancef(c / 100.0)


static func chancef(c: float)-> bool:
	return randf() < c


static func get_random_vec3()-> Vector3:
	return Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
