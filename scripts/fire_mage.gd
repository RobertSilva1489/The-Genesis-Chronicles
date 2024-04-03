extends Node2D
var fire_mage = false
func _ready() -> void:
	$Sprite2D.visible = false
func _process(delta: float) -> void:
	if Global.Dfire == true and fire_mage == false:
		fire_mage = true
		$fire_mage.visible = false
		$AnimationPlayer.play("broken")
