class_name TutorialWarning
extends Resource

signal triggered


@export var message: String
@export var trigger: TutorialBaseTrigger
@export var voice: AudioStream


func initialize():
	trigger.initialize()
	trigger.triggered.connect(func(): triggered.emit(), CONNECT_ONE_SHOT)
