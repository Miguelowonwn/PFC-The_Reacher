extends Control
@onready var line_edit_name: LineEdit = $LineEditName
@onready var line_edit_pass: LineEdit = $LineEditPass
@onready var label_warning: Label = $LabelWarning
@onready var si_crear_usuario: Button = $SiCrearUsuario
@onready var no_crear_usuario: Button = $NoCrearUsuario
@onready var ok_button: Button = $OKButton
@onready var ok_button_crear_pass: Button = $OKButtonCrearPass
@onready var cancelar_registro: Button = $CancelarRegistro
@onready var item_list: ItemList = $ItemList
@onready var label: Label = $ItemList/Label
 
var database : SQLite
var nombre_only_value
var password_only_value


func _ready() -> void:
	line_edit_name.grab_focus()
	database = SQLite.new()
	database.path="res://data.db"
	database.open_db()	
	_draw_progress_chart()
	line_edit_pass.secret = true 
 
func _process(delta: float) -> void:
	pass

		
func _on_ok_button_pressed() -> void:
	if line_edit_name.text.is_empty():
		label_warning.text = "El nombre está vacío"
	elif line_edit_pass.text.is_empty():
		label_warning.text = "La contraseña está vacía"
	else:  
		var password_introducida = line_edit_pass.text
		var nombre = database.select_rows("Usuarios", "nombre = '" + line_edit_name.text + "'", ["nombre"])
		var password_bd = database.select_rows("Usuarios", "nombre = '" + line_edit_name.text + "'", ["password"])
		 
		nombre_only_value = _get_individual_value_from_query(nombre)
		password_only_value = _get_individual_value_from_query(password_bd)
		
		if nombre.is_empty():
			label_warning.text = "El usuario '" + line_edit_name.text + "' no existe\n¿Deseas crearlo?" 
			line_edit_name.visible = false
			line_edit_pass.visible = false
			ok_button.visible = false
			si_crear_usuario.visible = true
			no_crear_usuario.visible = true
		else: 
			if password_only_value != password_introducida.sha256_text():
				line_edit_pass.text = ""
				label_warning.text = "La contraseña no coincide"
			else:
				#TODO: Esto no espera los 3 segundos...
				label_warning.text = "Login correcto" 
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
				 

func _on_si_crear_usuario_pressed() -> void: 
	ok_button_crear_pass.visible = true
	ok_button_crear_pass.position.x = 469
	si_crear_usuario.visible = false
	no_crear_usuario.visible = false
	label_warning.text = "Introduce la contraseña para el nuevo usuario '" + line_edit_name.text + "'"  
	line_edit_pass.text = ""
	line_edit_pass.visible = true
	cancelar_registro.visible = true
	
func _on_no_crear_usuario_pressed() -> void:
	label_warning.text = "Login" 
	line_edit_name.text = ""
	line_edit_pass.text = ""
	line_edit_name.visible = true
	line_edit_pass.visible = true
	ok_button.visible = true
	si_crear_usuario.visible = false
	no_crear_usuario.visible = false


func _on_ok_button_crear_pass_pressed() -> void:  
	var pass_valida = _check_password(line_edit_pass.text)
	var usuario_registrado = false
	if usuario_registrado: 
		label_warning.text = "Login" 
		line_edit_name.visible = false
		line_edit_pass.visible = false
		pass
	elif pass_valida:
		var datos_usuario_nuevo = {
			"nombre": line_edit_name.text,
			"password": line_edit_pass.text.sha256_text()
		}
		var result = database.insert_row("Usuarios", datos_usuario_nuevo)  
		label_warning.text = "Usuario registrado"   
		usuario_registrado = true
		line_edit_name.visible = false 
		
		
		label_warning.text = "Login" 
		line_edit_name.text = ""
		line_edit_pass.text = ""
		line_edit_name.visible = true
		line_edit_pass.visible = true
		ok_button.visible = true
		si_crear_usuario.visible = false
		no_crear_usuario.visible = false
		ok_button_crear_pass.position.x = 541.5
		ok_button_crear_pass.visible = false
		cancelar_registro.visible = false 
	else:
		label_warning.text = "La contraseña debe tener 8 carácteres como mínimo, una letra y un número"  

 
func _on_cancelar_registro_pressed() -> void:
	label_warning.text = "Login" 
	line_edit_name.text = ""
	line_edit_pass.text = ""
	line_edit_name.visible = true
	line_edit_pass.visible = true
	ok_button.visible = true
	si_crear_usuario.visible = false
	no_crear_usuario.visible = false
	ok_button_crear_pass.position.x = 541.5
	ok_button_crear_pass.visible = false
	cancelar_registro.visible = false
	
	
	
#*************************************************** Funciones extra


func _get_all_users_and_each_progress() -> Dictionary:
	var usuarios_con_progreso := {}  
	
	var todos_ids_registrados = database.select_rows("Usuarios", "", ["id"])
	
	for usuario in todos_ids_registrados:
		var id_usuario = usuario["id"] 
		var progreso = 0
		
		var desbloqueos = database.select_rows("Medallas", "usuario_id = '" + str(id_usuario) + "'", ["tipo_desbloqueo"])
		
		
		for tipo_desbloqueo in desbloqueos:  
			tipo_desbloqueo = tipo_desbloqueo["tipo_desbloqueo"] 
			match tipo_desbloqueo:
				2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20:
					progreso += 2
				24, 25, 26, 27, 28, 29, 30, 31, 32, 33:
					progreso += 5
				34:
					progreso += 6
				35:
					progreso += 8
		
		usuarios_con_progreso[id_usuario] = progreso  
		
	return usuarios_con_progreso
	
func _check_password(password: String) -> bool:
	if password.length() < 8:
		return false

	var has_letter := RegEx.new()
	var has_number := RegEx.new()
	has_letter.compile("[A-Za-z]")
	has_number.compile("[0-9]")

	if not has_letter.search(password):
		return false
	if not has_number.search(password):
		return false

	return true
	
func _draw_progress_chart():
	var users_progress = _get_all_users_and_each_progress()
	item_list.clear()
	
	var progress_list := []
	for user_id in users_progress.keys():
		progress_list.append([user_id, users_progress[user_id]])
	
	progress_list.sort_custom(func(a, b): return a[1] > b[1]) 

	for pair in progress_list:
		var user_id = pair[0]
		var progreso = pair[1]
		var nombre_query = database.select_rows("Usuarios", "id = '" + str(user_id) + "'", ["nombre"])
		var nombre_usuario = _get_individual_value_from_query(nombre_query)

		var linea = "%s - Progreso: %d" % [nombre_usuario, progreso] 
		item_list.add_item(linea) 
		 
func _get_individual_value_from_query(query: Array) -> Variant:
	if query.size() == 0:
		return null   

	var first_row = query[0]
	for key in first_row.keys():
		return first_row[key]   

	return null   

func _on_salir_pressed() -> void:
	get_tree().quit()
