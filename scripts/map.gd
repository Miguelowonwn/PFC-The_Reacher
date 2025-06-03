extends Node2D

#Base de datos
var database := SQLite.new()

#Variables de partida
@onready var checkpoint_manager: Node = $CheckpointManager

var game_paused: bool = false  
var num_coins = 0  
@onready var respawn_1: Marker2D = $Respawn1    
var timer_actualizacion: Timer  
 
#Esquina de pantalla con Stats
@onready var label_time: Label = $CanvasLayer/TiempoRestante/VBoxContainer/Tiempo/LabelTime
@onready var time_left: Label = $CanvasLayer/TiempoRestante/VBoxContainer/Tiempo/TimeLeft
@onready var label_coins: Label = $CanvasLayer/TiempoRestante/VBoxContainer/Monedas/LabelCoins
@onready var coins: Label = $CanvasLayer/TiempoRestante/VBoxContainer/Monedas/Coins
@onready var animaciones: AnimationPlayer = $Animaciones
 
@onready var musgo_1: CollisionPolygon2D = $"Torre 1/RigidBody2D/Musgo1"
@onready var musgo_2: CollisionPolygon2D = $"Torre 1/RigidBody2D/Musgo2"
@onready var musgo_3: CollisionPolygon2D = $Node2D/RigidBody2D/Musgo3
@onready var reacher: Node2D = $Reacher

#Manos de The Reacher 
@onready var left_hand: CharacterBody2D = $Reacher/Left_hand
@onready var right_hand: CharacterBody2D = $Reacher/Right_hand 
@onready var left_hand_sprite: Sprite2D = $Left_hand/Sprite2D
@onready var right_hand_sprite: Sprite2D = $Right_hand/Sprite2D

const GRAVITY = 9.8

#Variables estado The reacher
var left_esta_en_musgo: bool = false
var right_esta_en_musgo: bool = false
var left_esta_agarrando: bool = false
var right_esta_agarrando: bool = false
 
#Menu escape 
#Ajustes
@onready var musica_slider: HSlider = $CanvasMenuEscape/MenuEscape/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/Controladores/SliderMusica/VSlider
@onready var efectos_slider: HSlider = $CanvasMenuEscape/MenuEscape/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/FullScreenYEfectos/ContainerEfectos/VSlider
@onready var resolutions_option_button: OptionButton = $CanvasMenuEscape/MenuEscape/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/Controladores/ContainerResolucion/OptionResolucion/OptionButton

@onready var full_screen_check_box: CheckBox = $CanvasMenuEscape/MenuEscape/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/FullScreenYEfectos/HBoxContainer/FullScreenCheckBox
			
@onready var music: AudioStreamPlayer = $Music    
@onready var effects: AudioStreamPlayer = $Effects

var sound_effects := {
	"coin": preload("res://resources/musicNsounds/coin-pickup.mp3"),
	"select": preload("res://resources/musicNsounds/select_sound.mp3")
	#"damage": preload("res://resources/musicNsounds/damage.ogg")
}

@onready var eyeAnimation: AnimatedSprite2D = $Reacher/Eye/Animacion
@onready var menu_escape: Control = $CanvasMenuEscape/MenuEscape
@onready var ajustes_mapeo: Control = $GUI/Mapeo
@onready var salir_box: PanelContainer = $CanvasMenuEscape/MenuEscape/SalirBox
 

 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:     
	Global.tiempo_maximo = 500 #Cambiar en pro
	
	Engine.time_scale = 1
	process_mode = Node.PROCESS_MODE_PAUSABLE 
	_inicializar_bd()
	_cargar_ajustes()
	
	timer_actualizacion = Timer.new()
	add_child(timer_actualizacion)
	timer_actualizacion.timeout.connect(_actualizar_tiempo)
	timer_actualizacion.wait_time = 1.0  # 1 segundo
	 
	# Inicia el conteo
	iniciar_conteo_tiempo()

func iniciar_conteo_tiempo():
	# Reinicia el valor si es necesario 
	time_left.text = str(Global.tiempo_maximo)
	timer_actualizacion.start()

func _actualizar_tiempo():
	if Global.tiempo_maximo > 0:
		Global.tiempo_maximo -= 1
		time_left.text = str(Global.tiempo_maximo)
	else:
		timer_actualizacion.stop()
		# Aquí puedes añadir lo que ocurre cuando el tiempo llega a 0
		game_over() 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:  
	comprobar_si_moneda_obtenida()
	cada_segundo_actualizar_tiempo_restando()
	pass
	 
func _on_area_2d_area_entered(area: Area2D) -> void:  
	if area.is_in_group("Left_Hand"): 
		Global.left_esta_en_musgo = true
	elif area.is_in_group("Right_Hand"): 
		Global.right_esta_en_musgo = true
	   
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Left_Hand"): 
		Global.left_esta_en_musgo = false
	elif area.is_in_group("Right_Hand"): 
		Global.right_esta_en_musgo = false
 
func game_over():
	animaciones.play("game_over")
	Engine.time_scale = 0.05
	music.pitch_scale = 0.4
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func toggle_pause():
	game_paused = !game_paused
	
	if game_paused: 
		# Pausar el juego
		get_tree().paused = true
		menu_escape.visible = true
		resolutions_option_button.grab_focus()
		
		# Pausar solo la música (no los efectos)
		music.stream_paused = true
		
		if salir_box.z_index > 0:
			salir_box.z_index = 0
	else:   
		# Reanudar el juego
		get_tree().paused = false
		menu_escape.visible = false 
		
		# Reanudar la música
		music.stream_paused = false

	# Manejar ajustes si estaban activos
	if musica_slider.has_focus() or efectos_slider.has_focus(): 
		_guardar_ajustes_en_bd()
		await get_tree().create_timer(0.1).timeout
		full_screen_check_box.grab_focus()

