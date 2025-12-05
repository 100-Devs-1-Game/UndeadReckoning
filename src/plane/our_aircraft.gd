class_name OurAircraft
extends Aircraft

@export var enable_builtin_interface: bool= false

@onready var cockpit: Cockpit = $Cockpit
@onready var builtin_interface: CanvasLayer = $"Builtin Interface"
@onready var instrument_attitude: AircraftModule_InstrumentAttitude = $InstrumentAttitude



func _ready() -> void:
	super()
	Input.mouse_mode= Input.MOUSE_MODE_CAPTURED
	
	builtin_interface.visible= enable_builtin_interface

	$Steering.update_interface.connect($Model/MovingParts/Steering._on_Steering_update_interface)
