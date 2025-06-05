extends ItemList

var database: SQLite
var resultados: Array = []
var skins_mano_usadas: Array = []
var skins_ojo_usadas: Array = []
var num_muertes: Array = []
var total_muertes: int = 0
var skin_mano_mas_usada: String = ""
var skin_ojo_mas_usada: String = ""
var nivel_mas_jugado: String = ""
var partidas_jugadas: int = 0
var progreso_total: int = 0
var total_monedas: int = 0
var tiempo_total_juego: int = 0

const MAX_SKINS = 18  # Total de skins posibles (excluyendo las 2 por defecto)
const MAX_MEDALS = 12  # Total de medallas posibles
const SKINS_WEIGHT = 0.6  # 60% del progreso total
const MEDALS_WEIGHT = 0.4  # 40% del progreso total

# Equivalencias de skins
var skin_index = {
	"0": "Roja",
	"1": "Amarilla",
	"2": "Azul",
	"3": "Gris",
	"4": "Negra",
	"5": "Rosa",
	"6": "Naranja",
	"7": "Verde",
	"8": "Blanca",
	"9": "Cian"
}

func _ready() -> void:  
	database = SQLite.new()
	database.path = "user://data.db"
	database.open_db()
	  
	_cargar_estadisticas()
	escribir_datos_tabla()

func _cargar_estadisticas() -> void:
	# Limpiar datos previos
	resultados.clear()
	skins_mano_usadas.clear()
	skins_ojo_usadas.clear()
	num_muertes.clear()
	total_muertes = 0
	total_monedas = 0
	tiempo_total_juego = 0
	skin_mano_mas_usada = "0"
	skin_ojo_mas_usada = "0"
	nivel_mas_jugado = "1"
	partidas_jugadas = 0
	progreso_total = 0

	# Obtener todos los scores del usuario
	resultados = database.select_rows(
		"Scores", 
		"usuario_id LIKE '" + str(Global.id_usuario) + "'", 
		["puntuacion", "nivel_id", "tiempo_completitud"]
	)
	 
	partidas_jugadas = resultados.size()
	
	# Procesar cada resultado
	for resultado in resultados:
		var puntuacion_str = str(resultado["puntuacion"]).pad_zeros(8)  # Asegurar 8 dígitos
		
		# Extraer componentes según nuevo formato (8-1-1-1-2)
		var segundos_restantes = int(puntuacion_str.substr(0, 3))  # Primeros 3 dígitos
		tiempo_total_juego += (Global.tiempo_maximo - segundos_restantes)
		
		skins_mano_usadas.append(puntuacion_str.substr(3, 1))  # 4º dígito (índice skin mano)
		skins_ojo_usadas.append(puntuacion_str.substr(4, 1))   # 5º dígito (índice skin ojo)
		  
		var muertes =  1 # 6º dígito (9 - X muertes)
		num_muertes.append(muertes)
		
		var monedas = int(puntuacion_str.substr(6, 2))         # Últimos 2 dígitos
		total_monedas += monedas
		 
	# Calcular skins más usadas
	skin_mano_mas_usada = _calcular_mas_usado(skins_mano_usadas)
	skin_ojo_mas_usada = _calcular_mas_usado(skins_ojo_usadas)
	
	# Calcular nivel más jugado
	nivel_mas_jugado = _calcular_nivel_mas_jugado()
	
	# Calcular total de muertes
	for muerte in num_muertes:
		total_muertes += muerte
 
	 # Calcular progreso total basado en skins y medallas
	progreso_total = _calcular_progreso_total() 


func _calcular_progreso_total() -> int:
	# Obtener skins desbloqueadas
	var skins_desbloqueadas = database.select_rows(
		"Skins", 
		"usuario_id = '%s' AND desbloqueada = 'true'" % Global.id_usuario, 
		["id"]
	).size()
	
	# Restar las 2 skins por defecto si es necesario
	skins_desbloqueadas = max(0, skins_desbloqueadas - 2)
	
	# Obtener medallas conseguidas
	var medallas_conseguidas = database.select_rows(
		"Medallas", 
		"usuario_id = '%s'" % Global.id_usuario, 
		["id"]
	).size()
	
	# Calcular porcentajes individuales
	var porcentaje_skins = (float(skins_desbloqueadas) / MAX_SKINS) * 100 * SKINS_WEIGHT
	var porcentaje_medallas = (float(medallas_conseguidas) / MAX_MEDALS) * 100 * MEDALS_WEIGHT
	
	# Progreso total combinado
	var progreso = porcentaje_skins + porcentaje_medallas
	return min(int(progreso), 100)  # Asegurar que no supere 100%
	
func _calcular_mas_usado(lista: Array) -> String:
	var contador = {}
	var max_item = "0"
	var max_count = 0
	
	for item in lista:
		contador[item] = contador.get(item, 0) + 1
		if contador[item] > max_count:
			max_count = contador[item]
			max_item = item
	
	return max_item

func _calcular_nivel_mas_jugado() -> String:
	var contador = {}
	var max_nivel = "1"
	var max_count = 0
	
	for resultado in resultados:
		var nivel = str(resultado["nivel_id"])
		contador[nivel] = contador.get(nivel, 0) + 1
		if contador[nivel] > max_count:
			max_count = contador[nivel]
			max_nivel = nivel
	match max_nivel:
		"1":
			max_nivel = "Fácil"
		"2":
			max_nivel = "Normal"
		"3":
			max_nivel = "Difícil"
		
	return max_nivel

func escribir_datos_tabla():
	clear()
  
	# Datos en formato [título, valor]
	var datos = [
		["Skin de mano más usada:", skin_index.get(skin_mano_mas_usada, "N/A")],
		["Skin de ojo más usada:", skin_index.get(skin_ojo_mas_usada, "N/A")],
		["Nivel más jugado:", nivel_mas_jugado],
		["Partidas totales:", str(partidas_jugadas)],  
		["Monedas totales:", str(total_monedas)],
		["Progreso total:", str(progreso_total) + "%"]
	]

	for par in datos:
		var titulo = par[0]
		var valor = par[1]

		# Aseguramos un ancho fijo para la primera columna
		while titulo.length() < 25:
			titulo += " "

		add_item(titulo + valor)

func _process(delta: float) -> void:
	pass
