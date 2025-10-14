class_name Cockpit
extends Node3D

@export var aircraft: OurAircraft

@export var steering_joint: Node3D
@export var steering_handle_joint: Node3D


func _ready() -> void:
	await aircraft.setup_finished
	
	var steering_module: AircraftModule= aircraft.find_modules_by_type("steering")[0]
	steering_module.update_interface.connect(_on_update_steering)


func _process(delta: float) -> void:
	#steering_joint.basis= steering_joint.basis.slerp(Basis.IDENTITY, delta)
	pass

func _on_update_steering(values: Dictionary):
	steering_joint.rotation_degrees.x= values["axis_x"] * 10
	steering_joint.rotation_degrees.z= values["axis_y"] * 10
	steering_handle_joint.rotation_degrees.z= -values["axis_z"] * 10
	
