extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.boss_name =="Fire":
		$AnimationPlayer.play("broken")
	if Global.boss_name =="Ground":
		$AnimationPlayer.play("broken")
	if Global.boss_name =="Wind":
		$AnimationPlayer.play("broken")
	if Global.boss_name =="Water":
		$AnimationPlayer.play("broken")		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
