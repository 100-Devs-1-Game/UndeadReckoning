extends Game

@onready var aircraft: Aircraft = $Aircraft



func _on_aircraft_crashed(impact_velocity: Variant) -> void:
	aircraft.queue_free()
