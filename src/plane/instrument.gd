class_name Instrument
extends Node3D

@export var cockpit: Cockpit
@export var connect_to_module: String
@export var display_value: String



func _ready() -> void:
	assert(cockpit)
	if connect_to_module and cockpit.aircraft:
		cockpit.aircraft.setup_finished.connect(connect_module)


func connect_module():
	var module= cockpit.aircraft.find_modules_by_type(connect_to_module)[0]
	var generic_module: AircraftModule
	var spatial_module: AircraftModuleSpatial
	
	if module is AircraftModule:
		generic_module= module
		generic_module.update_interface.connect(_on_update_interface)
	elif module is AircraftModuleSpatial:
		spatial_module= module
		spatial_module.update_interface.connect(_on_update_interface)


func _on_update_interface(_values: Dictionary):
	pass
