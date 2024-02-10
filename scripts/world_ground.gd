extends Node2D


func _ready() -> void:
	Global.showwave = true
	Global.wave = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.wave == 0:
		$AnimationPlayer.play("open")
		Global.showwave = false
		Global.wave = -1
