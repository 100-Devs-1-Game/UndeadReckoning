class_name NeedleInstrument
extends Instrument

@export var needle: Node3D
@export var min_rotation: float= -90
@export var max_rotation: float= 250
@export var min_value: float= 0
@export var max_value: float= 100
@export var reverse: bool= false



func _ready() -> void:
	super()
	set_process(connect_to_module.is_empty())


func _process(_delta: float) -> void:
	_on_update_interface({})


func _on_update_interface(values: Dictionary):
	var min_rot= min_rotation
	var max_rot= max_rotation
	if reverse:
		min_rot= max_rotation
		max_rot= min_rotation
		
	var val: float
	
	if connect_to_module:
		val= values[display_value]
	else:
		val= cockpit.aircraft.get(display_value)
	
	var deg: float= remap(val, min_value, max_rotation, min_rot, max_rot)
	needle.rotation.y= deg_to_rad(deg)

	if not connect_to_module:
		prints(val, deg)
