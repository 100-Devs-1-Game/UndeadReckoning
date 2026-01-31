class_name TutorialInstrumentTrigger
extends TutorialBaseTrigger

@export var module: String
@export var key: String
@export var threshold: float
@export var great_than: bool= true



func initialize(aircraft: OurAircraft):
	if module:
		connect_module(aircraft)


func connect_module(aircraft: OurAircraft):
	var module= aircraft.find_modules_by_type(module)[0]
	var generic_module: AircraftModule
	var spatial_module: AircraftModuleSpatial
	
	if module is AircraftModule:
		generic_module= module
		generic_module.update_interface.connect(_on_update_interface, CONNECT_ONE_SHOT)
	elif module is AircraftModuleSpatial:
		spatial_module= module
		spatial_module.update_interface.connect(_on_update_interface, CONNECT_ONE_SHOT)


func _on_update_interface(values: Dictionary):
	assert(values.has(key))
	var val= values[key]
	
	match great_than:
		true:
			if val <= threshold:
				return
		false:
			if val >= threshold:
				return
				
	triggered.emit()
