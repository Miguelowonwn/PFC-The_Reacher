extends CharacterBody2D
 
const SPEED = 300.0
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:   
	# Obtiene la dirección horizontal y vertical basándose en las entradas de usuario  
	var direction_x_left := Input.get_axis("left_hand_left", "left_hand_right")
	var direction_y_left := Input.get_axis("left_hand_up", "left_hand_down") 
	  
	# Agarrar 
	if Input.is_action_just_pressed("grab_left"):
		toggle_sprite()
	
	if Input.is_action_just_released("grab_left"):
		toggle_sprite()
		
	# Movimiento horizontal mano izquierda
	if direction_x_left:
		velocity.x = direction_x_left * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Movimiento vertical mano izquierda
	if direction_y_left:
		velocity.y = direction_y_left * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		  
	# Mueve el personaje utilizando la velocidad calculada
	move_and_slide() 

func toggle_sprite() -> void:
	#Cambiar de sprite
	if sprite_2d.texture == preload("res://sprites/glove_no_grab.png"):
		sprite_2d.texture = preload("res://sprites/glove_grab.png")
	else:
		sprite_2d.texture = preload("res://sprites/glove_no_grab.png")
