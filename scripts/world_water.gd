extends Node2D

var mermaid = preload("res://scene/mermaid.tscn")
var boss = preload("res://scene/water.tscn")
var water_check = true
@onready var leaf: CharacterBody2D = $Leaf
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
	Global.stage = "water"
	Global.can_pause = true
	Global.showwave = true
	Global.wave = wave_lenght
	Global.quiver = 10
	Global.victory = false
	$"/root/Hud".show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var water: CharacterBody2D = $water
	if Global.wave == 0:
		Global.wave = -1
		$AnimationPlayer.play("open")
		Global.showwave = false
	if water != null:
		
		if water.health <=0 and water_check == true:
			water_check = false
			$level.stream_paused = true
			$bossDead.play()
			leaf.powerUP("water")
			await get_tree().create_timer(5).timeout
			leaf._out()
	if Global.health <= 0 and Global.victory == false and water:
		Global.victory = true
		$Camera2D.make_current()
		water._victory()
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file("res://scene/world.tscn")
	elif Global.health <= 0:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/world.tscn")
func spawn_enemy():
	wave_lenght-=1
	Global.scene_enemy+=1
	randomize()
	RanPos.append(spawn1)
	RanPos.append(spawn2)
	RanPos.append(spawn3)
	RanPos.append(spawn4)
	enemy.append(mermaid)
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
	$waterbubles.emitting = true
	await get_tree().create_timer(1).timeout
	add_child(Boss)
	Boss.global_position = boss_spawn.global_position
	


func _on_boss_timeout() -> void:
	spawn_boss()
	
func _on_area_boss_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("close")
	$boss.start()
	$AreaBoss.queue_free()
