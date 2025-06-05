extends Area2D

@onready var checkpoint_manager: Node = $"../CheckpointManager"
@onready var reacher: Node2D = $"../Reacher"
@onready var respawn_animation: AnimationPlayer = $RespawnAnimation

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Reacher"):
		Global.muertes += 1 
		checkpoint_manager.respawn_reacher()  

func _play_death_sequence():
	if not Global.mostrar_scores:
		# Aquí puedes añadir efectos de muerte
		# Ejemplo: animación, sonido, partículas
		get_tree().paused = true
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = false
  
