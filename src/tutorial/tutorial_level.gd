extends Game

@export var tutorial_chain: TutorialChain 


func _ready() -> void:
	super()
	tutorial_chain.segments[0].finished.connect(on_intro_finished)
	tutorial_chain.start()


func on_intro_finished():
	spawn_aircraft(Vector3.ZERO, true)
	await aircraft.setup_finished
	tutorial_chain.advance()


func _on_aircraft_crashed(_impact_velocity: Variant) -> void:
	aircraft.queue_free()
	reset()


func reset():
	get_tree().quit()
	#get_tree().reload_current_scene.call_deferred()
