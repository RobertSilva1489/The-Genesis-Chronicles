extends CharacterBody2D
@export var speed = randf_range(100,150)
@export var health = 100
@export var strong = 20
@export var gravity = 980
@export var can_attack = true
@export var follow = false
@export var attack_cooldown : float = 4
@export var attack_player = false
@export var DIST_FOLLOW := 2000
@export var DIST_ATTACK := 300
@onready var leaf: CharacterBody2D = $"../Leaf"
var hurricane: PackedScene = preload("res://scene/hurricane_fire.tscn")
var rain_fire: PackedScene = preload("res://scene/rain_fire.tscn")
var skull: PackedScene = preload("res://scene/skull.tscn")
var attacks = ["attack1","attack2","attack3","attack2","attack3"]
var direction = 0
var enter_state = true
var dead = false
var dano: int
var distance := 0.0
var _position

func _ready() -> void:
	Global.scene_enemy+=1
	$TextureProgressBar.value = health
	randomize()
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
func _process(delta: float) -> void:
	if Global.health <= 0:
		$AnimationPlayer.play("idle")
	if leaf != null:
		distance = global_position.distance_to(leaf.global_position)
		if distance <=DIST_FOLLOW :
			follow = true
		else:
			follow = false
			$AnimationPlayer.play("idle")
		if distance <=DIST_ATTACK and Global.health > 0:
			attack_player = true
		elif distance > DIST_ATTACK and can_attack:
			attack_player = false
	if leaf != null and dead == false:
		_position = leaf.global_position.x - global_position.x
		direction = sign(_position)
		if attack_player and can_attack:
			attack()
			await $AnimationPlayer.animation_finished
		elif follow and attack_player !=true:
			$AnimationPlayer.play("walk")
			_patrol()
	_flip()	
	$TextureProgressBar.value = health
func blink() -> void:
	$Marker2D/AnimatedSprite2D.modulate = Color(10,10,10,10)
	await get_tree().create_timer(.1).timeout
	$Marker2D/AnimatedSprite2D.modulate = Color(1,1,1,1)
func damage (dame) -> void:
	health -= dame
	blink()
	Global.hit_stop_short()
	if health <=0:
		dead = true
		$TextureProgressBar.hide()
		$AnimationPlayer.play("death")
		Global.wave-= 1
		Global.scene_enemy-=1
		Global.hit_stop_long()
		await $AnimationPlayer.animation_finished	
		
func _patrol():
	if Global.health > 0 and health > 0:
		velocity.x = direction * speed
		move_and_slide()
	if follow == false:
		velocity.x = 0 
func _flip() -> void:
	if direction < 0 and health > 0:
		transform.x.x = -1
		$Timer.start(0.5)
	if direction > 0 and health > 0:
		transform.x.x = 1
		$Timer.start(0.5)	
func attack():
	var select = attacks[randi()%attacks.size()]
	can_attack = false
	$AnimationPlayer.play(select)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
func _rain_fire():
	var rain_fires = rain_fire.instantiate()
	get_parent().add_child(rain_fires)
	rain_fires.global_position.y = $rainFire.global_position.y
	rain_fires.global_position.x = leaf.global_position.x - 70
func _hurricane():
	var hurricanes = hurricane.instantiate()
	get_parent().add_child(hurricanes)
	hurricanes.global_position = $hurricane.global_position
	hurricanes.direction = direction 
func attack_fly_head():
	var skulls = skull.instantiate()
	get_parent().add_child(skulls)
	skulls.global_position = $skull.global_position
	skulls.direction = direction

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if health > 0 and dead == false:
		$AnimationPlayer.play("idle")
	if dead == true:
		$AnimationPlayer.play("death")
