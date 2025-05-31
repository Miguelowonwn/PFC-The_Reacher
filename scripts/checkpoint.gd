extends Area2D

@onready var checkpoint_manager: Node = $".."
@onready var respawn_point_izquierda: Marker2D = $RespawnPointIzquierda
@onready var respawn_point_derecha: Marker2D = $RespawnPointDerecha
@onready var respawn_point_ojo: Marker2D = $RespawnPointOjo

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Reacher"):
		# Guardar posiciones
		checkpoint_manager.ultima_posicion_izquierda = respawn_point_izquierda.global_position
		checkpoint_manager.ultima_posicion_derecha = respawn_point_derecha.global_position
		checkpoint_manager.ultima_posicion_ojo = respawn_point_ojo.global_position
		
		# Guardar estados adicionales
		checkpoint_manager.ultima_velocidad_izquierda = checkpoint_manager.left_hand.velocity
		checkpoint_manager.ultima_velocidad_derecha = checkpoint_manager.right_hand.velocity
		checkpoint_manager.ultima_velocidad_ojo = checkpoint_manager.eye.linear_velocity
		checkpoint_manager.ultima_rotacion_ojo = checkpoint_manager.eye.rotation
		
		print("Checkpoint actualizado!")
