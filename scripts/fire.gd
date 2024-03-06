extends CharacterBody2D

var attack_hold = 1
var attacks = ["attack1","attack2","attack3","defender"]
var special = ["special1","special2","defender"]
var special2 = ["special1","special2","attack1","attack2","attack3"]
var direction = 0
var dead = false
var distance
var move :int
var selected_animation
var damage_apply = randi_range(15,30)
var _position
@export var DIST_FOLLOW := 1000
@export var DIST_ATTACK := 50
@export var invencible = false
@export var speed = 70
@export var health = 100
@export var gravity = 3000
@export var attack_cooldown : float = 1.2
@export var countHit = 0
@export var attack_player = false
@export var can_attack = true
@export var follow = false
@onready var tree: AnimationTree = $AnimationTree
@onready var leaf: CharacterBody2D = $"../Leaf"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	randomize()
	$AnimationPlayer.clear_caches()
	$AnimationPlayer.play("idle")
	Global.show_boss = true
	Global.boss_name = "Fire"
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

func _process(delta: float) -> void:
	Global.boss_health = health
	if leaf != null:
		distance = global_position.distance_to(leaf.global_position)
		if distance <=DIST_FOLLOW:
			follow = true
			invencible = false
		else:
			follow = false
			$AnimationPlayer.play("idle")
		if distance <=DIST_ATTACK:
			attack_player = true
			invencible = false
		else:
			attack_player = false
	if leaf != null and dead == false:
		_position = leaf.global_position.x - global_position.x
		direction = sign(_position)
		if attack_player and can_attack:
			attack()
		elif follow and attack_player !=true:
			$AnimationPlayer.play("run")
			_patrol()
	_flip()	

func _patrol():
	if Global.health > 0 and health > 0:
		velocity.x = direction * speed
		move_and_slide()
	if follow == false:
		velocity.x = 0 
		$AnimationPlayer.play("idle")
func _flip() -> void:
	if direction < 0 and health > 0:
		transform.x.x = -1
		$Timer.start(0.5)
	if direction > 0 and health > 0:
		transform.x.x = 1
		$Timer.start(0.5)
func attack():
	if dead == false:
		var attack_animations
		var selected_animation
		if countHit < 7 and health > 30:
			attack_animations = attacks
		elif countHit >= 7 and health > 30:
			attack_animations = special
		elif  health < 30 and health > 0:
			attack_animations = special2
		for attackSet in attack_animations:
			selected_animation = attackSet
			can_attack = false
			if dead == false:
				$AnimationPlayer.play(selected_animation)
				await get_tree().create_timer(attack_cooldown).timeout
				can_attack = true
func damage (dame) -> void:
	if invencible !=true:
		blink()
		health -= dame
		print(health)
		countHit+=1
	if health <= 0:
		dead = true
		gravity = 0
		Global.show_boss = false
		can_attack = false
		$CollisionShape2D.shape = null
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play("death")
		await $AnimationPlayer.animation_finished
	
func blink() -> void:
	$Sprite2D.modulate = Color(10,10,10,10)
	await get_tree().create_timer(.1).timeout
	$Sprite2D.modulate = Color(1,1,1,1)
func _on_attacks_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage_apply)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if health > 0 and dead == false:
		$AnimationPlayer.play("idle")
	if dead == true:
		$AnimationPlayer.play("death")
	
