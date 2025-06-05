extends Control

#Base de datos
var database := SQLite.new()

var puntuacion
var tiempo_completitud
var monedas_conseguidas
var desbloqueos_conseguidos: Array = []

var indice_mano 
var indice_ojo 
var numero_muertes
var monedas
var skins_usuario
@onready var score_resultado: Label = $ScoreResultado
@onready var tiempo_resultado: Label = $TiempoResultado
@onready var monedas_resultado: Label = $MonedasResultado
@onready var desbloqueos_list: ItemList = $DesbloqueosList
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_inicializar_bd() 


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
	if Global.mostrar_scores:
		Global.mostrar_scores = false
		montar_scores()
		desbloqueos_list.grab_focus()
		 
func montar_scores():
	var segundos_jugados = int(Global.tiempo_maximo) - int(Global.tiempo_actual)
	tiempo_completitud = Global.tiempo_maximo - segundos_jugados
	monedas_conseguidas = Global.coin_count
	indice_mano = devolver_indice_skin(Global.mano_skin)
	indice_ojo = devolver_indice_skin(Global.ojo_skin)
	numero_muertes = 9 - Global.muertes  
	numero_muertes = clamp(numero_muertes, 0, 9)
	
	# Formatear monedas
	monedas = "%02d" % monedas_conseguidas
	
	# Calcular puntuación
	puntuacion = str(tiempo_completitud) + str(indice_mano) + str(indice_ojo) + str(numero_muertes) + monedas
	
	# Comprobar y mostrar desbloqueos
	comprobar_desbloqueos(puntuacion)
	score_resultado.text = str(puntuacion)
	tiempo_resultado.text = str(segundos_jugados)
	monedas_resultado.text = str(monedas_conseguidas)
	 
	# Preparar datos para insertar
	var datos_score = {
		"usuario_id": Global.id_usuario,
		"nivel_id": Global.nivel_seleccionado,
		"puntuacion": puntuacion,
		"tiempo_completitud": segundos_jugados,
		"fecha": Time.get_datetime_string_from_system(),
		"medalla_id": medallas_obtenidas()
		}
	
	# Insertar en la base de datos
	database.insert_row("Scores", datos_score)
	  
	# Esperar 3 segundos y volver al menú principal
	await get_tree().create_timer(3).timeout
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
 

func medallas_obtenidas():
	var segundos_jugados = int(Global.tiempo_maximo) - int(Global.tiempo_actual)
	var nivel = Global.nivel_seleccionado
	
	# Diccionario con los requisitos de monedas por nivel
	var monedas_requeridas = {1: 30, 2: 40, 3: 50}
	
	# Verificar medalla de velocidad (tiempo)
	if segundos_jugados <= (Global.tiempo_maximo / 2):
		var tipo_medalla = 21 + (nivel-1)*3  # 21, 24 o 27
		agregar_medalla(tipo_medalla, "Velocista Nivel %d" % nivel)
	
	# Verificar medalla de perfección (sin muertes)
	if Global.muertes == 0:
		var tipo_medalla = 22 + (nivel-1)*3  # 22, 25 o 28
		agregar_medalla(tipo_medalla, "Perfección Nivel %d" % nivel)
	
	# Verificar medalla de coleccionista (monedas) 
	if Global.coin_count >= monedas_requeridas[nivel]:
		var tipo_medalla = 23 + (nivel-1)*3  # 23, 26 o 29
		agregar_medalla(tipo_medalla, "Coleccionista Nivel %d" % nivel)

func agregar_medalla(tipo_desbloqueo: int, nombre_medalla: String):
	# Verificar si la medalla ya existe en la base de datos
	var existe = database.select_rows("Medallas", "usuario_id = '%s' AND tipo_desbloqueo = %d" % [Global.id_usuario, tipo_desbloqueo],["id"]
	)
	
	if existe.size() == 0:
		# Insertar en la base de datos
		database.insert_row("Medallas", {"nombre": nombre_medalla, "tipo_desbloqueo": tipo_desbloqueo, "usuario_id": Global.id_usuario})
		
		# Añadir al ItemList
		var texture = obtener_textura_medalla(tipo_desbloqueo)
		desbloqueos_list.add_item(nombre_medalla, texture)

