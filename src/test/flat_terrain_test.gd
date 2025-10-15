extends Game

@onready var aircraft: Aircraft = $Aircraft



func _on_aircraft_crashed(impact_velocity: Variant) -> void:
	aircraft.queue_free()


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1:
			var mode:= DisplayServer.window_get_mode(0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if mode == DisplayServer.WINDOW_MODE_WINDOWED else DisplayServer.WINDOW_MODE_FULLSCREEN)
