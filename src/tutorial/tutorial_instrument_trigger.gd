class_name TutorialInstrumentTrigger
extends TutorialBaseTrigger

@export var connect_to_module: String
@export var key: String
@export var threshold: float
@export var greater_than: bool= true

var aircraft: OurAircraft
var on_destroy: Callable


func initialize(p_aircraft: OurAircraft):
	aircraft= p_aircraft
	if connect_to_module:
		connect_module()
	else:
		aircraft.get_tree().process_frame.connect(_on_update_interface)


func connect_module():
	var module= aircraft.find_modules_by_type(connect_to_module)[0]
	var generic_module: AircraftModule
	var spatial_module: AircraftModuleSpatial
	
	if module is AircraftModule:
		generic_module= module
		generic_module.update_interface.connect(_on_update_interface)
		on_destroy= func(): generic_module.update_interface.disconnect(_on_update_interface)
	elif module is AircraftModuleSpatial:
		spatial_module= module
		spatial_module.update_interface.connect(_on_update_interface)
		on_destroy= func(): spatial_module.update_interface.disconnect(_on_update_interface)


func _on_update_interface(values: Dictionary= {}):
	var val
	if not connect_to_module:
		val= aircraft.get(key)
	else:
		assert(values.has(key))
		val= values[key]

	if (greater_than and val > threshold) or (not greater_than and val < threshold): 
		if on_destroy:
			on_destroy.call()
		if not connect_to_module:
			aircraft.get_tree().process_frame.disconnect(_on_update_interface)
		triggered.emit()
