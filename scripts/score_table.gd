extends ItemList  
 
@onready var filtro_nivel: OptionButton = $"../Filtros/FiltroNivel"
var database : SQLite

var id_usuario
var nivel_id
var puntuacion
var tiempo
var texto 

var filtros_aplicados = {
	"NIVEL" : func (element): return true,
	"MEJOR_TIEMPO" : func (element): return true,
	"USUARIOS" : func (element): return true
}

func _ready() -> void:   
	database = SQLite.new()
	database.path="user://data.db"
	database.open_db() 
	_mostrar_lista(_get_all_scores())
	  
	add_theme_constant_override("item_height", 60)   
	add_theme_font_size_override("font_size", 30)  
	 
func _process(delta: float) -> void: 
	pass
	
func _get_all_scores() -> Array:       
	var resultados = database.select_rows("Scores", "" , ["usuario_id, nivel_id, puntuacion, tiempo_completitud"])     
	return resultados
	
func _filter_scores(scores) -> Array:
	var array_filtrados = _get_all_scores()
	for filtro in filtros_aplicados.values():
		array_filtrados = array_filtrados.filter(filtro)
	return array_filtrados
	
func _mostrar_lista(scores: Array) -> void:
	clear()
	var filtrados = _filter_scores(scores)
	var usuarios_id_nombre = _get_usuarios_id_nombre_like_nombre("")

	for info in filtrados:
		var id_usuario = _get_name_from_id(usuarios_id_nombre, info.usuario_id)
		 
		var nombre_fixed = id_usuario.substr(0, 6)   
		while nombre_fixed.length() <6:
			nombre_fixed += " "   

		var nivel_id = info["nivel_id"]
		var puntuacion = info["puntuacion"]
		var tiempo = info["tiempo_completitud"]

		var texto = "Nivel: " + str(nivel_id) + " Usuario: " + nombre_fixed + " Puntuación: " + str(puntuacion) + " Tiempo: " + str(tiempo)
 
		add_item(texto)  

	
func _on_filtro_nivel_item_selected(index: int) -> void:   
	var usuarios_id_nombre = _get_usuarios_id_nombre_like_nombre("")
	var array_filtrado = _get_all_scores()
	match filtro_nivel.text:
		"Todos":
			filtros_aplicados["NIVEL"] = func(info): return true
		"Nivel 1": 
			filtros_aplicados["NIVEL"] = func(info): return info.nivel_id == 1
		"Nivel 2": 
			filtros_aplicados["NIVEL"] = func(info): return info.nivel_id == 2
		"Nivel 3": 
			filtros_aplicados["NIVEL"] = func(info): return info.nivel_id == 3
			
	for filtro in filtros_aplicados.values():
		array_filtrado = array_filtrado.filter(filtro) 
	
	_mostrar_lista(array_filtrado)
	
func _mejor_puntuacion(score_) -> bool:
	var mejores_por_nivel = {}
	var array_filtrado = _get_all_scores()
	for score in array_filtrado:
		var nivel = score["nivel_id"]
		if not mejores_por_nivel.has(nivel) or score["puntuacion"] > mejores_por_nivel[nivel]["puntuacion"]:
			mejores_por_nivel[nivel] = score  
	var es_mejor_puntuacion = false
	
	return score_ in mejores_por_nivel.values()
	
func _on_mejores_tiempos_toggled(toggled_on: bool) -> void:  
	var usuarios_id_nombre = _get_usuarios_id_nombre_like_nombre("") 
	var array_filtrado = _filter_scores(_get_all_scores())
	
	if toggled_on:
		filtros_aplicados["MEJOR_TIEMPO"] = _mejor_puntuacion
	else:
		filtros_aplicados["MEJOR_TIEMPO"] = func(element): return true
		
	_mostrar_lista(array_filtrado) 

func _on_filtrar_usuario_text_changed(nombre: String) -> void:   
	var usuarios_id_nombre = _get_usuarios_id_nombre_like_nombre(nombre)
	var usuarios_ids = usuarios_id_nombre.map(func (element): return element.id) 
	
	var array_filtrado = _get_all_scores()
	filtros_aplicados["USUARIOS"] = func(info): return usuarios_ids.has(info.usuario_id)
	for filtro in filtros_aplicados.values():
		array_filtrado = array_filtrado.filter(filtro)
	
	_mostrar_lista(array_filtrado)
		 
func _get_usuarios_id_nombre_like_nombre(nombre) -> Array:
	return database.select_rows("Usuarios", "nombre LIKE '" + nombre + "%'", ["id, nombre"])
	
func _get_name_from_id(usuarios_id_nombre, id) -> String: 
	return usuarios_id_nombre.filter(func (element): return id == element.id)[0].nombre
		
