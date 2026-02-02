extends Camera3D

@export var return_strength: float= 10



func _ready() -> void:
	var cockpit: Cockpit= get_parent()
	await cockpit.ready
	if cockpit.aircraft:
		cockpit.aircraft.rumble.connect(on_rumble)


func _process(delta: float) -> void:
	h_offset= lerp(h_offset, 0.0, delta * return_strength)
	v_offset= lerp(v_offset, 0.0, delta * return_strength)


func on_rumble(vec: Vector2):
	h_offset= vec.x
	v_offset= vec.y
