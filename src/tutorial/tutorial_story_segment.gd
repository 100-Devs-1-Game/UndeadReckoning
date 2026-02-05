class_name TutorialStorySegment
extends TutorialSegment

@export var dialog_list: Array[TutorialStoryDialog]

var current_index := -1

func start():
	advance()


func advance():
	current_index += 1
	if current_index >= dialog_list.size():
		EventBus.dialog_segment_finished.emit()
		finished.emit()
		return
		
	var current_dialog := dialog_list[current_index]
	EventBus.play_dialog.emit(current_dialog)
	await EventBus.dialog_finished
	advance.call_deferred()
