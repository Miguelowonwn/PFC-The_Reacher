extends Control
 

@onready var tabla_scores: ItemList = $Progreso/PanelContainer/VBoxContainer/StatsYItemList/ItemList
@onready var resolutions_option_button: OptionButton = $Ajustes/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/Controladores/ContainerResolucion/OptionResolucion/OptionButton
	
#Escalar

#Niveles
@onready var nivel_1: TextureButton = $"SeleccionNivel/Container Niveles/Nivel 1"
@onready var nivel_2: TextureButton = $"SeleccionNivel/Container Niveles/Nivel 2"
@onready var nivel_3: TextureButton = $"SeleccionNivel/Container Niveles/Nivel 3"

#Scores
@onready var filtro_nivel: OptionButton = $TablaScores/PanelContainer/VBoxContainer/Filtros/FiltroNivel
@onready var mejores_tiempos: CheckBox = $TablaScores/PanelContainer/VBoxContainer/Filtros/MejoresTiempos
@onready var filtrar_usuario: LineEdit = $TablaScores/PanelContainer/VBoxContainer/Filtros/FiltrarUsuario
@onready var scores_list: ItemList = $TablaScores/PanelContainer/VBoxContainer/ScoresList


#Progreso 
@onready var lista_stats: ItemList = $Progreso/PanelContainer/VBoxContainer/StatsYItemList/PanelContainer/ListaStats
@onready var lista_medallas: ItemList = $Progreso/PanelContainer/VBoxContainer/StatsYItemList/ListaMedallas
 

#Botones Menu principal
@onready var escalar: Button = $MenuPrincipal/Container_Menu/Escalar
@onready var scores: Button = $MenuPrincipal/Container_Menu/Scores
@onready var progreso: Button = $MenuPrincipal/Container_Menu/Progreso
@onready var ajustes: Button = $MenuPrincipal/Container_Menu/Ajustes

#Botones Ajustes
@onready var option_button: OptionButton = $Ajustes/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/Controladores/ContainerResolucion/OptionResolucion/OptionButton

#Ajustes   
@onready var full_screen_check_box: CheckBox = $Ajustes/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/FullScreenYEfectos/HBoxResolucion/FullScreenCheckBox
@onready var musica_slider: HSlider = $Ajustes/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/Controladores/SliderMusica/VSlider
@onready var efectos_slider: HSlider = $Ajustes/PanelContainerBg/PanelContainer/MarginContainer/VBoxContainer/FullScreenYEfectos/ContainerEfectos/VSlider

#Sonido
@onready var effects: AudioStreamPlayer = $Effects

	#Animaciones 
@onready var animation_player: AnimationPlayer = $AnimationPlayer 

#	Manos 
@onready var boton_mano_rojo: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_rojo"
@onready var boton_mano_amarillo: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_amarillo"
@onready var boton_mano_azul: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_azul"
@onready var boton_mano_gris: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_gris"
@onready var boton_mano_negro: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_negro"
@onready var boton_mano_rosa: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_rosa"
@onready var boton_mano_naranja: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_naranja"
@onready var boton_mano_verde: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_verde"
@onready var boton_mano_blanco: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_blanco"
@onready var boton_mano_cian: Button = $"SeleccionNivel/Container Skins Mano/boton_mano_cian"

#	Ojos 
@onready var boton_ojo_rojo: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_rojo"
@onready var boton_ojo_amarillo: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_amarillo"
@onready var boton_ojo_azul: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_azul"
@onready var boton_ojo_gris: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_gris"
@onready var boton_ojo_negro: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_negro"
@onready var boton_ojo_rosa: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_rosa"
@onready var boton_ojo_naranja: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_naranja"
@onready var boton_ojo_verde: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_verde"
@onready var boton_ojo_blanco: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_blanco"
@onready var boton_ojo_cian: Button = $"SeleccionNivel/Container Skins Ojo/boton_ojo_cian"
  
 
# Diccionario para almacenar las skins desbloqueadas
var skins_desbloqueadas

# Diccionario para mapear nombres de skin a botones
var mapa_botones = {
	"Mano-Rojo": boton_mano_rojo,
	"Mano-Amarillo": boton_mano_amarillo,
	"Mano-Azul": boton_mano_azul,
	"Mano-Gris": boton_mano_gris,
	"Mano-Negro": boton_mano_negro,
	"Mano-Rosa": boton_mano_rosa,
	"Mano-Naranja": boton_mano_naranja,
	"Mano-Verde": boton_mano_verde,
	"Mano-Blanco": boton_mano_blanco,
	"Mano-Cian": boton_mano_cian,
	
	"Ojo-Rojo": boton_ojo_rojo,
	"Ojo-Amarillo": boton_ojo_amarillo,
	"Ojo-Azul": boton_ojo_azul,
	"Ojo-Gris": boton_ojo_gris,
	"Ojo-Negro": boton_ojo_negro,
	"Ojo-Rosa": boton_ojo_rosa,
	"Ojo-Naranja": boton_ojo_naranja,
	"Ojo-Verde": boton_ojo_verde,
	"Ojo-Blanco": boton_ojo_blanco,
	"Ojo-Cian": boton_ojo_cian
}
 
