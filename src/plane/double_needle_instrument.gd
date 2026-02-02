class_name DoubleNeedleInstrument
extends NeedleInstrument

@export var needle2: Node3D


func _on_update_interface(values: Dictionary):
	update_needle(needle, values)
	update_needle(needle2, values, 0.1)
