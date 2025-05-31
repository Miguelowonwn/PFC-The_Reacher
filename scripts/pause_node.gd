extends Node 

func _input(_event):
	if Input.is_action_just_pressed("escape_menu"): 
		if get_tree().paused:
			get_tree().paused = false
			 
