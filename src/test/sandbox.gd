extends Node

@export var aircraft: Aircraft

@export var wind_gust_chance: float= 5.0

func _physics_process(delta: float) -> void:
	if randf() < wind_gust_chance / 100.0:
		var impulse:= RngUtils.get_random_vec3()
		var position:= RngUtils.get_random_vec3()
		
		aircraft.apply_force(impulse * 20, position * 5)
