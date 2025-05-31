extends CharacterBody2D

const SPEED = 300.0
const BASE_GRAVITY = 4900.0
const MAX_GRAVITY = 20000.0
const GRAVITY_RAMP_TIME = 2.0
const MAX_UP_TIME = 2.0  # Tiempo máximo que se puede mantener el movimiento hacia arriba
const UP_COOLDOWN = 2.0  # Tiempo de espera después de alcanzar el límite 
  
# Variables exportables para ajustar en el editor
@export var max_hand_separation: float = 300  # Distancia máxima permitida entre manos
@export var pull_force: float = 800  # Fuerza de retorno cuando se separan demasiado
@export var other_hand: NodePath  # Asigna la otra mano en el inspector
@onready var sprite_right_hand: Sprite2D = $SpriteRightHand

var en_el_aire: bool = true
var tiempo_en_aire: float = 0.0
var congelado_en_musgo: bool = false
var up_pressed_time: float = 0.0  # Tiempo que se ha mantenido presionado UP
var up_cooldown_timer: float = 0.0  # Temporizador para el cooldown
var up_input_blocked: bool = false  # Si el input de arriba está bloqueado 
 
# Añade estas variables al inicio con las demás
var right_hand_grab_sprite_sheet = preload("res://sprites/skins/hand/right_grab_hand_skins.png") 
var current_skin_index = 0
var is_grabbing = false
@onready var effects: AudioStreamPlayer = $"../Effects"

# Configuración de Joints
@export var normal_stiffness: float = 2.0
@export var normal_damping: float = 0.5
@export var frozen_stiffness: float = 200.0
@export var frozen_damping: float = 20.0

# Nodos relacionados
@onready var righthand_joint: DampedSpringJoint2D = $"../RighthandJoint"
@onready var eye: RigidBody2D = $"../Eye"
@onready var left_hand: CharacterBody2D = $"../Left_hand"
@onready var lefthand_joint: DampedSpringJoint2D = $"../LefthandJoint"

# Sistema de skins
var right_hand_sprite_sheet = preload("res://sprites/skins/hand/right_hand_skins.png") 

var skin_index = {
	"Rojo": 4,
	"Amarillo": 3,
	"Azul": 2,
	"Gris": 1,
	"Negro": 0,
	"Rosa": 9,
	"Naranja": 8,
	"Verde": 7,
	"Blanco": 6,
	"Cian": 5
}

func _ready():
	inicializar_skins()
	set_joints_stiffness(normal_stiffness, normal_damping)

func inicializar_skins():
	var mano_skin = Global.mano_skin
	
	if skin_index.has(mano_skin):
		current_skin_index = skin_index[mano_skin]
		update_hand_texture()
		 
	else:
		print("Error: Skin no encontrada:", mano_skin)
		# Cargar una skin por defecto
		sprite_right_hand.texture = preload("res://sprites/glove_no_grab.png")

func update_hand_texture():
	# Asegurarnos que el sprite no está espejado
	sprite_right_hand.flip_h = false
	sprite_right_hand.flip_v = false
	
	# Seleccionar el sprite sheet adecuado según si está grab o no
	var sheet = right_hand_grab_sprite_sheet if is_grabbing else right_hand_sprite_sheet
	
	# Tamaño de cada sprite individual
	var sheet_width = sheet.get_width()
	var sheet_height = sheet.get_height()
	var sprite_width = sheet_width / 5  # 5 columnas
	var sprite_height = sheet_height / 2  # 2 filas
	
	# Calcular fila y columna del sprite
	var row = 0 if current_skin_index < 5 else 1  # Fila 0 (skins 0-4) o Fila 1 (skins 5-9)
	var col = current_skin_index % 5  # Columna (0-4)
	
	# Configurar AtlasTexture
	var atlas = AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		col * sprite_width,
		row * sprite_height,
		sprite_width,
		sprite_height
	)
	
	# Asignar la textura
	sprite_right_hand.texture = atlas
	
