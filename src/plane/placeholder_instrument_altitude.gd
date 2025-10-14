extends CustomPlaceholderInstrument


func _on_update_interface(values: Dictionary):
	label.text= "Altitude\n%d m" % cockpit.aircraft.local_altitude
