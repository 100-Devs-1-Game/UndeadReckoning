class_name Game
extends Node3D


@export var cockpit_view: bool= false

@export var tripod: CameraTripod
@export var aircraft: OurAircraft

var cameras: Array[Camera3D]



func _ready() -> void:
	var camera: Camera3D
	if aircraft:
		camera= aircraft.cockpit.camera
		cameras.append(camera)
		aircraft.cockpit.show()
		camera.current= cockpit_view
	if tripod:
		camera= tripod.camera
		cameras.append(camera)
		camera.current= not cockpit_view
		aircraft.cockpit.hide()


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1:
			var mode:= DisplayServer.window_get_mode(0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if mode == DisplayServer.WINDOW_MODE_WINDOWED else DisplayServer.WINDOW_MODE_FULLSCREEN)
		if event.keycode == KEY_C:
			for camera in cameras:
				if camera.current:
					var idx:= cameras.find(camera)
					idx= wrapi(idx + 1, 0, cameras.size())
					cameras[idx].current= true
					aircraft.cockpit.visible= camera != aircraft.cockpit.camera
					break
		