func _physics_process(delta: float) -> void:
	var direction = left_hand.global_position - global_position
	var distance = direction.length()
	
	if distance > max_hand_separation:
		var excess = distance - max_hand_separation
		var force = direction.normalized() * min(excess * pull_force, pull_force * 2) * delta
		
		# Para CharacterBody2D usamos velocity directamente
		velocity += force
		left_hand.velocity -= force
		
		move_and_slide()
		
		# Opcional: Feedback visual/sonoro
		if excess > 50 and has_node("StretchSound"):
			$StretchSound.play()
			
			
	# Control de sprite basado en input
	var grabbing_now = Input.is_action_pressed("grab_right")
	
	if grabbing_now != is_grabbing:
		is_grabbing = grabbing_now
		update_hand_texture()
		 
	# Control de agarre
	if Input.is_action_just_pressed("grab_right") and Global.right_esta_en_musgo:
		start_anchoring()
		effects.play()
	
	if Input.is_action_just_released("grab_right"):
		stop_anchoring()
	
	# Actualizar cooldown si está activo
	if up_input_blocked:
		up_cooldown_timer -= delta
		if up_cooldown_timer <= 0:
			up_input_blocked = false
			up_cooldown_timer = 0.0
	
	# Solo aplicar física si no está anclado
	if not congelado_en_musgo:
		handle_movement(delta)
	
	move_and_slide()
	
func handle_movement(delta: float):
	var direction_x_right := Input.get_axis("right_hand_left", "right_hand_right")
	var direction_y_right := Input.get_axis("right_hand_up", "right_hand_down")
	
	# Restricción de movimiento hacia arriba si la otra mano no está anclada
	if direction_y_right < 0:
		if !left_hand.congelado_en_musgo:
			direction_y_right = 0
	
	# Lógica de cooldown
	if Input.is_action_pressed("right_hand_up") && left_hand.congelado_en_musgo:
		if !up_input_blocked:
			up_pressed_time += delta
			if up_pressed_time >= MAX_UP_TIME:
				up_input_blocked = true
				up_cooldown_timer = UP_COOLDOWN
		else:
			direction_y_right = max(direction_y_right, 0)
	else:
		up_pressed_time = 0.0
	
	# Movimiento horizontal
	if direction_x_right:
		velocity.x = direction_x_right * SPEED
		en_el_aire = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Movimiento vertical
	if direction_y_right:
		velocity.y = direction_y_right * SPEED
		en_el_aire = false
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Gravedad progresiva
	if velocity == Vector2.ZERO && !congelado_en_musgo:
		en_el_aire = true
	
	if en_el_aire && !congelado_en_musgo:
		var factor = min(tiempo_en_aire / GRAVITY_RAMP_TIME, 1.0)
		var gravedad_actual = BASE_GRAVITY + (MAX_GRAVITY - BASE_GRAVITY) * factor
		velocity.y += gravedad_actual * delta
		tiempo_en_aire += delta
	else:
		tiempo_en_aire = 0.0

func start_anchoring():
	print("RIGHT EN MUSGO - CONGELANDO")
	congelado_en_musgo = true
	velocity = Vector2.ZERO
	en_el_aire = false
	tiempo_en_aire = 0.0
	up_pressed_time = 0.0
	up_input_blocked = false
	up_cooldown_timer = 0.0
	righthand_joint.stiffness = frozen_stiffness
	righthand_joint.damping = frozen_damping

func stop_anchoring():
	congelado_en_musgo = false
	righthand_joint.stiffness = normal_stiffness
	righthand_joint.damping = normal_damping
	left_hand.set_hand_hanging(false)

func set_hand_hanging(hanging: bool):
	if hanging:
		lefthand_joint.stiffness = normal_stiffness * 2
		lefthand_joint.damping = normal_damping * 2
		en_el_aire = false
		tiempo_en_aire = 0.0
	else:
		lefthand_joint.stiffness = normal_stiffness
		lefthand_joint.damping = normal_damping

func set_joints_stiffness(stiffness: float, damping: float):
	righthand_joint.stiffness = stiffness
	righthand_joint.damping = damping
