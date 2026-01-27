class_name TutorialInstrumentTrigger
extends TutorialBaseTrigger

@export var connect_to_module: String


func initialize(aircraft: OurAircraft, _instance: TutorialBaseTrigger):
	if connect_to_module:
		connect_module(aircraft)


func connect_module(aircraft: OurAircraft):
	var module= aircraft.find_modules_by_type(connect_to_module)[0]
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
