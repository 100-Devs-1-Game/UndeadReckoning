extends Game



func _on_aircraft_crashed(impact_velocity: Variant) -> void:
	aircraft.queue_free()
