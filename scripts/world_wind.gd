extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.showwave = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.wave == 0:
		$AnimationPlayer.play("new_animation")
		Global.showwave = false
		Global.wave = -1
