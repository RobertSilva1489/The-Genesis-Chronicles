extends Node2D
var ground_mage = false
func _ready() -> void:
	$Sprite2D.visible = false
func _process(delta: float) -> void:
	if Global.Dground == true and ground_mage == false:
		ground_mage = true
		$ground_mage.visible = false
		$AnimationPlayer.play("broken")
