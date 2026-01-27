class_name TutorialInstruction
extends Resource

@export var message: String
@export var message_completed: String
@export var message_failed: String

@export var success_trigger: TutorialBaseTrigger
@export var warnings: Array[TutorialWarning]

@export var voice: AudioStream
@export var voice_completed: AudioStream
@export var voice_failed: AudioStream
