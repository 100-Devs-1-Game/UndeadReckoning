extends Game



func _ready() -> void:
	super()
	spawn_aircraft(Vector3.ZERO, true)


func _on_aircraft_crashed(_impact_velocity: Variant) -> void:
	aircraft.queue_free()
	reset()


func reset():
	pass
