# This script is just an example of one way to implement a control module
# the way input is handled here is by no means a requirement whatsoever
# You can (and are actually expected to) modify this or write your own module

extends AircraftModule
class_name AircraftModule_ControlSteering

@export var ControlActive: bool = true
@export var enable_mouse_steering: bool = true
@export var input_limit: float= 0.5
@export var mouse_sensitivity: float = 0.1

# There should be only one steering and one steering control in the aircraft
var steering_module = null

var is_pitch_locked:= false
var locked_pitch: float= 0.0

func _ready():
	ReceiveInput = true


func setup(aircraft_node):
	aircraft = aircraft_node
	steering_module = aircraft.find_modules_by_type("steering").pop_front()
	print("steering found: %s" % str(steering_module))

func receive_input(event):
	if (not steering_module) or (not ControlActive):
		return
	
	var factor:= input_limit
	
	if (event is InputEventKey) and (not event.echo):
		
		var axis_z = 0.0
		if Input.is_key_pressed(KEY_A):
			axis_z -= 1.0
		if Input.is_key_pressed(KEY_D):
			axis_z += 1.0
		
		steering_module.set_z(clampf(axis_z, -factor, factor))
		
		var axis_x = 0.0
		if Input.is_key_pressed(KEY_W):
			axis_x -= 1.0
		if Input.is_key_pressed(KEY_S):
			axis_x += 1.0
		
		steering_module.set_x(clampf(axis_x, -factor, factor))
		
		# Y axis positive turns plane left
		var axis_y = 0.0
		if Input.is_key_pressed(KEY_Q):
			axis_y += 1.0
		if Input.is_key_pressed(KEY_E):
			axis_y -= 1.0
		
		steering_module.set_y(clampf(axis_y, -factor, factor))
	
		if Input.is_key_pressed(KEY_R):
			is_pitch_locked= not is_pitch_locked
			locked_pitch= aircraft.instrument_attitude.current_pitch
	
	elif event is InputEventMouseMotion and enable_mouse_steering:
		steering_module.set_x(clampf(event.relative.y * mouse_sensitivity, -factor, factor))
		steering_module.set_z(clampf(event.relative.x * mouse_sensitivity, -factor, factor))


func process_physic_frame(_delta):
	if is_pitch_locked and not is_equal_approx(locked_pitch, aircraft.instrument_attitude.current_pitch):
		var pitch_delta: float= locked_pitch - aircraft.instrument_attitude.current_pitch
		steering_module.set_x(clampf(sqrt(abs(pitch_delta) * 2) * sign(pitch_delta), -1.0, 1.0 ))
