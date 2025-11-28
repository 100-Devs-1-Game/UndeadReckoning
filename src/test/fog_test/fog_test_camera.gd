extends Camera3D

@export var speed: float= 10.0


func _process(delta: float) -> void:
	position.z-= delta * speed
