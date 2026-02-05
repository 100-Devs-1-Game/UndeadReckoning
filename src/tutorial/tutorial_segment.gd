@abstract
class_name TutorialSegment
extends Resource

@warning_ignore_start("unused_signal")
signal finished
signal failed

@export var auto_advance:= true


@abstract
func start()
