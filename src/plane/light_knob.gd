class_name LightKnob
extends Node3D

var material: StandardMaterial3D
var light: OmniLight3D

var toggled: bool= true



func _ready() -> void:
	material= (get_child(0) as MeshInstance3D).get_surface_override_material(0)
	light= get_child(1)
	toggle(false)


func toggle(toggled_on: bool):
	if toggled_on:
		material.color= Color.RED
		material.emission_enabled= true
		light.show()
	else:
		material.color= Color.WHITE
		material.emission_enabled= false
		light.hide()
	
