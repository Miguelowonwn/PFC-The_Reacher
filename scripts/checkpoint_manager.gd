extends Node

# Posiciones y estados
var ultima_posicion_izquierda: Vector2
var ultima_posicion_derecha: Vector2
var ultima_posicion_ojo: Vector2
var ultima_rotacion_ojo: float

		# Guardar estados adicionales
var ultima_velocidad_izquierda  
var ultima_velocidad_derecha  
var ultima_velocidad_ojo  
		
# Referencias a los nodos
@onready var reacher: Node2D = $"../Reacher"
@onready var left_hand: CharacterBody2D
@onready var right_hand: CharacterBody2D
@onready var eye: RigidBody2D

# Estados adicionales para reset completo
var saved_physics_states := {}

func _ready() -> void:
	_get_references()
	_save_initial_state()

func _get_references():
	left_hand = reacher.get_node("Left_hand") as CharacterBody2D
	right_hand = reacher.get_node("Right_hand") as CharacterBody2D
	eye = reacher.get_node("Eye") as RigidBody2D

func _save_initial_state():
	# Guardar estado inicial para reset completo si es necesario
	saved_physics_states = {
		"left_hand": {
			"position": left_hand.global_position,
			"velocity": Vector2.ZERO,
			"up_direction": left_hand.up_direction,
			"floor_stop_on_slope": left_hand.floor_stop_on_slope,
			"floor_max_angle": left_hand.floor_max_angle
		},
		"right_hand": {
			"position": right_hand.global_position,
			"velocity": Vector2.ZERO,
			"up_direction": right_hand.up_direction,
			"floor_stop_on_slope": right_hand.floor_stop_on_slope,
			"floor_max_angle": right_hand.floor_max_angle
		},
		"eye": {
			"position": eye.global_position,
			"linear_velocity": Vector2.ZERO,
			"angular_velocity": 0,
			"rotation": 0,
			"gravity_scale": eye.gravity_scale,
			"linear_damp": eye.linear_damp,
			"angular_damp": eye.angular_damp
		}
	}

func save_checkpoint():
	# Guardar posiciones actuales
	ultima_posicion_izquierda = left_hand.global_position
	ultima_posicion_derecha = right_hand.global_position
	ultima_posicion_ojo = eye.global_position
	ultima_rotacion_ojo = eye.rotation

func respawn_reacher():
	# 1. Desactivar física temporalmente
	_set_physics_process(false)
	
	# 2. Resetear parámetros físicos
	_reset_physics_parameters()
	
	# 3. Restaurar posiciones
	left_hand.global_position = ultima_posicion_izquierda
	right_hand.global_position = ultima_posicion_derecha
	eye.global_position = ultima_posicion_ojo
	eye.rotation = ultima_rotacion_ojo
	
	# 4. Esperar un frame para asegurar que las transformaciones se aplican
	await get_tree().process_frame
	
	# 5. Reactivar física
	_set_physics_process(true)
	
	# 6. Forzar actualización de física
	_force_physics_update()

func _set_physics_process(active: bool):
	left_hand.set_physics_process(active)
	right_hand.set_physics_process(active)
	eye.set_physics_process(active)
	eye.sleeping = !active

func _reset_physics_parameters():
	# Reset CharacterBody2D parameters
	for hand in [left_hand, right_hand]:
		hand.velocity = Vector2.ZERO
		hand.up_direction = Vector2.UP
		hand.floor_stop_on_slope = saved_physics_states["left_hand"]["floor_stop_on_slope"]
		hand.floor_max_angle = saved_physics_states["left_hand"]["floor_max_angle"]
		hand.move_and_slide()
	
	# Reset RigidBody2D parameters
	eye.linear_velocity = Vector2.ZERO
	eye.angular_velocity = 0
	eye.gravity_scale = saved_physics_states["eye"]["gravity_scale"]
	eye.linear_damp = saved_physics_states["eye"]["linear_damp"]
	eye.angular_damp = saved_physics_states["eye"]["angular_damp"]
	eye.contact_monitor = true
	eye.max_contacts_reported = 1

func _force_physics_update():
	left_hand.move_and_slide()
	right_hand.move_and_slide()
	eye.linear_velocity = Vector2.ZERO
	eye.angular_velocity = 0
	await get_tree().physics_frame
