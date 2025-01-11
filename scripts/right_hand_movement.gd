extends CharacterBody2D
 
const SPEED = 300.0
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:   
	# Obtiene la dirección horizontal y vertical basándose en las entradas de usuario
	var direction_x_right := Input.get_axis("right_hand_left", "right_hand_right")
	var direction_y_right := Input.get_axis("right_hand_up", "right_hand_down") 
	
	# Agarrar 
	if Input.is_action_just_pressed("grab_right"):
		toggle_sprite()
	
	if Input.is_action_just_released("grab_right"):
		toggle_sprite()
	
	# Movimiento horizontal mano derecha
	if direction_x_right:
		velocity.x = direction_x_right * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Movimiento vertical mano derecha
	if direction_y_right:
		velocity.y = direction_y_right * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		  
	# Mueve el personaje utilizando la velocidad calculada
	move_and_slide() 
	
func toggle_sprite() -> void:
	#Cambiar de sprite
	if sprite_2d.texture == preload("res://sprites/glove_no_grab_right.png"):
		sprite_2d.texture = preload("res://sprites/glove_grab_right.png")
	else:
		sprite_2d.texture = preload("res://sprites/glove_no_grab_right.png")
