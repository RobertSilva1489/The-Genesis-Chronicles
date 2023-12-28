extends Area2D
var hit = int(randf_range(5,20))
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(hit)
