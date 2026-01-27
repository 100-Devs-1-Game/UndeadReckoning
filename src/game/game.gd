class_name Game
extends Node3D


@export var terrain_provider: TerrainProvider
@export var cockpit_view: bool= false

@export var tripod: CameraTripod
@export var aircraft: OurAircraft

@export var aircraft_scene: PackedScene

var cameras: Array[Camera3D]



func _ready() -> void:
	setup_camera()

func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1:
			var mode:= DisplayServer.window_get_mode(0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if mode == DisplayServer.WINDOW_MODE_WINDOWED else DisplayServer.WINDOW_MODE_FULLSCREEN)
		if event.keycode == KEY_C:
			for camera in cameras:
				if not camera or not is_instance_valid(camera):
					continue
				if camera.current:
					var idx:= cameras.find(camera)
					idx= wrapi(idx + 1, 0, cameras.size())
					cameras[idx].current= true
					aircraft.cockpit.visible= camera != aircraft.cockpit.camera
					break


func spawn_aircraft(pos: Vector3, snap_to_ground: bool= false, plane_basis: Basis= Basis.IDENTITY):
	assert(not aircraft)
	aircraft= aircraft_scene.instantiate()
	aircraft.position= pos
	aircraft.transform.basis= plane_basis
	if snap_to_ground:
		aircraft.position.y= terrain_provider.get_height_at(pos.x, pos.z) + 1.5
	aircraft.crashed.connect(_on_aircraft_crashed)
	add_child(aircraft)
	EventBus.aircraft_spawned.emit(aircraft)
	setup_camera()


func setup_camera():
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


func _on_aircraft_crashed(_impact_velocity: Variant) -> void:
	pass
