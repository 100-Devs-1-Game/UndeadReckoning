class_name NeedleInstrument
extends Instrument

@export var needle: Node3D
@export var min_rotation: float= -90
@export var max_rotation: float= 250
@export var min_value: float= 0
@export var max_value: float= 100
@export var factor: float= 1.0
@export var limit: bool= false
@export var reverse: bool= false



func _ready() -> void:
	super()
	set_process(connect_to_module.is_empty() and cockpit.aircraft)


func _process(_delta: float) -> void:
	_on_update_interface({})


func _on_update_interface(values: Dictionary):
	update_needle(needle, values)


func update_needle(p_needle: Node3D, values: Dictionary, value_factor: float= 1.0):
	var min_rot= min_rotation
	var max_rot= max_rotation

	var val: float
	if connect_to_module:
		val= values[display_value]
	else:
		val= cockpit.aircraft.get(display_value)
	val*= factor
	
	if limit:
		val= clampf(val, min_value, max_value)
	
	var deg: float= remap(val * value_factor, min_value, max_value, min_rot, max_rot)
	p_needle.rotation.y= deg_to_rad(deg) * ( -1 if reverse else 1 )
