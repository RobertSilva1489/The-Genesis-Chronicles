extends Node

@export var quiver = 10
@export var health = 400
@export var mana = 100
@export var wave = 0
@export var scene_enemy = 0
@export var recovery_health = 5
@export var recovery_mana = 5
@export var recovery_quive = 1
@export var show_boss = false
@export var boss_health = 0
@export var god_mode = false
@export var Dfire = false
@export var Dwater = false
@export var Dwind = false
@export var Dground = false
@export var stage = ""
var can_pause = true
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
func hit_stop_mediun():
	Engine.time_scale = 0
	await get_tree().create_timer(0.5,true,false,true).timeout
	Engine.time_scale = 1
func hit_stop_long():
	Engine.time_scale = 0
	await get_tree().create_timer(1.0,true,false,true).timeout
	Engine.time_scale = 1
