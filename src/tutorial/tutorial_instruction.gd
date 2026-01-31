class_name TutorialInstruction
extends Resource

signal success
signal failed
signal send_message(msg: String, audio: AudioStream)

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
	fail_trigger.initialize(aircraft)
	fail_trigger.triggered.connect(on_fail, CONNECT_ONE_SHOT)

	for warning in warnings:
		warning.initialize(self, aircraft)
		warning.triggered.connect(on_warning.bind(warning), CONNECT_ONE_SHOT)

	send_message.emit(message, voice)


func on_success():
	send_message.emit(message_completed, voice_completed)
	success.emit()


func on_fail():
	send_message.emit(message_failed, voice_failed)
	failed.emit()


func on_warning(warning: TutorialWarning):
	send_message.emit(warning.message, warning.voice)
