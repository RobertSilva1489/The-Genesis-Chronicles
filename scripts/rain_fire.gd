extends Area2D
var hit = int(randf_range(5,20))
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(hit)
func _make_rain():
	$fire2.play("default")
	$fire3.play("default")
	$fire4.play("default")
	$fire5.play("default")
	$fire6.play("default")
	$fire7.play("default")
