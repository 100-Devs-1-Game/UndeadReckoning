extends Node

@export var aircraft: Aircraft


func _physics_process(delta: float) -> void:
	if randf() < 0.005:
		var impulse:= RngUtils.get_random_vec3()
		var position:= RngUtils.get_random_vec3()
		
		aircraft.apply_impulse(impulse * 100, position)
