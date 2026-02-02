class_name Cockpit
extends Node3D

signal pitch_lock_toggled(toggled_on: bool)

@export var aircraft: OurAircraft

@export var steering_joint: Node3D
@export var throttle_offset: Node3D
@export var steering_angle_factor: Vector2= Vector2.ONE
@export var throttle_min_offset: float= .1
@export var throttle_max_offset: float= -.1

@onready var camera: Camera3D = $Camera3D

var target_steering_joint:= Node3D.new()



func _ready() -> void:
	if not aircraft:
		push_error("Cockpit not connected to aircraft")
	
	target_steering_joint.basis= steering_joint.basis
	
	if aircraft:
		await aircraft.setup_finished
	
		var steering_module: AircraftModule= aircraft.find_modules_by_type("steering")[0]
		steering_module.update_interface.connect(_on_update_steering)


func _process(delta: float) -> void:
	if not aircraft:
		return
	steering_joint.basis= steering_joint.basis.slerp(target_steering_joint.basis, delta * 5).orthonormalized()
	throttle_offset.position.z= remap(aircraft.engine.current_power, 0.0, 1.0, throttle_min_offset, throttle_max_offset)


func _on_update_steering(values: Dictionary):
	target_steering_joint.rotation_degrees.x= values["axis_x"] * 100 * steering_angle_factor.x
	target_steering_joint.rotation_degrees.z= -values["axis_z"] * 100 * steering_angle_factor.y

	
func toggle_pitch_lock(toggled_on: bool):
	pitch_lock_toggled.emit(toggled_on)
