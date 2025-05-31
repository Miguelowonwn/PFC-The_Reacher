extends Control

@onready var resolutions_option_button: OptionButton = $PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/Controladores/ContainerResolucion/OptionResolucion/OptionButton
@onready var container_salir: PanelContainer = $SalirBox 
@onready var salir_box: PanelContainer = $SalirBox 
@onready var aceptar_salir: Button = $SalirBox/ContainerSalir/VBoxContainer/HBoxContainer/AceptarSalir
@onready var cancelar_salir: Button = $SalirBox/ContainerSalir/VBoxContainer/HBoxContainer/CancelarSalir

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
		resolutions_option_button.clear()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		add_resolutions()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		 
func _on_salir_menu_principal_pressed() -> void:   
	salir_box.z_index = 1
	cancelar_salir.grab_focus() 
	
func _on_aceptar_salir_pressed() -> void:  
	get_tree().paused = false 
	get_tree().root.get_viewport().set_input_as_handled()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
 
func _on_cancelar_salir_pressed() -> void:  
	salir_box.z_index = 0 
	resolutions_option_button.grab_focus()
