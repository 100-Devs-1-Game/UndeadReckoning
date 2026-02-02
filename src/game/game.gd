class_name Game
extends Node3D


@export var terrain_provider: TerrainProvider
@export var cockpit_view: bool= true

@export var tripod: CameraTripod
@export var aircraft: OurAircraft

@export var aircraft_scene: PackedScene

var cameras: Array[Camera3D]



func _ready() -> void:
	#update_camera()
	pass

func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event is InputEventKey:
		if event.keycode == KEY_F1:
			var mode:= DisplayServer.window_get_mode(0)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if mode == DisplayServer.WINDOW_MODE_WINDOWED else DisplayServer.WINDOW_MODE_FULLSCREEN)
		if event.keycode == KEY_C:
			cockpit_view= not cockpit_view
			update_camera()


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
	update_camera()


func update_camera():
	var camera: Camera3D
	if aircraft:
		camera= aircraft.cockpit.camera
		aircraft.cockpit.visible= cockpit_view
		camera.current= cockpit_view
		if tripod:
			camera= tripod.camera
			camera.current= not cockpit_view


func _on_aircraft_crashed(_impact_velocity: Variant) -> void:
	pass