var escena_reproducida

#Variables 
var mapa_elegido: String
	
#Base de datos
var database := SQLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:   
	Engine.time_scale = 1
	await get_tree().process_frame 
	escalar.grab_focus()
	_inicializar_bd()
	_cargar_ajustes()
	_cargar_skins()
	GUI.center_window()
	
func _cargar_skins():   
	# Consulta para obtener todas las skins del usuario actual
	skins_desbloqueadas = database.select_rows("Skins", "usuario_id = '" + str(Global.id_usuario) + "'", ["nombre", "desbloqueada"]) 
	  
	# Luego activamos solo los desbloqueados
	for skin in skins_desbloqueadas:
		var nombre_skin = skin["nombre"]
		var desbloqueada = skin["desbloqueada"]
		
		if desbloqueada == "true":
			desbloqueada = true
		else: 
			desbloqueada = false
			
		match str(nombre_skin):
			"Mano-Rojo":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_rojo)
			"Mano-Amarillo":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_amarillo)
			"Mano-Azul":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_azul)
			"Mano-Gris":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_gris)
			"Mano-Negro":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_negro)
			"Mano-Rosa":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_rosa)
			"Mano-Naranja":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_naranja)
			"Mano-Verde":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_verde)
			"Mano-Blanco":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_blanco)
			"Mano-Cian":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_mano_cian)
					
			"Ojo-Rojo":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_rojo)
			"Ojo-Amarillo":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_amarillo)
			"Ojo-Azul":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_azul)
			"Ojo-Gris":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_gris)
			"Ojo-Negro":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_negro)
			"Ojo-Rosa":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_rosa)
			"Ojo-Naranja":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_naranja)
			"Ojo-Verde":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_verde)
			"Ojo-Blanco":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_blanco)
			"Ojo-Cian":
				if desbloqueada == false:
					_aplicar_efecto_bloqueado(boton_ojo_cian)

# Función helper para aplicar efecto visual
func _aplicar_efecto_bloqueado(boton: Button):
	if boton == null:
		return 
	# Mantener visible pero con efecto visual
	boton.disabled = true
	boton.modulate = Color(0.5, 0.5, 0.5)  # Visual de gris 
	 
	 
############################ AJUSTES  
func _cargar_ajustes():
	var resultado = database.select_rows("Ajustes", "usuario_id = '" + str(Global.id_usuario) + "'", ["id", "resolucion", "pantalla_completa", "volumen"])
	
	if resultado.size() == 0:
		# No hay ajustes: cargar valores predeterminados
		Global.resolucion = 5 
		Global.pantalla_completa = 0
		Global.volumen_musica = "5"
		Global.volumen_efectos = "5"
		
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

	  
func _guardar_ajustes_en_bd():
	var volumen_bd = str(Global.volumen_musica) + ";" + str(Global.volumen_efectos)
	var datos_ajustes = {
			"volumen": volumen_bd,
			"resolucion": Global.resolucion,
			"pantalla_completa": Global.pantalla_completa,
		}
	database.update_rows("Ajustes", "usuario_id = '" + str(Global.id_usuario) + "'", datos_ajustes)
	
func add_resolutions():   
	for r in GUI.resolutions:
		resolutions_option_button.add_item(r)

func update_button_values():
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var resolutions_index = GUI.resolutions.keys().find(window_size_string)
	resolutions_option_button.selected = resolutions_index
	
func _on_option_button_item_selected(index: int) -> void: 
	var key = resolutions_option_button.get_item_text(index)
	DisplayServer.window_set_size(GUI.resolutions[key])
	GUI.center_window()
	
	Global.resolucion = index  
	_guardar_ajustes_en_bd()
	 
func _on_full_screen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		resolutions_option_button.clear()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		Global.pantalla_completa = 1
		_guardar_ajustes_en_bd()
		effects.play()
	else:
		add_resolutions()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		var key = resolutions_option_button.get_item_text(Global.resolucion)
		DisplayServer.window_set_size(GUI.resolutions[key])
		GUI.center_window()
		update_button_values()
		Global.pantalla_completa = 0  
		_guardar_ajustes_en_bd()
		
