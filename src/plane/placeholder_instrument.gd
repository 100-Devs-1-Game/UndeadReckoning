class_name PlaceholderInstrument
extends Instrument

@export var value_factor: float= 1.0
@export_multiline var display_format:String


@onready var label: Label3D = $Label3D


func _on_update_interface(values: Dictionary):
	label.text= display_format % ( values[display_value] * value_factor )