func obtener_textura_medalla(tipo_desbloqueo: int) -> AtlasTexture:
	# Configuración del spritesheet
	var sheet = preload("res://resources/medallas.png")
	var cols = 3
	var rows = 4
	var width = sheet.get_width() / cols
	var height = sheet.get_height() / rows
	
	# Calcular posición en el spritesheet
	var col = 0
	var row = 0
	
	if tipo_desbloqueo >= 21 and tipo_desbloqueo <= 29:  # Medallas normales
		var nivel = ((tipo_desbloqueo - 21) / 3)  # 0, 1 o 2 (para nivel 1-3)
		var tipo = (tipo_desbloqueo - 21) % 3     # 0, 1 o 2
		 
		match tipo:
			0: col = 1  
			1: col = 0   
			2: col = 2  
		
		row = nivel
	else:   
		row = 3
		col = tipo_desbloqueo - 30
	
	# Crear AtlasTexture
	var atlas = AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		col * width,
		row * height,
		width,
		height
	)
	return atlas
	
	 
func comprobar_desbloqueos(puntuacion):
	puntuacion = int(puntuacion)
	var skins_desbloqueadas = []
	
	# Obtener todas las skins del usuario
	skins_usuario = database.select_rows("Skins", "usuario_id LIKE '" + str(Global.id_usuario) + "'", ["*"])
	
	# Crear un diccionario rápido para buscar skins por nombre
	var skins_dict = {}
	for skin in skins_usuario:
		skins_dict[skin["nombre"]] = skin
	
	# Verificar condiciones de desbloqueo
	if puntuacion >= 15000910:
		match Global.nivel_seleccionado:
			1:
				desbloquear_skin("Mano-Amarillo", skins_dict)
				desbloquear_skin("Ojo-Naranja", skins_dict)
			2:
				desbloquear_skin("Mano-Rosa", skins_dict)
				desbloquear_skin("Ojo-Gris", skins_dict)
			3:
				desbloquear_skin("Mano-Blanco", skins_dict)
				desbloquear_skin("Ojo-Amarillo", skins_dict)
				
	if puntuacion >= 12000910:
		match Global.nivel_seleccionado:
			1:
				desbloquear_skin("Mano-Azul", skins_dict)
				desbloquear_skin("Ojo-Blanco", skins_dict)
			2:
				desbloquear_skin("Mano-Negro", skins_dict)
				desbloquear_skin("Ojo-Rosa", skins_dict)
			3:
				desbloquear_skin("Mano-Verde", skins_dict)
				desbloquear_skin("Ojo-Negro", skins_dict)
				
	if puntuacion >= 10000910:
		match Global.nivel_seleccionado:
			1:
				desbloquear_skin("Mano-Gris", skins_dict) 
				desbloquear_skin("Ojo-Verde", skins_dict) 
			2:
				desbloquear_skin("Mano-Naranja", skins_dict) 
				desbloquear_skin("Ojo-Azul", skins_dict) 
			3: 
				# Desbloquear skin Cian si todas las demás están desbloqueadas
				if todas_las_skins_desbloqueadas(skins_usuario, ["Mano-Cian", "Ojo-Cian"]):
					desbloquear_skin("Mano-Cian", skins_dict)
					desbloquear_skin("Ojo-Cian", skins_dict) 
	  
	# Actualizar el ItemList con las skins desbloqueadas
	actualizar_itemlist()

func desbloquear_skin(nombre_skin, skins_dict):
	if nombre_skin in skins_dict:
		var skin = skins_dict[nombre_skin]
		if skin["desbloqueada"] == "false":  # Si está bloqueada
			# Actualizar en la base de datos
			database.update_rows("Skins", "nombre = '" + str(nombre_skin) + "' AND usuario_id LIKE '" + str(Global.id_usuario) + "'", {"desbloqueada": "true"})
		
			# Añadir a la lista de desbloqueos conseguidos
			if "desbloqueos_conseguidos" in self:
				desbloqueos_conseguidos.append(nombre_skin)
			else:
				desbloqueos_conseguidos = [nombre_skin]

func todas_las_skins_desbloqueadas(skins_usuario, excluir=[]):
	for skin in skins_usuario:
		if skin["nombre"] in excluir:
			continue
		if skin["desbloqueada"] != "true":
			return false
	return true
 
			
