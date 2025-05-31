extends RigidBody2D

signal respawned()

@onready var lefthand_joint: DampedSpringJoint2D = $"../LefthandJoint"
@onready var righthand_joint: DampedSpringJoint2D = $"../RighthandJoint"
@onready var left_hand: CharacterBody2D = $"../Left_hand"
@onready var right_hand: CharacterBody2D = $"../Right_hand"
@onready var sprite_2d: Sprite2D = $Sprite2D

# Sistema de skins del ojo
var eye_sprite_sheet = preload("res://sprites/skins/eye/eye_skins_animation.png")
var current_eye_skin_index = 0

var eye_skin_index = {
	"Rojo": 0,
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

func _ready() -> void:
	inicializar_eye_skin()
	# Configuración inicial de las joints
	lefthand_joint.stiffness = 80.0
	lefthand_joint.damping = 15.0
	righthand_joint.stiffness = 2.0
	righthand_joint.damping = 0.5

func inicializar_eye_skin():
	var ojo_skin = Global.ojo_skin
	
	if eye_skin_index.has(ojo_skin):
		current_eye_skin_index = eye_skin_index[ojo_skin]
		update_eye_texture()
	 

func update_eye_texture():  
	# Asegurarnos que el sprite no está espejado
	sprite_2d.flip_h = false
	sprite_2d.flip_v = false
	
	# Tamaño del sprite sheet (ajusta según tu archivo)
	var sheet_width = eye_sprite_sheet.get_width() / 3
	var sheet_height = eye_sprite_sheet.get_height()
	
	# Asumiendo 1 columna (solo estado abierto) y 10 filas (una por skin)
	var sprite_height = sheet_height / 10  # 10 skins
	
	# Configurar AtlasTexture
	var atlas = AtlasTexture.new()
	atlas.atlas = eye_sprite_sheet
	atlas.region = Rect2(
		0,  # Columna 0
		current_eye_skin_index * sprite_height,  # Fila según skin
		sheet_width,  # Ancho completo
		sprite_height
	)
	
	sprite_2d.texture = atlas

func _process(delta: float) -> void:
	if Global.ojo_skin_changed: 
		inicializar_eye_skin()
		Global.ojo_skin_changed = false
 
