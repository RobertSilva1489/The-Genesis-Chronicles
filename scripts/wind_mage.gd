extends Node2D
var wind_mage = false
func _ready() -> void:
	$Sprite2D.visible = false
func _process(delta: float) -> void:
	if Global.Dwind == true and wind_mage == false:
		wind_mage = true
		$wind_mage.visible = false
		$AnimationPlayer.play("broken")