func _stop_game_when_paused():
	music.stream_paused = true 
	
func _resume_game_when_not_paused():
	music.stream_paused = false 
	 
	
######################## CONTROLES  
func _unhandled_input(event: InputEvent) -> void: 
	if event.is_action_pressed("escape_menu"):
		toggle_pause()
		get_tree().root.get_viewport().set_input_as_handled()	  
		
	if musica_slider.has_focus() or efectos_slider.has_focus(): 
			_guardar_ajustes_en_bd()
			await get_tree().create_timer(0.1).timeout
			full_screen_check_box.grab_focus()
############################ AJUSTES  
func _volver_atras():
	if musica_slider.has_focus():
		await get_tree().create_timer(0.2).timeout
		resolutions_option_button.grab_focus()
		_cargar_ajustes()
	elif efectos_slider.has_focus():
		await get_tree().create_timer(0.2).timeout
		resolutions_option_button.grab_focus()
		_cargar_ajustes() 
		 
func _guardar_ajustes_en_bd():
	var volumen_bd = str(Global.volumen_musica) + ";" + str(Global.volumen_efectos)
	var datos_ajustes = {
			"volumen": volumen_bd,
			"resolucion": Global.resolucion,
			"pantalla_completa": Global.pantalla_completa,
		}
	database.update_rows("Ajustes", "usuario_id = '" + str(Global.id_usuario) + "'", datos_ajustes)
	 
func _cargar_ajustes():
	var resultado = database.select_rows("Ajustes", "usuario_id = '" + str(Global.id_usuario) + "'", ["id", "resolucion", "pantalla_completa", "volumen"])
	
	if resultado.size() == 0:
		# No hay ajustes: cargar valores predeterminados
		Global.resolucion = 1  # 1920x1080
		Global.pantalla_completa = 0  # Ventana
		Global.volumen_musica = "0.5"
		Global.volumen_efectos = "0.5"
		
		# Insertar ajustes predeterminados en la base de datos
		var volumen_texto = Global.volumen_musica + ";" + Global.volumen_efectos
		var ajustes_insert = {
			"usuario_id": Global.id_usuario,
			"resolucion": Global.resolucion,
			"pantalla_completa": Global.pantalla_completa,
			"volumen": volumen_texto
		}
		Global.id_ajustes_de_usuario = database.insert_row("Ajustes", ajustes_insert)
	else:
		# Cargar los ajustes existentes
		var ajustes = resultado[0]
		Global.id_ajustes_de_usuario = ajustes["id"]
		Global.resolucion = int(ajustes["resolucion"])
		Global.pantalla_completa = int(ajustes["pantalla_completa"])
		var volumen_general = ajustes["volumen"].split(";")
		Global.volumen_musica = volumen_general[0]
		Global.volumen_efectos = volumen_general[1]

	# Aplicar los ajustes cargados o predeterminados
	AudioServer.set_bus_volume_db(0, linear_to_db(float(Global.volumen_musica)))
	AudioServer.set_bus_volume_db(1, linear_to_db(float(Global.volumen_efectos)))
	GUI.center_window()

	full_screen_check_box.button_pressed = Global.pantalla_completa == 1
	resolutions_option_button.select(Global.resolucion)
 
	match Global.resolucion:
		0: get_window().size = Vector2i(2560, 1440)
		1: get_window().size = Vector2i(1920, 1080)
		2: get_window().size = Vector2i(1600, 900)
		3: get_window().size = Vector2i(1440, 900)
		4: get_window().size = Vector2i(1366, 768)
		5: get_window().size = Vector2i(1280, 720)
		6: get_window().size = Vector2i(1024, 600)
		7: get_window().size = Vector2i(800, 600)
		_: get_window().size = Vector2i(1920, 1080)  # Por defecto

	musica_slider.value = int(Global.volumen_musica)
	efectos_slider.value = int(Global.volumen_efectos)
	
	if int(Global.volumen_musica) == 0:
		musica_slider.value = 0
	if int(Global.volumen_efectos) == 0:
		efectos_slider.value = 0

func comprobar_si_moneda_obtenida():
	if Global.coin_count > num_coins:
		num_coins = Global.coin_count
		effects.play() 
		coins.text = str(num_coins)
		
func cada_segundo_actualizar_tiempo_restando():
	time_left.text = str(Global.tiempo_maximo) 
	pass 

		
############################ BASE DE DATOS
func _inicializar_bd():
	var source_db = "res://data.db"
	var target_db = "user://data.db"
	
	# Crear directorio si no existe
	var dir = DirAccess.open("user://")
	if dir == null:
		DirAccess.make_dir_absolute("user://")
		dir = DirAccess.open("user://")
		if dir == null:
			push_error("No se pudo crear directorio user://")
			return
			
	# Verificar y copiar la BD
	if !FileAccess.file_exists(target_db): 
		var err = DirAccess.copy_absolute(source_db, target_db)
		if err != OK:
			push_error("Error copiando BD: ", error_string(err))
			return
			
	# Abrir la base de dawtos
	database = SQLite.new() 
	database.path="user://data.db"
	database.open_db()	
