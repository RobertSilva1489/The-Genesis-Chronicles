extends Node2D


var night_boner = preload("res://scene/night_boner.tscn")
var monster = preload("res://scene/monster.tscn")
var boss = preload("res://scene/ground.tscn")
var ground_check = true
@onready var leaf: CharacterBody2D = $Leaf
@export var wave_lenght = 30
@export var sceneEnemy = 6
@onready var spawn1 = $spawn
@onready var spawn2 = $spawn2
@onready var spawn3 = $spawn3
@onready var spawn4 = $spawn4
@onready var boss_spawn = $spawn5
var RanPos = []
var enemy = []

func _ready() -> void:
	Global.stage = "ground"
	Global.can_pause = true
	Global.showwave = true
	Global.wave = wave_lenght
	Global.victory = false
	Global.quiver = 10
	$"/root/Hud".show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ground: CharacterBody2D = $ground
	if Global.wave == 0:
		Global.wave = -1
		Global.health = 400
		Global.quiver = 10
		if Global.Dfire or Global.Dwind:
			Global.mana = 100
		$AnimationPlayer.play("open")
		Global.showwave = false
	if ground != null:
		if ground.health <=0 and ground_check == true:
			ground_check = false
			$level.stream_paused = true
			$bossDead.play()
			leaf.powerUP("ground")
			await get_tree().create_timer(5).timeout
			leaf._out()
	if Global.health <= 0 and Global.victory == false and ground:
		Global.victory = true
		ground._victory()
		await get_tree().create_timer(3.2).timeout
		get_tree().change_scene_to_file("res://scene/world.tscn")
	elif Global.health <= 0:
		await get_tree().create_timer(3.2).timeout
		get_tree().change_scene_to_file("res://scene/world.tscn")
func spawn_enemy():
	wave_lenght-=1
	Global.scene_enemy+=1
	randomize()
	RanPos.append(spawn1)
	RanPos.append(spawn2)
	RanPos.append(spawn1)
	RanPos.append(spawn2)
	RanPos.append(spawn3)
	RanPos.append(spawn4)
	enemy.append(night_boner)
	enemy.append(monster)
	enemy.append(monster)
	var selecte = enemy.pick_random()
	var select = RanPos.pick_random()
	var Enemy = selecte.instantiate()
	add_child(Enemy)
	Enemy.global_position = select.global_position

func spawn_boss():
	var Boss = boss.instantiate()
	add_child(Boss)
	Boss.global_position = boss_spawn.global_position
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Camera2D2.make_current()
		$boss.start()

func _on_timer_timeout() -> void:
	if Global.scene_enemy < sceneEnemy and wave_lenght > 0:
		spawn_enemy()

func _on_boss_timeout() -> void:
	spawn_boss()

