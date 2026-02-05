class_name TutorialInstructionSet
extends TutorialSegment

@export var instructions: Array[TutorialInstruction]

var current_index:= -1


func start():
	advance.call_deferred()


func advance():
	current_index+= 1
	if current_index >= instructions.size():
		finished.emit()
		return
	
	var current_instruction: TutorialInstruction= instructions[current_index]
	current_instruction.success.connect(on_success)
	current_instruction.failed.connect(on_failed)
	if current_index > 0:
		await GlobalRefs.aircraft.get_tree().create_timer(5).timeout
	current_instruction.initialize()


func on_success():
	advance()


func on_failed():
	failed.emit()
	GlobalRefs.game.get_tree().quit()
