extends CharacterBody2D

const SPEED = 300.0
const BASE_GRAVITY = 4900.0
const MAX_GRAVITY = 20000.0
const GRAVITY_RAMP_TIME = 2.0
const MAX_UP_TIME = 2.0
const UP_COOLDOWN = 2.0

# Variables exportables para el sistema de separación de manos
@export var max_hand_separation: float = 300
@export var pull_force: float = 800 

@onready var sprite_left_hand: Sprite2D = $SpriteLeftHand

var en_el_aire: bool = true
var tiempo_en_aire: float = 0.0
var congelado_en_musgo: bool = false
var up_pressed_time: float = 0.0
var up_cooldown_timer: float = 0.0
var up_input_blocked: bool = false
var _other_hand_node: CharacterBody2D

# Sistema de skins y agarre
var left_hand_grab_sprite_sheet = preload("res://sprites/skins/hand/left_grab_hand_skins.png") 
var current_skin_index = 0
var is_grabbing = false
@onready var effects: AudioStreamPlayer = $"../Effects"

# Configuración de Joints
@export var normal_stiffness: float = 2.0
@export var normal_damping: float = 0.5
@export var frozen_stiffness: float = 200.0
@export var frozen_damping: float = 20.0

# Nodos relacionados
@onready var lefthand_joint: DampedSpringJoint2D = $"../LefthandJoint"
@onready var eye: RigidBody2D = $"../Eye"
@onready var right_hand: CharacterBody2D = $"../Right_hand"
@onready var righthand_joint: DampedSpringJoint2D = $"../RighthandJoint"

# Sistema de skins
var left_hand_sprite_sheet = preload("res://sprites/skins/hand/left_hand_skins.png") 
  
var skin_index = {
	"Roja": 0,
	"Amarillo": 1,
	"Azul": 2,
	"Gris": 3,
	"Negro": 4,
	"Rosa": 5,
	"Naranja": 6,
	"Verde": 7,
	"Blanco": 8,
	"Cian": 9
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
		sprite_left_hand.texture = preload("res://sprites/glove_no_grab.png")

func update_hand_texture():
	sprite_left_hand.flip_h = false
	sprite_left_hand.flip_v = false
	
	var sheet = left_hand_grab_sprite_sheet if is_grabbing else left_hand_sprite_sheet
	var sheet_width = sheet.get_width()
	var sheet_height = sheet.get_height()
	var sprite_width = sheet_width / 5
	var sprite_height = sheet_height / 2
	
	var row = 0 if current_skin_index < 5 else 1
	var col = current_skin_index % 5
	
	var atlas = AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		col * sprite_width,
		row * sprite_height,
		sprite_width,
		sprite_height
	)
	
	sprite_left_hand.texture = atlas

func _physics_process(delta: float) -> void:
	# Sistema de limitación de distancia entre manos
	var direction = right_hand.global_position - global_position
	var distance = direction.length()
	
	if distance > max_hand_separation:
		var excess = distance - max_hand_separation
		var force = direction.normalized() * min(excess * pull_force, pull_force * 2) * delta
		
		velocity += force
		right_hand.velocity -= force
		
		move_and_slide()
		
		if excess > 50 and has_node("StretchSound"):
			$StretchSound.play()
	
	# Control de sprite basado en input
	var grabbing_now = Input.is_action_pressed("grab_left")
	
	if grabbing_now != is_grabbing:
		is_grabbing = grabbing_now
		update_hand_texture()
	
	# Control de agarre
	if Input.is_action_just_pressed("grab_left") and Global.left_esta_en_musgo:
		start_anchoring()
		effects.play()
	
	if Input.is_action_just_released("grab_left"):
		stop_anchoring()
	
	# Actualizar cooldown
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
	var direction_x_left := Input.get_axis("left_hand_left", "left_hand_right")
	var direction_y_left := Input.get_axis("left_hand_up", "left_hand_down")
	
	# Restricción de movimiento hacia arriba
	if direction_y_left < 0:
		if !right_hand.congelado_en_musgo:
			direction_y_left = 0
	
	# Lógica de cooldown
	if Input.is_action_pressed("left_hand_up") && right_hand.congelado_en_musgo:
		if !up_input_blocked:
			up_pressed_time += delta
			if up_pressed_time >= MAX_UP_TIME:
				up_input_blocked = true
				up_cooldown_timer = UP_COOLDOWN
		else:
			direction_y_left = max(direction_y_left, 0)
	else:
		up_pressed_time = 0.0
	
	# Movimiento horizontal
	if direction_x_left:
		velocity.x = direction_x_left * SPEED
		en_el_aire = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Movimiento vertical
	if direction_y_left:
		velocity.y = direction_y_left * SPEED
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
	
	# Actualizar cooldown
	if up_input_blocked:
		up_cooldown_timer -= delta
		if up_cooldown_timer <= 0:
			up_input_blocked = false

func start_anchoring():
	print("LEFT EN MUSGO - CONGELANDO")
	congelado_en_musgo = true
	velocity = Vector2.ZERO
	en_el_aire = false
	tiempo_en_aire = 0.0
	up_pressed_time = 0.0
	up_input_blocked = false
	up_cooldown_timer = 0.0
	lefthand_joint.stiffness = frozen_stiffness
	lefthand_joint.damping = frozen_damping

func stop_anchoring():
	congelado_en_musgo = false
	lefthand_joint.stiffness = normal_stiffness
	lefthand_joint.damping = normal_damping
	right_hand.set_hand_hanging(false)

func set_hand_hanging(hanging: bool):
	if hanging:
		righthand_joint.stiffness = normal_stiffness * 2
		righthand_joint.damping = normal_damping * 2
		en_el_aire = false
		tiempo_en_aire = 0.0
	else:
		righthand_joint.stiffness = normal_stiffness
		righthand_joint.damping = normal_damping

func set_joints_stiffness(stiffness: float, damping: float):
	lefthand_joint.stiffness = stiffness
	lefthand_joint.damping = damping
