extends Area2D
var hit = int(randf_range(30,50))
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(hit)
#		await get_tree().create_timer(1.5).timeout
#		queue_free()
func _make_rain():
	$fire2.play("default")
	$fire3.play("default")
	$fire4.play("default")
	$fire5.play("default")
	$fire6.play("default")
	$fire7.play("default")
func _invisible():
	$fire2.hide()
	$fire3.hide()
	$fire4.hide()
	$fire5.hide()
	$fire6.hide()
	$fire7.hide()
func _visible():
	$fire2.show()
	$fire3.show()
	$fire4.show()
	$fire5.show()
	$fire6.show()
	$fire7.show()
