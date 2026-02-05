extends Node

@warning_ignore_start("unused_signal")
signal aircraft_spawned(aircraft: OurAircraft)

signal send_message(msg: String, color: Color, voice: AudioStream)

signal play_dialog(dialog: TutorialStoryDialog)
signal dialog_finished
signal dialog_segment_finished
