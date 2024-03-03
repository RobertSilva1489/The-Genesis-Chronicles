extends Node2D

var golem = preload("res://scene/fire_golem.tscn")
var necromancer = preload("res://scene/necromancer.tscn")
var boss = preload("res://scene/fire.tscn")
@export var wave_lenght = 30
@onready var spawn1 = $spawn
@onready var spawn2 = $spawn2
@onready var spawn3 = $spawn3
@onready var spawn4 = $spawn4
@onready var boss_spawn = $spawn5
var RanPos = []
var enemy = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.showwave = true
	Global.wave = wave_lenght
	spawn_enemy()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.wave == 0:
		$AnimationPlayer.play("open")
		Global.wave = -1
		Global.showwave = false
func spawn_enemy():
	wave_lenght-=1
	Global.scene_enemy+=1
	randomize()
	RanPos.append(spawn1)
	RanPos.append(spawn2)
	RanPos.append(spawn3)
	RanPos.append(spawn4)
	enemy.append(golem)
	enemy.append(necromancer)
	var selecte = enemy.pick_random()
	var select = RanPos.pick_random()
	var Enemy = selecte.instantiate()
	add_child(Enemy)
	Enemy.global_position = select.global_position
func _on_timer_timeout() -> void:
		if Global.scene_enemy < 6 and wave_lenght > 0:
			spawn_enemy()
			
func spawn_boss():
	var Boss = boss.instantiate()
	add_child(Boss)
	Boss.global_position = boss_spawn.global_position


func _on_boss_timeout() -> void:
	spawn_boss()
	
func _on_area_boss_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("close")
	$rainFire.emitting = true
	$Boss.start()
	$AreaBoss.queue_free()
