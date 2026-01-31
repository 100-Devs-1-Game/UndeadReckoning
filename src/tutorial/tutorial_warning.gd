class_name TutorialWarning
extends Resource

signal triggered


@export var message: String
@export var trigger: TutorialBaseTrigger
@export var voice: AudioStream


func initialize(aircraft: OurAircraft):
	trigger.initialize(aircraft)
	trigger.triggered.connect(func(): triggered.emit(), CONNECT_ONE_SHOT)
