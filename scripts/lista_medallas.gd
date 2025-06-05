extends ItemList

var database: SQLite
var resultados
const MEDALLA_LOCKED = preload("res://resources/medalla-locked.png")

func _ready() -> void:
	database = SQLite.new()
	database.path = "user://data.db"
	database.open_db()
	initialize_items()
	cargar_medallas_conseguidas()    
	update_icons_appearance()

func update_icons_appearance():   
	for i in get_item_count():
		if is_item_unlocked(i):
			set_item_custom_bg_color(i, Color(0.5, 0.5, 0.5, 0.3))
			set_item_icon_modulate(i, Color(1, 1, 1, 1))
			set_item_disabled(i, false)
		else:
			set_item_text(i, "?")
			set_item_icon(i, MEDALLA_LOCKED)
			set_item_icon_modulate(i, Color(0.5, 0.5, 0.5, 0.6))
			set_item_disabled(i, false)

func initialize_items():
	# Asegurar que tenemos exactamente 12 items en el orden correcto
	if get_item_count() != 12:
		clear()
		# Nivel 1
		add_item("Perfección Nivel 1")  # ID 21 - Índice 0
		add_item("Velocista Nivel 1")   # ID 24 - Índice 1
		add_item("Coleccionista Nivel 1") # ID 27 - Índice 2
		# Nivel 2
		add_item("Perfección Nivel 2")  # ID 22 - Índice 3
		add_item("Velocista Nivel 2")   # ID 25 - Índice 4
		add_item("Coleccionista Nivel 2") # ID 28 - Índice 5
		# Nivel 3
		add_item("Perfección Nivel 3")  # ID 23 - Índice 6
		add_item("Velocista Nivel 3")   # ID 26 - Índice 7
		add_item("Coleccionista Nivel 3") # ID 29 - Índice 8
		# Especiales
		add_item("Objeto Shiny")       # ID 30 - Índice 9
		add_item("100 Monedas")        # ID 31 - Índice 10
		add_item("Platino")            # ID 32 - Índice 11
	
	for i in get_item_count():
		set_item_metadata(i, {"unlocked": false})

func is_item_unlocked(index: int) -> bool:
	return get_item_metadata(index).get("unlocked", false)

func mark_item_as_unlocked(index: int):
	set_item_metadata(index, {"unlocked": true})

func cargar_medallas_conseguidas():
	resultados = database.select_rows("Medallas", "usuario_id = '%s'" % Global.id_usuario, ["tipo_desbloqueo"])
	
	# Mapeo CORREGIDO de IDs a índices
	var medal_index_map = {
		# Perfección (N/D)
		21: 0,  # Nivel 1
		22: 3,  # Nivel 2
		23: 6,  # Nivel 3
		
		# Velocista (Runner)
		24: 1,  # Nivel 1
		25: 4,  # Nivel 2 (¡ESTE ES EL QUE FALLABA!)
		26: 7,  # Nivel 3
		
		# Coleccionista (Coins)
		27: 2,  # Nivel 1
		28: 5,  # Nivel 2
		29: 8,  # Nivel 3
		
		# Especiales
		30: 9,   # Shiny
		31: 10,  # 100 Monedas
		32: 11   # Platino
	}
	
	for medalla in resultados:
		var tipo = medalla["tipo_desbloqueo"]
		if medal_index_map.has(tipo):
			var index = medal_index_map[tipo]
			mark_item_as_unlocked(index)
			print("Medalla desbloqueada correctamente: %s (ID: %d -> Índice: %d)" % [
				get_item_text(index), tipo, index])
