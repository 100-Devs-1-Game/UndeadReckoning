class_name OurAircraft
extends Aircraft

@export var enable_builtin_interface: bool= false
@export var cockpit: Cockpit

@onready var builtin_interface: CanvasLayer = $"Builtin Interface"
@onready var instrument_attitude: AircraftModule_InstrumentAttitude = $InstrumentAttitude
@onready var engine: AircraftModule_Engine = $Engine


var vertical_speed: float


func _ready() -> void:
	super()
	Input.mouse_mode= Input.MOUSE_MODE_CAPTURED
	
	builtin_interface.visible= enable_builtin_interface

	$Steering.update_interface.connect($Model/MovingParts/Steering._on_Steering_update_interface)


func _physics_process(delta):
	super(delta)
	vertical_speed= air_velocity_vector.y


func _on_control_steering_pitch_lock_toggled(toggled_on: bool) -> void:
	cockpit.pitch_lock_toggled.emit(toggled_on)
