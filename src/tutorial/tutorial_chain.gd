class_name TutorialChain
extends Resource

signal finished
signal failed

@export var segments: Array[TutorialSegment]

var current_index := -1
var current_segment: TutorialSegment


func start():
	advance()


func advance():
	current_index += 1
	if current_index >= segments.size():
		finished.emit()
		return
	
	current_segment = segments[current_index]
	current_segment.finished.connect(on_segment_finished, CONNECT_ONE_SHOT)
	current_segment.start()


func on_segment_finished():
	if current_segment.auto_advance:
		advance()
