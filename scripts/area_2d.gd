extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D 
@onready var area_2d: Area2D = $"."

var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Reacher") and not collected: 
		collected = true
		sprite_2d.visible = false    
		area_2d.monitorable = false
		Global.coin_count += 1
		print(Global.coin_count) 
