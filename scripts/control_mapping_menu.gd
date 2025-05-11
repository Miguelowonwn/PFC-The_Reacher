extends Control

@onready var input_button_scene = preload("res://scenes/input_button.tscn")  
@onready var action_list: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList


var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"left_hand_up": "Left hand up",
	"left_hand_down": "Left hand down",
	"left_hand_left": "Left hand left",
	"left_hand_right": "Left hand right",
	"grab_left": "Grab left hand",
	
	"right_hand_up": "Right hand up",
	"right_hand_down": "Right hand down",
	"right_hand_left": "Right hand left",
	"right_hand_right": "Right hand right",
	"grab_right": "Grab right hand",

}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_action_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _create_action_list(): 
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()

	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action 
		remapping_button = button
		button.find_child("LabelInput").text = "Presiona el botón para remapear..."
		
		
func _input(event):
	if is_remapping:
		if (event is InputEventKey && event.pressed):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")
