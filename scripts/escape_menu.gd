extends Control

@onready var resolutions_option_button: OptionButton = $PanelContainer/MarginContainer/VBoxContainer/Controladores/ContainerResolucion/OptionResolucion/OptionButton
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	add_resolutions()
 
	
func add_resolutions():
	for r in GUI.resolutions:
		resolutions_option_button.add_item(r)
		
		
func update_button_values():
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var resolutions_index = GUI.resolutions.keys().find(window_size_string)
	resolutions_option_button.selected = resolutions_index
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_option_button_item_selected(index: int) -> void:
	var key = resolutions_option_button.get_item_text(index)
	DisplayServer.window_set_size(GUI.resolutions[key])
	GUI.center_window()
 

func _on_full_screen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
