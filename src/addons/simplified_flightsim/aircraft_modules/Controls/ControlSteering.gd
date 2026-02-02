# This script is just an example of one way to implement a control module
# the way input is handled here is by no means a requirement whatsoever
# You can (and are actually expected to) modify this or write your own module

extends AircraftModule
class_name AircraftModule_ControlSteering

signal pitch_lock_toggled(toggled_on: bool)

@export var ControlActive: bool = true
@export var enable_mouse_steering: bool = true
@export var input_limit:= Vector3(0.5, 0.3, 0.1)
@export var mouse_sensitivity: float = 0.1

# There should be only one steering and one steering control in the aircraft
var steering_module = null

var is_pitch_locked:= false
var locked_pitch: float= 0.0
var mouse_steer_target: Vector2


func _ready():
	ReceiveInput = true


func setup(aircraft_node):
	aircraft = aircraft_node
	steering_module = aircraft.find_modules_by_type("steering").pop_front()
	print("steering found: %s" % str(steering_module))

func receive_input(event):
	if (not steering_module) or (not ControlActive):
		return
	
	if (event is InputEventKey) and (not event.echo):
		
		var axis_z = 0.0
		if Input.is_key_pressed(KEY_A):
			axis_z -= 1.0
		if Input.is_key_pressed(KEY_D):
			axis_z += 1.0
		
		steering_module.set_z(clampf(axis_z, -input_limit.z, input_limit.z))
		
		var axis_x = 0.0
		if Input.is_key_pressed(KEY_W):
			axis_x -= 1.0
		if Input.is_key_pressed(KEY_S):
			axis_x += 1.0
		
		steering_module.set_x(clampf(axis_x, -input_limit.x, input_limit.x))
		
		# Y axis positive turns plane left
		var axis_y = 0.0
		if Input.is_key_pressed(KEY_Q):
			axis_y += 1.0
		if Input.is_key_pressed(KEY_E):
			axis_y -= 1.0
		
		steering_module.set_y(clampf(axis_y, -input_limit.y, input_limit.y))
	
		if Input.is_key_pressed(KEY_R):
			toggle_pitch_lock()
	
	elif event is InputEventMouseMotion and enable_mouse_steering:
		mouse_steer_target+= Vector2(event.relative.y, event.relative.x) * mouse_sensitivity
		#mouse_steer_target= mouse_steer_target.limit_length(input_limit)
		mouse_steer_target.x= clampf(mouse_steer_target.x, -input_limit.x, input_limit.x)
		mouse_steer_target.y= clampf(mouse_steer_target.y, -input_limit.z, input_limit.z)
		steering_module.set_x(pow(mouse_steer_target.x / input_limit.x, 5) * input_limit.x)
		steering_module.set_z(pow(mouse_steer_target.y / input_limit.z, 5) * input_limit.z)
	
	elif event is InputEventMouseButton:
		if not event.pressed:
			return
			
		if event.button_index == MOUSE_BUTTON_LEFT:
			toggle_pitch_lock()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			mouse_steer_target= Vector2.ZERO
			steering_module.set_x(0)
			steering_module.set_z(0)
			

func process_physic_frame(_delta):
	if is_pitch_locked and not is_equal_approx(locked_pitch, aircraft.instrument_attitude.current_pitch):
		var pitch_delta: float= locked_pitch - aircraft.instrument_attitude.current_pitch
		steering_module.set_x(clampf(pitch_delta * 5, -input_limit.x, input_limit.x))


func toggle_pitch_lock():
	is_pitch_locked= not is_pitch_locked
	locked_pitch= aircraft.instrument_attitude.current_pitch
	if is_pitch_locked:
		mouse_steer_target= Vector2.ZERO
		steering_module.set_x(0)
		steering_module.set_z(0)
	pitch_lock_toggled.emit(is_pitch_locked)
