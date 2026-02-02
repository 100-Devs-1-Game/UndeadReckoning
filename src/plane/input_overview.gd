extends CanvasLayer


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed: return
		if event.keycode == KEY_F2:
			visible= not visible
