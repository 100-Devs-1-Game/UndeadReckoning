class_name Instrument
extends Node3D

@export var cockpit: Cockpit
@export var connect_to_module: String
@export var display_value: String
@export var value_factor: float= 1.0
@export_multiline var display_format:String


@onready var label: Label3D = $Label3D



func _ready() -> void:
	assert(cockpit)
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


func _on_update_interface(values: Dictionary):
	label.text= display_format % ( values[display_value] * value_factor )
