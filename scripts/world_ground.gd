extends Node2D


func _ready() -> void:
	Global.showwave = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.wave == 0:
		$AnimationPlayer.play("open")
		Global.showwave = false
		Global.wave = -1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Camera2D2.make_current()
		print("trocou")
