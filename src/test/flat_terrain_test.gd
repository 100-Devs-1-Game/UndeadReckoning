extends Node3D

@onready var aircraft: Aircraft = $Aircraft

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_aircraft_crashed(impact_velocity: Variant) -> void:
	aircraft.queue_free()
