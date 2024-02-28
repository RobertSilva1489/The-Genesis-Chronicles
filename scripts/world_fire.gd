extends Node2D

var golem = preload("res://scene/fire_golem.tscn")
var necromancer = preload("res://scene/necromancer.tscn")
var leaf = preload("res://scene/leaf.tscn")
@export var wave_lenght = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.showwave = true
	spawn_enemy()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.wave == 0:
		$AnimationPlayer.play("open")
		Global.showwave = false
		Global.wave = -1
func spawn_enemy():
	var g = golem.instantiate()
	add_child(g)
	g.global_position = $spawn.global_position
	var n = necromancer.instantiate()
	add_child(n)
	n.global_position = $spawn2.global_position


func _on_timer_timeout() -> void:
		if Global.wave < 2 and wave_lenght > 0:
			spawn_enemy()
