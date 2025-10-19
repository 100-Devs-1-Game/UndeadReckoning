extends Camera3D

@export var move_speed: float= 500.0



func _process(delta: float) -> void:
	var inp: float= Input.get_axis("free_cam_back", "free_cam_forward")
	position+= -global_basis.z * inp * move_speed * delta
	inp= Input.get_axis("free_cam_down", "free_cam_up")
	position.y+= inp * move_speed * 0.5 * delta
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.is_pressed():
			return

		if event.keycode == KEY_F1:
			current= true
	elif event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * 0.1)
