extends Node

@export var quiver = 10
@export var health = 100
@export var mana = 100
@export var wave = 0
@export var scene_enemy = 0
@export var recovery_health = 10
@export var recovery_mana = 10
@export var recovery_quive = 1
@export var show_boss = false
@export var boss_health = 0
var boss_name = ""
var showwave = false
func _process(delta: float) -> void:
	pass
func freeze_frame(time, duration):
	Engine.time_scale = time
	await get_tree().create_timer(duration * time).timeout
	Engine.time_scale = 1.0
func hit_stop_short():
	Engine.time_scale = 0
	await get_tree().create_timer(0.09,true,false,true).timeout
	Engine.time_scale = 1
func hit_stop_long():
	Engine.time_scale = 0
	await get_tree().create_timer(1.0,true,false,true).timeout
	Engine.time_scale = 1