############################ AJUSTES
	
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
			
	# Abrir la base de datos
	database = SQLite.new() 
	database.path="user://data.db"
	database.open_db()	
	
############################ BASE DE DATOS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:   
	comprobar_si_line_edit_tiene_focus()
	comprobar_partida_terminada()
	pass 

func comprobar_si_line_edit_tiene_focus():
	filtrar_usuario.deselect() 
	if filtrar_usuario.has_focus():
		filtrar_usuario.deselect()  
		
func comprobar_partida_terminada():
	if Global.meta_conseguida:
		
		pass
		 
# Manos Pressed ---------------------------------
func _on_mano_skin_1_pressed() -> void:
	seleccionar_skin_mano("Rojo", boton_mano_rojo)

func _on_mano_skin_2_pressed() -> void:
	seleccionar_skin_mano("Amarillo", boton_mano_amarillo)

func _on_mano_skin_3_pressed() -> void:
	seleccionar_skin_mano("Azul", boton_mano_azul)

func _on_mano_skin_4_pressed() -> void:
	seleccionar_skin_mano("Gris", boton_mano_gris)

func _on_mano_skin_5_pressed() -> void:
	seleccionar_skin_mano("Negro", boton_mano_negro)

func _on_mano_skin_6_pressed() -> void:
	seleccionar_skin_mano("Rosa", boton_mano_rosa)

func _on_mano_skin_7_pressed() -> void:
	seleccionar_skin_mano("Naranja", boton_mano_naranja)

func _on_mano_skin_8_pressed() -> void:
	seleccionar_skin_mano("Verde", boton_mano_verde)

func _on_mano_skin_9_pressed() -> void:
	seleccionar_skin_mano("Blanco", boton_mano_blanco)

func _on_mano_skin_10_pressed() -> void:
	seleccionar_skin_mano("Cian", boton_mano_cian)
 
func seleccionar_skin_mano(nombre_skin: String, boton: Button) -> void: 
	Global.mano_skin = nombre_skin
	boton.get_theme_stylebox("normal").bg_color = Color.GRAY
	boton_ojo_rojo.grab_focus()
	effects.play()

# Ojos Pressed ---------------------------------

func _on_ojo_skin_1_pressed() -> void:
	seleccionar_skin_ojo("Rojo", boton_mano_cian)

	 
func _on_ojo_skin_2_pressed() -> void:
	seleccionar_skin_ojo("Amarillo", boton_mano_cian)

func _on_ojo_skin_3_pressed() -> void:
	seleccionar_skin_ojo("Azul", boton_mano_cian)
 
func _on_ojo_skin_4_pressed() -> void:
	seleccionar_skin_ojo("Gris", boton_mano_cian)
 
func _on_ojo_skin_5_pressed() -> void:
	seleccionar_skin_ojo("Negro", boton_mano_cian)
 
func _on_ojo_skin_6_pressed() -> void:
	seleccionar_skin_ojo("Rosa", boton_mano_cian)
 
func _on_ojo_skin_7_pressed() -> void:
	seleccionar_skin_ojo("Naranja", boton_mano_cian)
 
func _on_ojo_skin_8_pressed() -> void:
	seleccionar_skin_ojo("Verde", boton_mano_cian)
 
func _on_ojo_skin_9_pressed() -> void:
	seleccionar_skin_ojo("Blanco", boton_mano_cian)

func _on_ojo_skin_10_pressed() -> void:
	seleccionar_skin_ojo("Cian", boton_mano_cian)
   
func seleccionar_skin_ojo(nombre_skin: String, boton: Button) -> void: 
	effects.play()
	Global.ojo_skin = nombre_skin
	boton.get_theme_stylebox("normal").bg_color = Color.GRAY
	animation_player.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	empezar_partida()
	
######################## CONTROLES
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_back"): 
		if filtrar_usuario.has_focus():
			pass
		else:
			_volver_atras() 
		
	if event.is_action_pressed("ui_accept"):
		if musica_slider.has_focus() or efectos_slider.has_focus(): 
			_guardar_ajustes_en_bd()
			await get_tree().create_timer(0.1).timeout
			full_screen_check_box.grab_focus()
	
		if filtrar_usuario.has_focus():
			filtrar_usuario.editable = true
			
	if event.is_action_pressed("ui_left"):
		if filtrar_usuario.has_focus():
			filtrar_usuario.release_focus()
			mejores_tiempos.grab_focus()
			get_viewport().set_input_as_handled()
			
	if event.is_action_pressed("ui_right"):
		if filtrar_usuario.has_focus():
			filtrar_usuario.release_focus()
			filtro_nivel.grab_focus()
			get_viewport().set_input_as_handled()
			
