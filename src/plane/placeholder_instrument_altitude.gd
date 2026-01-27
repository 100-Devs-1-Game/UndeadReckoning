extends CustomPlaceholderInstrument


func _on_update_interface(_values: Dictionary):
	label.text= "Altitude\n%d m" % cockpit.aircraft.local_altitude
