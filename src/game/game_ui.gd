extends CanvasLayer

@onready var message_label: Label = %MessageLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	EventBus.send_message.connect(on_message_sent)


func on_message_sent(msg: String, color: Color, voice: AudioStream):
	message_label.text= msg
	message_label.modulate= color
	message_label.show()
	#animation_player.play("fade_message_label")
