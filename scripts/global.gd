extends Node

var id_usuario
var id_ajustes_de_usuario
 
var medallas_por_nivel = {
	1: {"monedas": false, "sin_muertes": false, "tiempo_rapido": false},
	2: {"monedas": false, "sin_muertes": false, "tiempo_rapido": false},
	3: {"monedas": false, "sin_muertes": false, "tiempo_rapido": false}
}

var total_monedas_por_nivel = {
	1: 20,  
	2: 40,
	3: 50
}

var tiempo_maximo_por_nivel = {
	1: 500,  # 5 minutos (ajusta según tu juego)
	2: 400,  # 7 minutos
	3: 200   # 10 minutos
}

#Partida 
var muertes: int = 0
var coin_count: int
var tiempo_maximo: int
var tiempo_actual: int 
var nivel_seleccionado: int
var meta_conseguida: bool = false
var mostrar_scores: bool = false
var left_esta_en_musgo: bool = false
var right_esta_en_musgo: bool = false 

#Skins
var mano_skin
var ojo_skin
var ojo_skin_changed: bool = false

#Ajustes
var volumen_musica
var volumen_efectos
var resolucion
var pantalla_completa
