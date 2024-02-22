extends Node

@warning_ignore("shadowed_global_identifier")
func get_percent(current, max, step = 1):
	return snapped((float(current)/float(max)) * 100, step)
