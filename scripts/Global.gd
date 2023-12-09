extends Node

@export var quiver = 10
@export var health = 100
@export var mana = 100
var attackPla = false

func freeze_frame(time, duration):
	Engine.time_scale = time
	await get_tree().create_timer(duration * time).timeout
	Engine.time_scale = 1.0
