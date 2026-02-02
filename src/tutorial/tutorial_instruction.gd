class_name TutorialInstruction
extends Resource

signal success
signal failed

@export var message: String
@export var message_completed: String
@export var message_failed: String

@export var success_trigger: TutorialBaseTrigger
@export var fail_trigger: TutorialBaseTrigger
@export var warnings: Array[TutorialWarning]

@export var voice: AudioStream
@export var voice_completed: AudioStream
@export var voice_failed: AudioStream



func initialize(aircraft: OurAircraft):
	success_trigger.initialize(aircraft)
	success_trigger.triggered.connect(on_success, CONNECT_ONE_SHOT)
	if fail_trigger:
		fail_trigger.initialize(aircraft)
		fail_trigger.triggered.connect(on_fail, CONNECT_ONE_SHOT)

	for warning in warnings:
		warning.initialize(aircraft)
		warning.triggered.connect(on_warning.bind(warning), CONNECT_ONE_SHOT)

	EventBus.send_message.emit(message, Color.WHITE,voice)


func on_success():
	EventBus.send_message.emit(message_completed, Color.GREEN, voice_completed)
	success.emit()


func on_fail():
	EventBus.send_message.emit(message_failed, Color.RED,voice_failed)
	failed.emit()


func on_warning(warning: TutorialWarning):
	EventBus.send_message.emit(warning.message, Color.ORANGE,warning.voice)
