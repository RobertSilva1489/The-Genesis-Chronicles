extends Node2D

func _process(delta: float) -> void:
	Global.mana = 0
	Global.quiver = 0
#	$ParallaxBackground/ParallaxLayer2/Sprite2D.material = null


func _on_water_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass


func _on_wind_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass


func _on_fire_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass


func _on_ground_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass
