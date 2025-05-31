extends Node

var id_usuario
var id_ajustes_de_usuario

#Partida 
var muertes: int = 0
var coin_count: int
var tiempo_maximo: int
var left_esta_en_musgo: bool = false
var right_esta_en_musgo: bool = false 
var meta_conseguida: bool = false
#Skins
var mano_skin
var ojo_skin
var ojo_skin_changed: bool = false

#Ajustes
var volumen_musica
var volumen_efectos
var resolucion
var pantalla_completa
