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
@export var boss_health = 600
@export var god_mode = false
@export var Dfire = false
@export var Dwater = false
@export var Dwind = false
@export var Dground = false
var victory = false
var powerwater = true
var powerfire = true
var powerwind = true
var powerground = true
var special1 = false
var special2 = false
var unlock = 0
@export var stage = ""
var can_pause = false
var boss_name = ""
var showwave = false
func _process(delta: float) -> void:
	UPGRADE()
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
func UPGRADE():
	if Dfire and not Dwater and powerfire and unlock < 4:
		special1 = true
		recovery_mana = 5
		mana = 100
		powerfire = false
	else:
		recovery_mana = 5
	if Dwind and not Dwater and powerwind and unlock < 4: 
		special2 = true
		recovery_mana = 5
		mana = 100
		powerwind = false
	else:
		recovery_mana = 5
	if Dwater and powerwater and unlock < 4:
		recovery_mana = 10
		powerwater = false
	if Dground and powerground and unlock < 4:
		recovery_health = 10
		powerground = false