func actualizar_itemlist():
	desbloqueos_list.clear()
	if "desbloqueos_conseguidos" in self and desbloqueos_conseguidos.size() > 0:
		# Cargar los spritesheets una sola vez
		var sheet_manos = preload("res://sprites/skins/hand/left_hand_skins.png")
		var sheet_ojos = preload("res://sprites/skins/eye/eye_skins.png")
		
		
		var manos_sheet_width = sheet_manos.get_width()
		var manos_sheet_height = sheet_manos.get_height()
		var manos_cols = 5  
		var manos_rows = 2 
		var mano_width = manos_sheet_width / manos_cols
		var mano_height = manos_sheet_height / manos_rows
		
		# Configuración del spritesheet de ojos (ajusta según tu estructura real)
		var ojos_sheet_width = sheet_ojos.get_width()
		var ojos_sheet_height = sheet_ojos.get_height()
		var ojos_cols = 5   
		var ojos_rows = 2   
		var ojo_width = ojos_sheet_width / ojos_cols
		var ojo_height = ojos_sheet_height / ojos_rows
		
		# Mapeo de skins a posiciones en el spritesheet
		var skin_positions = {
			# Manos 
			"Mano-Rojo": {"sheet": sheet_manos, "row": 0, "col": 0},
			"Mano-Amarillo": {"sheet": sheet_manos, "row": 0, "col": 1},
			"Mano-Azul": {"sheet": sheet_manos, "row": 0, "col": 2},
			"Mano-Gris": {"sheet": sheet_manos, "row": 0, "col": 3},
			"Mano-Negro": {"sheet": sheet_manos, "row": 0, "col": 4},
			"Mano-Rosa": {"sheet": sheet_manos, "row": 1, "col": 0},
			"Mano-Naranja": {"sheet": sheet_manos, "row": 1, "col": 1},
			"Mano-Verde": {"sheet": sheet_manos, "row": 1, "col": 2},
			"Mano-Blanco": {"sheet": sheet_manos, "row": 1, "col": 3},
			"Mano-Cian": {"sheet": sheet_manos, "row": 1, "col": 4},
			
			# Ojos 
			"Ojo-Rojo": {"sheet": sheet_ojos, "row": 0, "col": 0},
			"Ojo-Amarillo": {"sheet": sheet_ojos, "row": 0, "col": 1},
			"Ojo-Azul": {"sheet": sheet_ojos, "row": 0, "col": 2},
			"Ojo-Gris": {"sheet": sheet_ojos, "row": 0, "col": 3},
			"Ojo-Negro": {"sheet": sheet_ojos, "row": 0, "col": 4},
			"Ojo-Rosa": {"sheet": sheet_ojos, "row": 1, "col": 0},
			"Ojo-Naranja": {"sheet": sheet_ojos, "row": 1, "col": 1},
			"Ojo-Verde": {"sheet": sheet_ojos, "row": 1, "col": 2},
			"Ojo-Blanco": {"sheet": sheet_ojos, "row": 1, "col": 3},
			"Ojo-Cian": {"sheet": sheet_ojos, "row": 1, "col": 4}
		}
		
		for skin in desbloqueos_conseguidos:
			var icono: Texture2D
			var skin_data = skin_positions.get(skin)
			
			if skin_data:
				var atlas = AtlasTexture.new()
				atlas.atlas = skin_data["sheet"]
				
				if skin.begins_with("Mano"):
					atlas.region = Rect2(
						skin_data["col"] * mano_width,
						skin_data["row"] * mano_height,
						mano_width,
						mano_height
					)
				else:  # Ojos
					atlas.region = Rect2(
						skin_data["col"] * ojo_width,
						skin_data["row"] * ojo_height,
						ojo_width,
						ojo_height
					)
				icono = atlas
			else:  
				pass
			# Añadir el ítem con ícono y texto 
			desbloqueos_list.add_item(skin, icono)
			
			# Configuración adicional para cada ítem
			var index = desbloqueos_list.item_count - 1
			desbloqueos_list.set_item_tooltip(index, skin)
			desbloqueos_list.set_item_selectable(index, false)
			
			# Opcional: Ajustar tamaño de los íconos
			desbloqueos_list.fixed_icon_size = Vector2(64, 64)
			
			
func devolver_indice_skin(skin) -> int:
	var indice
	match skin:
		"Rojo":
			indice = 0
		"Amarillo":
			indice = 1
		"Azul":
			indice = 2
		"Gris":
			indice = 3
		"Negro":
			indice = 4
		"Rosa":
			indice = 5
		"Naranja":
			indice = 6
		"Verde":
			indice = 7 
		"Blanco":
			indice = 8
		"Cian":
			indice = 9 
	return indice
