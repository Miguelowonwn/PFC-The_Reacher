extends Control

enum mano_skins{
	Roja,
	Amarilla,
	Azul,
	Gris,
	Negra,
	Rosa,
	Naranja,
	Verde, 
	Blanca,
	Cian
}

enum ojo_skins{
	Rojo,
	Amarillo,
	Azul,
	Gris,
	Negro,
	Rosa,
	Naranja,
	Verde, 
	Blanco,
	Cian
}

var skin_mano: mano_skins
var skin_ojo: ojo_skins
var mapa_elegido: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:   
	await get_tree().process_frame
	$MenuPrincipal/Container_Menu/Escalar.grab_focus() 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	pass
	
func _on_escalar_pressed():
	$AnimationPlayer.play("fade_escalar")
	await get_tree().create_timer(1.5).timeout
	$"SeleccionNivel/HBoxContainer/Nivel 1".grab_focus() 

func _on_scores_pressed() -> void:
	$AnimationPlayer.play("scores_animation")
	


func _on_ajustes_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	
	
# Niveles pressed 

func _on_nivel_1_pressed() -> void:
	$"SeleccionNivel/Container Skins Mano/Mano Skin 1".grab_focus()   
	

func _on_nivel_2_pressed() -> void:
	$"SeleccionNivel/Container Skins Mano/Mano Skin 1".grab_focus()   

func _on_nivel_3_pressed() -> void:
	$"SeleccionNivel/Container Skins Mano/Mano Skin 1".grab_focus()   
 

# Manos Pressed ---------------------------------

func _on_mano_skin_1_pressed() -> void:
	skin_mano = mano_skins.Roja
	$"SeleccionNivel/Container Skins Mano/Mano Skin 1".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_2_pressed() -> void:
	skin_mano = mano_skins.Amarilla
	$"SeleccionNivel/Container Skins Mano/Mano Skin 2".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_3_pressed() -> void:
	skin_mano = mano_skins.Azul
	$"SeleccionNivel/Container Skins Mano/Mano Skin 3".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_4_pressed() -> void:
	skin_mano = mano_skins.Gris
	$"SeleccionNivel/Container Skins Mano/Mano Skin 4".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus() 

func _on_mano_skin_5_pressed() -> void:
	skin_mano = mano_skins.Negra
	$"SeleccionNivel/Container Skins Mano/Mano Skin 5".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_6_pressed() -> void:
	skin_mano = mano_skins.Rosa
	$"SeleccionNivel/Container Skins Mano/Mano Skin 6".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_7_pressed() -> void:
	skin_mano = mano_skins.Naranja
	$"SeleccionNivel/Container Skins Mano/Mano Skin 7".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_8_pressed() -> void:
	skin_mano = mano_skins.Verde
	$"SeleccionNivel/Container Skins Mano/Mano Skin 8".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_9_pressed() -> void:
	skin_mano = mano_skins.Blanca
	$"SeleccionNivel/Container Skins Mano/Mano Skin 9".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()


func _on_mano_skin_10_pressed() -> void:
	skin_mano = mano_skins.Cian
	$"SeleccionNivel/Container Skins Mano/Mano Skin 10".get_theme_stylebox("normal").bg_color = Color.GRAY
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".grab_focus()




# Ojos Pressed ---------------------------------

func _on_ojo_skin_1_pressed() -> void:
	skin_ojo = ojo_skins.Rojo
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 1".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_ojo_skin_2_pressed() -> void:
	skin_ojo = ojo_skins.Amarillo
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 2".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_3_pressed() -> void:
	skin_ojo = ojo_skins.Azul
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 3".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_4_pressed() -> void:
	skin_ojo = ojo_skins.Gris
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 4".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_5_pressed() -> void:
	skin_ojo = ojo_skins.Negro
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 5".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_6_pressed() -> void:
	skin_ojo = ojo_skins.Rosa
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 6".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_7_pressed() -> void:
	skin_ojo = ojo_skins.Naranja
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 7".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_8_pressed() -> void:
	skin_ojo = ojo_skins.Verde
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 8".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_9_pressed() -> void:
	skin_ojo = ojo_skins.Blanco
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 9".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ojo_skin_10_pressed() -> void:
	skin_ojo = ojo_skins.Cian
	$"SeleccionNivel/Container Skins Ojo/Ojo Skin 10".get_theme_stylebox("normal").bg_color = Color.GRAY
	$AnimationPlayer.play("fade_jugar") 
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
  
