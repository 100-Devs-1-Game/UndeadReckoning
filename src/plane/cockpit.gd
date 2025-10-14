class_name Cockpit
extends Node3D

@export var aircraft: OurAircraft

@export var steering_joint: Node3D
@export var steering_handle_joint: Node3D

var target_steering_joint:= Node3D.new()
var target_steering_handle_joint:= Node3D.new()



func _ready() -> void:
	target_steering_joint.basis= steering_joint.basis
	target_steering_handle_joint.basis= steering_handle_joint.basis
	
	await aircraft.setup_finished
	
	var steering_module: AircraftModule= aircraft.find_modules_by_type("steering")[0]
	steering_module.update_interface.connect(_on_update_steering)


func _process(delta: float) -> void:
	steering_joint.basis= steering_joint.basis.slerp(target_steering_joint.basis, delta).orthonormalized()
	steering_handle_joint.basis= steering_handle_joint.basis.slerp(target_steering_handle_joint.basis, delta).orthonormalized()


func _on_update_steering(values: Dictionary):
	target_steering_joint.rotation_degrees.x= values["axis_x"] * 10
	target_steering_joint.rotation_degrees.z= values["axis_y"] * 10
	target_steering_handle_joint.rotation_degrees.z= -values["axis_z"] * 10
