extends CustomPlaceholderInstrument



func _on_update_interface(values: Dictionary):
	label.text= "Speed\n%d m/s" % cockpit.aircraft.air_velocity