func _volver_atras():
	match escena_reproducida:
		"Escalar": 
			nivel_1.texture_normal = preload("res://sprites/level_icons/Level-1.png")
			nivel_2.texture_normal = preload("res://sprites/level_icons/Level-2.png")
			nivel_3.texture_normal = preload("res://sprites/level_icons/Level-3.png")

			animation_player.play_backwards("fade_escalar") 
			escena_reproducida = "" 
			await get_tree().create_timer(1.5).timeout
			escalar.grab_focus() 
			resetear_elección_nivel_skins()
		"Scores":
			animation_player.play_backwards("fade_scores") 
			escena_reproducida = ""
			await get_tree().create_timer(1.5).timeout
			scores.grab_focus() 
			filtrar_usuario.clear
			filtrar_usuario.editable = false  
			
		"Progreso":
			animation_player.play_backwards("fade_progreso")
			escena_reproducida = ""
			await get_tree().create_timer(1.5).timeout
			progreso.grab_focus()
		"Ajustes":
			if musica_slider.has_focus():
				await get_tree().create_timer(0.2).timeout
				resolutions_option_button.grab_focus()
				_cargar_ajustes()
			elif efectos_slider.has_focus():
				await get_tree().create_timer(0.2).timeout
				resolutions_option_button.grab_focus()
				_cargar_ajustes()
			else:
				animation_player.play_backwards("fade_ajustes")
				escena_reproducida = ""
				await get_tree().create_timer(1.5).timeout
				ajustes.grab_focus()  
				
			if filtrar_usuario.has_focus():
				#filtrar_usuario.editable = false
				pass	  
	   
func _on_escalar_pressed(): 
	effects.play()
	escena_reproducida = "Escalar" 
	animation_player.play("fade_escalar")
	await get_tree().create_timer(1).timeout
	nivel_1.grab_focus()  

func _on_scores_pressed() -> void:
	effects.play()
	# Forzar la actualización de la lista de scores
	filtro_nivel.select(0) 
	mejores_tiempos.button_pressed = false
	if filtrar_usuario.text != "":
		filtrar_usuario.clear()
	escena_reproducida = "Scores" 
	animation_player.play("fade_scores")
	await get_tree().create_timer(1).timeout
	filtro_nivel.grab_focus() 
	
func _on_progreso_pressed() -> void:
	effects.play()
	escena_reproducida = "Progreso" 
	animation_player.play("fade_progreso")
	await get_tree().create_timer(1).timeout 
	lista_medallas.grab_focus()
	
func _on_ajustes_pressed() -> void:
	effects.play()
	escena_reproducida = "Ajustes" 
	animation_player.play("fade_ajustes")
	await get_tree().create_timer(1).timeout
	resolutions_option_button.grab_focus()   
	
# Niveles pressed  
func _on_nivel_1_pressed() -> void:
	Global.nivel_seleccionado = 1
	nivel_1.texture_normal = preload("res://sprites/level_icons/Level-1-Selected.png")
	boton_mano_rojo.grab_focus()    
	Global.tiempo_maximo = 500  
	Global.tiempo_actual = 500  
	effects.play()

func _on_nivel_2_pressed() -> void:
	Global.nivel_seleccionado = 2
	nivel_2.texture_normal = preload("res://sprites/level_icons/Level-2-Selected.png")
	boton_mano_rojo.grab_focus()   
	Global.tiempo_maximo = 400
	Global.tiempo_actual = 400    
	effects.play()
	
func _on_nivel_3_pressed() -> void:
	Global.nivel_seleccionado = 3
	nivel_3.texture_normal = preload("res://sprites/level_icons/Level-3-Selected.png")
	boton_mano_rojo.grab_focus()   
	Global.tiempo_maximo = 200
	Global.tiempo_actual = 200  
	effects.play()
	
func resetear_elección_nivel_skins(): 
	Global.ojo_skin = ""   
		# Skins de Mano
	boton_mano_rojo.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_amarillo.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_azul.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_gris.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_negro.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_rosa.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_naranja.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_verde.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_blanco.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_mano_cian.get_theme_stylebox("normal").bg_color = Color("1e1e1e")

	# Skins de Ojo
	boton_ojo_rojo.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_amarillo.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_azul.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_gris.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_negro.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_rosa.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_naranja.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_verde.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_blanco.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	boton_ojo_cian.get_theme_stylebox("normal").bg_color = Color("1e1e1e")
	 
func empezar_partida(): 
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	
func _on_exit_pressed():
	get_tree().quit()
	
	
