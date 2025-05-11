extends Node2D 

@onready var leftHandOnTower: bool = false
@onready var rightHandOnTower: bool = false   

@onready var music: AudioStreamPlayer = $Music
@onready var reacher: Node2D = $Reacher
@onready var eyeAnimation: AnimatedSprite2D = $Reacher/Eye/Animacion
 
@onready var menu_escape: Control = $CanvasMenuEscape/MenuEscape  
@onready var ajustes_mapeo: Control = $GUI/Mapeo
var game_paused: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	print(menu_escape) 
  
func _on_area_2d_body_entered(body: Node2D) -> void: 
	if body.name == "Left_hand":
		_log(str(leftHandOnTower))
		leftHandOnTower = true; 
		
	if body.name == "Right_hand":
		_log(str(rightHandOnTower))
		rightHandOnTower = true;


func _on_area_2d_body_exited(body: Node2D) -> void:  
	if body.name == "Left_hand":
		_log(str(leftHandOnTower))
		leftHandOnTower = false; 
		
	if body.name == "Right_hand":
		_log(str(rightHandOnTower))
		rightHandOnTower = false;
	
func _log(msg: String) -> void:
	print("[GAME] %s" % msg)
	 
func _unhandled_input(event: InputEvent) -> void: 
	if event.is_action_pressed("escape_menu"):
		game_paused = !game_paused
		if game_paused:
			menu_escape.visible = true
			_stop_game_when_paused() 
			get_tree().paused = true  
		else:   
			menu_escape.visible = false 
			_resume_game_when_not_paused()
			get_tree().paused = false 
		get_tree().root.get_viewport().set_input_as_handled()

func _stop_game_when_paused():
	music.stream_paused = true
	eyeAnimation.pause()  
	
func _resume_game_when_not_paused():
	music.stream_paused = false
	eyeAnimation.play()
	
