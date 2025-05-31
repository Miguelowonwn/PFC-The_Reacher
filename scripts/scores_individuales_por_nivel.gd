extends ItemList  
 
@onready var selector_niveles: OptionButton = $"../../SelectorNiveles"
var database : SQLite

var id_usuario
var nivel_id
var puntuacion
var tiempo
var texto 

var filtros_aplicados = {
	"NIVEL" : func (element): return true
}

func _ready() -> void:   
	database = SQLite.new()
	database.path="user://data.db"
	database.open_db() 
	_mostrar_lista(_get_all_scores())
	 
	# Cambiar tamaño visual de los ítems (sin fuentes externas)
	add_theme_constant_override("item_height", 60)  # Altura del ítem
	add_theme_font_size_override("font_size", 30)   # Tamaño del texto
 
func _process(delta: float) -> void:
	pass
	
func _get_all_scores() -> Array:       
	var resultados = database.select_rows("Scores", "usuario_id LIKE '" + str(Global.id_usuario) + "'" , ["usuario_id, nivel_id, puntuacion, tiempo_completitud"])     
	print(str(Global.id_usuario))
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
		
		# Asegura longitud fija (12) con espacios, cortando si es muy largo
		var nombre_fixed = id_usuario.substr(0, 6)  # corta si excede
		while nombre_fixed.length() <6:
			nombre_fixed += " "  # añade espacios hasta llegar a 12

		var nivel_id = info["nivel_id"]
		var puntuacion = info["puntuacion"]
		var tiempo = info["tiempo_completitud"]

		var texto = "Nivel: " + str(nivel_id) + " Usuario: " + nombre_fixed + " Puntuación: " + str(puntuacion) + " Tiempo: " + str(tiempo)
 
		add_item(texto)
	   
	
func _on_selector_niveles_item_selected(index: int) -> void:
	var usuarios_id_nombre = _get_usuarios_id_nombre_like_nombre("")
	var array_filtrado = _get_all_scores()
	match selector_niveles.text:
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
	  
  
func _get_usuarios_id_nombre_like_nombre(nombre) -> Array:
	return database.select_rows("Usuarios", "nombre LIKE '" + nombre + "%'", ["id, nombre"])
	
func _get_name_from_id(usuarios_id_nombre, id) -> String: 
	return usuarios_id_nombre.filter(func (element): return id == element.id)[0].nombre
		
 
