class_name LightKnob
extends Node3D

@export var light_emission_material: StandardMaterial3D

var material: ShaderMaterial
var light: OmniLight3D

var toggled: bool= true



func _ready() -> void:
	material= (get_child(0) as MeshInstance3D).get_surface_override_material(0)
	light= get_child(1)
	toggle(false)


func toggle(toggled_on: bool):
	if toggled_on:
		material.next_pass= light_emission_material
		light.show()
	else:
		material.next_pass= null
		light.hide()
	
