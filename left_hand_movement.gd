extends CharacterBody2D

# Velocidad de movimiento del personaje
const SPEED: float = 300.0

func _physics_process(delta: float) -> void:
	# Chequea las entradas de los botones WASD o las que hayas configurado
	if Input.is_action_pressed("left_hand_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("left_hand_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("left_hand_up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("left_hand_down"):
		velocity.y += SPEED

	# Normaliza la velocidad para evitar moverse más rápido en diagonales
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED

	# Mueve al personaje
	move_and_slide
