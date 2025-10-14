class_name OurAircraft
extends Aircraft

@export var enable_builtin_interface: bool= false

@onready var builtin_interface: CanvasLayer = $"Builtin Interface"


func _ready() -> void:
	super()
	Input.mouse_mode= Input.MOUSE_MODE_CAPTURED
	
	builtin_interface.visible= enable_builtin_interface
