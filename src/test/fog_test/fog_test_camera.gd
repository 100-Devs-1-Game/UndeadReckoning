extends Node3D

@export var speed: float= 10.0


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_select"):
		position.z-= delta * speed
