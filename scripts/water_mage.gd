extends Node2D
var water_mage = false
func _ready() -> void:
	$Sprite2D.visible = false
func _process(delta: float) -> void:
	if Global.Dwater == true and water_mage == false:
		water_mage = true
		$water_mage.visible = false
		$Animation.play("broken")
