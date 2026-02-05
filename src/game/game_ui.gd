extends CanvasLayer

@onready var message_label: Label = %MessageLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var dialog_container: PanelContainer = %PanelContainerDialog
@onready var dialog_line_label: Label = %Line
@onready var dialog_answer_label: Label = %Answer

@onready var dialog_answer_orig_color: Color = dialog_answer_label.modulate


func _ready() -> void:
	EventBus.send_message.connect(on_message_sent)
	EventBus.play_dialog.connect(on_play_dialog)
	EventBus.dialog_segment_finished.connect(on_dialog_segment_finished)


func on_message_sent(msg: String, color: Color, voice: AudioStream):
	message_label.text= msg
	message_label.modulate= color
	message_label.show()
	#animation_player.play("fade_message_label")


func on_play_dialog(dialog: TutorialStoryDialog):
	Input.mouse_mode= Input.MOUSE_MODE_CONFINED
	dialog_line_label.text= dialog.line
	dialog_answer_label.text= dialog.answer
	dialog_container.show()


func on_dialog_segment_finished():
	Input.mouse_mode= Input.MOUSE_MODE_CAPTURED
	var tween:= create_tween()
	tween.tween_property(dialog_container, "modulate:a", 0.0, 2.0)
	await tween.finished
	dialog_container.hide()


func _on_dialog_answer_mouse_entered() -> void:
	dialog_answer_label.modulate= Color.WHITE


func _on_dialog_answer_mouse_exited() -> void:
	dialog_answer_label.modulate= dialog_answer_orig_color


func _on_dialog_answer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed: return
		EventBus.dialog_finished.emit()
