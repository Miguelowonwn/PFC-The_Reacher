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
		if is_item_unlocked(i):  # Si está desbloqueado
			# Mantener el icono original del item (ya asignado)
			set_item_custom_bg_color(i, Color(0.5, 0.5, 0.5, 0.3))
			set_item_icon_modulate(i, Color(1, 1, 1, 1))
		else:
			# Cambiar el icono a la versión bloqueada
			set_item_text(i, "?")
			set_item_icon(i, MEDALLA_LOCKED)
			set_item_icon_modulate(i, Color(0.5, 0.5, 0.5, 0.6))
			set_item_disabled(i, false)

func initialize_items():
	for i in get_item_count():
		set_item_disabled(i, false)
		set_item_metadata(i, {"unlocked": false})
		# No asignamos MEDALLA_LOCKED aquí para mantener los iconos originales

func is_item_unlocked(index: int) -> bool:
	return get_item_metadata(index).get("unlocked", false)

func mark_item_as_unlocked(index: int):
	set_item_metadata(index, {"unlocked": true})

func cargar_medallas_conseguidas():
	resultados = database.select_rows("Medallas", "usuario_id LIKE '" + str(Global.id_usuario) + "'", ["tipo_desbloqueo"])
	
	for medalla in resultados:
		var tipo = medalla["tipo_desbloqueo"]   
		if tipo > 0 && tipo < 11:
			match tipo:
				1: print("Skin mano 1")
				2: print("Skin mano 2")
				3: print("Skin mano 3")
				4: print("Skin mano 4")
				5: print("Skin mano 5")
				6: print("Skin mano 6")
				7: print("Skin mano 7")
				8: print("Skin mano 8")
				9: print("Skin mano 9")
				10: print("Skin mano 10")
		elif tipo > 10 && tipo < 21:
			match tipo:
				11: print("Skin ojo 11")
				12: print("Skin ojo 12")
				13: print("Skin ojo 13")
				14: print("Skin ojo 14")
				15: print("Skin ojo 15")
				16: print("Skin ojo 16")
				17: print("Skin ojo 17")
				18: print("Skin ojo 18")
				19: print("Skin ojo 19")
				20: print("Skin ojo 20")
		
		match tipo: 
			21, 24, 27: 
				tipo = str(tipo)
				if tipo.right(1) == "1":
					print("Nivel 1 N/D")
				elif tipo.right(1) == "4":
					mark_item_as_unlocked(1)
					print("Nivel 1 Runner")
				else:
					mark_item_as_unlocked(2)
					print("Nivel 1 Coins")
			22, 25, 28: 
				tipo = str(tipo)
				if tipo.right(1) == "2": 
					mark_item_as_unlocked(3)
				elif tipo.right(1) == "5":
					mark_item_as_unlocked(4)
				else:
					mark_item_as_unlocked(5)
			23, 26, 29:
				tipo = str(tipo)
				if tipo.right(1) == "3":
					mark_item_as_unlocked(6)
					print("Nivel 3 N/D")
				elif tipo.right(1) == "6":
					mark_item_as_unlocked(7)
					print("Nivel 3 Runner")
				else:
					mark_item_as_unlocked(8)
					print("Nivel 3 Coins")
