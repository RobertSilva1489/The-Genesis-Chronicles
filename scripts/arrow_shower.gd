extends Area2D

var enemy
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".monitoring = true
	$CollisionShape2D.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy != null:
		enemy.damage(100)


func _on_animated_sprite_2d_animation_finished() -> void:
	await get_tree().create_timer(1).timeout
	$".".monitoring = false
	$CollisionShape2D.disabled = true
	queue_free()




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy = body


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy = null
